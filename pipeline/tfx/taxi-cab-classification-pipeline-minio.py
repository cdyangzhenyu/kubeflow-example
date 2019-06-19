#!/usr/bin/env python3
# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


import kfp
from kfp import components
from kfp import dsl
from kfp import gcp
from kfp import onprem
from kubernetes.client.models import V1EnvVar

platform = 'onprem' #can be in ['GCP', 'onprem']
storage = 'minio' #all data on minio object storage, and use s3 API to access.

GITPAHT = 'https://github.com/kubeflow/pipelines.git'
GITDIR = '/tmp/pipelines'
MINIOPATH = '/mlpipeline/tfx/taxi-cab-classification/'
DATAPATH = '/tmp/pipelines/samples/tfx/taxi-cab-classification/'

AWS_ACCESS_KEY_ID='minio'
AWS_SECRET_ACCESS_KEY='minio123'
AWS_REGION='us-west-1'
S3_ENDPOINT='minio-service.kubeflow:9000'
S3_USE_HTTPS='0'
S3_VERIFY_SSL='0'

dataflow_tf_data_validation_op  = components.load_component_from_file('components/dataflow/tfdv/component.yaml')
dataflow_tf_transform_op        = components.load_component_from_file('components/dataflow/tft/component.yaml')
tf_train_op                     = components.load_component_from_file('components/kubeflow/dnntrainer/component.yaml')
dataflow_tf_model_analyze_op    = components.load_component_from_file('components/dataflow/tfma/component.yaml')
dataflow_tf_predict_op          = components.load_component_from_file('components/dataflow/predict/component.yaml')

confusion_matrix_op             = components.load_component_from_file('components/local/confusion_matrix/component.yaml')
roc_op                          = components.load_component_from_file('components/local/roc/component.yaml')

kubeflow_deploy_op              = components.load_component_from_file('components/kubeflow/deployer/component.yaml')

@dsl.pipeline(
  name='TFX Taxi Cab Classification Pipeline Example',
  description='Example pipeline that does classification with model analysis based on a public BigQuery dataset.'
)
def taxi_cab_classification(
    project,
    output='s3://mlpipeline/tfx/output',
    column_names='s3://mlpipeline/tfx/taxi-cab-classification/column-names.json',
    key_columns='trip_start_timestamp',
    train='s3://mlpipeline/tfx/taxi-cab-classification/train.csv',
    evaluation='s3://mlpipeline/tfx/taxi-cab-classification/eval.csv',
    mode='local',
    preprocess_module='s3://mlpipeline/tfx/taxi-cab-classification/preprocessing.py',
    learning_rate=0.1,
    hidden_layer_size='1500',
    steps=3000,
    analyze_slice_column='trip_start_hour'
):
    output_template = str(output) + '/{{workflow.uid}}/{{pod.name}}/data'
    target_lambda = """lambda x: (x['target'] > x['fare'] * 0.2)"""
    target_class_lambda = """lambda x: 1 if (x['target'] > x['fare'] * 0.2) else 0"""

    tf_server_name = 'taxi-cab-classification-model-{{workflow.uid}}'

    if platform == 'onprem':
        if storage == 'minio':
            data_preparation = dsl.ContainerOp(
                name="data_preparation",
                image="aiven86/minio_mc-git",
                command=["sh", "/bin/run.sh"],
            ).set_image_pull_policy('IfNotPresent')
            data_preparation.container.add_env_variable(V1EnvVar(name='GITPAHT', value=GITPAHT))
            data_preparation.container.add_env_variable(V1EnvVar(name='GITDIR', value=GITDIR))
            data_preparation.container.add_env_variable(V1EnvVar(name='MINIOPATH', value=MINIOPATH))
            data_preparation.container.add_env_variable(V1EnvVar(name='DATAPATH', value=DATAPATH))
        else:
            vop = dsl.VolumeOp(
                name="create_pvc",
                storage_class="rook-ceph-fs",
                resource_name="pipeline-pvc",
                modes=dsl.VOLUME_MODE_RWM,
                size="1Gi"
            )
        
            data_preparation = dsl.ContainerOp(
                name="data_preparation",
                image="aiven86/git",
                command=["git", "clone", "https://github.com/kubeflow/pipelines.git", str(output) + "/pipelines"],
            ).apply(onprem.mount_pvc(vop.outputs["name"], 'local-storage', output))
            data_preparation.after(vop)

    validation = dataflow_tf_data_validation_op(
        inference_data=train,
        validation_data=evaluation,
        column_names=column_names,
        key_columns=key_columns,
        gcp_project=project,
        run_mode=mode,
        validation_output=output_template,
    )
    if platform == 'onprem':
        validation.after(data_preparation)

    preprocess = dataflow_tf_transform_op(
        training_data_file_pattern=train,
        evaluation_data_file_pattern=evaluation,
        schema=validation.outputs['schema'],
        gcp_project=project,
        run_mode=mode,
        preprocessing_module=preprocess_module,
        transformed_data_dir=output_template
    )

    training = tf_train_op(
        transformed_data_dir=preprocess.output,
        schema=validation.outputs['schema'],
        learning_rate=learning_rate,
        hidden_layer_size=hidden_layer_size,
        steps=steps,
        target='tips',
        preprocessing_module=preprocess_module,
        training_output_dir=output_template
    )

    analysis = dataflow_tf_model_analyze_op(
        model=training.output,
        evaluation_data=evaluation,
        schema=validation.outputs['schema'],
        gcp_project=project,
        run_mode=mode,
        slice_columns=analyze_slice_column,
        analysis_results_dir=output_template
    )

    prediction = dataflow_tf_predict_op(
        data_file_pattern=evaluation,
        schema=validation.outputs['schema'],
        target_column='tips',
        model=training.output,
        run_mode=mode,
        gcp_project=project,
        predictions_dir=output_template
    )

    cm = confusion_matrix_op(
        predictions=prediction.output,
        target_lambda=target_lambda,
        output_dir=output_template
    )

    roc = roc_op(
        predictions_dir=prediction.output,
        target_lambda=target_class_lambda,
        output_dir=output_template
    )

    if platform == 'GCP' or storage == 'minio':
        deploy = kubeflow_deploy_op(
            model_dir=str(training.output) + '/export/export',
            server_name=tf_server_name
        )
    elif platform == 'onprem' and storage != 'minio':
        deploy = kubeflow_deploy_op(
            cluster_name=project,
            model_dir=str(training.output) + '/export/export',
            pvc_name=vop.outputs["name"],
            server_name=tf_server_name
        )

    steps = [validation, preprocess, training, analysis, prediction, cm, roc, deploy]
    for step in steps:
        if platform == 'GCP':
            step.apply(gcp.use_gcp_secret('user-gcp-sa'))
        elif platform == 'onprem':
            if storage == 'minio':
                step.container.add_env_variable(V1EnvVar(name='AWS_ACCESS_KEY_ID', value=AWS_ACCESS_KEY_ID))
                step.container.add_env_variable(V1EnvVar(name='AWS_SECRET_ACCESS_KEY', value=AWS_SECRET_ACCESS_KEY))
                step.container.add_env_variable(V1EnvVar(name='AWS_REGION', value=AWS_REGION))
                step.container.add_env_variable(V1EnvVar(name='S3_ENDPOINT', value=S3_ENDPOINT))
                step.container.add_env_variable(V1EnvVar(name='S3_USE_HTTPS', value=S3_USE_HTTPS))
                step.container.add_env_variable(V1EnvVar(name='S3_VERIFY_SSL', value=S3_VERIFY_SSL))
            else:
                step.apply(onprem.mount_pvc(vop.outputs["name"], 'local-storage', output))


if __name__ == '__main__':
    kfp.compiler.Compiler().compile(taxi_cab_classification, __file__ + '.zip')


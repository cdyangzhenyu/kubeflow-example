kubectl create namespace kubeflow

./kustomize build metacontroller/base/ | kubectl apply -f -
./kustomize build argo/base/ | kubectl apply -f -
./kustomize build common/centraldashboard/base/ | kubectl apply -f -
./kustomize build common/ambassador/base/ | kubectl apply -f -

./kustomize build jupyter/jupyter/base/ | kubectl apply -f -
./kustomize build jupyter/jupyter-web-app/base/ | kubectl apply -f -
./kustomize build jupyter/notebook-controller/base/ | kubectl apply -f -

#./kustomize build katib-v1alpha2/katib-controller/base/ | kubectl apply -f -
#./kustomize build katib-v1alpha2/katib-db/base/ | kubectl apply -f -
#./kustomize build katib-v1alpha2/katib-manager/base/ | kubectl apply -f -
#./kustomize build katib-v1alpha2/katib-ui/base/ | kubectl apply -f -
#./kustomize build katib-v1alpha2/metrics-collector/base/ | kubectl apply -f -
#./kustomize build katib-v1alpha2/suggestion/base/ | kubectl apply -f -

./kustomize build katib-v1alpha1/vizier-core/base/ | kubectl apply -f -
./kustomize build katib-v1alpha1/vizier-db/base/ | kubectl apply -f -
./kustomize build katib-v1alpha1/studyjob/base/ | kubectl apply -f -
./kustomize build katib-v1alpha1/katib-ui/base/ | kubectl apply -f -
./kustomize build katib-v1alpha1/metrics-collector/base/ | kubectl apply -f -
./kustomize build katib-v1alpha1/suggestion/base/ | kubectl apply -f -

./kustomize build pipeline/mysql/base/ | kubectl apply -f -
./kustomize build pipeline/minio/base/ | kubectl apply -f -
./kustomize build pipeline/pipelines-runner/base/ | kubectl apply -f -
./kustomize build pipeline/pipelines-ui/base/ | kubectl apply -f -
./kustomize build pipeline/persistent-agent/base/ | kubectl apply -f -
./kustomize build pipeline/pipelines-viewer/base/ | kubectl apply -f -
./kustomize build pipeline/scheduledworkflow/base/ | kubectl apply -f -
./kustomize build pipeline/api-service/base/ | kubectl apply -f -

./kustomize build tensorboard/base/ | kubectl apply -f -

./kustomize build tf-training/tf-job-operator/base/ | kubectl apply -f -
./kustomize build pytorch-job/pytorch-job-crds/base/ | kubectl apply -f -
./kustomize build pytorch-job/pytorch-operator/base/ | kubectl apply -f -

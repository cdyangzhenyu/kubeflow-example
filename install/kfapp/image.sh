docker tag gcr.io/kubeflow-images-public/centraldashboard:v0.5.0 aiven86/kubeflow-images-public_centraldashboard:v0.5.0
docker tag gcr.io/kubeflow-images-public/jupyter-web-app:v0.5.0 aiven86/kubeflow-images-public_jupyter-web-app:v0.5.0
docker tag gcr.io/kubeflow-images-public/katib/katib-ui:v0.1.2-alpha-156-g4ab3dbd aiven86/kubeflow-images-public_katib_katib-ui:v0.1.2-alpha-156-g4ab3dbd
docker tag gcr.io/kubeflow-images-public/katib/studyjob-controller:v0.1.2-alpha-156-g4ab3dbd aiven86/kubeflow-images-public_katib_studyjob-controller:v0.1.2-alpha-156-g4ab3dbd
docker tag gcr.io/kubeflow-images-public/katib/suggestion-bayesianoptimization:v0.1.2-alpha-156-g4ab3dbd aiven86/kubeflow-images-public_katib_suggestion-bayesianoptimization:v0.1.2-alpha-156-g4ab3dbd
docker tag gcr.io/kubeflow-images-public/katib/suggestion-grid:v0.1.2-alpha-156-g4ab3dbd aiven86/kubeflow-images-public_katib_suggestion-grid:v0.1.2-alpha-156-g4ab3dbd
docker tag gcr.io/kubeflow-images-public/katib/suggestion-hyperband:v0.1.2-alpha-156-g4ab3dbd aiven86/kubeflow-images-public_katib_suggestion-hyperband:v0.1.2-alpha-156-g4ab3dbd
docker tag gcr.io/kubeflow-images-public/katib/suggestion-random:v0.1.2-alpha-156-g4ab3dbd aiven86/kubeflow-images-public_katib_suggestion-random:v0.1.2-alpha-156-g4ab3dbd
docker tag gcr.io/kubeflow-images-public/katib/vizier-core-rest:v0.1.2-alpha-156-g4ab3dbd aiven86/kubeflow-images-public_katib_vizier-core-rest:v0.1.2-alpha-156-g4ab3dbd
docker tag gcr.io/kubeflow-images-public/katib/vizier-core:v0.1.2-alpha-156-g4ab3dbd aiven86/kubeflow-images-public_katib_vizier-core:v0.1.2-alpha-156-g4ab3dbd
docker tag gcr.io/kubeflow-images-public/notebook-controller:v20190401-v0.4.0-rc.1-308-g33618cc9-e3b0c4 aiven86/kubeflow-images-public_notebook-controller:v20190401-v0.4.0-rc.1-308-g33618cc9-e3b0c4
docker tag gcr.io/kubeflow-images-public/pytorch-operator:v0.5.0 aiven86/kubeflow-images-public_pytorch-operator:v0.5.0
docker tag gcr.io/kubeflow-images-public/tf_operator:v0.5.0 aiven86/kubeflow-images-public_tf_operator:v0.5.0
docker tag gcr.io/ml-pipeline/api-server:0.1.21 aiven86/ml-pipeline_api-server:0.1.21
docker tag gcr.io/ml-pipeline/frontend:0.1.21 aiven86/ml-pipeline_frontend:0.1.21 
docker tag gcr.io/ml-pipeline/persistenceagent:0.1.21 aiven86/ml-pipeline_persistenceagent:0.1.21
docker tag gcr.io/ml-pipeline/scheduledworkflow:0.1.21 aiven86/ml-pipeline_scheduledworkflow:0.1.21 
docker tag gcr.io/ml-pipeline/viewer-crd-controller:0.1.21 aiven86/ml-pipeline_viewer-crd-controller:0.1.21

docker push aiven86/kubeflow-images-public_centraldashboard:v0.5.0
docker push aiven86/kubeflow-images-public_jupyter-web-app:v0.5.0
docker push aiven86/kubeflow-images-public_katib_katib-ui:v0.1.2-alpha-156-g4ab3dbd
docker push aiven86/kubeflow-images-public_katib_studyjob-controller:v0.1.2-alpha-156-g4ab3dbd
docker push aiven86/kubeflow-images-public_katib_suggestion-bayesianoptimization:v0.1.2-alpha-156-g4ab3dbd
docker push aiven86/kubeflow-images-public_katib_suggestion-grid:v0.1.2-alpha-156-g4ab3dbd
docker push aiven86/kubeflow-images-public_katib_suggestion-hyperband:v0.1.2-alpha-156-g4ab3dbd
docker push aiven86/kubeflow-images-public_katib_suggestion-random:v0.1.2-alpha-156-g4ab3dbd
docker push aiven86/kubeflow-images-public_katib_vizier-core-rest:v0.1.2-alpha-156-g4ab3dbd
docker push aiven86/kubeflow-images-public_katib_vizier-core:v0.1.2-alpha-156-g4ab3dbd
docker push aiven86/kubeflow-images-public_notebook-controller:v20190401-v0.4.0-rc.1-308-g33618cc9-e3b0c4
docker push aiven86/kubeflow-images-public_pytorch-operator:v0.5.0
docker push aiven86/kubeflow-images-public_tf_operator:v0.5.0
docker push aiven86/ml-pipeline_api-server:0.1.21
docker push aiven86/ml-pipeline_frontend:0.1.21 
docker push aiven86/ml-pipeline_persistenceagent:0.1.21
docker push aiven86/ml-pipeline_scheduledworkflow:0.1.21 
docker push aiven86/ml-pipeline_viewer-crd-controller:0.1.21

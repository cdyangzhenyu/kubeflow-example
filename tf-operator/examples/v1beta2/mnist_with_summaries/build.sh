cp -r ../../../../data/mnist/ input_data
docker build -f Dockerfile -t kubeflow/tf-mnist-with-summaries:cpu ./

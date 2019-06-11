cp -r ../../../../data/mnist/ mnist-data
docker build -f Dockerfile -t kubeflow/tf-dist-mnist-test:1.0 ./

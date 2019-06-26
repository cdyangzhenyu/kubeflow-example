cp -r ../../../../data/mnist/ input_data
docker build -f Dockerfile -t aiven86/tf-mnist-with-summaries:gpu ./
docker push aiven86/tf-mnist-with-summaries:gpu

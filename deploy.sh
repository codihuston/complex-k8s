# build images
docker build -t codihuston/multi-docker-client:latest -t codihuston/multi-docker-client:$SHA -f ./client/Dockerfile ./client
docker build -t codihuston/multi-docker-server:latest -t codihuston/multi-docker-server:$SHA -f ./server/Dockerfile ./server
docker build -t codihuston/multi-docker-worker:latest -t codihuston/multi-docker-worker:$SHA -f ./worker/Dockerfile ./worker

# push to docker hub (don't need to auth b/c we've done it already)
docker push codihuston/multi-docker-client:latest
docker push codihuston/multi-docker-server:latest
docker push codihuston/multi-docker-worker:latest
docker push codihuston/multi-docker-client:$SHA
docker push codihuston/multi-docker-server:$SHA
docker push codihuston/multi-docker-worker:$SHA

# apply the k8s configuration files
kubectl apply -f k8s

# update the images
kubectl set image deployments/server-deployment server=codihuston/multi-docker-server:$SHA
kubectl set image deployments/client-deployment client=codihuston/multi-docker-client:$SHA
kubectl set image deployments/worker-deployment worker=codihuston/multi-docker-worker:$SHA
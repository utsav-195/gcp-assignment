gcloud components install kubectl
echo "enter cluster name: "
read cluster_name
gcloud container clusters create $cluster_name --zone us-central1-a \
--node-locations us-central1-a,us-central1-b,us-central1-c \
--enable-autoscaling \
--labels="name"="utsav","project"="pe-training" \
--max-nodes=3 --min-nodes=1 --num-nodes=1
gcloud container clusters get-credentials $cluster_name --zone us-central1-a
kubectl run hello-server --image gcr.io/google-samples/hello-app:1.0 --port 8080 --replicas=3
kubectl expose deployment hello-server --type LoadBalancer \
  --port 3000 --target-port 8080
kubectl get service hello-server
#gcloud container clusters delete $cluster_name --zone us-central1-a

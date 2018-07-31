echo "project name: "
read project_name

echo "enter template name: "
read template_name

echo "instance group name: "
read group_name

echo "health check name:"
read health_check_name

echo "back end name: "
read backend_name

echo "balancer name: "
read balancer_name

echo "check interval value: "
read check_interval

echo "timeout value: "
read timeout

echo "healthy threshold value: "
read healthy_threshold

echo "unhealthy threshold value: "
read unhealthy_threshold

echo "cool down period value: "
read cooldown_period

echo "maximum number of replicas: "
read max_replicas

echo "minimum number of replicas: "
read min_replicas

echo "target utilization: "
read target_utilization

#create instance template
gcloud beta compute --project=$project_name instance-templates create $template_name --machine-type=custom-1-1024 --network=projects/pe-training/global/networks/default --network-tier=PREMIUM --metadata=name=utsav --maintenance-policy=MIGRATE --service-account=912623308461-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server,https-server --image=debian-9-stretch-v20180716 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=$template_name --labels=name=utsav

#Create health check
gcloud compute --project "$project_name" http-health-checks create "$health_check_name" --port "80" --request-path "/" --check-interval "$check_interval" --timeout "$timeout" --unhealthy-threshold "$unhealthy_threshold" --healthy-threshold "$healthy_threshold"

#Configure instance group
gcloud beta compute --project "$project_name" instance-groups managed create "$group_name" --base-instance-name "$group_name" --template "$template_name" --size "1" --zones "us-central1-b,us-central1-c,us-central1-f"

#Configure auto scaling with instance group
gcloud compute --project "$project_name" instance-groups managed set-autoscaling "$group_name" --region "us-central1" --cool-down-period "$cooldown_period" --max-num-replicas "$max_replicas" --min-num-replicas "$min_replicas" --target-load-balancing-utilization "$target_utilization"

#creating load balancer

#create back end
gcloud compute backend-services create $backend_name --global --http-health-checks $health_check_name

#attach backend to a health check 
gcloud compute backend-services add-backend $backend_name --instance-group $group_name

#attach back end to load balancer
gcloud compute url-maps create $balancer_name --default-service $backend_name

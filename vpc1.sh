echo "vpc name: "
read vpc_name
echo "firewall rule name: "
read firewall_name
echo "ip name: "
read ip_addr
gcloud compute networks create $vpc_name --subnet-mode auto
gcloud compute firewall-rules create $firewall_name --allow=tcp:22 --source-ranges=$ip_addr --network=$vpc_name --priority=900

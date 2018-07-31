echo "vpc name: "
read vpc_name
echo "firewall rule name: "
read firewall_name
echo "ip name: "
read ip_addr

#create vpc with subnet in automatic subnet mode
gcloud compute networks create $vpc_name --subnet-mode auto
#firewall rule to allow ssh from specified IP
gcloud compute firewall-rules create $firewall_name --allow=tcp:22 --source-ranges=$ip_addr --network=$vpc_name --priority=900

echo "enter subnet name: "
read subnet_name1
echo "enter cidr range: "
read subnet1
echo "enter region: "
read region1
echo "enter subnet name 2: "
read subnet_name2
echo "enter cidr range: "
read subnet2
echo "enter region: "
read region2

#create vpc with subnet in custom subnet mode
gcloud compute networks create $vpc_name --subnet-mode custom

#creating 2 custom subnets
gcloud compute networks subnets create $subnet_name1 --network $vpc_name --region $region1 --range $subnet1
gcloud compute networks subnets create $subnet_name2 --network $vpc_name --region $region2 --range $subnet2

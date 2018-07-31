echo "enter subnet name: "
read subnet_name1
echo "enter cidr range: "
read subnet1
echo "enter region: "
read region
echo "enter zone: "
read zone1
echo "enter subnet name 2: "
read subnet_name2
echo "enter cidr range: "
read subnet2
echo "enter zone: "
read zone2

echo "enter nat instance name: "
read nat_name

echo "private instance name: "
read private_instance_name
gcloud compute networks create $vpc_name --subnet-mode custom #create vpc with subnet in customc subnet mode
gcloud compute networks subnets create $subnet_name1 --network $vpc_name --region $region --range $subnet1
#allowing private google access for private subnet
gcloud compute networks subnets create $subnet_name2 --network $vpc_name --region $region --range $subnet2 --enable-private-ip-google-access

#create firewall rule to allow ssh
gcloud compute firewall-rules create all-ssh-firewall-rule --allow tcp:22 --network $vpc_name

#allow internal communication rule
gcloud compute firewall-rules create allow-internat-firewall-rule --allow tcp:1-65535,udp:1-65535,icmp --source-ranges 10.0.0.0/16 --network $vpc_name

#creating nat instance
gcloud compute instances create $nat_name --network $vpc_name --can-ip-forward --zone $zone1 --image-family debian-8 --subnet $subnet_name1 --image-project debian-cloud --tags nat-int --metadata=startup-script="sudo sysctl -w net.ipv4.ip_forward=1\nsudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE"

#creating private instances
gcloud compute instances create $private_instance_name --network $vpc_name --no-address --zone $zone2 --image-family debian-8 --subnet $subnet_name2 --image-project debian-cloud --tags private-int

#creating route from private to nat
gcloud compute routes create private-access-route --network $vpc_name --destination-range 0.0.0.0/0 --next-hop-instance nat-gateway --next-hop-instance-zone $zone1 --tags private-int --priority 800


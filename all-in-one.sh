#!/bin/bash

# Read variables
read -p "Enter the AWS region: " REGION
read -p "Enter the ID of the first subnet: " SUBNET_ID_1
read -p "Enter the ID of the second subnet: " SUBNET_ID_2
read -p "Enter the ID of the third subnet: " SUBNET_ID_3

cat << EOF > terraform.tfvars
region = "$REGION"
subnet_ids = ["$SUBNET_ID_1", "$SUBNET_ID_2", "$SUBNET_ID_3"]
EOF

# Initialize and apply Terraform code
terraform init
terraform apply -auto-approve

# Get instance IDs and public IP addresses
INSTANCE_IDS=$(terraform output instance_ids | tr -d '[],"')
PUBLIC_IPS=$(terraform output public_ips | tr -d '[],"')

# Send user data script to instances and execute
for i in $(seq 1 3); do
  INSTANCE_ID=$(echo $INSTANCE_IDS | cut -d' ' -f$i)
  PUBLIC_IP=$(echo $PUBLIC_IPS | cut -d' ' -f$i)
  scp -i ~/.ssh/id_rsa script.sh ec2-user@$PUBLIC_IP:/tmp/
  ssh -i ~/.ssh/id_rsa ec2-user@$PUBLIC_IP 'bash /tmp/script.sh'
done

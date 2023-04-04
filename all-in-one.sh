#This script reads the region and one to three subnet IDs provided by the user, 
#appends them to a list of subnet IDs, and creates a Terraform variables file with the region and subnet IDs. 
#It then initializes and applies the Terraform code.

#!/bin/bash

# Read variables
read -p "Enter the AWS region: " REGION
read -p "Enter the ID of the first subnet: " SUBNET_ID_1

# Create an empty list of subnet IDs
SUBNET_IDS=($SUBNET_ID_1)

# Read the second and third subnet IDs if provided
read -p "Enter the ID of the second subnet (leave empty if not applicable): " SUBNET_ID_2
read -p "Enter the ID of the third subnet (leave empty if not applicable): " SUBNET_ID_3

# Append the second and third subnet IDs if provided
if [[ ! -z $SUBNET_ID_2 ]]; then
  SUBNET_IDS+=($SUBNET_ID_2)
fi

if [[ ! -z $SUBNET_ID_3 ]]; then
  SUBNET_IDS+=($SUBNET_ID_3)
fi

# Create a Terraform variables file
cat << EOF > terraform.tfvars
region = "$REGION"
subnet_ids = ${SUBNET_IDS[@]}
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

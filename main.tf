provider "aws" {
  region = var.region
}

resource "aws_instance" "ec2_instance" {
  count = 3

  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  subnet_id     = element(var.subnet_ids, count.index)

  user_data = <<-EOF
              #!/bin/bash
              # This script will be run as the ec2-user when the instance launches

              # Install necessary packages
              yum update -y
              yum install -y nc
              yum install -y curl
              yum install -y jq

              # Copy the connectivity test script
              curl -o /home/ec2-user/connectivity_test.sh https://raw.githubusercontent.com/houshym/
rosa-endpoint-verifier/main/rosa-net-verifier.sh
              chmod +x /home/ec2-user/rosa-net-verifier.sh

              # Run the connectivity test
              /home/ec2-user/rosa-net-verifier.sh ${var.region}
              EOF
}

output "instance_ids" {
  value = aws_instance.ec2_instance.*.id
}

output "public_ips" {
  value = aws_instance.ec2_instance.*.public_ip
}

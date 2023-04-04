provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "rosa-ep-verifier" {
  count = 3

  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  subnet_id = element(var.subnet_ids, count.index)

  tags = {
    Name = "example-instance-${count.index + 1}"
  }
}

variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-abc123", "subnet-def456", "subnet-ghi789"]
}

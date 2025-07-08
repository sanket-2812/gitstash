variable "aws_access_key" {
  type        = string
  description = "AWS access key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret key"
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "eu-north-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  monitoring   = true         # Enables detailed monitoring
  ebs_optimized = true        # Enable EBS optimization

  metadata_options {
    http_tokens = "required"  # Enforce IMDSv2 (disable IMDSv1)
  }

  root_block_device {
    encrypted = true          # Enable encryption for root EBS volume
  }

  tags = {
    Name = "HelloWorld"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

data "aws_ami" "latest_rhel" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["RHEL-9.0*"]  # Fetches latest RHEL AMI
  }
}

resource "aws_security_group" "sylog_ng_sg" {
  name        = "sylog_ng_sg"
  description = "Allow ports"

   ingress { 
    from_port = 22
    to_port = 22 
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"] 
    }


   ingress { 
    from_port = 80
    to_port = 80
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"] 
    }


   ingress { 
    from_port = 443
    to_port = 443
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"] 
    }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "syslog-ng" {
  ami           = data.aws_ami.latest_rhel.id
  instance_type = "t2.medium"
  key_name      = var.key_name  # Change to your key name
  security_groups = [aws_security_group.sylog_ng_sg.name]

  root_block_device {
    volume_size = 30
  }

  user_data = file("install-syslog-ng.sh")

  tags = {
    Name = "SyslogNG"
  }
}
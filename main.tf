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
  region = var.region_aws
}

resource "aws_instance" "terraformAWS" {
  count                  = 2
  ami                    = var.ami_aws
  instance_type          = var.instanceType_aws
  vpc_security_group_ids = var.sgID_aws
  key_name               = var.key_aws
  subnet_id              = var.subnetID_aws

  tags = {
    Name = var.tagNAME_aws
    APP  = var.tagAPP_aws
  }
}

terraform {
  required_version = "1.4.6"
  backend "s3" {
    bucket         = "rate-platform"
    dynamodb_table = "terraform-state-lock"
    key            = "gr-hello-world/terraform-ec2-deployment/plans/saas/nonprod/terraform.tfstate"
    region         = "us-east-1"
    role_arn       = "arn:aws:iam::800864774051:role/TerraformDeployer"
    profile        = "default"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.12.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_iam_policy" "gr_ec2_base_policy" {
  arn = "arn:aws:iam::336015931235:policy/gr_ec2_base_policy"
}

data "aws_subnet" "gr_subnet" {
  id = var.subnet_id
}

data "aws_vpc" "gr_vpc" {
  id = data.aws_subnet.gr_subnet.vpc_id
}

locals {
  basic_linux_server_name = "exampleserver"
}

module "tagging" {
  source           = "git@github.com:Guaranteed-Rate/terraform-aws-app-modules.git//tagging?ref=v1.0.81"
  business_contact = var.tags.BusinessContact
  business_owner   = var.tags.BusinessOwner
  tech_contact     = var.tags.TechContact
  tech_owner       = var.tags.TechOwner
  code_repo        = var.tags.CodeRepo
  compliance       = var.tags.Compliance
  criticality      = var.tags.Criticality
  environment      = var.tags.Environment
  product          = var.tags.Product
  public_facing    = var.tags.PublicFacing
  retirement_date  = var.tags.RetirementDate
}

module "basic_linux_server" {
  source                    = "git@github.com:Guaranteed-Rate/terraform-aws-app-modules.git//basic_linux_server?ref=v1.0.81"
  permissions_boundary_name = "DevelopersExample_PermissionsBoundary"
  instance_profile_name     = "${local.basic_linux_server_name}-instance-profile"
  subnet_id                 = var.subnet_id
  server_name               = var.server_name
  security_groups           = [aws_security_group.ec2_security_group.id]
  tags                      = var.tags
  managed_policy_arns       = [data.aws_iam_policy.gr_ec2_base_policy.arn]
  inline_policies           = var.inline_policies
  path                      = var.path
}


resource "aws_security_group" "ec2_security_group" {
  name        = "allow_tlssg"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_subnet.gr_subnet.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.gr_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tlssg"
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "gr-${local.basic_linux_server_name}-storage"
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket     = aws_s3_bucket.bucket.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "object" {
  bucket       = aws_s3_bucket.bucket.id
  key          = var.APPLICATION_ZIP_NAME
  source       = "./application.zip"
  content_type = "application/zip"
  acl          = "private"

  depends_on = [
    aws_s3_bucket.bucket,
    aws_s3_bucket_acl.bucket_acl,
    aws_s3_bucket_versioning.bucket_versioning
  ]
}

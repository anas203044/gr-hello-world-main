terraform {
  required_version = "1.4.6"
  backend "s3" {
    bucket         = "rate-platform"
    dynamodb_table = "terraform-state-lock"
    key            = "gr-hello-world/terraform/plans/saas/nonprod/terraform.tfstate"
    region         = "us-east-1"
    role_arn       = "arn:aws:iam::800864774051:role/TerraformDeployer"
    profile        = "nonprod-saas-DevelopersExample"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.12.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "nonprod-saas-DevelopersExample"
}

module "tagging" {
  source           = "git@github.com:Guaranteed-Rate/terraform-aws-app-modules.git//tagging?ref=v1.0.81"
  business_contact = "cpe@rate.com"
  business_owner   = "cpe"
  tech_contact     = "cpe@rate.com"
  tech_owner       = "cpe"
  code_repo        = "https://github.com/Guaranteed-Rate/gr-hello-world"
  compliance       = "none"
  criticality      = "low"
  environment      = "nonprod"
  product          = "gr-hello-world"
  public_facing    = "no"
  retirement_date  = "2026-12-31"
}

module "github-actions-role" {
  source                    = "git@github.com:Guaranteed-Rate/terraform-aws-app-modules.git//iam_role_gh_actions?ref=v1.0.81"
  rolename                  = "gr-hello-world-gh-role"
  permissions_boundary_name = "DevelopersExample_PermissionsBoundary"
  github_repo               = "gr-hello-world"
  inline_policies = {
    "role-permissions" = file("${path.root}/role-inline-permissions.json")
  }
  tags = merge(
    {},
    module.tagging.value
  )
}

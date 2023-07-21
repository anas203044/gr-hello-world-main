terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket = "python-application-main"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    sid    = "AllowLambdaToAssumeExecutionRole"
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "additional_policy" {
  statement {
    sid    = "AllowListPolicies"
    effect = "Allow"
    actions = [
      "iam:ListPolicies"
    ]
    resources = ["*"]
  }
}


resource "aws_cloudwatch_log_group" "my-lambda-function-logs" {
  name              = "/aws/lambda/my-lambda-function-logs"
  retention_in_days = var.cloudwatch_log_retention_period
  tags              = merge(var.tags, {})
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

module "role" {
  source                    = "git@github.com:Guaranteed-Rate/terraform-aws-app-modules.git//iam_role_gh_actions?ref=v1.0.81"
  github_repo               = "https://github.com/Guaranteed-Rate/terraform-aws-app-modules"
  rolename                  = "my-lambda-role"
  permissions_boundary_name = "DevelopersExample_PermissionsBoundary"
  inline_policies           = var.inline_policies
  tags                      = merge({}, module.tagging.value)
}

moved {
  from = aws_iam_role.this
  to   = module.role.aws_iam_role.this
}


moved {
  from = aws_iam_role_policy.inline_policies
  to   = module.role.aws_iam_role_policy.this
}

moved {
  from = aws_iam_role_policy_attachment.managed_policies
  to   = module.role.aws_iam_role_policy_attachment.this
}


locals {
  is_vpc_lambda = length(var.subnet_ids) > 0
  default_managed_policies = setunion(toset(["arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"]),
    local.is_vpc_lambda ? toset(["arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]) : toset([
      "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]))
}

data "aws_subnet" "subnet_lookup" {
  for_each = toset(var.subnet_ids)
  id       = each.key
}

resource "aws_security_group" "this" {
  count  = local.is_vpc_lambda ? 1 : 0
  name   = "lambda-${var.name}"
  vpc_id = one(toset([for id, sub in data.aws_subnet.subnet_lookup : sub.vpc_id]))
  egress {
    from_port        = 0
    protocol         = "-1"
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = var.tags
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lambda_function" "this" {
  function_name = var.name
  role          = "arn:aws:iam::336015931235:role/gr-lambda-role"
  memory_size   = var.memory
  publish       = true
  image_uri     = var.image_uri
  description   = var.description
  tags          = var.tags
  package_type  = "Image"
  #reserved_concurrent_executions = var.minimum_available_concurrency
  timeout       = var.timeout
  architectures = ["x86_64"]
}

resource "aws_lambda_provisioned_concurrency_config" "this" {
  count                             = var.warm_provisioned_concurrency > 0 ? 1 : 0
  function_name                     = aws_lambda_function.this.function_name
  qualifier                         = aws_lambda_function.this.version
  provisioned_concurrent_executions = var.warm_provisioned_concurrency
}

resource "aws_cloudwatch_metric_alarm" "errors" {
  alarm_description   = "More than ${var.excessive_errors_in_period} errors from ${var.name} in the last ${var.errors_evaluation_period} seconds."
  namespace           = "AWS/Lambda"
  metric_name         = "Errors"
  statistic           = "Sum"
  alarm_name          = "lambda-errors-${var.name}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  period              = var.errors_evaluation_period
  threshold           = var.excessive_errors_in_period
  treat_missing_data  = "notBreaching"
  ok_actions          = var.alarm_notification_arns
  alarm_actions       = var.alarm_notification_arns
  tags                = var.tags
  dimensions = {
    FunctionName = aws_lambda_function.this.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "throttles" {
  alarm_description   = "More than ${var.excessive_errors_in_period} throttles from ${var.name} in the last ${var.errors_evaluation_period} seconds."
  namespace           = "AWS/Lambda"
  metric_name         = "Throttles"
  statistic           = "Sum"
  alarm_name          = "lambda-throttles-${var.name}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  period              = var.throttles_evaluation_period
  threshold           = var.excessive_throttles_in_period
  treat_missing_data  = "notBreaching"
  ok_actions          = var.alarm_notification_arns
  alarm_actions       = var.alarm_notification_arns
  tags                = var.tags
  dimensions = {
    FunctionName = aws_lambda_function.this.function_name
  }
}

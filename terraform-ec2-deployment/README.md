## EC2 Deployment with GitHub Actions
This repository contains code and configurations to deploy an EC2 instance and manage application artifacts using GitHub Actions and Terraform.

# Workflow
The deployment process is automated through the following GitHub Actions workflow:

## Requirements
To use this deployment, make sure you have the following:

AWS account credentials and access keys
GitHub repository with appropriate access permissions
Terraform installed locally or provided through GitHub Actions environment

## Providers
| Name | Version |
|------|---------|
| aws | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| [iam_role](../iam_role/) | git@github.com:Guaranteed-Rate/terraform-aws-app-modules.git//iam_role | v1.0.81 |
| [tagging](../tagging/) | git@github.com:Guaranteed-Rate/gr-hello-world.git//tagging?ref=v1.0.81 |

## Resources
| Name | Type |
|------|------|
| [aws_instance.ec2_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_ami.golden_image](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy.gr_ec2_base_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3) | resource |
| [aws_s3_bucket_acl.bucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3) | resource |
| [aws_s3_bucket_versioning.bucket_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3) | resource |
| [aws_s3_object.object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3) | resource |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Any additional tags to set on the server | `map(string)` | `{}` | no |
| <a name="input_assume_role_policies"></a> [assume\_role\_policies](#input\_assume\_role\_policies) | Any additional assume role trust policies you want to have beyond ec2.amazonaws.com and your Permissions Boundary (both of which are automatic) | `map(string)` | `{}` | no |
| <a name="input_created_instance_profile_name"></a> [created\_instance\_profile\_name](#input\_created\_instance\_profile\_name) | If you want a custom instance profile name to be created. If not set, this will default to the following naming convention: instance-profile-ProductName | `string` | `""` | no |
| <a name="input_golden_image_regex"></a> [golden\_image\_regex](#input\_golden\_image\_regex) | The base AMI to use | `string` | `"gr-win-19-full*"` | no |
| <a name="input_inline_policies"></a> [inline\_policies](#input\_inline\_policies) | Any bespoke IAM policies you want to attach to your instance profile | `map(string)` | `{}` | no |
| <a name="input_instance_profile"></a> [instance\_profile](#input\_instance\_profile) | Existing EC2 Instance Profile name, if you already have one and want to use it | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The AWS instance type and size to use | `string` | `"t3.small"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | What key pair shall decrypt the Administrator password? | `string` | `""` | no |
| <a name="input_managed_policy_arns"></a> [managed\_policy\_arns](#input\_managed\_policy\_arns) | Any additional pre-defined IAM policies you want attached to your instance profile beyond gr\_ec2\_base\_policy (which is automatic) | `list(string)` | `[]` | no |
| <a name="input_path"></a> [path](#input\_path) | (Optional) Path to the role | `string` | `"/"` | no |
| <a name="input_permissions_boundary_name"></a> [permissions\_boundary\_name](#input\_permissions\_boundary\_name) | Your team's permission boundary name, e.g. DevelopersPPS\_PermissionsBoundary | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | n/a | yes |

# Usage
Set up your AWS credentials and access keys as secrets in your GitHub repository.
Configure the required inputs and variables in terraform-ec2-deployment/variables.tf.
Push your changes to the repository's main branch to trigger the deployment workflow.
The workflow will zip the Node.js application, configure AWS credentials, store the artifact in S3, and deploy the EC2 instance using Terraform.
Please refer to the provided code and configurations for more details.

## Outputs

| Name | Description |
|------|-------------|
|  |  |

For any questions or assistance, feel free to reach out. Happy deploying!
<!-- END_TF_DOCS -->
# Repository Structure for Deploying to EC2, Lambda and EKS using Github Actions
The repository structure includes the following files and directories:

## .github/workflows
1. ec2.yml: Contains the workflow definition for deploying the Python application to EC2 using GitHub Actions.
2. eks-deployment.yml:  Contains the workflow definition for deploying Node.js to EKS to show how to use GitHub actions.
3. lambda.yml: Contains the workflow definition to Deploy Python to Lambda using Github Actions.

# k8s-terraform-deployment
This directory contains the necessary files and modules to deploy a Kubernetes application using Terraform.

## Repository Structure

- `app`: Contains the application files.
    - `deployment.yml`: YAML file defining the deployment of the Kubernetes application.
    - `service.yml`: YAML file defining the Kubernetes service for the application.

- `modules/k8s-module`: Contains the Kubernetes Terraform module.

- `.gitignore`: Specifies intentionally untracked files that Git should ignore.

- `Dockerfile`: Dockerfile for building the application container image.

# lambda_containerized
This directory contains the Terraform configuration files for deploying a containerized AWS Lambda function.

## Repository Structure

- `main.tf`: The main Terraform configuration file. It defines the infrastructure resources required for the containerized Lambda function.

- `outputs.tf`: This file contains the Terraform outputs that provide useful information after the deployment is complete.

- `variables.tf`: The variables file where you can define the input variables required for the Terraform configuration.

# node-application
This directory contains a Node.js application that serves a simple web page.

## Repository Structure

- `public/`: This directory contains the static assets of the application, including the `index.html` file.

- `index.html`: The main HTML file that represents the web page served by the Node.js application.

- `index.js`: The main JavaScript file that contains the server-side code for the Node.js application.

- `package.json`: The package.json file that includes the dependencies and scripts for the application.

- `Procfile`: This file is used for specifying the command to start the application when deploying to platforms like Heroku.


# python-application-main
This directory contains a Python application that demonstrates a basic functionality.

## Repository Structure

- `application.py`: This file contains the main Python code of the application.

- `Dockerfile`: The Dockerfile for containerizing the Python application.

- `example_1.json`: An example JSON file that the application uses for processing.

- `test_application.py`: The unit test file for testing the functionality of the application.

# terraform-ec2-deployment
This ddirectory contains the Terraform code for deploying an EC2 instance.

## Repository Structure

- `plans/saas/nonprod`: This directory contains the Terraform plans specific to the non-production environment.

- `application.zip`: The zipped archive of the application code to be deployed on the EC2 instance.

- `main.tf`: The main Terraform configuration file for provisioning the EC2 instance.

- `role-inline-permissions.json`: The JSON file containing the inline permissions for the IAM role associated with the EC2 instance.

- `variables.tf`: The Terraform variables file defining the input variables used in the configuration.

## Usage

## Deploy Python to EC2 using GitHub Actions
This repository provides an example workflow to deploy a Python application to an EC2 instance using GitHub Actions. The workflow utilizes GitHub Actions within the same repository where the application code lives.

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
| [tagging](../tagging/) | git@github.com:Guaranteed-Rate/gr-hello-world.git//tagging | v1.0.81 |
| [basic_linux_server](../basic_linux_server/) | git@github.com:Guaranteed-Rate/terraform-aws-app-modules.git//basic_linux_server | v1.0.81 |

## Resources
| Name | Type |
|------|------|
| [aws_instance.ec2_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.ec2_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_iam_policy.gr_ec2_base_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3) | resource |
| [aws_s3_bucket_acl.bucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3) | resource |
| [aws_s3_bucket_versioning.bucket_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3) | resource |
| [aws_s3_object.object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | n/a | yes |
| <a name="input_server_name"></a> [server\_name](#input\_server\_name) | Friendly name for the server for the AWS API. This is not the OS hostname | `string` | `""` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The subnet to launch the instance into | `string` | `""` | yes |
| <a name="input_path"></a> [path](#input\_path) | (Optional) Path to the role | `string` | `"/"` | no |
| <a name="input_inline_policies"></a> [inline\_policies](#input\_inline\_policies) | Any bespoke IAM policies you want to attach to your instance profile | `map(string)` | `{}` | no |
| <a name="input_managed_policy_arns"></a> [managed\_policy\_arns](#input\_managed\_policy\_arns) | Any additional pre-defined IAM policies you want attached to your instance profile beyond gr\_ec2\_base\_policy (which is automatic) | `list(string)` | `[]` | no |
| <a name="input_APPLICATION_ZIP_NAME"></a> [APPLICATION\_ZIP\_NAME](#input\_APPLICATION\_ZIP\_NAME) | Name of the application ZIP file | `string` | `"application.zip"` | no |


## To use this workflow and deploy your Python application to EC2, follow these steps:

Ensure you have the necessary AWS credentials and permissions to provision EC2 instances and related resources.
Fork this repository or create a new repository based on this template.
Update the necessary variables in the workflow file ec2.yml to match your environment and requirements.
Commit and push your changes to trigger the workflow.
Monitor the workflow progress and review the generated artifact and Terraform plan.
If everything looks satisfactory, approve the Terraform apply step to provision the EC2 instance.
- Please refer to the GitHub Actions documentation for more information on configuring and customizing workflows.



# Deploy to lambda_containerized
This repository contains Terraform code and a `Github Actions` workflow to deploy a containerized `Lambda function`. The deployment process involves building a `Docker image` pushing it to a container registry, and using Terraform to provision the Lambda function in AWS.

## Deployment Workflow
The deployment is automated using a GitHub Actions workflow defined in the `.github/workflows directory`. The workflow is triggered manually but can be customized to run automatically based on specific events.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| [role](../iam_role/) | git@github.com:Guaranteed-Rate/terraform-aws-app-modules.git//iam_role | v1.0.81 |  
| [tagging](../tagging/) | git@github.com:Guaranteed-Rate/gr-hello-world.git//tagging | v1.0.81 |


## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_security_group"></a> [aws\_security\_group](#output\_aws\_security\_group) | n/a |
| <a name="output_lambda"></a> [lambda](#output\_lambda) | n/a |
| <a name="output_lambda_arn"></a> [lambda\_arn](#output\_lambda\_arn) | n/a |
| <a name="output_lambda_name"></a> [lambda\_name](#output\_lambda\_name) | n/a |
| <a name="output_role"></a> [role](#output\_role) | n/a |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | n/a |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | n/a |


## Getting Started
To deploy the containerized Lambda function, follow these steps:

- Clone this repository to your local machine.
- Set up the required environment variables, such as AWS credentials and container registry credentials.
- Modify the variables.tf file to customize the input variables according to your requirements.
- Run the GitHub Actions workflow manually by triggering the Deploy to lambda_containerized workflow using the GitHub Actions interface.
- Monitor the workflow execution and check the Terraform output values for the deployed Lambda function.


# **K8S-Terraform-Deployment**

This repository contains Terraform code for deploying resources to Kubernetes clusters using EKS.

## Deployment Workflow

The deployment workflow in this repository follows the steps outlined below:

1. When changes are pushed to the `main` branch or when a pull request is opened or updated for the `EKS-deployment` branch, the deployment workflow is triggered.

2. The workflow allows manual triggering through the GitHub Actions workflow dispatch event, which can be used to provide inputs like the AWS region.

3. The workflow consists of the following jobs:

   - **Build**: This job builds a Docker image for the application using the provided Dockerfile and pushes it to the Amazon Elastic Container Registry (ECR).
   
   - **Deploy**: This job initializes and validates Terraform configurations, including the Kubernetes manifest files, and plans the deployment.
   
   - **ManualApproval**: This job requests manual approval for the deployment by creating a pull request. The approval can be provided by commenting on the pull request.
   
   - **terraform-apply**: This job applies the Terraform plan and deploys the resources to the specified EKS cluster.

## Configuration

To configure the deployment, you can provide the following inputs:

- `aws_region`: AWS region where the deployment will take place. (Optional, default: `us-east-1`)

## Resources
The deployment creates the following Kubernetes resources:

- kubectl_manifest.namespaces: Creates Kubernetes namespaces based on the provided YAML manifests.
- kubectl_manifest.custom_resource_definitions: Creates custom resource definitions based on the provided YAML manifests.
- kubectl_manifest.constraint_templates: Creates constraint templates based on the provided YAML manifests.
- kubectl_manifest.other: Creates other Kubernetes resources (excluding namespaces, custom resource definitions, and constraint templates) based on the provided YAML manifests.


<!-- END_TF_DOCS -->
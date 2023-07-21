# **K8S Deployment**

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


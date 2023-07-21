variable "server_name" {
  type        = string
  default     = ""
  description = "Friendly name for the server for the AWS API. This is not the OS hostname."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the resources"

}

variable "subnet_id" {
  type        = string
  default     = ""
  description = "The subnet to launch the instance into. In most cases this will be a private subnet"
}

variable "APPLICATION_ZIP_NAME" {
  type        = string
  default     = "application.zip"
  description = "Name of the application ZIP file"
}


variable "path" {
  type        = string
  default     = "/"
  description = "(Optional) Path to the role"
}

variable "inline_policies" {
  type        = map(string)
  default     = {}
  description = "Any bespoke IAM policies you want to attach to your instance profile"
}


variable "managed_policy_arns" {
  type        = list(string)
  default     = []
  description = "Any additional pre-defined IAM policies you want attached to your instance profile beyond gr_ec2_base_policy (which is automatic)"
}


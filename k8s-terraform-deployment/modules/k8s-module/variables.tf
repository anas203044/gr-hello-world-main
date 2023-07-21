variable "pattern" {
  type        = string
  description = "A glob pattern that will match YAML files containing Kubernetes resource definitions."
}

variable "variables" {
  type        = map(string)
  default     = {}
  description = "A map of template variables to values that you want to render in the Kubernetes manifests."
}




variable "pattern" {
  type        = string
  default     = "*app/*.yml"
  description = "A glob pattern that will match YAML files containing Kubernetes resource definitions."
}

variable "variables" {
  type = map(string)
  default = {
    appName     = "nodeapp"
    replicas    = 2
    serviceType = "NodePort"
    nodePort    = ""
    port        = 3000
    pullSecret  = ""
  }
  description = "A map of template variables to values that you want to render in the Kubernetes manifests."
}

variable "image_uri" {
  type    = string
  default = "nginx:latest"
}

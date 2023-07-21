terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
    }
    util = {
      source = "poseidon/util"
    }
  }
}

module "k8s_app_deployment" {
  source    = "./modules/k8s-module"
  pattern   = var.pattern
  variables = merge(var.variables, { image_uri = var.image_uri })
}

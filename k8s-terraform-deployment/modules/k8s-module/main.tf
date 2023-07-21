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

data "kubectl_path_documents" "this" {
  pattern = var.pattern
  vars    = var.variables
}

data "kubectl_filename_list" "this" {
  pattern = var.pattern
}

data "kubectl_file_documents" "this" {
  for_each = toset(data.kubectl_filename_list.this.matches)
  content  = file(each.key)
}

data "util_replace" "this" {
  for_each     = toset(local.resource_names)
  content      = each.value
  replacements = { for k, v in var.variables : "$${${k}}" => v }
}


locals {
  all_documents    = [for resource in flatten([for file in values(data.kubectl_file_documents.this) : file.documents]) : yamldecode(resource)]
  resource_names   = [for resource in local.all_documents : "${resource["kind"]}:${lookup(resource["metadata"], "namespace", "_")}:${resource["metadata"]["name"]}"]
  parsed_resources = [for resource in data.kubectl_path_documents.this.documents : [resource, yamldecode(resource)]]
  indexed_resources = {
    for resource in local.parsed_resources :
    "${resource[1]["kind"]}:${lookup(resource[1]["metadata"], "namespace", "_")}:${resource[1]["metadata"]["name"]}" => resource[0]
  }
}

resource "kubectl_manifest" "namespaces" {
  for_each  = toset([for key in local.resource_names : key if length(regexall("^(Namespace):", key)) > 0])
  yaml_body = local.indexed_resources[data.util_replace.this[each.key].replaced]
}

resource "kubectl_manifest" "custom_resource_definitions" {
  for_each  = toset([for key in local.resource_names : key if length(regexall("^(CustomResourceDefinition):", key)) > 0])
  yaml_body = local.indexed_resources[data.util_replace.this[each.key].replaced]
}

resource "kubectl_manifest" "constraint_templates" {
  for_each  = toset([for key in local.resource_names : key if length(regexall("^(ConstraintTemplate):", key)) > 0])
  yaml_body = local.indexed_resources[data.util_replace.this[each.key].replaced]
}

resource "kubectl_manifest" "other" {
  for_each  = toset([for key in local.resource_names : key if length(regexall("^(Namespace|CustomResourceDefinition|ConstraintTemplate):", key)) == 0])
  yaml_body = local.indexed_resources[data.util_replace.this[each.key].replaced]
  depends_on = [
    kubectl_manifest.constraint_templates,
    kubectl_manifest.namespaces,
    kubectl_manifest.custom_resource_definitions
  ]
}

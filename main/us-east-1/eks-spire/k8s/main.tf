
locals {
    namespace = var.namespace
}

terraform {
  required_version = ">= 0.13"
  required_providers {
    helm       = "~> 1.0"
    kubernetes = "~> 1.0"
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.0"
    }
  }
}

resource "kubernetes_namespace" "spire" {
  metadata {
    labels = {
      name = local.namespace
    }

    name = local.namespace
  }
}
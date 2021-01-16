include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "./k8s"

}

dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    cluster_id              = "cluster-name"
    cluster_oidc_issuer_url = "https://oidc.eks.eu-west-3.amazonaws.com/id/0000000000000000"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    provider "aws" {
      region = "${local.aws_region}"
    }
    provider "kubectl" {
      host                   = data.aws_eks_cluster.cluster.endpoint
      cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
      token                  = data.aws_eks_cluster_auth.cluster.token
      load_config_file       = false
    }
    provider "kubernetes" {
      host                   = data.aws_eks_cluster.cluster.endpoint
      cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
      token                  = data.aws_eks_cluster_auth.cluster.token
      load_config_file       = false
    }
    provider "helm" {
      kubernetes {
        host                   = data.aws_eks_cluster.cluster.endpoint
        cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
        token                  = data.aws_eks_cluster_auth.cluster.token
        load_config_file       = false
      }
    }
    data "aws_eks_cluster" "cluster" {
      name = var.cluster-name
    }
    data "aws_eks_cluster_auth" "cluster" {
      name = var.cluster-name
    }
  EOF
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    terraform {
      backend "s3" {}
    }
  EOF
}

locals {
  aws_region          = yamldecode(file("${find_in_parent_folders("common_values.yaml")}"))["aws_region"]
  custom_tags         = yamldecode(file("${find_in_parent_folders("common_tags.yaml")}"))
  default_domain_name = yamldecode(file("${find_in_parent_folders("common_values.yaml")}"))["default_domain_name"]
  env                 = yamldecode(file("${find_in_parent_folders("common_tags.yaml")}"))["Env"]
  namespace           = "spire"
}

inputs = {
    cluster-name = dependency.eks.outputs.cluster_id
    discovery_domain = "oidc-discovery.k8sguru.info"
    email_address = "leogsilva@gmail.com"
}
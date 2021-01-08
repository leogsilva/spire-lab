include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "./aws-oidc"
}

dependency "eks-spire" {
  config_path = "../eks-spire"
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
    discovery_domain = dependency.eks-spire.outputs.discovery_domain
    audience = "mys3"
    bucket_name = "terraform-projects-devops"
}
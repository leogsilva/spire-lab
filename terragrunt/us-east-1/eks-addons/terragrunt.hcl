include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "github.com/particuleio/terraform-kubernetes-addons.git//modules/aws?ref=v1.5.0"


  before_hook "helm_repo" {
    commands = ["apply"]
    execute = ["bash","-c", "helm repo add stable https://charts.helm.sh/stable --force-update"]
  }

  before_hook "helm_update" {
    commands = ["apply"]
    execute  = ["bash", "-c", "helm repo update"]
  }
}

dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    cluster_id              = "cluster-name"
    cluster_oidc_issuer_url = "https://oidc.eks.eu-west-3.amazonaws.com/id/0000000000000000"
  }
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    private_subnets_cidr_blocks = [
      "10.0.0.0/16",
      "192.168.0.0/24"
    ]
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
}

inputs = {

  cluster-name = dependency.eks.outputs.cluster_id

  tags = merge(
    local.custom_tags
  )

  eks = {
    "cluster_oidc_issuer_url" = dependency.eks.outputs.cluster_oidc_issuer_url
  }

  aws-for-fluent-bit = {
    enabled = false
  }

  aws-load-balancer-controller = {
    enabled = false
  }

  aws-node-termination-handler = {
    enabled = false
  }

  calico = {
    enabled = false
  }

  cert-manager = {
    enabled                        = false
    acme_email                     = "kevin@particule.io"
    enable_default_cluster_issuers = true
    allowed_cidrs                  = dependency.vpc.outputs.private_subnets_cidr_blocks
  }

  cluster-autoscaler = {
    enabled = false
  }

  cni-metrics-helper = {
    enabled = false
  }

  external-dns = {
    external-dns = {  
      enabled = true
      extra_values = <<-EXTRA_VALUES
        aws:
          zoneType: public
      EXTRA_VALUES
    },
  }

  ingress-nginx = {
    enabled = false
  }

  istio-operator = {
    enabled = false
  }

  karma = {
    enabled      = false
    extra_values = <<-EXTRA_VALUES
      ingress:
        enabled: true
        path: /
        annotations:
          kubernetes.io/ingress.class: nginx
          cert-manager.io/cluster-issuer: "letsencrypt"
        hosts:
          - karma.${local.default_domain_name}
        tls:
          - secretName: karma.${local.default_domain_name}
            hosts:
              - karma.${local.default_domain_name}
      env:
        - name: ALERTMANAGER_URI
          value: "http://prometheus-operator-alertmanager.monitoring.svc.cluster.local:9093"
        - name: ALERTMANAGER_PROXY
          value: "true"
        - name: FILTERS_DEFAULT
          value: "@state=active severity!=info severity!=none"
      EXTRA_VALUES
  }

  keycloak = {
    enabled = false
  }

  kong = {
    enabled = false
  }

  kube-prometheus-stack = {
    enabled       = false
    allowed_cidrs = dependency.vpc.outputs.private_subnets_cidr_blocks
    extra_values  = <<-EXTRA_VALUES
      grafana:
        deploymentStrategy:
          type: Recreate
        ingress:
          enabled: true
          annotations:
            kubernetes.io/ingress.class: nginx
            cert-manager.io/cluster-issuer: "letsencrypt"
          hosts:
            - grafana.${local.default_domain_name}
          tls:
            - secretName: grafana.${local.default_domain_name}
              hosts:
                - grafana.${local.default_domain_name}
        persistence:
          enabled: true
          storageClassName: gp2
          accessModes:
            - ReadWriteOnce
          size: 10Gi
      prometheus:
        prometheusSpec:
          replicas: 1
          retention: 180d
          ruleSelectorNilUsesHelmValues: false
          serviceMonitorSelectorNilUsesHelmValues: false
          storageSpec:
            volumeClaimTemplate:
              spec:
                storageClassName: gp2
                accessModes: ["ReadWriteOnce"]
                resources:
                  requests:
                    storage: 50Gi
      EXTRA_VALUES
  }

  metrics-server = {
    enabled       = true
    allowed_cidrs = dependency.vpc.outputs.private_subnets_cidr_blocks
  }

  npd = {
    enabled = false
  }

  sealed-secrets = {
    enabled = false
  }

}

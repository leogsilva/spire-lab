
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

# For the server to function, it is necessary for it to provide agents with certificates 
# that they can use to verify the identity of the server when establishing a connection.
# In a deployment such as this, where the agent and server share the same cluster, 
# SPIRE can be configured to automatically generate these certificates on a periodic 
# basis and update a configmap with contents of the certificate. 
# To do that, the server needs the ability to get and patch a configmap object in the spire namespace.
# To allow the server to read and write to this configmap, a ClusterRole must be created 
# that confers the appropriate entitlements to Kubernetes RBAC, and that ClusterRoleBinding must be associated with the service account created in the previous step.

data "kubectl_file_documents" "spire_server_account" {
  content = file("${path.module}/k8s/yaml/server-account.yaml")
}

data "kubectl_file_documents" "spire_bundle_configmap" {
  content = file("${path.module}/k8s/yaml/spire-bundle-configmap.yaml")
}

data "kubectl_file_documents" "server_cluster_role" {
  content = file("${path.module}/k8s/yaml/server-cluster-role.yaml")
}

resource "kubectl_manifest" "spire_server_account" {
  count     = length(data.kubectl_file_documents.spire_server_account.documents)
  yaml_body = element(data.kubectl_file_documents.spire_server_account.documents, count.index)
  depends_on = [
    kubernetes_namespace.spire
  ]
}

resource "kubectl_manifest" "spire_bundle_configmap" {
  count     = length(data.kubectl_file_documents.spire_bundle_configmap.documents)
  yaml_body = element(data.kubectl_file_documents.spire_bundle_configmap.documents, count.index)
  depends_on = [
    kubernetes_namespace.spire
  ]
}

resource "kubectl_manifest" "server_cluster_role" {
  count     = length(data.kubectl_file_documents.server_cluster_role.documents)
  yaml_body = element(data.kubectl_file_documents.server_cluster_role.documents, count.index)
  depends_on = [
    kubernetes_namespace.spire
  ]
}

# The server is configured in the Kubernetes configmap 
# specified in server-configmap.yaml, which specifies a number of important 
# directories, notably /run/spire/data and /run/spire/config. 
# These volumes are bound in when the server container is deployed.

data "kubectl_file_documents" "spire_server_configmap" {
  content = file("${path.module}/k8s/yaml/server-configmap.yaml")
}

data "kubectl_file_documents" "spire_server_statefulset" {
  content = file("${path.module}/k8s/yaml/server-statefulset.yaml")
}

data "kubectl_file_documents" "server_service" {
  content = file("${path.module}/k8s/yaml/server-service.yaml")
}

resource "kubectl_manifest" "spire_server_configmap" {
  count     = length(data.kubectl_file_documents.spire_server_configmap.documents)
  yaml_body = element(data.kubectl_file_documents.spire_server_configmap.documents, count.index)
  depends_on = [
    kubernetes_namespace.spire
  ]
}

resource "kubectl_manifest" "spire_server_statefulset" {
  count     = length(data.kubectl_file_documents.spire_server_statefulset.documents)
  yaml_body = element(data.kubectl_file_documents.spire_server_statefulset.documents, count.index)
  depends_on = [
    kubernetes_namespace.spire
  ]
}

resource "kubectl_manifest" "server_service" {
  count     = length(data.kubectl_file_documents.server_service.documents)
  yaml_body = element(data.kubectl_file_documents.server_service.documents, count.index)
  depends_on = [
    kubernetes_namespace.spire
  ]
}

# Spire agent 
data "kubectl_file_documents" "spire_agent_account" {
  content = file("${path.module}/k8s/yaml/agent-account.yaml")
}

data "kubectl_file_documents" "spire_agent_cluster_role" {
  content = file("${path.module}/k8s/yaml/agent-cluster-role.yaml")
}

resource "kubectl_manifest" "spire_agent_account" {
  count     = length(data.kubectl_file_documents.spire_agent_account.documents)
  yaml_body = element(data.kubectl_file_documents.spire_agent_account.documents, count.index)
  depends_on = [
    kubernetes_namespace.spire
  ]
}

resource "kubectl_manifest" "spire_agent_cluster_role" {
  count     = length(data.kubectl_file_documents.spire_agent_cluster_role.documents)
  yaml_body = element(data.kubectl_file_documents.spire_agent_cluster_role.documents, count.index)
  depends_on = [
    kubernetes_namespace.spire
  ]
}

# Apply the agent-configmap.yaml configuration file to create the 
# agent configmap and deploy the Agent as a daemonset that runs one 
# instance of each Agent on each Kubernetes worker node.
data "kubectl_file_documents" "spire_agent_configmap" {
  content = file("${path.module}/k8s/yaml/agent-configmap.yaml")
}

data "kubectl_file_documents" "spire_agent_daemonset" {
  content = file("${path.module}/k8s/yaml/agent-daemonset.yaml")
}

resource "kubectl_manifest" "spire_agent_configmap" {
  count     = length(data.kubectl_file_documents.spire_agent_configmap.documents)
  yaml_body = element(data.kubectl_file_documents.spire_agent_configmap.documents, count.index)
  depends_on = [
    kubernetes_namespace.spire
  ]
}

resource "kubectl_manifest" "spire_agent_daemonset" {
  count     = length(data.kubectl_file_documents.spire_agent_daemonset.documents)
  yaml_body = element(data.kubectl_file_documents.spire_agent_daemonset.documents, count.index)
  depends_on = [
    kubernetes_namespace.spire
  ]
}
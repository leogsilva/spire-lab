
variable "cluster-name" {
  type = string
}

variable "namespace" {
  type = string
  default = "spire"
}

variable "trust_domain" {
  type = string
  default = "example.com"
}

variable "discovery_domain" {
  description = "url for oidc endpoint"
  type = string
  mandatory = true
}

variable "email_address" {
  description = "valid email address for certificate generation"
  type = string
  mandatory = true
}
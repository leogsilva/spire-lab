
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
  validation {
    condition     = length(var.discovery_domain) > 0
    error_message = "A valid discovery_domain value should be provided."
  }
}

variable "email_address" {
  description = "valid email address for certificate generation"
  type = string
  validation {
    condition     = length(var.email_address) > 0
    error_message = "A valid email_address value should be is provided."
  }
}
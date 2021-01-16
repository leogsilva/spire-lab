
variable "discovery_domain" {
  type = string
  description = "OIDC discovery domain"
}

variable "audience" {
  type = string
  description = "Specify the client ID issued by the Identity provider for your app."
}

variable "bucket_name" {
    type = string
    description = "Bucket name used to test the integration between spire and aws"
}

variable "client_spiffe_id" {
    type = string
    description = "spiffe id for client interacting with aws"
    default = "spiffe://example.org/ns/default/sa/default"
}
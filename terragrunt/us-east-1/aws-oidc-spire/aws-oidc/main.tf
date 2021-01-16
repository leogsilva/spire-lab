
locals {
    discovery_domain = var.discovery_domain
    audience = var.audience
    bucket_name = var.bucket_name
    client_spiffe_id = var.client_spiffe_id
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

data "external" "thumbprint" {
  program = [format("%s/thumbprint.sh", path.module), local.discovery_domain]
}

resource "aws_iam_openid_connect_provider" "oidc-s3" {
  client_id_list  = ["${var.audience}"]
  thumbprint_list = [data.external.thumbprint.result.thumbprint]
  url             = format("%s%s", "https://", local.discovery_domain)
}

resource "aws_iam_policy" "oidc-federation-test-policy" {
  name        = "oidc-federation-test-policy"
  description = "a policy for oidc federation"
  policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "s3:PutAccountPublicAccessBlock",
            "s3:GetAccountPublicAccessBlock",
            "s3:ListAllMyBuckets",
            "s3:ListJobs",
            "s3:CreateJob",
            "s3:HeadBucket"
        ],
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": "s3:*",
        "Resource": [
            "arn:aws:s3:::${local.bucket_name}",
            "arn:aws:s3:::${local.bucket_name}/*"
        ]
    }
]
}
EOF
}

resource "aws_iam_role" "oidc-federation-test-role" {
  name               = "oidc-federation-test-role"
  path               = "/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Federated": "${aws_iam_openid_connect_provider.oidc-s3.arn}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
            "StringEquals": {
            "oidc-discovery.k8sguru.info:aud": "${local.audience}",
            "oidc-discovery.k8sguru.info:sub": "${local.client_spiffe_id}"
            }
        }
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3-oid-attachment" {
  role       = aws_iam_role.oidc-federation-test-role.name
  policy_arn = aws_iam_policy.oidc-federation-test-policy.arn
}
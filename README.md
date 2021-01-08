# spire-lab
Simple k8s lab for spiffe/spire aws integration architecture

## Pre-req to launch spire-lab
Install aws cli - https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
    *config aws_security file.

Install terraform - https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/azure-get-started

Install terragrunt - https://terragrunt.gruntwork.io/docs/getting-started/install/
    after install, run:
        terragrunt state rm "kubernetes_config_map.aws_auth[0]"

Install jq - https://stedolan.github.io/jq/download/

Install helm3 - https://helm.sh/docs/intro/install/

Install direnv 
    (from root) run:  ```curl -sfL https://direnv.net/install.sh | bash```
    after install, run this command from main project: ```direnv allow```

Install kubectl

## Sequency to create Infrastructure 
    Create the infrastructure using terragrunt, for each type of source, execute:
            - ```terragrunt init```
		    - ```terragrunt plan```
		    - ```terragrunt apply -auto-approve```
Sequency directories/sources   
    1 - ../spire-lab/main/<region>/vpc
    2 - ../spire-lab/main/<region>/eks
    3 - ../spire-lab/main/<region>/eks-addons
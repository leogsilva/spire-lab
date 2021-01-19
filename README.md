# spire-lab
Simple k8s lab for spiffe/spire aws integration architecture

# Pre-req to launch spire-lab
## Install aws cli
https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
config aws_security file: 
```sh 
$ vi ~/.aws/credentials
```

## Install terraform 
https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/azure-get-started

## Install terragrunt 
https://terragrunt.gruntwork.io/docs/getting-started/install/

after install, run:
```sh
terragrunt state rm "kubernetes_config_map.aws_auth[0]"
```


## Install jq 
https://stedolan.github.io/jq/download/

## Install helm3 
https://helm.sh/docs/intro/install/

## Install direnv 

(from root) run:  
    
```sh 
$ curl -sfL https://direnv.net/install.sh | bash
```
after install, run this command from main project: 

```sh
$ direnv allow
```

## Install kubectl

## install tilt
https://tilt.dev/

## install kubernetes
https://k3d.io/

## instal Kustomize
https://kustomize.io/

# Sequency to create Infrastructure 
Create the infrastructure using terragrunt, for each type of source, execute:

```sh 
$ terragrunt init
$ terragrunt plan
$ terragrunt apply -auto-approve
```

# Sequency to destroy Infrastructure 
Destroy environment, execute:

```sh
$ terragrunt init
$ terragrunt refresh
$ terragrunt destroy -auto-approve
```


## Directories/sources sequency
-  ../spire-lab/main/<<'region'>>/vpc

-  ../spire-lab/main/<region>/eks

-  ../spire-lab/main/<region>/eks-addons

-  ../spire-lab/main/<region>/eks-spire

-  ../spire-lab/main/<region>/aws-oidc-spire


## test oidc return certified 
run command: 
```sh 
$ curl -v https://oidc-discovery.k8sguru.info/keys
```


## test 
https://github.com/spiffe/spire-tutorials/blob/master/k8s/oidc-aws/client-deployment.yaml
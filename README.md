# spire-lab

Simple k8s lab for spiffe/spire aws integration architecture.

This lab aim to provide a security layer supported by spiffe/spire for microservices.

---
## Pre-req to launch spire-lab

### Install aws cli

link: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html

config aws_security file:

``` 
vi ~/.aws/credentials
```

something like this:

```{r, attr.source='.numberLines'}
[aws-security] 
aws_access_key_id = <AWS_ACCESS_KEY_ID>
aws_secret_access_key = <AWS_SECRET_ACCESS_KEY>

```

### Install terraform 

link: https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/azure-get-started

### Install terragrunt 
link: https://terragrunt.gruntwork.io/docs/getting-started/install/

after install, run:
```sh
terragrunt state rm "kubernetes_config_map.aws_auth[0]"
```

### Install jq

link: https://stedolan.github.io/jq/download/

### Install helm3

link: https://helm.sh/docs/intro/install/

### Install direnv

(from root) run:  

```sh 
 curl -sfL https://direnv.net/install.sh | bash
```

after install, run this command from main project:

```sh
 direnv allow
```

### Install kubectl

link: https://kubernetes.io/docs/tasks/tools/install-kubectl/

### install tilt

link: https://tilt.dev/

### install kubernetes

link: https://k3d.io/

### install Kustomize

link: https://kustomize.io/

### install git submodule

run command:

```sh
git submodule update --init --recursive
```

---
### Launch Cloud Infrastructure

Command to create the infrastructure using terragrunt.
From each Directories/sources:

1. ../spire-lab/terragrunt/\<region\>/vpc

2. ../spire-lab/terragrunt/\<region\>/eks

3. ../spire-lab/terragrunt/\<region\>/eks-addons

4. ../spire-lab/terragrunt/\<region\>/eks-spire

5. ../spire-lab/terragrunt/\<region\>/aws-oidc-spire

Basic for launch from terragrunt:

```sh
 terragrunt init
 ```

 ```sh
 terragrunt plan
 ```

```sh
terragrunt apply -auto-approve
```

Sequency to destroy Infrastructure
Destroy environment, execute:

```sh
terragrunt init
```

```sh
terragrunt refresh
```

```sh
terragrunt destroy -auto-approve
```

Learn more in [terragrunt.io](https://terragrunt.gruntwork.io/)

### test oidc return certified 
after to create cloud environment, run command:

```sh
curl -v https://oidc-discovery.k8sguru.info/keys
```

### test 
https://github.com/spiffe/spire-tutorials/blob/master/k8s/oidc-aws/client-deployment.yaml

---

## How to start environment

Execute the follows steps:

```sh
<PROJECT_HOME>/k8s/scripts/$ ./1_start_k8s_cluster.sh
```

after kubernetes cluster is available, run:

```sh
<PROJECT_HOME>/k8s/$ tilt up
```

### test
Confirm that kafka broker is presenting a X509 cert generated by spire

openssl s_client -showcerts -connect localhost:9093 -tls1

openssl s_client -showcerts -connect localhost:19093

openssl s_client -showcerts -connect localhost:9100


kafka-topics --list --bootstrap-server kafka-cp-kafka-headless:9092

kafka-console-consumer --bootstrap-server kafka-cp-kafka-headless:9092 --topic envoy --from-beginning


kafka-console-producer --bootstrap-server kafka-cp-kafka-headless:9092 --topic envoy

kafka-topics --create --zookeeper kafka-cp-zookeeper.default:2181 --replication-factor 1 --partitions 1 --topic envoy

apk update
apk add py-pip openssl
pip install kafka-python
apk add python3

from kafka import KafkaConsumer
consumer = KafkaConsumer('sample', bootstrap_servers='localhost:9100')
consumer = KafkaConsumer('sample', bootstrap_servers='kafka-proxy.default.svc.cluster.local:9094')
for message in consumer:
    print (message)

from kafka import KafkaProducer
producer = KafkaProducer(bootstrap_servers='127.0.0.1:9100')
producer.send('sample', b'Go Spire')
producer.send('sample', key=b'message-two', value=b'This is Kafka-Python')

to consume a message directly from kafka

```sh
kubectl -n kafka run kafka-consumer -ti --image=quay.io/strimzi/kafka:0.21.1-kafka-2.7.0 --rm=true --restart=Never -- bin/kafka-console-consumer.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --topic my-topic --from-beginning
```

To produce a message directly to kafka
```sh
kubectl -n kafka run kafka-producer -ti --image=quay.io/strimzi/kafka:0.21.1-kafka-2.7.0 --rm=true --restart=Never -- bin/kafka-console-producer.sh --broker-list my-cluster-kafka-bootstrap:9092 --topic my-topic
```
#!/bin/bash

kubectl exec -n spire spire-server-0 -- \
    /opt/spire/bin/spire-server entry create \
    -registrationUDSPath /run/spire/sockets/registration.sock \
    -spiffeID spiffe://example.org/ns/spire/sa/spire-agent \
    -selector k8s_sat:cluster:demo-cluster \
    -selector k8s_sat:agent_ns:spire \
    -selector k8s_sat:agent_sa:spire-agent \
    -node

kubectl exec -n spire spire-server-0 -- \
    /opt/spire/bin/spire-server entry create \
    -registrationUDSPath /run/spire/sockets/registration.sock \
    -spiffeID spiffe://example.org/ns/default/sa/default \
    -parentID spiffe://example.org/ns/spire/sa/spire-agent \
    -selector k8s:ns:default \
    -selector k8s:sa:default

kubectl exec -n spire spire-server-0 -- \
    /opt/spire/bin/spire-server entry create \
    -registrationUDSPath /run/spire/sockets/registration.sock \
    -spiffeID spiffe://example.org/ns/kafkaconsumer/sa/default \
    -parentID spiffe://example.org/ns/spire/sa/spire-agent \
    -selector k8s:ns:kafkaconsumer \
    -selector k8s:sa:default

kubectl exec -n spire spire-server-0 -- \
    /opt/spire/bin/spire-server entry create \
    -registrationUDSPath /run/spire/sockets/registration.sock \
    -spiffeID spiffe://example.org/ns/default/sa/default \
    -parentID spiffe://example.org/ns/spire/sa/spire-agent \
    -selector k8s:ns:default \
    -selector k8s:sa:default

kubectl exec -n spire spire-server-0 -- \
    /opt/spire/bin/spire-server entry create \
    -registrationUDSPath /run/spire/sockets/registration.sock \
    -spiffeID spiffe://example.org/ns/sslfactory/sa/sslfactory \
    -parentID spiffe://example.org/ns/spire/sa/spire-agent \
    -selector k8s:ns:sslfactory \
    -selector k8s:sa:sslfactory    

kubectl exec -n spire spire-server-0 -- \
    /opt/spire/bin/spire-server entry create \
    -registrationUDSPath /run/spire/sockets/registration.sock \
    -spiffeID spiffe://example.org/ns/sslfactory/sa/consumer \
    -parentID spiffe://example.org/ns/spire/sa/spire-agent \
    -selector k8s:ns:sslfactory \
    -selector k8s:sa:sslfactory  

kubectl exec -n spire spire-server-0 -- \
    /opt/spire/bin/spire-server entry create \
    -registrationUDSPath /run/spire/sockets/registration.sock \
    -spiffeID spiffe://example.org/ns/sslfactory/sa/producer \
    -parentID spiffe://example.org/ns/spire/sa/spire-agent \
    -selector k8s:ns:sslfactory \
    -selector k8s:sa:sslfactory  

kubectl exec -n spire spire-server-0 -- \
    /opt/spire/bin/spire-server entry create \
    -registrationUDSPath /run/spire/sockets/registration.sock \
    -spiffeID spiffe://example.org/ns/kafka/sa/default \
    -parentID spiffe://example.org/ns/spire/sa/spire-agent \
    -selector k8s:ns:kafka \
    -selector k8s:sa:default  
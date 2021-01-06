#!/bin/bash

# kubectl exec -n spire spire-server-0 -- \
#     /opt/spire/bin/spire-server entry create \
#     -spiffeID spiffe://example.org/ns/spire/sa/spire-agent \
#     -selector k8s_sat:cluster:demo-cluster \
#     -selector k8s_sat:agent_ns:spire \
#     -selector k8s_sat:agent_sa:spire-agent \
#     -node

# kubectl exec -n spire spire-server-0 -- \
#     /opt/spire/bin/spire-server entry create \
#     -spiffeID spiffe://example.org/ns/default/sa/default \
#     -parentID spiffe://example.org/ns/spire/sa/spire-agent \
#     -selector k8s:ns:default \
#     -selector k8s:sa:default

# kubectl apply -f k8s/yaml/client-deployment.yaml
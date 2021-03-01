#!/bin/bash
# Keycloak rest api documentation https://www.keycloak.org/docs-api/5.0/rest-api/index.html#_users_resource
set -x

KEYCLOAK=`kubectl get svc/keycloak -n keycloak | tail -n 1 | awk '{ print $4 }'`

echo "* Request for authorization"
RESULT=`curl -k --data "username=admin&password=admin&grant_type=password&client_id=admin-cli" https://${KEYCLOAK}:9443/auth/realms/master/protocol/openid-connect/token`

echo "\n"
echo "* Recovery of the token"
TOKEN=`echo $RESULT | sed 's/.*access_token":"//g' | sed 's/".*//g'`

echo "\n"
echo "* Display token"
echo $TOKEN

# curl -v https://172.18.0.3:9443/auth/admin/realms/master/users -k -H "Content-Type: application/json" -H "Authorization: bearer $TOKEN"   --data '{"firstName":"xyz","lastName":"xyz", "email":"demo2@gmail.com", "username":"demo2@gmail.com", "enabled":"true"}'


curl -X POST -d '{ "clientId": "kafka-broker" }' -v https://${KEYCLOAK}:9443/auth/admin/realms/master/clients -k -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" || true
sleep 5
ID=`curl -X GET https://${KEYCLOAK}:9443/auth/admin/realms/master/clients?clientId=kafka-broker -k -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" | jq -r '.[0].id'`
BROKER_SECRET=`curl -X GET -v https://${KEYCLOAK}:9443/auth/admin/realms/master/clients/${ID}/client-secret -k -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" | jq -r '.value'`

pushd ${PROJECT_HOME}/tmpdir
kubectl create secret generic broker-oauth-secret -n kafka \
  --from-literal=secret=$BROKER_SECRET -o yaml --dry-run=client > broker-oauth-secret.yaml

kubectl apply -n kafka -f broker-oauth-secret.yaml
popd
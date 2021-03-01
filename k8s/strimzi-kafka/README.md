cat > /tmp/tools-log4j.properties <<EOF
log4j.rootLogger=DEBUG, stderr

log4j.appender.stderr=org.apache.log4j.ConsoleAppender
log4j.appender.stderr.layout=org.apache.log4j.PatternLayout
log4j.appender.stderr.layout.ConversionPattern=[%d] %p %m (%c)%n
log4j.appender.stderr.Target=System.err
EOF

export OAUTH_CLIENT_ID=kafka-client
export OAUTH_CLIENT_SECRET=c376076b-6806-43f1-b680-582b15484f2f
export KAFKA_OPTS=" \
  -Dlog4j.configuration=file:/tmp/tools-log4j.properties \
  -Djavax.net.ssl.trustStore=/opt/kafka/keystore/kafka-client-truststore.p12 \
  -Djavax.net.ssl.trustStorePassword=truststorepassword \
  -Djavax.net.ssl.trustStoreType=PKCS12"

bin/kafka-console-producer.sh --broker-list my-cluster-kafka-bootstrap.kafka:9092 --producer-property 'security.protocol=SASL_PLAINTEXT' --producer-property 'sasl.mechanism=OAUTHBEARER' --producer-property 'sasl.jaas.config=org.apache.kafka.common.security.oauthbearer.OAuthBearerLoginModule required;' --producer-property 'sasl.login.callback.handler.class=io.strimzi.kafka.oauth.client.JaasClientOauthLoginCallbackHandler' --topic sample  

bin/kafka-console-consumer.sh --bootstrap-server my-cluster-kafka-bootstrap.kafka:9092 --consumer-property 'security.protocol=SASL_PLAINTEXT' --consumer-property 'sasl.mechanism=OAUTHBEARER' --consumer-property 'sasl.jaas.config=org.apache.kafka.common.security.oauthbearer.OAuthBearerLoginModule required;' --consumer-property 'sasl.login.callback.handler.class=io.strimzi.kafka.oauth.client.JaasClientOauthLoginCallbackHandler' --from-beginning --topic sample  

bin/kafka-console-consumer.sh --bootstrap-server \
  my-cluster-kafka-bootstrap.kafka:9092 --topic sample --from-beginning \
  --consumer-property 'security.protocol=SASL_PLAINTEXT' \
  --consumer-property 'sasl.mechanism=OAUTHBEARER' \
  --consumer-property 'sasl.jaas.config=org.apache.kafka.common.security.oauthbearer.OAuthBearerLoginModule required;' \
  --consumer-property 'sasl.login.callback.handler.class=io.strimzi.kafka.oauth.client.JaasClientOauthLoginCallbackHandler' 


FROM gcr.io/spiffe-io/spire-agent:0.11.0

COPY conf/spire-agent.conf /opt/spire/conf/agent/agent.conf
COPY conf/agent.key.pem /opt/spire/conf/agent/agent.key.pem
COPY conf/agent.crt.pem /opt/spire/conf/agent/agent.crt.pem
COPY agent.log /opt/spire/agent.log

ENTRYPOINT ["/bin/sh","-C"]
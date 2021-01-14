package org.apache.kafka.common.auth.spire;

import javax.net.ssl.SSLEngine;

import org.apache.kafka.common.security.auth.SslEngineFactory;

import java.io.IOException;
import java.security.KeyStore;
import java.util.Map;
import java.util.Set;

public class SpireSslEngineFactory implements SslEngineFactory {

    @Override
    public SSLEngine createClientSslEngine(String peerHost, int peerPort, String endpointIdentification) {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public SSLEngine createServerSslEngine(String peerHost, int peerPort) {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public KeyStore keystore() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Set<String> reconfigurableConfigs() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public boolean shouldBeRebuilt(Map<String, Object> nextConfigs) {
        // TODO Auto-generated method stub
        return false;
    }

    @Override
    public KeyStore truststore() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public void configure(Map<String, ?> configs) {
        // TODO Auto-generated method stub

    }

    @Override
    public void close() throws IOException {
        // TODO Auto-generated method stub

    }
    

}
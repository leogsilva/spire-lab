package org.apache.kafka.common.auth.spire;

import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLEngine;
import javax.net.ssl.SSLParameters;

import io.spiffe.exception.SocketEndpointAddressException;
import io.spiffe.exception.X509SourceException;
import io.spiffe.provider.SpiffeKeyStore;
import io.spiffe.provider.SpiffeProviderConstants;
import io.spiffe.provider.SpiffeSslContextFactory;
import io.spiffe.spiffeid.SpiffeId;
import io.spiffe.workloadapi.DefaultX509Source;
import io.spiffe.workloadapi.X509Source;
import org.apache.kafka.common.KafkaException;
import org.apache.kafka.common.config.SslClientAuth;
import org.apache.kafka.common.config.SslConfigs;
import org.apache.kafka.common.network.Mode;
import org.apache.kafka.common.security.auth.SslEngineFactory;
import org.apache.kafka.common.security.ssl.DefaultSslEngineFactory;
import org.apache.kafka.common.utils.SecurityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.security.KeyManagementException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.util.*;
import java.util.function.Supplier;
import java.util.stream.Collectors;

public class SpireSslEngineFactory implements SslEngineFactory {
    private static final Logger log = LoggerFactory.getLogger(DefaultSslEngineFactory.class);
    private Map<String, ?> configs;

    public static final String AGENT_SOCK = "spire.agent.sock";
    public static final String SPIFFE_IDS = "spire.spiffe.ids";
    private SSLContext sslContext;
    private SslClientAuth sslClientAuth;
    private String protocol;
    private String provider;

    @Override
    public SSLEngine createClientSslEngine(String peerHost, int peerPort, String endpointIdentification) {
        return createSslEngine(Mode.CLIENT, peerHost, peerPort, endpointIdentification);
    }

    private SSLEngine createSslEngine(Mode mode, String peerHost, int peerPort, String endpointIdentification) {
        SSLEngine sslEngine = this.sslContext.createSSLEngine(peerHost, peerPort);

        if (mode == Mode.SERVER) {
            sslEngine.setUseClientMode(false);
            switch(this.sslClientAuth) {
                case REQUIRED:
                    sslEngine.setNeedClientAuth(true);
                    break;
                case REQUESTED:
                    sslEngine.setWantClientAuth(true);
                case NONE:
            }

            sslEngine.setUseClientMode(false);
        } else {
            sslEngine.setUseClientMode(true);
            SSLParameters sslParams = sslEngine.getSSLParameters();
            sslParams.setEndpointIdentificationAlgorithm(endpointIdentification);
            sslEngine.setSSLParameters(sslParams);
        }

        return sslEngine;
    }

    @Override
    public SSLEngine createServerSslEngine(String peerHost, int peerPort) {
        return createSslEngine(Mode.SERVER, peerHost, peerPort, (String)null);
    }

    @Override
    public KeyStore keystore() {
        try {
            KeyStore instance = KeyStore.getInstance(SpiffeProviderConstants.ALGORITHM);
            return instance;
        } catch (KeyStoreException e) {
            log.error("Error returning keystore", e);
        }
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
        try {
            KeyStore instance = KeyStore.getInstance(SpiffeProviderConstants.ALGORITHM);
            return instance;
        } catch (KeyStoreException e) {
            log.error("Error returning truststore", e);
        }
        return null;
    }

    @Override
    public void configure(Map<String, ?> cfg) {
        this.configs = Collections.unmodifiableMap(cfg);
        this.protocol = (String) configs.get(SslConfigs.SSL_PROTOCOL_CONFIG);
        this.provider = (String) configs.get(SslConfigs.SSL_PROVIDER_CONFIG);
        SecurityUtils.addConfiguredSecurityProviders(this.configs);
        
        String rawSpiffeIds = (String) this.configs.get(SPIFFE_IDS);
        if (rawSpiffeIds == null) {
            throw new RuntimeException("Property " + SPIFFE_IDS + " not set");
        }
        log.info("Property " + SPIFFE_IDS + ": " + rawSpiffeIds);

        List<String> spiffeIds = Arrays.asList(rawSpiffeIds.split(","));
        String agentSock = (String)this.configs.get(AGENT_SOCK);
        if (agentSock == null) {
            throw new RuntimeException("Property " + AGENT_SOCK + " not set");
        }
        log.info("Property " + AGENT_SOCK + ":" + agentSock);

        SecurityUtils.addConfiguredSecurityProviders(this.configs);
        DefaultX509Source.X509SourceOptions x509SourceOptions = DefaultX509Source.X509SourceOptions
                .builder()
                .spiffeSocketPath(agentSock)
                .svidPicker(list -> list.get(list.size()-1))
                .build();
        X509Source x509Source = null;
        try {
            x509Source = DefaultX509Source.newSource(x509SourceOptions);
            this.sslContext = this.createSSLContext(x509Source, spiffeIds);
        } catch (SocketEndpointAddressException e) {
            log.error("Could not connecto to spire agent ", e);
            throw new RuntimeException(e);
        } catch (X509SourceException e) {
            log.error("Could not obtain X509 certificates", e);
            throw new RuntimeException(e);
        }
        this.sslClientAuth = createSslClientAuth((String)configs.get("ssl.client.auth"));
    }

    private SSLContext createSSLContext(X509Source x509Source, Collection<String> spiffeIds) {
        Supplier<Set<SpiffeId>> acceptedSpiffeIds = () -> spiffeIds.stream().map(id -> SpiffeId.parse(id)).collect(Collectors.toSet());
        SpiffeSslContextFactory.SslContextOptions options = SpiffeSslContextFactory.SslContextOptions
                .builder()
                .sslProtocol(this.protocol)
                .x509Source(x509Source)
                .acceptedSpiffeIdsSupplier(acceptedSpiffeIds)
                .build();

        SSLContext sslContext = null;
        try {
            sslContext = SpiffeSslContextFactory.getSslContext(options);
        } catch (NoSuchAlgorithmException e) {
            throw new KafkaException(e);
        } catch (KeyManagementException e) {
            throw new KafkaException(e);
        }
        return sslContext;
    }

    @Override
    public void close() throws IOException {
        this.sslContext = null;
    }

    private static SslClientAuth createSslClientAuth(String key) {
        SslClientAuth auth = SslClientAuth.forConfig(key);
        if (auth != null) {
            return auth;
        } else {
            log.warn("Unrecognized client authentication configuration {}.  Falling back to NONE.  Recognized client authentication configurations are {}.", key, String.join(", ", (Iterable)SslClientAuth.VALUES.stream().map((a) -> {
                return a.name();
            }).collect(Collectors.toList())));
            return SslClientAuth.NONE;
        }
    }

}
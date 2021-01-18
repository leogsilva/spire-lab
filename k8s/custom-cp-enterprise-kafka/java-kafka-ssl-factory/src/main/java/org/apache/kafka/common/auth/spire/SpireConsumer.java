package org.apache.kafka.common.auth.spire;

import io.spiffe.bundle.x509bundle.X509Bundle;
import io.spiffe.exception.BundleNotFoundException;
import io.spiffe.exception.SocketEndpointAddressException;
import io.spiffe.exception.X509SourceException;
import io.spiffe.provider.SpiffeProvider;
import io.spiffe.provider.SpiffeSslContextFactory;
import io.spiffe.spiffeid.SpiffeId;
import io.spiffe.spiffeid.TrustDomain;
import io.spiffe.svid.x509svid.X509Svid;
import io.spiffe.workloadapi.DefaultX509Source;
import io.spiffe.workloadapi.X509Source;

import javax.net.ssl.SSLContext;
import java.security.KeyManagementException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.Certificate;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.Collection;
import java.util.Collections;
import java.util.Set;
import java.util.function.Supplier;

public class SpireConsumer {

    public static final String X509 = "X509";
    private final KeyStore keyStore = null;

    public SpireConsumer() throws KeyStoreException {
        KeyStore.getInstance(KeyStore.getDefaultType());
    }
    
    private Collection<? extends Certificate> generateCertificates(byte[] input) throws IOException, CertificateException {
        return CertificateFactory.getInstance(X509).generateCertificates(new ByteArrayInputStream(input));
    }

    public SSLContext create(X509Source x509Source, String spiffeId) throws KeyManagementException, NoSuchAlgorithmException {
        X509Source source = x509Source;
        Supplier<Set<SpiffeId>> acceptedSpiffeIds = () -> Collections.singleton(SpiffeId.parse(spiffeId));
        SpiffeSslContextFactory.SslContextOptions options = SpiffeSslContextFactory.SslContextOptions
                .builder()
                .x509Source(source)
                .acceptedSpiffeIdsSupplier(acceptedSpiffeIds)
                .build();

        SSLContext sslContext = SpiffeSslContextFactory.getSslContext(options);
        return sslContext;
    }



    public X509Source createX509Source() throws X509SourceException, SocketEndpointAddressException, BundleNotFoundException {
        DefaultX509Source.X509SourceOptions x509SourceOptions = DefaultX509Source.X509SourceOptions
                .builder()
                .spiffeSocketPath("unix:/run/spire/sockets/agent.sock")
                .svidPicker(list -> list.get(list.size()-1))
                .build();
        X509Source x509Source = DefaultX509Source.newSource(x509SourceOptions);
        return x509Source;
    }

    public X509Bundle createX509Bundle(X509Source x509Source, String domainName) throws BundleNotFoundException {
        X509Bundle bundle = x509Source.getBundleForTrustDomain(TrustDomain.of(domainName));
        return bundle;
    }
}

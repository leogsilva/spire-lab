package org.apache.kafka.common.auth.spire;

import io.spiffe.provider.SpiffeProvider;
import io.spiffe.provider.SpiffeProviderConstants;
import io.spiffe.workloadapi.X509Source;
import org.junit.Assert;
import org.junit.Test;

import javax.net.ssl.KeyManagerFactory;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.TrustManagerFactory;
import java.security.KeyStore;
import java.security.Provider;
import java.security.Security;

public class SpiffeProviderTest {

    @Test
    public void testProvider() throws Exception {
        SpiffeProvider.install();
        Provider spiffe = Security.getProvider("Spiffe");
        Assert.assertNotNull(spiffe);
        KeyStore keyStore = KeyStore.getInstance(SpiffeProviderConstants.ALGORITHM, spiffe);
        Assert.assertNotNull(keyStore);
        System.out.println(keyStore);
        TrustManagerFactory trust = TrustManagerFactory.getInstance(SpiffeProviderConstants.ALGORITHM);
        KeyManagerFactory keyManagerFactory = KeyManagerFactory.getInstance(SpiffeProviderConstants.ALGORITHM);
        SpireConsumer c = new SpireConsumer();
        X509Source x509Source = c.createX509Source();
        SSLContext sslContext = c.create(x509Source, "spiffe://example.org/ns/default/sa/default");
        SSLContext instance = SSLContext.getInstance("TLSv1.2", spiffe);
        System.out.println("--> " + instance);

    }
}

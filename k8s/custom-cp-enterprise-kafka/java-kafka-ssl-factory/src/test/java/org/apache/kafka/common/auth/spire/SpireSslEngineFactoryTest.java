package org.apache.kafka.common.auth.spire;

import alkarn.github.io.sslengine.example.NioSslClient;
import alkarn.github.io.sslengine.example.NioSslServer;
import io.grpc.netty.shaded.io.grpc.netty.NettyServerBuilder;
import io.spiffe.bundle.x509bundle.X509Bundle;
import io.spiffe.exception.BundleNotFoundException;
import io.spiffe.exception.SocketEndpointAddressException;
import io.spiffe.exception.X509SourceException;
import io.spiffe.spiffeid.TrustDomain;
import io.spiffe.svid.x509svid.X509Svid;
import io.spiffe.workloadapi.DefaultX509Source;
import io.spiffe.workloadapi.X509Source;
import org.apache.kafka.common.config.SslConfigs;
import org.apache.kafka.common.security.auth.SslEngineFactory;
import org.apache.kafka.common.security.ssl.SslFactoryTest;
import org.junit.Assert;
import org.junit.ClassRule;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.Timeout;
import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;
import org.junit.runners.Parameterized;

import javax.net.ssl.SSLEngine;
import java.io.File;
import java.io.FileWriter;
import java.util.HashMap;
import java.util.Map;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

@RunWith(JUnit4.class)
public class SpireSslEngineFactoryTest  extends SslFactoryTest{


//    @Rule
//    public Timeout testTimeout = new Timeout(60000);

    public SpireSslEngineFactoryTest() {
    }

    @Test
    public void testSSL() throws Exception {
        String address = AGENT_SOCK;
        SslEngineFactory serverFactory = super.createServerFactory();

        SSLEngine serverEngine = serverFactory.createServerSslEngine("localhost", 8443);
        final NioSslServer nioServer = new NioSslServer("localhost", 8443, serverEngine);

        final Runnable server = () -> {
            try {
                 nioServer.start();
            } catch (Exception e) {
                e.printStackTrace();
            }
        };
        Thread t = new Thread(server);
        t.start();

        SpireSslEngineFactory clientFactory = new SpireSslEngineFactory();
        Map<String,String> clientConfig = new HashMap<String,String>();
        clientConfig.put(SpireSslEngineFactory.AGENT_SOCK, AGENT_SOCK);
        clientConfig.put(SpireSslEngineFactory.SPIFFE_IDS, "spiffe://example.org/ns/sslfactory/sa/consumer,spiffe://example.org/ns/sslfactory/sa/producer");
        clientFactory.configure(clientConfig);

        SSLEngine clientEngine = clientFactory.createClientSslEngine("localhost", 8443, null);
        NioSslClient client = new NioSslClient("localhost",8443, clientEngine);
        client.connect();
        client.write("Hello SPIRE");
        client.read();
        client.shutdown();
        nioServer.stop();

    }
}

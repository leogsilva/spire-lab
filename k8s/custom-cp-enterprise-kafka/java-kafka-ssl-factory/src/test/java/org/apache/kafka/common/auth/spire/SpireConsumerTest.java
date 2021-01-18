package org.apache.kafka.common.auth.spire;

import io.spiffe.bundle.x509bundle.X509Bundle;
import io.spiffe.exception.BundleNotFoundException;
import io.spiffe.exception.SocketEndpointAddressException;
import io.spiffe.exception.X509SourceException;
import io.spiffe.spiffeid.TrustDomain;
import io.spiffe.svid.x509svid.X509Svid;
import io.spiffe.workloadapi.DefaultX509Source;
import io.spiffe.workloadapi.X509Source;
import org.junit.Test;

public class SpireConsumerTest {

    @Test
    public void testSVID() {
        DefaultX509Source.X509SourceOptions x509SourceOptions = DefaultX509Source.X509SourceOptions
                .builder()
                .spiffeSocketPath("unix:/run/spire/sockets/agent.sock")
                .svidPicker(list -> list.get(list.size()-1))
                .build();
        X509Source x509Source = null;
        try {
            x509Source = DefaultX509Source.newSource(x509SourceOptions);
        } catch (SocketEndpointAddressException | X509SourceException e) {
            e.printStackTrace();
        }
        X509Svid svid = x509Source.getX509Svid();
        System.out.println("SVID: " + svid);
        X509Bundle bundle = null;
        try {
            bundle = x509Source.getBundleForTrustDomain(TrustDomain.of("example.org"));
        } catch (BundleNotFoundException e) {
            e.printStackTrace();
        }
        System.out.println("Authorities:" + bundle.getX509Authorities());
    }
}

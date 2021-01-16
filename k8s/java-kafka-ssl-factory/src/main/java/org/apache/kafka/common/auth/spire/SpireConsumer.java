package org.apache.kafka.common.auth.spire;

import java.security.cert.Certificate;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.Collection;

public class SpireConsumer {

    public static final String X509 = "X509";
    
    private Collection<? extends Certificate> generateCertificates(byte[] input) throws IOException, CertificateException {
        return CertificateFactory.getInstance(X509).generateCertificates(new ByteArrayInputStream(input));
    }


}

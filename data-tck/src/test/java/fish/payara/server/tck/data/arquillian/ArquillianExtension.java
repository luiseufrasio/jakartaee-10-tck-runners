package fish.payara.server.tck.data.arquillian;

import org.jboss.arquillian.container.test.spi.client.deployment.ApplicationArchiveProcessor;
import org.jboss.arquillian.core.spi.LoadableExtension;

/**
 * Arquillian Extension to add Processors
 */
public class ArquillianExtension implements LoadableExtension {
    @Override
    public void register(ExtensionBuilder builder) {
        builder.service(ApplicationArchiveProcessor.class, PayaraPersistenceProcessor.class);
    }
}

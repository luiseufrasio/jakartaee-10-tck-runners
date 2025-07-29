package fish.payara.server.tck.data.arquillian;

import com.sun.tdk.signaturetest.SignatureTest;
import com.sun.tdk.signaturetest.plugin.PluginAPI;
import com.sun.tdk.signaturetest.util.CommandLineParser;
import ee.jakarta.tck.data.standalone.entity.EntityTests;
import java.util.logging.Logger;
import org.jboss.arquillian.container.test.spi.client.deployment.ApplicationArchiveProcessor;
import org.jboss.arquillian.test.spi.TestClass;
import org.jboss.shrinkwrap.api.Archive;
import org.jboss.shrinkwrap.api.asset.ClassLoaderAsset;
import org.jboss.shrinkwrap.api.spec.WebArchive;

public class PayaraPersistenceProcessor implements ApplicationArchiveProcessor {
    
    private static final Logger logger = Logger.getLogger(PayaraPersistenceProcessor.class.getName());

    @Override
    public void process(Archive<?> archive, TestClass testClass) {
        logger.info("preprocessing archive:" + archive.getName());
        logger.info("with content:" + archive.getContent());
        if (archive instanceof WebArchive webArchive) {
            webArchive.addAsWebInfResource(getClass().getClassLoader().getResource("persistence.xml"), 
                    "classes/META-INF/persistence.xml")
                    .addAsWebInfResource(getClass().getClassLoader().getResource("beans.xml"),"classes/META-INF/beans.xml")
                    .addPackages(false, TransactionExtension.class.getPackage(), EntityTests.class.getPackage())
                    .addPackages(true, SignatureTest.class.getPackage(), PluginAPI.class.getPackage(),
                            com.sun.tdk.signaturetest.core.Log.class.getPackage(), CommandLineParser.class.getPackage())
                    .add(new ClassLoaderAsset("META-INF/services/org.junit.jupiter.api.extension.Extension"),
                            "WEB-INF/classes/META-INF/services/org.junit.jupiter.api.extension.Extension");
        }
    }
}

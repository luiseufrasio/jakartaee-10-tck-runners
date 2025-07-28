package fish.payara.server.tck.data.arquillian;

import com.sun.tdk.signaturetest.SignatureTest;
import com.sun.tdk.signaturetest.plugin.PluginAPI;
import com.sun.tdk.signaturetest.util.CommandLineParser;
import ee.jakarta.tck.data.standalone.entity.EntityTests;
import org.jboss.arquillian.container.test.spi.client.deployment.ApplicationArchiveProcessor;
import org.jboss.arquillian.test.spi.TestClass;
import org.jboss.shrinkwrap.api.Archive;
import org.jboss.shrinkwrap.api.asset.ClassLoaderAsset;
import org.jboss.shrinkwrap.api.spec.WebArchive;

public class PayaraPersistenceProcessor implements ApplicationArchiveProcessor {


    @Override
    public void process(Archive<?> archive, TestClass testClass) {
        if (archive instanceof WebArchive webArchive) {
            webArchive.addAsWebInfResource(getClass().getClassLoader().getResource("persistence.xml"), 
                    "classes/META-INF/persistence.xml")
                    .addPackages(false, TransactionExtension.class.getPackage(), EntityTests.class.getPackage())
                    .addPackages(true, SignatureTest.class.getPackage(), PluginAPI.class.getPackage(),
                            com.sun.tdk.signaturetest.core.Log.class.getPackage(), CommandLineParser.class.getPackage())
                    .add(new ClassLoaderAsset("META-INF/services/org.junit.jupiter.api.extension.Extension"),
                            "WEB-INF/classes/META-INF/services/org.junit.jupiter.api.extension.Extension");
        }
    }
}

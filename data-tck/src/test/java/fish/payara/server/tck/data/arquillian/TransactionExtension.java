package fish.payara.server.tck.data.arquillian;

import java.lang.reflect.Method;
import java.util.logging.Logger;
import org.junit.jupiter.api.extension.ExtensionContext;
import org.junit.jupiter.api.extension.InvocationInterceptor;
import org.junit.jupiter.api.extension.ReflectiveInvocationContext;

/**
 * This Extension will provide transaction for all methods executed by the tests from TCK
 */
public class TransactionExtension implements InvocationInterceptor {

    private static final Logger log = Logger.getLogger(TransactionExtension.class.getName());
    
    @Override
    public void interceptTestMethod(Invocation<Void> invocation, ReflectiveInvocationContext<Method> invocationContext, ExtensionContext extensionContext) throws Throwable {
        log.info("intercepting test method"+invocationContext.toString());
        invocation.proceed();
    }
}

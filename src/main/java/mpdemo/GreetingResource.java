package mpdemo;

import org.eclipse.microprofile.config.inject.ConfigProperty;
import org.eclipse.microprofile.faulttolerance.Retry;
import org.eclipse.microprofile.metrics.annotation.Metered;

import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("/hello")
public class GreetingResource {

    @Inject
    @ConfigProperty(name = "message", defaultValue = "Hello from MicroProfile!")
    String message;

    @GET
    @Retry
    @Metered
    @Produces(MediaType.TEXT_PLAIN)
    public String hello() {
        return this.message;
    }
}
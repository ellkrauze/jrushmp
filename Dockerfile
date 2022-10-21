FROM bellsoft/liberica-openjdk-alpine-musl-std:latest as builder
# Create custom JRE
RUN jlink --compress 2 --strip-java-debug-attributes --no-header-files --no-man-pages --add-modules java.base,java.compiler,java.datatransfer,java.desktop,java.logging,java.management,java.naming,java.rmi,java.security.sasl,java.security.jgss,java.sql,java.transaction.xa,java.xml,jdk.compiler,jdk.management,jdk.unsupported,jdk.zipfs --output /jlink-runtime

# FROM alpine:latest
FROM bellsoft/alpaquita-linux-base:stream-musl
COPY --from=builder /jlink-runtime /jlink-runtime
COPY target/quarkus-app/lib/ /opt/quarkus-app/lib/
COPY target/quarkus-app/*.jar /opt/quarkus-app/
COPY target/quarkus-app/app/ /opt/quarkus-app/app/
COPY target/quarkus-app/quarkus/ /opt/quarkus-app/quarkus/

EXPOSE 8080
# ENV AB_JOLOKIA_OFF=""
ENV JAVA_OPTS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager" 
ENTRYPOINT ["/jlink-runtime/bin/java", "-jar", "/opt/quarkus-app/quarkus-run.jar"]

FROM bellsoft/liberica-openjdk-alpine-musl:latest as base
RUN jlink --compress 2 --strip-java-debug-attributes  --no-header-files \
--no-man-pages --add-modules \
java.base,java.compiler,java.datatransfer,java.desktop,java.logging,java.management,java.naming,java.rmi,java.security.sasl,java.security.jgss,java.sql,java.transaction.xa,java.xml,jdk.compiler,jdk.management,jdk.unsupported,jdk.zipfs \
--output /jlink-runtime

FROM alpine:latest
COPY --from=base /jlink-runtime /jlink-runtime
COPY --chown=185 target/quarkus-app/lib/ /opt/quarkus-app/lib/
COPY --chown=185 target/quarkus-app/*.jar /opt/quarkus-app/
COPY --chown=185 target/quarkus-app/app/ /opt/quarkus-app/app/
COPY --chown=185 target/quarkus-app/quarkus/ /opt/quarkus-app/quarkus/

EXPOSE 8080
USER 185
ENV AB_JOLOKIA_OFF=""
ENV JAVA_OPTS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"
ENTRYPOINT ["/jlink-runtime/bin/java", "-jar", "/opt/quarkus-app/quarkus-run.jar"]
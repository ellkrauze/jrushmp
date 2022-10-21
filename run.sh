#!/bin/sh

JAVA_HOME=/Users/ellkrauze/java/jdk-17.0.4.1.jdk

mvn package -Dquarkus.package.type=uber-jar
jdeps --multi-release 11 -cp target/lib/*:target/quarkus-app/lib/boot/*:target/quarkus-app/lib/* --ignore-missing-deps --list-deps target/jrushmp-1.0.0-SNAPSHOT-runner.jar
jlink --compress 2 --strip-debug --no-header-files --no-man-pages --add-modules java.base,java.compiler,java.datatransfer,java.desktop,java.logging,java.management,java.naming,java.rmi,java.security.sasl,java.security.jgss,java.sql,java.transaction.xa,java.xml,jdk.compiler,jdk.management,jdk.unsupported,jdk.zipfs --output target/jlink-runtime
echo "Size of jlink runtime is $(du -sh target/jlink-runtime)"

wget https://raw.githubusercontent.com/bell-sw/Liberica/master/docker/repos/liberica-openjdk-alpine-musl/17/Dockerfile -O Dockerfile.liberica
docker build -f Dockerfile.liberica --build-arg LIBERICA_IMAGE_VARIANT=standard -t bellsoft/liberica-openjdk-alpine-musl-std:latest .
docker build -f Dockerfile -t jlink:1.0 . && docker run -it --rm -p 8080:8080 jlink:1.0

docker images | grep jlink
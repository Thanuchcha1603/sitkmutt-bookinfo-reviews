# MULTISTAGE Build
FROM gradle:7.2.0-jdk17 AS builder
WORKDIR /opt/java/
COPY . /opt/java/
RUN gradle clean build

# MULTISTAGE Run
FROM websphere-liberty:21.0.0.9-kernel-java8-ibmjava

# Copy .jar file from build stage
COPY --from=builder /opt/java/build/libs/java.war /opt/ibm/wlp/usr/servers/defaultServer/apps/reviews.war
# Copy server configuration
COPY config/server.xml /opt/ibm/wlp/usr/servers/defaultServer/

RUN /opt/ibm/wlp/bin/installUtility install  --acceptLicense /opt/ibm/wlp/usr/servers/defaultServer/server.xml

EXPOSE 8082

CMD ["/opt/ibm/wlp/bin/server", "run", "defaultServer","8082"]
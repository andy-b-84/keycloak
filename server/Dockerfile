FROM tpires/alpine-openjdk:8

ENV KEYCLOAK_VERSION 1.9.8.Final
# Enables signals getting passed from startup script to JVM
# ensuring clean shutdown when container is stopped.
ENV LAUNCH_JBOSS_IN_BACKGROUND 1
ENV DEPS="jq curl unzip"

USER root

RUN apk update \
    && apk add $DEPS \
    && rm /var/cache/apk/*
RUN mkdir -p /usr/share/java/saxon
RUN curl -L -o /usr/share/java/saxon/saxon.zip http://downloads.sourceforge.net/project/saxon/Saxon-HE/9.6/SaxonHE9-6-0-7J.zip \
    && unzip /usr/share/java/saxon/saxon.zip -d /usr/share/java/saxon \
    && rm -rf /usr/share/java/saxon/noticies /usr/share/java/saxon/doc \
      /usr/share/java/saxon/saxon9-test.jar /usr/share/java/saxon/saxon9-unpack.jar /usr/share/java/saxon/saxon.zip \
    && ln -s /usr/share/java/saxon/saxon9he.jar /usr/share/java/saxon.jar

USER jboss

ENV JBOSS_HOME /opt/jboss/keycloak

RUN cd /opt/jboss/ \
    && curl -L https://downloads.jboss.org/keycloak/$KEYCLOAK_VERSION/keycloak-$KEYCLOAK_VERSION.tar.gz | tar zx \
    && mv /opt/jboss/keycloak-$KEYCLOAK_VERSION /opt/jboss/keycloak

ADD docker-entrypoint.sh /opt/jboss/docker-entrypoint.sh
ADD setLogLevel.xsl /opt/jboss/keycloak/setLogLevel.xsl

RUN java -jar /usr/share/java/saxon.jar -s:/opt/jboss/keycloak/standalone/configuration/standalone.xml -xsl:/opt/jboss/keycloak/setLogLevel.xsl -o:/opt/jboss/keycloak/standalone/configuration/standalone.xml

EXPOSE 8080

ENTRYPOINT [ "/opt/jboss/docker-entrypoint.sh" ]
CMD ["-b", "0.0.0.0"]

#ENTRYPOINT ["watch"]
#CMD ["ps", "-ef"]

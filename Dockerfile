FROM openjdk:8u141-jdk

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

EXPOSE 9966

CMD [ "java", "-jar", "-Xmx256m", "-Xss32m", "/usr/src/app/spring-petclinic-1.5.2.war" ]

# Install app dependencies
COPY target/spring-petclinic-1.5.2.war /usr/src/app/
FROM maven:3.3.3-jdk-8 

# copy app
COPY . /usr/src/app/

# set app working directory
WORKDIR /usr/src/app/

EXPOSE 9966

CMD ["./mvnw spring-boot:run"]


FROM maven:3.3.3-jdk-8 

# copy app
COPY . /usr/src/app/

# set app working directory
WORKDIR /usr/src/app/

CMD [ "./mvnw", "spring-boot:run" ]

EXPOSE 9966
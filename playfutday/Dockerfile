# docker build -t playfutday:1.0 .
FROM  maven:3.8.5-openjdk-17
WORKDIR /playfutday
COPY . .
RUN mvn clean install

RUN mvn dependency:resolve

CMD mvn spring-boot:run
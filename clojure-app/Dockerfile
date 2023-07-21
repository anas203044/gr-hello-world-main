# syntax = docker/dockerfile:1.0-experimental
FROM clojure:openjdk-8-lein-2.9.3-buster AS UBERJAR_BUILD
ARG AWS_ACCESS_KEY_ID 
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_SESSION_TOKEN
ENV AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
ENV AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
ENV AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY ./clojure-app/* /usr/src/app
RUN lein clean
RUN lein uberjar

FROM openjdk:11.0.7-jre-slim AS RUNTIME
RUN mkdir -p /usr/src/app
ENV JAVA_OPTS=""
WORKDIR /usr/src/app
COPY --from=UBERJAR_BUILD /usr/src/app/target/devops-clojure-mini.jar devops-clojure-mini.jar
CMD ["sh", "-c", "java $JAVA_OPTS -Duser.timezone=UTC -jar devops-clojure-mini.jar"]

# TODO APP

Todo app is an example rest application, which can be build and deployed on Local and AWS environment.

## Tech

TODO App uses following technologies:

* [Java 11] - JDK
* [Maven] - Build tool
* [Gradle] - Build tool
* [Springboot] - Open source Java-based Micro-Service framework
* [Spring-Data-Jpa] - JPA based repositories
* [Swagger] - Rest API documentation
* [Junit] - Unit test
* [MySql] - Backend data store
* [Docker] - OS level virtualization
* [Minikube] - Local kubernetes


## Build ##
##### Maven #####
Build application using below command

```bash
mvn clean install
```
or

```bash
./mvnw clean install
```

##### Gradle #####
Build application using below command

```bash
gradle clean build
```
or

```bash
./gradlew clean build
```

##### Docker image #####

```bash
docker build -f Dockerfile.mvn --tag klab-todo:0.0.1 .
```
or

```bash
docker build -f Dockerfile.gradle --tag klab-todo:0.0.1 .
```

## Run ##
```bash
docker-compose up -d
```

# TODO APP

Todo app is an example rest application, which can be build and deployed on Local and AWS environment.

## Tech

TODO App uses following technologies:

* [Java 11] - JDK
* [Maven-3.6.3] - Build tool
* [Gradle-6.7.1] - Build tool
* [Springboot-2.4.0] - Open source Java-based Micro-Service framework
* [Swagger-3.0.0] - Rest API documentation
* [Junit-5.7.0] - Unit test
* [MySql-8.0.22] - Backend data store
* [Docker-19.03.8] - OS level virtualization
* [Helm-v3.4.1] - Package Manager for kubernetes
* [Kubernetes-v1.19.2] - OS level virtualization
* [Minikube-v1.15.1] - Local kubernetes


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
docker build -f Dockerfile.mvn --tag psi-todo:1.0.0 .
```
or

```bash
docker build -f Dockerfile.gradle --tag psi-todo:1.0.0 .
```

## Run ##
```bash
docker-compose --env-file=env/<env>/Docker.env up -d
```
# Chapter 3. Documentation Overview

This section provides a brief overview of Spring Boot reference documentation. It serves as a map for the rest of the document.

The latest copy of this document is available at `docs.spring.io/spring-boot/docs/current/reference/`.

## 3.1. First Steps
 
 If you are getting started with Spring Boot or 'Spring' in general, start with the following topics:

 -  From scratch: Overview | Requirements | Installation
 -  Tutorial: Part 1 | Part 2
 - Running your example: Part 1 | Part 2

## 3.2. Upgrading From an Earlier Version

You should always ensure that you are running a supported version of Spring Boot.

Depending on the version that you are upgrading to, you can find some additional tips here:

- From 1.x: Upgrading from 1.x
- To a new feature release: Upgrading to New Feature Release
- Spring Boot CLI: Upgrading the Spring Boot CLI

## 3.3. Developing With Spring Boot

Ready to actually start using Spring Boot? We have you covered:

-  Build systems: Maven | Gradle | Ant | Starters
- Best practices: Code Structure | @Configuration | @EnableAutoConfiguration | Beans and Dependency Injection
- Running your code: IDE | Packaged | Maven | Gradle
- Packaging your app: Production jars
- Spring Boot CLI: Using the CLI

## 3.4. Learning About Spring Boot Features

Need more details about Spring Boot’s core features? The following content is for you:

- Spring Application: SpringApplication

- External Configuration: External Configuration

- Profiles: Profiles

- Logging: Logging

## 3.5. Web

If you develop Spring Boot web applications, take a look at the following content:

- Servlet Web Applications: Spring MVC, Jersey, Embedded Servlet Containers

- Reactive Web Applications: Spring Webflux, Embedded Servlet Containers

- Graceful Shutdown: Graceful Shutdown
  
- Spring Security: Default Security Configuration, Auto-configuration for OAuth2, SAML
  
- Spring Session: Auto-configuration for Spring Session

- Spring HATEOAS: Auto-configuration for Spring HATEOAS

## 3.6. Data

If your application deals with a datastore, you can see how to configure that here:

- SQL: Configuring a SQL Datastore, Embedded Database support, Connection pools, and more.

- NOSQL: Auto-configuration for NOSQL stores such as Redis, MongoDB, Neo4j, and others.

## 3.7. Messaging

If your application uses any messaging protocol, see one or more of the following sections:

- JMS: Auto-configuration for ActiveMQ and Artemis, Sending and Receiving messages through JMS

- AMQP: Auto-configuration for RabbitMQ

- Kafka: Auto-configuration for Spring Kafka

- RSocket: Auto-configuration for Spring Framework’s RSocket Support

- Spring Integration: Auto-configuration for Spring Integration

## 3.8. IO

If your application needs IO capabilities, see one or more of the following sections:

- Caching: Caching support with EhCache, Hazelcast, Infinispan, and more

- Quartz: Quartz Scheduling

- Mail: Sending Email

- Validation: JSR-303 Validation

- REST Clients: Calling REST Services with RestTemplate and WebClient

- Webservices: Auto-configuration for Spring Web Services

- JTA: Distributed Transactions with JTA

## 3.9. Container Images

Spring Boot provides first-class support for building efficient container images. You can read more
about it here:

- Efficient Container Images: Tips to optimize container images such as Docker images

- Dockerfiles: Building container images using dockerfiles
 
- Cloud Native Buildpacks: Support for Cloud Native Buildpacks with Maven and Gradle

## 3.10. GraalVM Native Images

Spring Boot applications can be converted into native executables using GraalVM. You can read
more about our native image support here:

- GraalVM Native Images: Introduction | Key Differences with the JVM | Ahead-of-Time Processing

- Getting Started: Buildpacks | Native Build Tools

- Testing: JVM | Native Build Tools

- Advanced Topics: Nested Configuration Properties | Converting JARs | Known Limitations
## 3.11. Advanced Topics

Finally, we have a few topics for more advanced users:

- Spring Boot Applications Deployment: Cloud Deployment | OS Service

- Build tool plugins: Maven | Gradle

- Appendix: Application Properties | Configuration Metadata | Auto-configuration Classes | Test Auto-configuration Annotations | Executable Jars | Dependency Versions
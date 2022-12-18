# Chapter 6. Developing with Spring Boot

This section goes into more detail about how you should use Spring Boot.

It covers topics such as build systems, auto-configuration, and how to run your applications.

We also cover some Spring Boot best practices.

Although there is nothing particularly special about Spring Boot (it is just
another library that you can consume), there are a few recommendations that, when followed,
make your development process a little easier.

If you are starting out with Spring Boot, you should probably read the `Getting Started` guide before
diving into this section.


## 6.1. Build Systems

It is strongly recommended that you choose a build system that supports dependency management
and that can consume artifacts published to the “Maven Central” repository.

- artifact n.（尤指有文化价值或历史价值的）人工制品，历史文物；非自然存在物体，假象（=artefact）

We would recommend that you choose Maven or Gradle.

It is possible to get Spring Boot to work with other build systems (Ant, for example), but they are not particularly well supported.


### 6.1.1. Dependency Management

Each release of Spring Boot provides a curated list of dependencies that it supports.

- curated adj. 仔细挑选并展览的

In practice, you do not need to provide a version for any of these dependencies in your build configuration, as Spring Boot manages that for you.

When you upgrade Spring Boot itself, these dependencies are upgraded as well in a consistent way.

- in a consistent way 以一贯的方式

The curated list contains all the Spring modules that you can use with Spring Boot as well as a refined list of third party libraries.

The list is available as a standard Bills of Materials (spring-boot-dependencies) that can be used with both Maven and Gradle.

- a standard Bills of Materials 标准的材料清单


## 1.2. Maven

To learn about using Spring Boot with Maven, see the documentation for Spring Boot’s Maven plugin:

Reference (HTML and PDF)

API

## 1.3. Gradle

To learn about using Spring Boot with Gradle, see the documentation for Spring Boot’s Gradle plugin:

Reference (HTML and PDF)

API

## 1.4. Ant

....

## 1.5. Starters

Starters are a set of convenient dependency descriptors that you can include in your application.

- convenient adj. 方便的，便利的；附近的，方便到达的；<旧>适当的

You get a one-stop shop for all the Spring and related technologies that you need without having to hunt through sample code and copy-paste loads of dependency descriptors.

- You get a one-stop shop 你可以得到一站式服务
- hunt through 找遍

For example, if you want to get started using Spring and JPA for database access, include the `spring-boot-starter-data-jpa` dependency in your project.

The starters contain a lot of the dependencies that you need to get a project up and running quickly and with a consistent, supported set of managed transitive dependencies.

- transitive adj.（动词）及物的；（关系）可递的，可迁的，传递的

What is in a name

All official starters follow a similar naming pattern;

spring-boot-starter-_, where _ is a particular type of application.

This naming structure is intended to help when you need to find a starter.

- be intended to 打算……；意图是

The Maven integration in many IDEs lets you search dependencies by name.

For example, with the appropriate Eclipse or Spring Tools plugin installed, you can press `ctrl-space` in the POM editor and type “spring-boot-starter” for a complete list.

- appropriate adj. 合适的，相称的

As explained in the “Creating Your Own Starter” section, third party starters should not start with `spring-boot`, as it is reserved for official Spring Boot artifacts.

- reserve v. 预订；保留，预留；

Rather, a third-party starter typically starts with the name of the project.

For example, a third-party starter project called `thirdpartyproject` would typically be named `thirdpartyproject-spring-boot-starter`.

The following application starters are provided by Spring Boot under the `org.springframework.boot` group:

_Table 1. Spring Boot application starters_

| Name                                        | Description                                                                                                                              |
| ------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| spring-boot-starter                         | Core starter, including auto-configuration support, logging and YAML                                                                     |
| spring-boot-starter-amqp                    | Starter for using Spring AMQP and Rabbit MQ                                                                                              |
| spring-boot-starter-aop                     | Starter for aspect-oriented programming with Spring AOP and AspectJ                                                                      |
| spring-boot-starter-**artemis**             | Starter for JMS messaging using Apache Artemis                                                                                           |
| spring-boot-starter-batch                   | Starter for using Spring Batch                                                                                                           |
| spring-boot-starter-cache                   | Starter for using Spring Framework’s caching support                                                                                     |
| spring-boot-starter-data-**cassandra**      | Starter for using Cassandra distributed database and Spring Data Cassandra                                                               |
| spring-boot-starter-data-cassandra-reactive | Starter for using Cassandra distributed database and Spring Data Cassandra Reactive                                                      |
| spring-boot-starter-data-**couchbase**      | Starter for using Couchbase document-oriented database and Spring Data Couchbase                                                         |
| spring-boot-starter-data-couchbase-reactive | Starter for using Couchbase document-oriented database and Spring Data Couchbase Reactive                                                |
| spring-boot-starter-data-elasticsearch      | Starter for using Elasticsearch search and analytics engine and Spring Data Elasticsearche                                               |
| spring-boot-starter-data-jdbc               | Starter for using Spring Data JDBC                                                                                                       |
| spring-boot-starter-data-jpa                | Starter for using Spring Data JPA with Hibernate                                                                                         |
| spring-boot-starter-data-**ldap**           | Starter for using Spring Data LDAP                                                                                                       |
| spring-boot-starter-data-mongodb            | Starter for using MongoDB document-oriented database and Spring Data MongoDB                                                             |
| spring-boot-starter-data-mongodb-reactive   | Starter for using MongoDB document-oriented database and Spring Data MongoDB Reactive                                                    |
| spring-boot-starter-data-neo4j              | Starter for using Neo4j graph database and Spring Data Neo4j                                                                             |
| spring-boot-starter-data-r2dbc              | Starter for using Spring Data R2DBC                                                                                                      |
| spring-boot-starter-data-redis              | Starter for using Redis key-value data store with Spring Data Redis and the Lettuce client                                               |
| spring-boot-starter-data-redis-reactive     | Starter for using Redis key-value data store with Spring Data Redis reactive and the Lettuce client                                      |
| spring-boot-starter-data-rest               | Starter for exposing Spring Data repositories over REST using Spring Data REST                                                           |
| spring-boot-starter-freemarker              | Starter for building MVC web applications using FreeMarker views                                                                         |
| spring-boot-starter-**graphql**             | Starter for building GraphQL applications with Spring GraphQL                                                                            |
| spring-boot-starter-groovy-templates        | Starter for building MVC web applications using Groovy Templates views                                                                   |
| spring-boot-starter-**hateoas**             | Starter for building hypermedia-based RESTful web application with Spring MVC and Spring **HATEOA**                                      |
| spring-boot-starter-**integration**         | Starter for using Spring Integration                                                                                                     |
| spring-boot-starter-jdbc                    | Starter for using JDBC with the HikariCP connection pool                                                                                 |
| spring-boot-starter-jersey                  | Starter for building RESTful web applications using JAX-RS and Jersey. **An alternative to** `spring-boot-starter-web`                   |
| spring-boot-starter-jooq                    | Starter for using jOOQ to access SQL databases with JDBC. An alternative to `spring-boot-starter-data-jpa` or `spring-boot-starter-jdbc` |
| spring-boot-starter-json                    | Starter for reading and writing json                                                                                                     |
| spring-boot-starter-mail                    | Starter for using Java Mail and Spring Framework’s email sending support                                                                 |
| spring-boot-starter-**mustache**            | Starter for building web applications using Mustache views                                                                               |
| spring-boot-starter-oauth2-resource-server  | Starter for using Spring Security’s OAuth2 resource server features                                                                      |
| spring-boot-starter-quartz                  | Starter for using the Quartz scheduler                                                                                                   |
| spring-boot-starter-**rsocket**             | Starter for building RSocket clients and servers                                                                                         |
| spring-boot-starter-security                | Starter for using Spring Security                                                                                                        |
| spring-boot-starter-test                    | Starter for testing Spring Boot applications with libraries including JUnit Jupiter, **Hamcrest** and **Mockito**                        |
| spring-boot-starter-thymeleaf               | Starter for building MVC web applications using Thymeleaf views                                                                          |
| spring-boot-starter-validation              | Starter for using Java Bean Validation with Hibernate Validator                                                                          |
| spring-boot-starter-web                     | Starter for building web, including RESTful, applications using Spring MVC. Uses Tomcat as the default embedded container                |
| spring-boot-starter-web-services            | Starter for using Spring Web Services                                                                                                    |
| spring-boot-starter-webflux                 | Starter for building WebFlux applications using Spring Framework’s Reactive Web support                                                  |
| spring-boot-starter-websocket               | Starter for building WebSocket applications using Spring Framework’s WebSocket support                                                   |

In addition to the application starters, the following starters can be used to add _production ready_
features:

_Table 2. Spring Boot production starters_

| Name                         | Description                                                                                                                       |
| ---------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| spring-boot-starter-actuator | Starter for using Spring Boot’s Actuator which provides production ready features to help you monitor and manage your application |

Finally, Spring Boot also includes the following starters that can be used if you want to exclude or swap specific technical facets:

- swap specific technical facets 交换特定的技术方面

_Table 3. Spring Boot technical starters_

| Name                              | Description                                                                                                |
| --------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| spring-boot-starter-jetty         | Starter for using Jetty as the embedded servlet container. An alternative to `spring-boot-starter-tomcat`  |
| spring-boot-starter-log4j2        | Starter for using Log4j2 for logging. An alternative to spring-boot-starter-logging                        |
| spring-boot-starter-logging       | Starter for logging using Logback. Default logging starter                                                 |
| spring-boot-starter-reactor-netty | Starter for using Reactor Netty as the embedded reactive HTTP server                                       |
| spring-boot-starter-undertow      | Starter for using Undertow as the embedded servlet container. An alternative to spring-boot-starter-tomcat |

To learn how to swap technical facets, please see the how-to documentation for swapping web server and logging system.

6.2. Structuring Your Code

Spring Boot does not require any specific code layout to work.

- Code Layout 代码布局

However, there are some best practices that help.

### 6.2.1. Using the “default” Package

When a class does not include a package declaration,it is considered to be in the “default package”.

The use of the “default package” is generally discouraged and should be avoided.

- discouraged v. 使泄气，使灰心；阻碍，制止（discourage 的过去式和过去分词形式）

It can cause
particular problems for Spring Boot applications that use the `@ComponentScan`, `@ConfigurationPropertiesScan`, `@EntityScan`, or `@SpringBootApplication` annotations, since every class from every jar is read.

# 6.2.2. Locating the Main Application Class

We generally recommend that you locate your main application class in a root package above other classes.

The `@SpringBootApplication` annotation is often placed on your main class, and it implicitly defines a base “search package” for certain items.

- implicitly adv. 含蓄地，暗中地；绝对地

For example, if you are writing a JPA application, the package of the `@SpringBootApplication` annotated class is used to search for `@Entity` items.

Using a root package also allows component scan to apply only on your project.

The following listing shows a typical layout:

```
com
 +- example
  +- myapplication
  +- MyApplication.java
  |
  +- customer
  | +- Customer.java
  | +- CustomerController.java
  | +- CustomerService.java
  | +- CustomerRepository.java
  |
  +- order
  +- Order.java
  +- OrderController.java
  +- OrderService.java
  +- OrderRepository.java
```

The `MyApplication.java` file would declare the `main` method, along with the basic `@SpringBootApplication`, as follows:

```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class MyApplication {

  public static void main(String[] args) {
    SpringApplication.run(MyApplication.class, args);
  }
}
```

## 6.3. Configuration Classes

Spring Boot favors Java-based configuration.

Although it is possible to use SpringApplication with XML sources, we generally recommend that your primary source be a single `@Configuration` class.

Usually the class that defines the main method is a good candidate as the primary `@Configuration`.

### 6.3.1. Importing Additional Configuration Classes

You need not put all your `@Configuration` into a single class.

The `@Import` annotation can be used to import additional configuration classes.

Alternatively, you can use `@ComponentScan` to automatically pick up all Spring components, including `@Configuration` classes.

### 6.3.2. Importing XML Configuration

If you absolutely must use XML based configuration, we recommend that you still start with a
`@Configuration` class.

You can then use an `@ImportResource` annotation to load XML configuration files.

## 6.4. Auto-configuration

Spring Boot auto-configuration attempts to automatically configure your Spring application based on the jar dependencies that you have added.

For example, if `HSQLDB` is on your classpath, and you have not manually configured any database connection beans, then Spring Boot auto-configures an in-memory database.

You need to opt-in to auto-configuration by adding the `@EnableAutoConfiguration` or `@SpringBootApplication` annotations to one of your `@Configuration` classes.

- opt-in v. 选择性加入，决定参加（计划等）

> You should only ever add one `@SpringBootApplication` or `@EnableAutoConfiguration` annotation. We generally recommend that you add one or the other to your primary `@Configuration` class only.

## 4.1. Gradually Replacing Auto-configuration

Auto-configuration is non-invasive.

- invasive adj. 扩散性的，侵入的；切入的，开刀的

At any point, you can start to define your own configuration to replace specific parts of the auto-configuration.

For example, if you add your own `DataSource` bean, the default embedded database support backs away.

- back away 逐渐后退为了让出地方而后退

If you need to find out what auto-configuration is currently being applied, and why, start your application with the --debug switch.

Doing so enables debug logs for a selection of core loggers and logs a conditions report to the console.

## 4.2. Disabling Specific Auto-configuration Classes

If you find that specific auto-configuration classes that you do not want are being applied, you can use the exclude attribute of `@SpringBootApplication` to disable them, as shown in the following example:

```java
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;

@SpringBootApplication(exclude = { DataSourceAutoConfiguration.class })
public class MyApplication {

}
```

If the class is not on the classpath, you can use the `excludeName` attribute of the annotation and specify the fully qualified name instead.

If you prefer to use `@EnableAutoConfiguration` rather than `@SpringBootApplication`, exclude and `excludeName` are also available.

Finally, you can also control the list of auto-configuration classes to exclude by using the `spring.autoconfigure.exclude` property.

> You can define exclusions both at the annotation level and by using the property.

# 5. Spring Beans and Dependency Injection

You are free to use any of the standard Spring Framework techniques to define your beans and their injected dependencies.

We generally recommend using constructor injection to wire up dependencies and `@ComponentScan` to find beans.

- wire up 连同

If you structure your code as suggested above (locating your application class in a top package), you can add `@ComponentScan` without any arguments or use the `@SpringBootApplication` annotation which implicitly includes it.

The following example shows a `@Service` Bean that uses constructor injection to obtain a required `RiskAssessor` bean:

```java
import org.springframework.stereotype.Service;

@Service
public class MyAccountService implements AccountService {

    private final RiskAssessor riskAssessor;

    public MyAccountService(RiskAssessor riskAssessor) {
        this.riskAssessor = riskAssessor;
    }

    // ...

}

```

If a bean has more than one constructor, you will need to mark the one you want Spring to use with `@Autowired`:

```java
import java.io.PrintStream;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MyAccountService implements AccountService {

    private final RiskAssessor riskAssessor;

    private final PrintStream out;

    @Autowired
    public MyAccountService(RiskAssessor riskAssessor) {
        this.riskAssessor = riskAssessor;
        this.out = System.out;
    }

    public MyAccountService(RiskAssessor riskAssessor, PrintStream out) {
        this.riskAssessor = riskAssessor;
        this.out = out;
    }

    // ...

}
```

> Notice how using constructor injection lets the riskAssessor field be marked as final, indicating that it cannot be subsequently changed.

# 6. Using the @SpringBootApplication Annotation

Many Spring Boot developers like their apps to use auto-configuration, component scan and be able to define extra configuration on their "application class".

A single `@SpringBootApplication` annotation can be used to enable those three features, that is:

- `@EnableAutoConfiguration`: enable Spring Boot’s auto-configuration mechanism
- `@ComponentScan`: enable `@Component` scan on the package where the application is located (see the best practices)
- `@SpringBootConfiguration`: enable registration of extra beans in the context or the import of additional configuration classes. An alternative to Spring’s standard `@Configuration` that aids configuration detection in your integration tests.

- An alternative to Spring’s standard `@Configuration` that aids configuration detection in your integration tests.
- Spring 标准“@Configuration”的替代方案，帮助您在集成测试中检测配置。

```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

// Same as @SpringBootConfiguration @EnableAutoConfiguration @ComponentScan
@SpringBootApplication
public class MyApplication {

    public static void main(String[] args) {
        SpringApplication.run(MyApplication.class, args);
    }

}
```

> @SpringBootApplication also provides aliases to customize the attributes of @EnableAutoConfiguration and @ComponentScan.

> None of these features are mandatory and you may choose to replace this single annotation by any of the features that it enables. For instance, you may not want to use component scan or configuration properties scan in your application:

```java
@SpringBootConfiguration(proxyBeanMethods = false)
@EnableAutoConfiguration
@Import({ SomeConfiguration.class, AnotherConfiguration.class })
public class MyApplication {

    public static void main(String[] args) {
        SpringApplication.run(MyApplication.class, args);
    }

}
```

In this example, MyApplication is just like any other Spring Boot application except `@Component-annotated` classes and `@ConfigurationProperties-annotated` classes are not detected automatically and the user-defined beans are imported explicitly (see `@Import`).

# 7. Running Your Application

One of the biggest advantages of packaging your application as a jar and using an embedded HTTP server is that you can run your application as you would any other.

The sample applies to debugging Spring Boot applications.

You do not need any special IDE plugins or extensions.

> This section only covers jar-based packaging. If you choose to package your application as a war file, see your server and IDE documentation.

## 7.1. Running From an IDE

You can run a Spring Boot application from your IDE as a Java application.

However, you first need to import your project.

Import steps vary depending on your IDE and build system.

- vary v.（使）不同，（使）呈现差异；（根据情况而）变化，改变；改变，使……变化；变奏

Most IDEs can import Maven projects directly.

For example, Eclipse users can select Import…​ → Existing Maven Projects from the File menu.

If you cannot directly import your project into your IDE, you may be able to generate IDE metadata by using a build plugin.

Maven includes plugins for `Eclipse` and `IDEA`. Gradle offers plugins for various IDEs.

## 7.2. Running as a Packaged Application

If you use the Spring Boot Maven or Gradle plugins to create an executable jar, you can run your application using `java -jar`, as shown in the following example:

```shell
$ java -jar target/myapplication-0.0.1-SNAPSHOT.jar
```

It is also possible to run a packaged application with remote debugging support enabled.

Doing so lets you attach a debugger to your packaged application, as shown in the following example:

```
$ java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=8000,suspend=n \
       -jar target/myapplication-0.0.1-SNAPSHOT.jar
```

# 7.3. Using the Maven Plugin

The Spring Boot Maven plugin includes a `run` goal that can be used to quickly compile and run your application.

Applications run in an exploded form, as they do in your IDE.

应用程序以分解形式运行，就像它们在 IDE 中所做的那样。

The following example shows a typical Maven command to run a Spring Boot application:

```shell
$ mvn spring-boot:run
```

You might also want to use the MAVEN_OPTS operating system environment variable, as shown in the following example:

```shell
$ export MAVEN_OPTS=-Xmx1024m
```

## 7.4. Using the Gradle Plugin

The Spring Boot Gradle plugin also includes a `bootRun` task that can be used to run your application in an exploded form.

The `bootRun` task is added whenever you apply the `org.springframework.boot` and `java` plugins and is shown in the following example:

```
$ gradle bootRun
```

You might also want to use the `JAVA_OPTS` operating system environment variable, as shown in the following example:

```
$ export JAVA_OPTS=-Xmx1024m
```

## 7.5. Hot Swapping

Since Spring Boot applications are plain Java applications, JVM hot-swapping should work out of the box.

JVM hot swapping is somewhat limited with the bytecode that it can replace.

JVM 热插拔在可以替换的字节码方面受到一定的限制。

The `spring-boot-devtools` module also includes support for quick application restarts. See the `Hot swapping “How-to”` for details

# 8. Developer Tools

Spring Boot includes an additional set of tools that can make the application development experience a little more pleasant.

- pleasant adj. 令人愉快的，惬意的；礼貌而友善的，和蔼可亲的

The spring-boot-devtools module can be included in any project to provide additional development-time features.

- provide additional development-time features 提供额外的开发时间特性

_Maven_

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-devtools</artifactId>
        <optional>true</optional>
    </dependency>
</dependencies>
```

_Gradle_

```gradle
dependencies {
    developmentOnly("org.springframework.boot:spring-boot-devtools")
}
```

## 8.1. Diagnosing Classloading Issues 诊断类加载问题

As described in the Restart vs Reload section, restart functionality is implemented by using two classloaders. For most applications, this approach works well. However, it can sometimes cause classloading issues, in particular in multi-module projects.

To diagnose whether the classloading issues are indeed caused by devtools and its two classloaders, try disabling restart. If this solves your problems, customize the restart classloader to include your entire project.

## 8.2. Property Defaults

Several of the libraries supported by Spring Boot use caches to improve performance.

For example, template engines cache compiled templates to avoid repeatedly parsing template files.

Also, Spring MVC can add HTTP caching headers to responses when serving static resources.

While caching is very beneficial in production, it can be counter-productive during development, preventing you from seeing the changes you just made in your application. For this reason, spring-boot-devtools disables the caching options by default.

- counter-productive adj. 产生相反效果的

Cache options are usually configured by settings in your application.properties file.

For example, Thymeleaf offers the `spring.thymeleaf.cache` property.

Rather than needing to set these properties manually, the spring-boot-devtools module automatically applies sensible development-time configuration.

The following table lists all the properties that are applied:

| Syntax                                         | Description |
| ---------------------------------------------- | ----------- |
| Header                                         | Title       |
| Paragraph                                      | Text        |
| server.error.include-binding-errors            | always      |
| server.error.include-message                   | always      |
| server.error.include-stacktrace                | always      |
| server.servlet.jsp.init-parameters.development | true        |
| server.servlet.session.persistent              | true        |
| spring.freemarker.cache                        | false       |
| spring.graphql.graphiql.enabled                | true        |
| spring.groovy.template.cache                   | false       |
| spring.h2.console.enabled                      | true        |
| spring.mustache.servlet.cache                  | false       |
| spring.mvc.log-resolved-exception              | true        |
| spring.reactor.debug                           | true        |
| spring.template.provider.cache                 | false       |
| spring.thymeleaf.cache                         | false       |
| spring.web.resources.cache.period              | 0           |
| spring.web.resources.chain.cache               | false       |

Because you need more information about web requests while developing Spring MVC and Spring WebFlux applications, developer tools suggests you to enable DEBUG logging for the web logging group.

This will give you information about the incoming request, which handler is processing it, the response outcome, and other details.

If you wish to log all request details (including potentially sensitive information), you can turn on the `spring.mvc.log-request-details` or spring.codec.`log-request-details` configuration properties.

## 8.3. Automatic Restart

Applications that use `spring-boot-devtools` automatically restart whenever files on the classpath change.

This can be a useful feature when working in an IDE, as it gives a very fast feedback loop for code changes.

By default, any entry on the classpath that points to a directory is monitored for changes.

Note that certain resources, such as static assets and view templates, do not need to restart the application.

### 8.3.1. Logging Changes in Condition Evaluation 记录条件评估中的变化

By default, each time your application restarts, a report showing the condition evaluation delta is logged.

The report shows the changes to your application’s auto-configuration as you make changes such as adding or removing beans and setting configuration properties.

To disable the logging of the report, set the following property:

```yaml
spring:
  devtools:
    restart:
      log-condition-evaluation-delta: false
```

### 8.3.2. Excluding Resources

Certain resources do not necessarily need to trigger a restart when they are changed.

For example, Thymeleaf templates can be edited in-place. By default, changing resources in `/META-INF/maven`, `/META-INF/resources`, `/resources`, `/static`, `/public`, or `/templates` does not trigger a restart but does trigger a live reload.

```yaml
spring:
  devtools:
    restart:
      exclude: "static/**,public/**"
```

## 8.3.3. Watching Additional Paths

You may want your application to be restarted or reloaded when you make changes to files that are not on the classpath.

To do so, use the `spring.devtools.restart.additional-paths property` to configure additional paths to watch for changes.

You can use the `spring.devtools.restart.exclude` property described earlier to control whether changes beneath the additional paths trigger a full restart or a live reload.

### 8.3.4. Disabling Restart

If you do not want to use the restart feature, you can disable it by using the `spring.devtools.restart.enabled` property.

In most cases, you can set this property in your `application.properties` (doing so still initializes the restart classloader, but it does not watch for file changes).

If you need to completely disable restart support (for example, because it does not work with a specific library), you need to set the `spring.devtools.restart.enabled` System property to false before calling `SpringApplication.run(…​)`, as shown in the following example:

```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class MyApplication {

    public static void main(String[] args) {
        System.setProperty("spring.devtools.restart.enabled", "false");
        SpringApplication.run(MyApplication.class, args);
    }

}
```

### 8.3.5. Using a Trigger File

### 8.3.6. Customizing the Restart Classloader

### 8.3.7. Known Limitations

## 8.4. LiveReload

## 8.5. Global Settings

## 8.6. Remote Applications

The Spring Boot developer tools are not limited to local development.

You can also use several features when running applications remotely.

Remote support is opt-in as enabling it can be a security risk.

It should only be enabled when running on a trusted network or when secured with SSL.

If neither of these options is available to you, you should not use DevTools' remote support.

You should never enable support on a production deployment.

To enable it, you need to make sure that `devtools` is included in the repackaged archive, as shown in the following listing:

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <configuration>
                <excludeDevtools>false</excludeDevtools>
            </configuration>
        </plugin>
    </plugins>
</build>
```

Then you need to set the `spring.devtools.remote.secret` property. Like any important password or secret, the value should be unique and strong such that it cannot be guessed or brute-forced.

- brute-forced adj. 依靠蛮力（获得）的

Remote devtools support is provided in two parts: a server-side endpoint that accepts connections and a client application that you run in your IDE.

The server component is automatically enabled when the `spring.devtools.remote.secret` property is set.

The client component must be launched manually.

### 8.6.1. Running the Remote Client Application

The remote client application is designed to be run from within your IDE.

You need to run `org.springframework.boot.devtools.RemoteSpringApplication` with the same classpath as the remote project that you connect to.

The application’s single required argument is the remote URL to which it connects.

For example, if you are using Eclipse or Spring Tools and you have a project named `my-app` that you have deployed to Cloud Foundry, you would do the following:

- Select `Run Configurations…`​ from the `Run` menu.
- Create a new `Java Application` “launch configuration”.
- Browse for the `my-app` project.
- Use `org.springframework.boot.devtools.RemoteSpringApplication` as the main class.
- Add `https://myapp.cfapps.io` to the `Program arguments` (or whatever your remote URL is).

A running remote client might resemble the following listing:

### 8.6.2. Remote Update

The remote client monitors your application classpath for changes in the same way as the local restart.

Any updated resource is pushed to the remote application and (if required) triggers a restart.

This can be helpful if you iterate on a feature that uses a cloud service that you do not have locally.

Generally, remote updates and restarts are much quicker than a full rebuild and deploy cycle.

On a slower development environment, it may happen that the quiet period is not enough, and the changes in the classes may be split into batches.

The server is restarted after the first batch of class changes is uploaded.

The next batch can’t be sent to the application, since the server is restarting.

This is typically manifested by a warning in the RemoteSpringApplication logs about failing to upload some of the classes, and a consequent retry.

- manifested v.显示；证明（manifest 的过去分词）

But it may also lead to application code inconsistency and failure to restart after the first batch of changes is uploaded.

If you observe such problems constantly, try increasing the `spring.devtools.restart.poll-interval` and `spring.devtools.restart.quiet-period` parameters to the values that fit your development environment.

See the Configuring File System Watcher section for configuring these properties.

# 9. Packaging Your Application for Production

Executable jars can be used for production deployment. As they are self-contained, they are also ideally suited for cloud-based deployment.

For additional “production ready” features, such as health, auditing, and metric REST or JMX end-points, consider adding spring-boot-actuator. See actuator.html for details.

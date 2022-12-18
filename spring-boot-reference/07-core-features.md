# Chapter 7. Core Features

This section dives into the details of Spring Boot.

Here you can learn about the key features that you may want to use and customize.

If you have not already done so, you might want to read the "Getting Started" and "Developing with Spring Boot" sections, so that you have a good grounding of the basics.

- a good grounding of the basics 良好的基础知识。
- grounding n. [电]接地；基础；搁浅；（染色的）底色

# 1. SpringApplication

The SpringApplication class provides a convenient way to bootstrap a Spring application that is started from a main() method.

In many situations, you can delegate to the static SpringApplication.run method, as shown in the following example:

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

When your application starts, you should see something similar to the following output:

...

By default, `INFO` logging messages are shown, including some relevant startup details, such as the user that launched the application.

If you need a log level other than `INFO`, you can set it, as described in Log Levels.

The application version is determined using the implementation version from the main application class’s package.

Startup information logging can be turned off by setting `spring.main.log-startup-info` to false.

This will also turn off logging of the application’s active profiles.

## 1.1. Startup Failure

If your application fails to start, registered `FailureAnalyzers` get a chance to provide a dedicated error message and a concrete action to fix the problem.

- dedicated adj. 专心致志的，献身的；专用的，专门用途的

For instance, if you start a web application on port `8080` and that port is already in use, you should see something similar to the following message:

...

If no failure analyzers are able to handle the exception, you can still display the full conditions report to better understand what went wrong.

To do so, you need to enable the debug property or enable DEBUG logging for `org.springframework.boot.autoconfigure.logging.ConditionEvaluationReportLoggingListener`.

For instance, if you are running your application by using java -jar, you can enable the debug property as follows:

```shell
$ java -jar myproject-0.0.1-SNAPSHOT.jar --debug
```

## 1.2. Lazy Initialization

SpringApplication allows an application to be initialized lazily.

When lazy initialization is enabled, beans are created as they are needed rather than during application startup.

As a result, enabling lazy initialization can reduce the time that it takes your application to start.

In a web application, enabling lazy initialization will result in many web-related beans not being initialized until an HTTP request is received.

A downside of lazy initialization is that it can delay the discovery of a problem with the application.

- n. 缺点，不利方面

If a misconfigured bean is initialized lazily, a failure will no longer occur during startup and the problem will only become apparent when the bean is initialized.

Care must also be taken to ensure that the JVM has sufficient memory to accommodate all of the application’s beans and not just those that are initialized during startup.

- accommodate v. 为……提供住宿；容纳，提供空间；考虑到，顾及；顺应，适应；帮助（某人），向……施以援手；迎合，迁就；调解

For these reasons, lazy initialization is not enabled by default and it is recommended that fine-tuning of the JVM’s heap size is done before enabling lazy initialization.

- fine-tuning n. 微调；细调

Lazy initialization can be enabled programmatically using the `lazyInitialization` method on `SpringApplicationBuilder` or the `setLazyInitialization` method on `SpringApplication`. Alternatively, it can be enabled using the `spring.main.lazy-initialization` property as shown in the following example:

```Properties
spring.main.lazy-initialization=true
```

## 1.3. Customizing the Banner

The banner that is printed on start up can be changed by adding a `banner.txt` file to your classpath or by setting the `spring.banner.location` property to the location of such a file.

If the file has an encoding other than `UTF-8`, you can set `spring.banner.charset`.

Inside your `banner.txt` file, you can use any key available in the `Environment` as well as any of the following placeholders:

- placeholders n. 占位符（placeholder 的复数）

| Variable                                                                       | Description                                                                                                                                                      |
| ------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ${application.version}                                                         | The version number of your application, as declared in MANIFEST.MF. For example, Implementation-Version: 1.0 is printed as 1.0.                                  |
| ${application.formatted-version}                                               | The version number of your application, as declared in MANIFEST.MF and formatted for display (surrounded with brackets and prefixed with v). For example (v1.0). |
| ${spring-boot.version}                                                         | The Spring Boot version that you are using. For example 3.0.0.                                                                                                   |
| ${spring-boot.formatted-version}                                               | The Spring Boot version that you are using, formatted for display (surrounded with brackets and prefixed with v). For example (v3.0.0).                          |
| ${Ansi.NAME} (or ${AnsiColor.NAME}, ${AnsiBackground.NAME}, ${AnsiStyle.NAME}) | Where NAME is the name of an ANSI escape code. See AnsiPropertySource for details.                                                                               |
| ${application.title}                                                           | The title of your application, as declared in MANIFEST.MF. For example Implementation-Title: MyApp is printed as MyApp.                                          |


You can also use the `spring.main.banner-mode` property to determine if the banner has to be printed on System.out (console), sent to the configured logger (log), or not produced at all (off).

The printed banner is registered as a singleton bean under the following name: `springBootBanner`.

## 1.4. Customizing SpringApplication

If the `SpringApplication` defaults are not to your taste, you can instead create a local instance and customize it. For example, to turn off the banner, you could write:

```java
import org.springframework.boot.Banner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class MyApplication {

    public static void main(String[] args) {
        SpringApplication application = new SpringApplication(MyApplication.class);
        application.setBannerMode(Banner.Mode.OFF);
        application.run(args);
    }

}
```

It is also possible to configure the `SpringApplication` by using an `application.properties` file. See `Externalized Configuration` for details.

For a complete list of the configuration options, see the `SpringApplication` Javadoc.

## 1.5. Fluent Builder API

- Fluent adj.（说话）流利的；（表达思想）熟练的，流畅的；（做事）娴熟的；畅流的，能流动的


If you need to build an `ApplicationContext` hierarchy (multiple contexts with a parent/child relationship) or if you prefer using a “fluent” builder API, you can use the `SpringApplicationBuilder`.

- hierarchy n. 等级制度；统治集团；等级体系

The `SpringApplicationBuilder` lets you chain together multiple method calls and includes `parent` and `child` methods that let you create a hierarchy, as shown in the following example:

```java
new SpringApplicationBuilder()
        .sources(Parent.class)
        .child(Application.class)
        .bannerMode(Banner.Mode.OFF)
        .run(args);
```

## 1.6. Application Availability

When deployed on platforms, applications can provide information about their availability to the platform using infrastructure such as Kubernetes Probes. 

- availability n. 可用性，可得性；

Spring Boot includes out-of-the box support for the commonly used “liveness” and “readiness” availability states. 



- liveness n. 活性，活跃度；现场感
- n.准备就绪状态；愿意，乐意；快，迅捷

If you are using Spring Boot’s “actuator” support then these states are exposed as health endpoint groups.

In addition, you can also obtain availability states by injecting the `ApplicationAvailability` interface into your own beans.

### 1.6.1. Liveness State

The “Liveness” state of an application tells whether its internal state allows it to work correctly, or recover by itself if it is currently failing. 

A broken “Liveness” state means that the application is in a state that it cannot recover from, and the infrastructure should restart the application.

> In general, the "Liveness" state should not be based on external checks, such as Health checks. If it did, a failing external system (a database, a Web API, an external cache) would trigger massive restarts and cascading failures across the platform.
>

The internal state of Spring Boot applications is mostly represented by the Spring `ApplicationContext`. 

If the application context has started successfully, Spring Boot assumes that the application is in a valid state. 

An application is considered live as soon as the context has been refreshed, see `Spring Boot application lifecycle` and `related Application Events`.

### 1.6.2. Readiness State

The “Readiness” state of an application tells whether the application is ready to handle traffic. 

- handle traffic 处理流量

A failing “Readiness” state tells the platform that it should not route traffic to the application for now. 

This typically happens during startup, while CommandLineRunner and ApplicationRunner components are being processed, or at any time if the application decides that it is too busy for additional traffic.

An application is considered ready as soon as application and command-line runners have been called, see Spring Boot application lifecycle and related Application Events.

### 1.6.3. Managing the Application Availability State

Application components can retrieve the current availability state at any time, by injecting the `ApplicationAvailability` interface and calling methods on it. 

More often, applications will want to listen to state updates or update the state of the application.

For example, we can export the "Readiness" state of the application to a file so that a Kubernetes "exec Probe" can look at this file:

```java
import org.springframework.boot.availability.AvailabilityChangeEvent;
import org.springframework.boot.availability.ReadinessState;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

@Component
public class MyReadinessStateExporter {

    @EventListener
    public void onStateChange(AvailabilityChangeEvent<ReadinessState> event) {
        switch (event.getState()) {
            case ACCEPTING_TRAFFIC:
                // create file /tmp/healthy
                break;
            case REFUSING_TRAFFIC:
                // remove file /tmp/healthy
                break;
        }
    }

}
```

We can also update the state of the application, when the application breaks and cannot recover:

```java
@Component
public class MyLocalCacheVerifier {

    private final ApplicationEventPublisher eventPublisher;

    public MyLocalCacheVerifier(ApplicationEventPublisher eventPublisher) {
        this.eventPublisher = eventPublisher;
    }

    public void checkLocalCache() {
        try {
            // ...
        }
        catch (CacheCompletelyBrokenException ex) {
            AvailabilityChangeEvent.publish(this.eventPublisher, ex, LivenessState.BROKEN);
        }
    }

}
```

Spring Boot provides Kubernetes HTTP probes for "Liveness" and "Readiness" with Actuator Health Endpoints. 

You can get more guidance about deploying Spring Boot applications on Kubernetes in the dedicated section.

## 1.7. Application Events and Listeners

In addition to the usual Spring Framework events, such as `ContextRefreshedEvent`, a `SpringApplication` sends some additional application events.

Application events are sent in the following order, as your application runs:

1. An `ApplicationStartingEvent` is sent at the start of a run but before any processing, except for the registration of listeners and initializers.
2. An `ApplicationEnvironmentPreparedEvent` is sent when the `Environment` to be used in the context is known but before the context is created.
3. An `ApplicationContextInitializedEvent` is sent when the `ApplicationContext` is prepared and ApplicationContextInitializers have been called but before any bean definitions are loaded.
4. An `ApplicationPreparedEvent` is sent just before the refresh is started but after bean definitions have been loaded.
5. An `ApplicationStartedEvent` is sent after the context has been refreshed but before any application and command-line runners have been called.
6. An `AvailabilityChangeEvent` is sent right after with `LivenessState.CORRECT` to indicate that the application is considered as live.
7. An `ApplicationReadyEvent` is sent after any `application and command-line runners` have been called.
8. An `AvailabilityChangeEvent` is sent right after with `ReadinessState.ACCEPTING_TRAFFIC` to indicate that the application is ready to service requests.
9. An `ApplicationFailedEvent` is sent if there is an exception on startup.

The above list only includes `SpringApplicationEvents` that are tied to a `SpringApplication`. In addition to these, the following events are also published after `ApplicationPreparedEvent` and before `ApplicationStartedEvent`:

- A `WebServerInitializedEvent` is sent after the `WebServer` is ready. `ServletWebServerInitializedEvent` and `ReactiveWebServerInitializedEvent` are the servlet and reactive variants respectively.
- A `ContextRefreshedEvent` is sent when an `ApplicationContext` is refreshed.

> You often need not use application events, but it can be handy to know that they exist. Internally, Spring Boot uses events to handle a variety of tasks.
>


- handy adj. 有用的，方便的，便于使用的；手巧的，有手艺的；手边的，附近的

Application events are sent by using Spring Framework’s event publishing mechanism.

Part of this mechanism ensures that an event published to the listeners in a child context is also published to the listeners in any ancestor contexts.

- ancestor n. 祖先，祖宗；（动植物）原种；原型，雏形

As a result of this, if your application uses a hierarchy of SpringApplication instances, a listener may receive multiple instances of the same type of
application event.

To allow your listener to distinguish between an event for its context and an event for a descendant context, it should request that its application context is injected and then compare the injected context with the context of the event.

- distinguish v. 使有别于；看清，认出；区别，分清

- descendant n. 后裔，子孙；派生物，衍生物

The context can be injected by implementing `ApplicationContextAware` or, if the listener is a bean, by using `@Autowired`.

### 7.1.8. Web Environment

A `SpringApplication` attempts to create the right type of `ApplicationContext` on your behalf.

The algorithm used to determine a `WebApplicationType` is the following:

- determine v. 决定，控制；查明，确定；下定决心；判决，裁定；求出，解出；限定；<古>终止
- Determine 还有一个意思是“确定”
- Decide 表示的是在看法不一、令人疑虑和众说纷纭的问题上，经过认真的考虑和商量而产生结论，从而结束了犹豫不决和意见分歧的状况。

- • If Spring MVC is present, an `AnnotationConfigServletWebServerApplicationContext` is used
- 如果存在 Spring MVC，则使用`AnnotationConfigServletWebServerApplicationContext`
- If Spring MVC is not present and Spring WebFlux is present, an `AnnotationConfigReactiveWebServerApplicationContext` is used
- Otherwise, `AnnotationConfigApplicationContext` is used

This means that if you are using Spring MVC and the new `WebClient` from Spring WebFlux in the same application, Spring MVC will be used by default.

You can override that easily by calling `setWebApplicationType(WebApplicationType`).

It is also possible to take complete control of the `ApplicationContext` type that is used by calling `setApplicationContextClass(…)`.

> It is often desirable to call `setWebApplicationType(WebApplicationType.NONE)` when using `SpringApplication` within a JUnit test.

- desirable adj. 令人向往的，值得拥有的；可取的；性感的

### 7.1.9. Accessing Application Arguments

If you need to access the application arguments that were passed to `SpringApplication.run(…)`, you can inject a `org.springframework.boot.ApplicationArguments` bean.

The ApplicationArguments interface provides access to both the raw `String[]` arguments as well as parsed `option` and `non-option` arguments, as shown in the following example:

```java
import java.util.List;
import org.springframework.boot.ApplicationArguments;
import org.springframework.stereotype.Component;

@Component
public class MyBean {

  public MyBean(ApplicationArguments args) {
    boolean debug = args.containsOption("debug");
    List<String> files = args.getNonOptionArgs();
    if (debug) {
      System.out.println(files);
    }
    // if run with "--debug logfile.txt" prints ["logfile.txt"]
  }
}
```

> Spring Boot also registers a `CommandLinePropertySource` with the Spring `Environment`.
> This lets you also inject single application arguments by using the `@Value` annotation.

### 7.1.10. Using the ApplicationRunner or CommandLineRunner

If you need to run some specific code once the `SpringApplication` has started, you can implement
the `ApplicationRunner` or `CommandLineRunner` interfaces.

Both interfaces work in the same way and offer a single `run` method, which is called just before `SpringApplication.run(…)` completes.

> This contract is well suited for tasks that should run after application startup but before it starts accepting traffic.

If several `CommandLineRunner` or `ApplicationRunner` beans are defined that must be called in a specific order, you can additionally implement the `org.springframework.core.Ordered` interface or use the `org.springframework.core.annotation.Order` annotation.

### 7.1.11. Application Exit

Each `SpringApplication` registers a shutdown hook with the JVM to ensure that the
`ApplicationContext` closes gracefully on exit.

All the standard Spring lifecycle callbacks (such as the `DisposableBean` interface or the `@PreDestroy` annotation) can be used.

In addition, beans may implement the `org.springframework.boot.ExitCodeGenerator` interface if they wish to return a specific exit code when `SpringApplication.exit()` is called.

This exit code can then be passed to `System.exit() `to return it as a status code, as shown in the following example:

```java
import org.springframework.boot.ExitCodeGenerator;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class MyApplication {

  @Bean
  public ExitCodeGenerator exitCodeGenerator() {
    return () -> 42;
  }

  public static void main(String[] args) {
    SpringApplication application = new SpringApplication(MyApplication.class);
      System.exit(SpringApplication.exit(application.run(args)));
  }
}

```

Also, the `ExitCodeGenerator` interface may be implemented by exceptions.

When such an exception is encountered, Spring Boot returns the exit code provided by the implemented `getExitCode()` method.

If there is more than `ExitCodeGenerator`, the first non-zero exit code that is generated is used.

To control the order in which the generators are called, additionally implement the
`org.springframework.core.Ordered` interface or use the `org.springframework.core.annotation.Order `annotation.

### 7.1.12. Admin Features

It is possible to enable admin-related features for the application by specifying the `spring.application.admin.enabled` property.

This exposes the `SpringApplicationAdminMXBean` on the platform MBeanServer.

You could use this feature to administer your Spring Boot application remotely.

This feature could also be useful for any service wrapper implementation.

> If you want to know on which HTTP port the application is running, get the property with a key of `local.server.port`.

### 7.1.13. Application Startup tracking

During the application startup, the `SpringApplication` and the `ApplicationContext` perform many tasks related to the application lifecycle, the beans lifecycle or even processing application events.

With `ApplicationStartup`, Spring Framework `allows you to track the application startup sequence` with `StartupStep` objects.

This data can be collected for profiling purposes, or just to have a better understanding of an application startup process.

- profiling n.（有关人或事物的）资料收集，剖析研究

You can choose an `ApplicationStartup` implementation when setting up the `SpringApplication` instance. For example, to use the `BufferingApplicationStartup`, you could write:

```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.metrics.buffering.BufferingApplicationStartup;

@SpringBootApplication
public class MyApplication {

  public static void main(String[] args) {
    SpringApplication application = new SpringApplication(MyApplication.class);
    application.setApplicationStartup(new BufferingApplicationStartup(2048));
    application.run(args);
  }
}
```

The first available implementation, `FlightRecorderApplicationStartup` is provided by Spring Framework.

It adds Spring-specific startup events to a Java Flight Recorder session and is meant for
profiling applications and correlating their Spring context lifecycle with JVM events (such as
allocations, GCs, class loading…).

- meant v. 意味；打算（mean 的过去式和过去分词）；表示……的意思

Once configured, you can record data by running the application with the Flight Recorder enabled:

```shell
java -XX:StartFlightRecording:filename=recording.jfr,duration=10s -jar demo.jar
```

Spring Boot ships with the BufferingApplicationStartup variant;

this implementation is meant for buffering the startup steps and draining them into an external metrics system.

这个实现的目的是缓冲启动步骤并将其导入外部度量系统。

Applications can ask for the bean of type `BufferingApplicationStartup` in any component.

Spring Boot can also be configured to expose a startup endpoint that provides this information as a JSON document.

Spring Boot 还可以配置为公开以 JSON 文档形式提供此信息的启动端点。

## 7.2. Externalized Configuration

Spring Boot lets you externalize your configuration so that you can work with the same application code in different environments.

You can use a variety of external configuration sources, include Java properties files, YAML files, environment variables, and command-line arguments.

- externalize vt. 给……以外形；使具体化，使客观化

Property values can be injected directly into your beans by using the `@Value` annotation, accessed through Spring’s `Environment` abstraction, or be bound to structured objects through `@ConfigurationProperties`.

- abstraction n. 抽象；提取；抽象概念；空想；心不在焉

Spring Boot uses a very particular `PropertySource` order that is designed to allow sensible overriding of values.

Later property sources can override the values defined in earlier ones.

Sources are considered in the following order:

1. Default properties (specified by setting `SpringApplication.setDefaultProperties`).
2. `@PropertySource` annotations on your `@Configuration` classes. Please note that such property sources are not added to the `Environment `until the application context is being refreshed. This is too late to configure certain properties such as `logging.*` and `spring.main.*` which are read before refresh begins.

3. Config data (such as `application.properties` files).
4. A `RandomValuePropertySource` that has properties only in `random.*`.
5. OS environment variables.
6. Java System properties (`System.getProperties()`).
7. JNDI attributes from `java:comp/env`.
8. `ServletContext` init parameters.
9. `ServletConfig` init parameters.
10. Properties from `SPRING_APPLICATION_JSON` (inline JSON embedded in an environment variable or
    system property).

11. Command line arguments.

12. properties attribute on your tests. Available on `@SpringBootTest` and the test annotations for testing a particular slice of your application.

13. `@TestPropertySource` annotations on your tests.

14. Devtools global settings properties in the `$HOME/.config/spring-boot` directory when devtools is active.

Config data files are considered in the following order:

1. Application properties packaged inside your jar (`application.properties` and YAML variants).
2. Profile-specific application properties packaged inside your jar (`application-{profile}.properties` and YAML variants).
3. Application properties outside of your packaged jar (`application.properties` and YAML
   variants).

4. Profile-specific application properties outside of your packaged jar (`application-{profile}.properties` and YAML variants).

To provide a concrete example, suppose you develop a `@Component` that uses a `name` property, as
shown in the following example:

```java
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
@Component
public class MyBean {
  @Value("${name}")
  private String name;
  // ...
}
```

- concrete adj. 确实的，具体的；实在的，有形的；混凝土的；物质的

On your application classpath (for example, inside your jar) you can have an `application.properties` file that provides a sensible default property value for name.

When running in a new environment, an application.properties file can be provided outside of your jar that overrides the `name`.

For one-off testing, you can launch with a specific command line switch (for example,` java -jar app.jar --name="Spring"`).

- one-off adj. 一次性的

## 7.2.1. Accessing Command Line Properties

By default, `SpringApplication` converts any command line option arguments (that is, arguments
starting with `--`, such as `--server.port=9000`) to a property and adds them to the Spring Environment.

As mentioned previously, command line properties always take precedence over file-based property sources.

- precedence n.（重要性或地位的）领先，优先权；地位先后，级别高低

If you do not want command line properties to be added to the `Environment`, you can disable them by using `SpringApplication.setAddCommandLineProperties(false)`.

### 7.2.2. JSON Application Properties

Environment variables and system properties often have restrictions that mean some property names cannot be used.

- restrictions n. 限制；限制条件（restriction 的复数）

To help with this, Spring Boot allows you to encode a block of properties into a single JSON structure.

When your application starts, any` spring.application.json` or `SPRING_APPLICATION_JSON` properties will be parsed and added to the `Environment`.

For example, the `SPRING_APPLICATION_JSON` property can be supplied on the command line in a UN\*X
shell as an environment variable:

```shell
$ SPRING_APPLICATION_JSON='{"my":{"name":"test"}}' java -jar myapp.jar
```

In the preceding example, you end up with `my.name=test` in the Spring `Environment`.

The same JSON can also be provided as a system property:

```
$ java -Dspring.application.json='{"my":{"name":"test"}}' -jar myapp.jar
```

Or you could supply the JSON by using a command line argument:

```
$ java -jar myapp.jar --spring.application.json='{"my":{"name":"test"}}'
```

If you are deploying to a classic Application Server, you could also use a JNDI variable named
`java:comp/env/spring.application.json`.

### 7.2.3. External Application Properties

Spring Boot will automatically find and load `application.properties` and `application.yaml` files from the following locations when your application starts:

1. From the classpath
   a. The classpath root
   b. The classpath `/config` package
2. From the current directory
   a. The current directory
   b. The `config/` subdirectory in the current directory
   c. Immediate child directories of the `config` subdirectory

The list is ordered by precedence (with values from lower items overriding earlier ones).

- precedence n.（重要性或地位的）领先，优先权；地位先后，级别高低

Documents from the loaded files are added as PropertySources to the Spring Environment.

If you do not like `application` as the configuration file name, you can switch to another file name by specifying a `spring.config.name` environment property. For example, to look for `myproject.properties` and `myproject.yaml` files you can run your application as follows:

```
 java -jar myproject.jar --spring.config.name=myproject
```

You can also refer to an explicit location by using the `spring.config.location` environment property.

This property accepts a comma-separated list of one or more locations to check.

The following example shows how to specify two distinct files:

```
$ java -jar myproject.jar --spring.config.location=\
  optional:classpath:/default.properties,\
  optional:classpath:/override.properties
```

**Optional Locations**

**Wildcard Locations** 通配符的位置

**Profile Specific Files**

**Importing Additional Data**

**Importing Extensionless Files** 导入无扩展文件

**Using Configuration Trees**

**Property Placeholders**

**Working With Multi-Document Files**

Spring Boot allows you to split a single physical file into multiple logical documents which are each added independently.

Documents are processed in order, from top to bottom.

Later documents can override the properties defined in earlier ones.

For example, the following file has two logical documents:

```yaml
spring:
  application:
    name: "MyApp"
---
spring:
  application:
    name: "MyCloudApp"
  config:
    activate:
    on-cloud-platform: "kubernetes"
```

For `application.properties` files a special `#---` or `!---` comment is used to mark the document splits:

```properties
spring.application.name=MyApp
#---
spring.application.name=MyCloudApp
spring.config.activate.on-cloud-platform=kubernetes
```

**Activation Properties**

It is sometimes useful to only activate a given set of properties when certain conditions are met.

For example, you might have properties that are only relevant when a specific profile is active.

You can conditionally activate a properties document using `spring.config.activate.*`.

The following activation properties are available:

_Table 5. activation properties_

| Property            | Note                                                                     |
| ------------------- | ------------------------------------------------------------------------ |
| `on-profile`        | A profile expression that must match for the document to be active.      |
| `on-cloud-platform` | The `CloudPlatform` that must be detected for the document to be active. |

For example, the following specifies that the second document is only active when running on Kubernetes, and only when either the “prod” or “staging” profiles are active:

- staging v. 表演；展现；分阶段进行；筹划（stage 的 ing 形式）

```yml
myprop: "always-set"
---
spring:
  config:
    activate:
      on-cloud-platform: "kubernetes"
      on-profile: "prod | staging"
myotherprop: "sometimes-set"
```

### 7.2.4. Encrypting Properties

Spring Boot does not provide any built in support for encrypting property values, however, it does provide the hook points necessary to modify values contained in the Spring Environment.

The `EnvironmentPostProcessor` interface allows you to manipulate the `Environment` before the application starts. See Customize the Environment or ApplicationContext Before It Starts for details.

- manipulate v. 操纵，摆布；操作，使用；正骨，推拿；篡改；巧妙地移动（某物），巧妙地处理（某事）；校正，转移（储存在计算机上的信息）

If you need a secure way to store credentials and passwords, the `Spring Cloud Vault` project provides support for storing externalized configuration in `HashiCorp Vault`.

### 7.2.5. Working With YAML

YAML is a superset of JSON and, as such, is a convenient format for specifying hierarchical configuration data.

- superset n. [数] 超集

The SpringApplication class automatically supports YAML as an alternative to properties whenever you have the `SnakeYAML` library on your classpath.

> If you use “Starters”, SnakeYAML is automatically provided by `spring-boot-starter`.

### 7.2.6. Configuring Random Values

The `RandomValuePropertySource` is useful for injecting random values (for example, into secrets or test cases). It can produce integers, longs, uuids, or strings, as shown in the following example:

```yaml
my:
  secret: "${random.value}"
  number: "${random.int}"
  bignumber: "${random.long}"
  uuid: "${random.uuid}"
  number-less-than-ten: "${random.int(10)}"
  number-in-range: "${random.int[1024,65536]}"
```

The `random.int*` syntax is `OPEN value (,max) CLOSE` where the `OPEN,CLOSE` are any character and
`value,max` are integers. If `max` is provided, then `value` is the minimum value and `max` is the maximum
value (exclusive).

# 7.2.7. Configuring System Environment Properties

Spring Boot supports setting a prefix for environment properties.

This is useful if the system environment is shared by multiple Spring Boot applications with different configuration requirements.

The prefix for system environment properties can be set directly on `SpringApplication`.

For example, if you set the prefix to `input`, a property such as `remote.timeout` will also be resolved as `input.remote.timeout` in the system environment.

# 7.2.8. Type-safe Configuration Properties

Using the `@Value("${property}")` annotation to inject configuration properties can sometimes be cumbersome, especially if you are working with multiple properties or your data is hierarchical in nature.

- cumbersome adj. 笨重的；繁琐的，复杂的；（话语或措词）冗长的

Spring Boot provides an alternative method of working with properties that lets strongly typed beans govern and validate the configuration of your application.

**JavaBean Properties Binding**

It is possible to bind a bean declaring standard JavaBean properties as shown in the following
example:

```java
import java.net.InetAddress;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties("my.service")
public class MyProperties {

    private boolean enabled;

    private InetAddress remoteAddress;

    private final Security security = new Security();

    public boolean isEnabled() {
        return this.enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    public InetAddress getRemoteAddress() {
        return this.remoteAddress;
    }

    public void setRemoteAddress(InetAddress remoteAddress) {
        this.remoteAddress = remoteAddress;
    }

    public Security getSecurity() {
        return this.security;
    }

    public static class Security {

        private String username;

        private String password;

        private List<String> roles = new ArrayList<>(Collections.singleton("USER"));

        public String getUsername() {
            return this.username;
        }

        public void setUsername(String username) {
            this.username = username;
        }

        public String getPassword() {
            return this.password;
        }

        public void setPassword(String password) {
            this.password = password;
        }

        public List<String> getRoles() {
            return this.roles;
        }

        public void setRoles(List<String> roles) {
            this.roles = roles;
        }

    }

}
```

The preceding POJO defines the following properties:

- `my.service.enabled`, with a value of `false` by default.
- `my.service.remote-address`, with a type that can be coerced from String.
  - coerc v. 强制，迫使；通过胁迫获得
- `my.service.security.username`, with a nested "security" object whose name is determined by the name of the property. In particular, the type is not used at all there and could have been `SecurityProperties`.

- `my.service.security.password`.

- `my.service.security.roles`, with a collection of `String` that defaults to USER.

### 2.8.2. Constructor Binding

The example in the previous section can be rewritten in an immutable fashion as shown in the following example:

```java
import java.net.InetAddress;
import java.util.List;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.bind.DefaultValue;

@ConfigurationProperties("my.service")
public class MyProperties {

    private final boolean enabled;

    private final InetAddress remoteAddress;

    private final Security security;

    public MyProperties(boolean enabled, InetAddress remoteAddress, Security security) {
        this.enabled = enabled;
        this.remoteAddress = remoteAddress;
        this.security = security;
    }

    public boolean isEnabled() {
        return this.enabled;
    }

    public InetAddress getRemoteAddress() {
        return this.remoteAddress;
    }

    public Security getSecurity() {
        return this.security;
    }

    public static class Security {

        private final String username;

        private final String password;

        private final List<String> roles;

        public Security(String username, String password, @DefaultValue("USER") List<String> roles) {
            this.username = username;
            this.password = password;
            this.roles = roles;
        }

        public String getUsername() {
            return this.username;
        }

        public String getPassword() {
            return this.password;
        }

        public List<String> getRoles() {
            return this.roles;
        }

    }

}
```

### 2.8.3. Enabling @ConfigurationProperties-annotated Types

Spring Boot provides infrastructure to bind `@ConfigurationProperties` types and register them as beans.

You can either enable configuration properties on a class-by-class basis or enable configuration property scanning that works in a similar manner to component scanning.

```java
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration(proxyBeanMethods = false)
@EnableConfigurationProperties(SomeProperties.class)
public class MyConfiguration {

}
```

To use configuration property scanning, add the `@ConfigurationPropertiesScan` annotation to your application.

Typically, it is added to the main application class that is annotated with `@SpringBootApplication` but it can be added to any `@Configuration` class.

By default, scanning will occur from the package of the class that declares the annotation.

If you want to define specific packages to scan, you can do so as shown in the following example:

```java
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;

@SpringBootApplication
@ConfigurationPropertiesScan({ "com.example.app", "com.example.another" })
public class MyApplication {

}
```

We recommend that `@ConfigurationProperties` only deal with the environment and, in particular, does not inject other beans from the context.

For corner cases, setter injection can be used or any of the `*Aware` interfaces provided by the framework (such as `EnvironmentAware` if you need access to the `Environment`).

- For corner cases 对于极端情况

If you still want to inject other beans using the constructor, the configuration properties bean must be annotated with `@Component` and use JavaBean-based property binding.

### 2.8.4. Using @ConfigurationProperties-annotated Types

This style of configuration works particularly well with the `SpringApplication` external YAML configuration, as shown in the following example:

```yaml
my:
  service:
    remote-address: 192.168.1.1
    security:
      username: "admin"
      roles:
        - "USER"
        - "ADMIN"
```

To work with `@ConfigurationProperties` beans, you can inject them in the same way as any other bean, as shown in the following example:

```java
import org.springframework.stereotype.Service;

@Service
public class MyService {

    private final MyProperties properties;

    public MyService(MyProperties properties) {
        this.properties = properties;
    }

    public void openConnection() {
        Server server = new Server(this.properties.getRemoteAddress());
        server.start();
        // ...
    }

    // ...

}
```

### 2.8.5. Third-party Configuration

As well as using `@ConfigurationProperties` to annotate a class, you can also use it on public `@Bean` methods.

- As well as 还有

Doing so can be particularly useful when you want to bind properties to third-party components that are outside of your control.

To configure a bean from the `Environment` properties, add `@ConfigurationProperties` to its bean registration, as shown in the following example:

```java
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration(proxyBeanMethods = false)
public class ThirdPartyConfiguration {

    @Bean
    @ConfigurationProperties(prefix = "another")
    public AnotherComponent anotherComponent() {
        return new AnotherComponent();
    }

}
```

Any JavaBean property defined with the `another` prefix is mapped onto that `AnotherComponent` bean in manner similar to the preceding `SomeProperties` example.

### 2.8.6. Relaxed Binding

Spring Boot uses some relaxed rules for binding `Environment` properties to `@ConfigurationProperties` beans, so there does not need to be an exact match between the `Environment` property name and the bean property name.

### 2.8.7. Merging Complex Types

### 2.8.8. Properties Conversion

**Converting Durations**

**Converting Periods**

**Converting Data Sizes**

### 2.8.9. @ConfigurationProperties Validation

### 2.8.10. @ConfigurationProperties vs. @Value

# 3. Profiles

Spring Profiles provide a way to segregate parts of your application configuration and make it be available only in certain environments.

- segregate v.（尤指因种族、性别、宗教不同而）使隔离，使分开；实行种族隔离；（使）分开，分离；（成对的等位基因）分离

Any `@Component`, `@Configuration` or `@ConfigurationProperties` can be marked with `@Profile` to limit when it is loaded, as shown in the following example:

```java
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

@Configuration(proxyBeanMethods = false)
@Profile("production")
public class ProductionConfiguration {

    // ...

}
```

You can use a` spring.profiles.active` Environment property to specify which profiles are active.

You can specify the property in any of the ways described earlier in this chapter.

For example, you could include it in your `application.properties`, as shown in the following example:

```yaml
spring:
  profiles:
    active: "dev,hsqldb"
```

You could also specify it on the command line by using the following switch: `--spring.profiles.active=dev,hsqldb`.

If no profile is active, a default profile is enabled.

The name of the default profile is default and it can be tuned using the `spring.profiles.default` `Environment` property, as shown in the following example:

```yaml
spring:
  profiles:
    default: "none"
```

`spring.profiles.active` and `spring.profiles.default` can only be used in non-profile specific documents.

This means they cannot be included in profile specific files or documents activated by `spring.config.activate.on-profile`.

For example, the second document configuration is invalid:

```yaml
# this document is valid
spring:
  profiles:
    active: "prod"
---
# this document is invalid
spring:
  config:
    activate:
      on-profile: "prod"
  profiles:
    active: "metrics"
```

## 3.1. Adding Active Profiles

The` spring.profiles.active` property follows the same ordering rules as other properties: The highest `PropertySource` wins. This means that you can specify active profiles in `application.properties` and then replace them by using the command line switch.

Sometimes, it is useful to have properties that `add` to the active profiles rather than replace them.

The `spring.profiles.include` property can be used to add active profiles on top of those activated by the `spring.profiles.active` property.

The SpringApplication entry point also has a Java API for setting additional profiles.

See the` setAdditionalProfiles()` method in SpringApplication.

For example, when an application with the following properties is run, the common and local profiles will be activated even when it runs using the `--spring.profiles.active` switch:

```
spring:
  profiles:
    include:
      - "common"
      - "local"
```

## 3.2. Profile Groups

Occasionally the profiles that you define and use in your application are too fine-grained and become cumbersome to use. For example, you might have proddb and prodmq profiles that you use to enable database and messaging features independently.

- Occasionally adv. 偶然，偶尔
- fine-grained adj. 细粒的；有细密纹理的；详细的；深入的

To help with this, Spring Boot lets you define profile groups. A profile group allows you to define a logical name for a related group of profiles.

```yaml
spring:
  profiles:
    group:
      production:
        - "proddb"
        - "prodmq"
```

Our application can now be started using `--spring.profiles.active=production` to active the `production`, `proddb` and `prodmq` profiles in one hit.

## 3.3. Programmatically Setting Profiles

You can programmatically set active profiles by calling `SpringApplication.setAdditionalProfiles(…​)` before your application runs.

It is also possible to activate profiles by using Spring’s `ConfigurableEnvironment` interface.

## 3.4. Profile-specific Configuration Files

Profile-specific variants of both `application.properties` (or `application.yml`) and files referenced through `@ConfigurationProperties` are considered as files and loaded. See "Profile Specific Files" for details.

# 4. Logging

Spring Boot uses Commons Logging for all internal logging but leaves the underlying log implementation open. Default configurations are provided for `Java Util Logging`, `Log4j2`, and `Logback`. In each case, loggers are pre-configured to use console output with optional file output also available.

- underlying adj. 根本的，潜在的；表面下的，下层的；优先的；（数量或水平）实际的

By default, if you use the “Starters”, Logback is used for logging.

Appropriate Logback routing is also included to ensure that dependent libraries that use `Java Util Logging`, `Commons Logging`, `Log4J`, or `SLF4J` all work correctly.

> There are a lot of logging frameworks available for Java. Do not worry if the above list seems confusing. Generally, you do not need to change your logging dependencies and the Spring Boot defaults work just fine.

## 4.1. Log Format

The default log output from Spring Boot resembles the following example:

- resemble v. 像，与……相似

The following items are output:

- Date and Time: Millisecond precision and easily sortable.

- Log Level: `ERROR`, `WARN`, `INFO`, `DEBUG`, or `TRACE`.

- Process ID.

- A `---` separator to distinguish the start of actual log messages.

- Thread name: Enclosed in square brackets (may be truncated for console output).

- Logger name: This is usually the source class name (often abbreviated).

- The log message.

## 4.2. Console Output

The default log configuration echoes messages to the console as they are written. By default, `ERROR`-level, `WARN`-level, and `INFO`-level messages are logged. You can also enable a “debug” mode by starting your application with a `--debug` flag.

When the debug mode is enabled, a selection of core loggers (embedded container, Hibernate, and Spring Boot) are configured to output more information.

Enabling the debug mode does not configure your application to log all messages with DEBUG level.

- a selection of core loggers 核心记录器的选择

Alternatively, you can enable a “trace” mode by starting your application with a --trace flag (or trace=true in your application.properties).

Doing so enables trace logging for a selection of core loggers (embedded container, Hibernate schema generation, and the whole Spring portfolio).

# 4.2.1. Color-coded Output

If your terminal supports ANSI, color output is used to aid readability. You can set `spring.output.ansi.enabled` to a supported value to override the auto-detection.

- aid v. 帮助，援助；促进，有助于

Color coding is configured by using the `%clr` conversion word.

In its simplest form, the converter colors the output according to the log level, as shown in the following example:

```
%clr(%5p)
```

| Level | Color  |
| ----- | ------ |
| FATAL | Red    |
| ERROR | Red    |
| WARN  | Yellow |
| INFO  | Green  |
| DEBUG | Green  |
| TRACE | Green  |

Alternatively, you can specify the color or style that should be used by providing it as an option to the conversion.

For example, to make the text yellow, use the following setting:

```
%clr(%d{yyyy-MM-dd'T'HH:mm:ss.SSSXXX}){yellow}
```

The following colors and styles are supported:

- blue

- cyan

- faint

- green

- magenta

- red

- yellow

## 4.3. File Output

By default, Spring Boot logs only to the console and does not write log files.

If you want to write log files in addition to the console output, you need to set a `logging.file.name` or `logging.file.path` property (for example, in your `application.properties`).

The following table shows how the `logging.*` properties can be used together:

_Table 5. Logging properties_

Log files rotate when they reach 10 MB and, as with console output, `ERROR-level`, `WARN-level`, and INFO-level messages are logged by default.

Log files rotate when they reach 10 MB and, as with console output, `ERROR`-level, `WARN`-level, and `INFO`-level messages are logged by default.

## 4.4. File Rotation

If you are using the Logback, it is possible to fine-tune log rotation settings using your `application.properties` or `application.yaml` file.

For all other logging system, you will need to configure rotation settings directly yourself (for example, if you use Log4j2 then you could add a `log4j2.xml` or `log4j2-spring.xml` file).

The following rotation policy properties are supported:

| Name                                                 | Description                                                            |
| ---------------------------------------------------- | ---------------------------------------------------------------------- |
| logging.logback.rollingpolicy.file-name-pattern      | The filename pattern used to create log archives.                      |
| logging.logback.rollingpolicy.clean-history-on-start | If log archive cleanup should occur when the application starts.       |
| logging.logback.rollingpolicy.max-file-size          | The maximum size of log file before it is archived.                    |
| logging.logback.rollingpolicy.total-size-cap         | The maximum amount of size log archives can take before being deleted. |
| logging.logback.rollingpolicy.max-history            | The maximum number of archive log files to keep (defaults to 7).       |

## 4.5. Log Levels

All the supported logging systems can have the logger levels set in the Spring `Environment` (for example, in `application.properties`) by using `logging.level.<logger-name>=<level>` where level is one of TRACE, DEBUG, INFO, WARN, ERROR, FATAL, or OFF. The `root` logger can be configured by using logging.level.root.

The following example shows potential logging settings in `application.properties`:

```yaml
logging:
  level:
    root: "warn"
    org.springframework.web: "debug"
    org.hibernate: "error"
```

It is also possible to set logging levels using environment variables. For example, `LOGGING_LEVEL_ORG_SPRINGFRAMEWORK_WEB=DEBUG` will set `org.springframework.web` to `DEBUG`.


# 4.6. Log Groups

It is often useful to be able to group related loggers together so that they can all be configured at the same time. 

For example, you might commonly change the logging levels for all Tomcat related loggers, but you can not easily remember top level packages.

To help with this, Spring Boot allows you to define logging groups in your Spring `Environment`. 

For example, here is how you could define a “tomcat” group by adding it to your `application.properties`:

```yml
logging:
  group:
    tomcat: "org.apache.catalina,org.apache.coyote,org.apache.tomcat"
```

Once defined, you can change the level for all the loggers in the group with a single line:

```yml
logging:
  level:
    tomcat: "trace"
```

Spring Boot includes the following pre-defined logging groups that can be used out-of-the-box:

| Name      | Loggers |
| ----------- | ----------- |
| web      | org.springframework.core.codec, org.springframework.http, org.springframework.web, org.springframework.boot.actuate.endpoint.web, org.springframework.boot.web.servlet.ServletContextInitializerBeans       |
| sql   | org.springframework.jdbc.core, org.hibernate.SQL, org.jooq.tools.LoggerListener        |

## 4.7. Using a Log Shutdown Hook

In order to release logging resources when your application terminates, a shutdown hook that will trigger log system cleanup when the JVM exits is provided.

```yaml
logging:
  register-shutdown-hook: false
```

## 4.8. Custom Log Configuration

The various logging systems can be activated by including the appropriate libraries on the classpath and can be further customized by providing a suitable configuration file in the root of the classpath or in a location specified by the following Spring `Environment` property: `logging.config`.

You can force Spring Boot to use a particular logging system by using the `org.springframework.boot.logging.LoggingSystem` system property. 

The value should be the fully qualified class name of a `LoggingSystem` implementation. 

You can also disable Spring Boot’s logging configuration entirely by using a value of none.

Depending on your logging system, the following files are loaded:

| Logging System      | Customization |
| ----------- | ----------- |
| Logback      | `logback-spring.xml`, `logback-spring.groovy`,` logback.xml`, or `logback.groovy`       |
| Log4j2   | `log4j2-spring.xml` or` log4j2.xml `       |

## 4.9. Logback Extensions

## 4.10. Log4j2 Extensions

# 5. Internationalization

Spring Boot supports localized messages so that your application can cater to users of different language preferences. 

- localized adj. 局部的；地区的；小范围的

- cater v. 提供餐饮服务，承办酒席；满足，迎合

By default, Spring Boot looks for the presence of a `messages` resource bundle at the root of the classpath.

The basename of the resource bundle as well as several other attributes can be configured using the `spring.messages` namespace, as shown in the following example:

```yaml
spring:
  messages:
    basename: "messages,config.i18n.messages"
    fallback-to-system-locale: false
```

# 6. JSON

# 7. Task Execution and Scheduling

In the absence of an `Executor` bean in the context, Spring Boot auto-configures a `ThreadPoolTaskExecutor` with sensible defaults that can be automatically associated to asynchronous task execution (`@EnableAsync`) and Spring MVC asynchronous request processing.

- n. 缺席，缺勤，不在；缺乏，没有；缺席期间，休假期间；不注意

The thread pool uses 8 core threads that can grow and shrink according to the load. Those default settings can be fine-tuned using the `spring.task.execution` namespace, as shown in the following example:

```
spring:
  task:
    execution:
      pool:
        max-size: 16
        queue-capacity: 100
        keep-alive: "10s"
```

This changes the thread pool to use a bounded queue so that when the queue is full (100 tasks), the thread pool increases to maximum 16 threads.

 Shrinking of the pool is more aggressive as threads are reclaimed when they are idle for 10 seconds (rather than 60 seconds by default).

A `ThreadPoolTaskScheduler` can also be auto-configured if need to be associated to scheduled task execution (using `@EnableScheduling` for instance). 

The thread pool uses one thread by default and its settings can be fine-tuned using the` spring.task.scheduling` namespace, as shown in the following example:

```yaml
spring:
  task:
    scheduling:
      thread-name-prefix: "scheduling-"
      pool:
        size: 2
```

Both a `TaskExecutorBuilder` bean and a `TaskSchedulerBuilder` bean are made available in the context if a custom executor or scheduler needs to be created.


# 8. Testing

Spring Boot provides a number of utilities and annotations to help when testing your application. 

- utilities n.公用事业；实用工具，应用程序；公共事业设备（utility 的复数）

Test support is provided by two modules: `spring-boot-test` contains core items, and `spring-boot-test-autoconfigure` supports auto-configuration for tests.

Most developers use the `spring-boot-starter-test` “Starter”, which imports both Spring Boot test modules as well as `JUnit Jupiter`, `AssertJ`, `Hamcrest`, and a number of other useful libraries.

## 8.1. Test Scope Dependencies

The spring-boot-starter-test “Starter” (in the test scope) contains the following provided libraries:

- `JUnit 5`: The de-facto standard for unit testing Java applications.
  - de-facto standard 事实标准；约定俗成的标准

- `Spring Test & Spring Boot Test`: Utilities and integration test support for Spring Boot applications.

- `AssertJ`: A fluent assertion library.

- `Hamcrest`: A library of matcher objects (also known as constraints or predicates).

- `Mockito`: A Java mocking framework.

- `JSONassert`: An assertion library for JSON.

- `JsonPath`: XPath for JSON.

We generally find these common libraries to be useful when writing tests. If these libraries do not suit your needs, you can add additional test dependencies of your own.

## 8.2. Testing Spring Applications
## 8.3. Testing Spring Boot Applications

## 8.4. Test Utilities

# 9. Creating Your Own Auto-configuration

## 9.1. Understanding Auto-configured Beans

## 9.2. Locating Auto-configuration Candidates

## 9.3. Condition Annotations

## 9.4. Testing your Auto-configuration

## 9.5. Creating Your Own Starter

# 10. Kotlin Support

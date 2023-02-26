# Chapter 4. Getting Started

We then walk you through building your first Spring Boot application, discussing some principles as we go.

- walk you through doing sth 指导你做某事
- discussing some principles as we go 边走边讨论一些原则。

## 4.1. Introducing Spring Boot

Spring Boot helps you to create stand-alone, production-grade Spring-based applications that you can run.

We take an opinionated view of the Spring platform and third-party libraries, so that you can get started with minimum fuss.

- fuss n. 大惊小怪，紧张不安；（为小事）大发牢骚；反对，抗议；繁琐的手续，麻烦

Most Spring Boot applications need very little Spring configuration.

You can use Spring Boot to create Java applications that can be started by using java -jar or more traditional war deployments.

We also provide a command line tool that runs “spring scripts”.

Our primary goals are:

- Provide a radically faster and widely accessible getting-started experience for all Spring development.
- 为所有 Spring 开发提供快速且广泛可访问的入门体验。

  - radically adv. 根本上，彻底地
  - faster adj. 更快的

- Be opinionated out of the box but get out of the way quickly as requirements start to diverge from the defaults

  - opinionated adj. 固执己见的；武断的
  - out of the box adj. 拆盒即可使用的；开箱即用的
  - get out of the way 让开；避开；解决
  - diverge from 背道而驰；背离

- Provide a range of non-functional features that are common to large classes of projects (such as embedded servers, security, metrics, health checks, and externalized configuration).

  - a range of 一系列；一些；一套
  - externalized configuration 外部化配置

- Absolutely no code generation and no requirement for XML configuration

## 4.2. System Requirements

Spring Boot 3.0.0 requires Java 17 and is compatible up to and including Java 19. Spring Framework 6.0.2 or above is also required.

Explicit build support is provided for the following build tools:

| Build Tool | Version            |
| ---------- | ------------------ |
| Maven      | 3.5+               |
| Gradle     | 7.x (7.5 or later) |

## 4.2.1. Servlet Containers

Spring Boot supports the following embedded servlet containers:

| Name                                | Servlet Version |
| ----------------------------------- | --------------- |
| Tomcat 10.0                         | 5.0             |
| Jetty 11.0                          | 5.1             |
| undertow 2.2 (Jakarta EE 9 variant) | 5.0             |

You can also deploy Spring Boot applications to any servlet 5.0+ compatible container.

- compatible adj. 兼容的；可共存的；可和睦相处的；与……一致的

## 4.2.2. GraalVM Native Images

Spring Boot applications can be converted into a Native Image using using GraalVM 22.3 or above.

Images can be created using the native build tools Gradle/Maven plugins or native-image tool provided by GraalVM.

You can also create native images using the the native-image Paketo buildpack.

The following versions are supported:

| Name               | Version |
| ------------------ | ------- |
| GraalVM Community  | 22.3    |
| Native Build Tools | 0.9.18  |

## 4.3. Installing Spring Boot

Spring Boot can be used with “classic” Java development tools or installed as a command line tool.

Either way, you need Java SDK v17 or higher.

- Either way 不管怎样；无论哪种方式

Before you begin, you should check your current Java installation by using the following command:

```shell
$ java -version
```

If you are new to Java development or if you want to experiment with Spring Boot, you might want to try the Spring Boot CLI (Command Line Interface) first.

Otherwise, read on for “classic” installation instructions.

### 4.3.1. Installation Instructions for the Java Developer

You can use Spring Boot in the same way as any standard Java library.

To do so, include the appropriate `spring-boot-*.jar` files on your classpath.

Spring Boot does not require any special tools integration, so you can use any IDE or text editor.

Also, there is nothing special about a Spring Boot application, so you can run and debug a Spring Boot application as you would any other Java program.

Although you could copy Spring Boot jars, we generally recommend that you use a build tool that supports dependency management (such as Maven or Gradle).

**Maven Installation**

Spring Boot is compatible with Apache Maven 3.3 or above.

If you do not already have Maven installed, you can follow the instructions at `maven.apache.org`.

Spring Boot dependencies use the `org.springframework.boot groupId`.

Typically, your Maven POM file inherits from the `spring-boot-starter-parent` project and declares dependencies to one or more “Starters”.

Spring Boot also provides an optional Maven plugin to create executable jars.

More details on getting started with Spring Boot and Maven can be found in the Getting Started section of the Maven plugin’s reference guide.

**Gradle Installation**

Spring Boot is compatible with Gradle 7.x (7.5 or later). If you do not already have Gradle installed, you can follow the instructions at gradle.org.

Spring Boot dependencies can be declared by using the org.springframework.boot group.

Typically, your project declares dependencies to one or more “Starters”. Spring Boot provides a useful Gradle plugin that can be used to simplify dependency declarations and to create executable jars.

More details on getting started with Spring Boot and Gradle can be found in the Getting Started section of the Gradle plugin’s reference guide.

### 4.3.2. Installing the Spring Boot CLI

The Spring Boot CLI (Command Line Interface) is a command line tool that you can use to quickly prototype with Spring.

- prototype v. 制作（产品的）原型

It lets you run Groovy scripts, which means that you have a familiar Java-like syntax without so much boilerplate code.

- boilerplate n. 样板文件；引用

You do not need to use the CLI to work with Spring Boot, but it is a quick way to get a Spring application off the ground without an IDE

- get off the ground v. 开始发行；飞起；（使）取得进展

**Manual Installation**

You can download the Spring CLI distribution from the Spring software repository:

Cutting edge snapshot distributions are also available.

尖端快照分发版也可用。

Once downloaded, follow the INSTALL.txt instructions from the unpacked archive.

In summary, there is a spring script (spring.bat for Windows) in a bin/ directory in the .zip file.

Alternatively, you can use java -jar with the .jar file (the script helps you to be sure that the classpath is set correctly).

**Installation with SDKMAN!**

....

## 4.4. Developing Your First Spring Boot Application

This section describes how to develop a small “Hello World!” web application that highlights some of Spring Boot’s key features.

We use Maven to build this project, since most IDEs support it.

You can shortcut the steps below by going to start.spring.io and choosing the "Web" starter from the dependencies searcher

- shortcut v. 通过使用捷径缩短（路线、程序等）；抄近道

Before we begin, open a terminal and run the following commands to ensure that you have valid versions of Java and Maven installed:

### 4.4.1. Creating the POM

We need to start by creating a Maven pom.xml file.

The pom.xml is the recipe that is used to build your
project.

Open your favorite text editor and add the following:

- recipe n. 烹饪法，食谱；诀窍，秘诀；原因；<古>处方

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
https://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.example</groupId>
  <artifactId>myproject</artifactId>
  <version>0.0.1-SNAPSHOT</version>
  <parent>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-parent</artifactId>
  <version>3.0.0</version>
  </parent>
  <!-- Additional lines to be added here... -->
</project>
```

The preceding listing should give you a working build. You can test it by running `mvn package` (for now, you can ignore the “jar will be empty - no content was marked for inclusion!” warning).

- The preceding listing 前面的清单

- working 运转的，运作的

- inclusion n. 包含，包括；包含物，包括的人；认同感，归属感

### 4.4.2. Adding Classpath Dependencies

Spring Boot provides a number of “Starters” that let you add jars to your classpath.

Our applications for smoke tests use the spring-boot-starter-parent in the parent section of the POM.

- 冒烟测试就是完成一个新版本的开发后，对该版本最基本的功能进行测试，保证基本的功能和流程能走通。

The spring-boot-starter-parent is a special starter that provides useful Maven defaults.

It also provides a dependency-management section so that you can omit version tags for “blessed” dependencies

- omit 省略

Other “Starters” provide dependencies that you are likely to need when developing a specific type of application.

Since we are developing a web application, we add a spring-boot-starter-web dependency.

Before that, we can look at what we currently have by running the following command:

```
mvn dependency:tree
```

The `mvn dependency:tree` command prints a tree representation of your project dependencies.

You can see that `spring-boot-starter-parent` provides no dependencies by itself.

To add the necessary dependencies, edit your `pom.xml` and add the `spring-boot-starter-web` dependency immediately below the `parent` section:

```xml

```

If you run `mvn dependency:tree` again, you see that there are now a number of additional dependencies, including the Tomcat web server and Spring Boot itself

### 4.4.3. Writing the Code

To finish our application, we need to create a single Java file.

By default, Maven compiles sources
from src/main/java, so you need to create that directory structure and then add a file named
`src/main/java/MyApplication.java` to contain the following code:

Although there is not much code here, quite a lot is going on.

虽然这里没有太多代码，但是有很多代码在运行

We step through the important parts in the next few sections.

#### The @RestController and @RequestMapping Annotations

The first annotation on our `MyApplication` class is `@RestController`.

This is known as a stereotype annotation.

这被称为原型注释。

- stereotype n.模式化的思想，老一套；公式化人物；铅版，铅版浇铸，铅版印刷

It provides hints for people reading the code and for Spring that the class plays a specific role.

In this case, our class is a web @Controller, so Spring considers it when handling incoming web requests.

The `@RequestMapping` annotation provides “routing” information.

It tells Spring that any HTTP request with the `/` path should be mapped to the `home` method.

The @RestController annotation tells Spring to render the resulting string directly back to the caller.

## The @SpringBootApplication Annotation

The second class-level annotation is `@SpringBootApplication`.

This annotation is known as a **_meta-annotation_**, it combines **@SpringBootConfiguration**, **@EnableAutoConfiguration** and **@ComponentScan**.

Of those, the annotation we’re most interested in here is `@EnableAutoConfiguration`.

- Of those 其中

`@EnableAutoConfiguration` tells Spring Boot to “guess” how you want to configure Spring, based on the jar dependencies that you have added.

. Since spring-boot-starter-web added Tomcat and Spring MVC, the auto-configuration assumes that you are developing a web application and sets up Spring accordingly.

**Starters and Auto-configuration**

Auto-configuration is designed to work well with “Starters”, but the two concepts are not directly tied.

You are free to pick and choose jar dependencies outside of the starters. Spring Boot still does its best to auto-configure your application.

**The “main” Method**

The final part of our application is the `main` method.

This is a standard method that follows the Java convention for an application entry point.

Our main method delegates to Spring Boot’s SpringApplication class by calling run.

- v.授权，把……委托给；选派（某人做某事）

SpringApplication bootstraps our application, starting Spring, which, in turn, starts the auto-configured Tomcat web server.

- bootstraps n. [计] 引导程序

We need to pass `MyApplication.class` as an argument to the run method to tell SpringApplication which is the primary Spring component.

The `args` array is also passed through to expose any command-line arguments.

### 4.4.4. Running the Example

At this point, your application should work.

Since you used the `spring-boot-starter-parent` POM, you have a useful `run` goal that you can use to start the application.

Type `mvn spring-boot:run` from the root project directory to start the application.

You should see output similar to the following:

....

If you open a web browser to localhost:8080, you should see the following output:

```
Hello World!
```

To gracefully exit the application, press `ctrl-c`.

### 4.4.5. Creating an Executable Jar

We finish our example by creating a completely self-contained executable jar file that we could run in production.

Executable jars (sometimes called “fat jars”) are archives containing your compiled classes along with all of the jar dependencies that your code needs to run.

**Executable jars and Java**

Java does not provide a standard way to load nested jar files (jar files that are themselves contained within a jar).

This can be problematic if you are looking to distribute a self-contained application.

- problematic adj. 成问题的，有困难的；未确定的

To solve this problem, many developers use “uber” jars.

An uber jar packages all the classes from all the application’s dependencies into a single archive.

The problem with this approach is that it becomes hard to see which libraries are in your application.

It can also be problematic if the same filename is used (but with different content) in multiple jars.

Spring Boot takes a different approach and lets you actually nest jars directly.

To create an executable jar, we need to add the `spring-boot-maven-plugin` to our `pom.xml`.

To do so, insert the following lines just below the `dependencies` section:

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
    </plugins>
</build>
```

> Tips
> The spring-boot-starter-parent POM includes <executions> configuration to bind the repackage goal. If you do not use the parent POM, you need to declare this configuration yourself. See the plugin documentation for details.

Save your `pom.xml` and run `mvn package` from the command line, as follows:

If you look in the `target` directory, you should see `myproject-0.0.1-SNAPSHOT.jar`.

The file should be around 10 MB in size.

If you want to peek inside, you can use `jar tvf`, as follows:

- peek v. 偷看，窥视；微露出，探出

```shell
jar tvf target/myproject-0.0.1-SNAPSHOT.jar
```

You should also see a much smaller file named `myproject-0.0.1-SNAPSHOT.jar.original` in the `target` directory.

This is the original jar file that Maven created before it was repackaged by Spring Boot.

To run that application, use the java -jar command, as follows:

```
java -jar target/myproject-0.0.1-SNAPSHOT.jar
```

As before, to exit the application, `press ctrl-c`.

# 4.5. What to Read Next

Hopefully, this section provided some of the Spring Boot basics and got you on your way to writing your own applications.

If you are a task-oriented type of developer, you might want to jump over to spring.io and follow some of the getting started guides that solve specific “How do I do that with Spring?” problems.

- How do I do that with Spring?

如何在 Spring 中做到这一点?

We also have Spring Boot-specific “`How-to`” reference documentation.

Otherwise, the next logical step is to read `using.html`.

If you are really impatient, you could also jump ahead and read about `Spring Boot features`.
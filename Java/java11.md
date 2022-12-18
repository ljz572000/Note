# JDK 11 

## JEP 328 ：Flight Recorder（JFR）

Flight Recorder（JFR）是Oracle刚刚开源的强大特性。

JFR 是一套**集成进入JDK、JVM内部的事件机制**框架，通过良好架构和设计的框架，硬件层面的极致优化，生产环境的广泛验证，它可以做到极致的可靠和低开销。在SPECjbb2015等基准测试中，JFR的性能开销最大不超过1%，所以工程师可以基本没有心理负担地在大规模分布式的生产系统使用，这意味着，我们既可以随时主动开启JFR 进行特定诊断，也可以让系统长期运行JFR，用以在复杂环境中进行“After-the-fact”分析。

在保证低开销的基础上，JFR提供的能力可以应用在对锁竞争、阻塞、延迟、JVM GC、SafePoint等领域，进行非常细粒度分析。甚至深入JIT Compiler内部，全面把握热点方法、内联、逆优化等等。JFR提供了标准的Java、C++等扩展API，可以与各种层面的应用进行定制、集成、为复杂的企业应用栈或复杂的分布式应用，提供All-in-One解决方案。

 而这一切都是内建在jdk和jvm内部的，并不需要额外的依赖，开箱即用。

 ## JEP 331：Low-Overhead Heap Profiling

 通过获取对象分配细节，为jdk补足了对象分配诊断方面的一些短板，工程师可以通过 JVMTI 使用这个能力增强自身的工具。

 从Java 类库发展的角度来看，JDK 11 最大的进步也是两个方面：

 1、 HTTP/2 Client API，新的HTTP API 提供了对HTTP/2 等业界前沿标准的支持，精简而又友好的API接口，与主流开源API（如，Apache HttpClient， Jetty， Okhttp等）对等甚至更高的性能。与此同时它是jdk在Reactive-Stream方面的第一个生成实践，广泛使用了java flow API等，终于让java 标准HTTP类库在扩展能力等方面，满足了现代互联网的需求。

 2、就是安全类库、标准等方面的大范围升级、其中特别是JEP 332： Transport Layer Security（TLS）1.3，除了在安全领域的重要价值，它还是中国安全专家范学雷所领导的JDK项目，完全不同于以往的修修补补，是个非常大规模的工程。

 除此之外，JDK还在逐渐进行瘦身工作，或者偿还JVM、Java规范等历史欠账，例如

## 335 Deprecate（丢弃） the Nashom JavaScript Engine

它进一步明确了 Graal 很有可能将成为JVM向前演进的核心选择，java-on-java 正在一步步的成为现实。


## java11 新特性

### Jshell

### var 语法 局部变量的类型推断

注意点：
    1） var a; 这样不可以，因为无法推断。
    2）类属性的数据类型不可以使用var。
    
有参数的lambda表达式使用：
函数式接口：
```
    Consumer<T>: 消费型函数式接口。
        public void accept(T t);
    Consumer<String> consumer = t -> System.out.println(t.toUpperCase());
    正确的形式
    Consumer<String> consumer = (@Deprecated var t) -> System.out.println(t.toUpperCase());
    错误的形式：必须要有类型，可以加上var
    Consumer<String> consumer = (@Deprecated t) -> System.out.println(t.toUpperCase());
```

### Stream

Stream 是java 8 中的新特性，java 9 开始对 Stream 增加了以下4个新方法。

1）增加单个参数构造方法，可为null。

Stream.ofNullable(null).count();

2) 增加takeWhile 和 dropWhile 方法
Stream.of(1,2,3,2,1);
.takeWhile(n -> n < 3)
.collect(Collectors.toList()); // [1,2]

**从流中一直获取判定器为真的元素，一旦遇到元素为假，就终止处理。**

从开始计算，当 n < 3 时就截止。

Stream.of(1, 2, 3, 2, 1)
.dropWhile(n -> n <3 )
.collect(Collectors.toList()); [3, 2, 1]
这个和上面的相反，一旦n<3不成立就开始计算。

3） iterate 重载

这个 iterate 方法的新重载方法，可以让你提供一个predicate（判断条件）来指定什么时候结束迭代。

```java
// 流的迭代，创建流
Stream<Integer> stream1 = Stream.iterate(1, t -> 2 * t + 1);
stream.limit(10).forEach(System.out::println);
//有限的迭代
Stream<Integer> stream2 = Stream.iterate(1, t -> t< 1000, t -> (2 * t) + 1);
stream2.forEach(System.out::println);
```
### 增加了一系列的字符串处理方法

如以下所示。

// 判断字符串是否为空白
"".isBlank();
// 去除首尾空白   去除字符串首尾的空白，包括英文和其他所有语言中的空白字符
" javastack ".strip(); // "javastack"
//去除字符串首尾的空白，只能去除码值小于等于32的空白字符
string.trim(); 
// 去除尾部空格
"javastack ".stripTralling(); // "javastack"
// 去除首部空格
" javastack".stripLeading(); // "javastack"
// 复制字符串
"java".repeat(3); // "JavaJavaJava"
// 行数统计
"A\nB\nC".lines().count();

### Optional 加强

Optional 也增加了几个非常酷的方法，现在可以很方便的将 Optional 转换成一个 Stream， 或者当一个空 Optional 时给它一个替代的。

```java
//of方法中如果传入的参数是null，会抛出空指针异常
// Optional<String> optional = Optional.of(null);
Option<Object> optional = Optional.ofNullable(null);
Obejct object = optional.orElse("abc"); //如果内部引用为空，则返回参数中的引用，否则则返回内部引用。
System.out.println(object);
```

### 改进的文件API

InputStream 加强

InputStream 终于有了一个非常有用的方法：transferTo， 可以用来将数据直接传输到OutputStream，这是在处理原始数据流时非常常见的一种用法，如下示例。

```java
var cl = this.getClass().getClassLoader();
var is = cl.getResourceAsStream("file");
try(var os = new FileOutputStream("file2")){
    is.transferTo(os);
}
is.close();
```

### 标准Java异步HTTP客户端

这是java 9 开始引入的一个处理HTTP请求的HTTP Client API， 该 API 支持同步和异步，而在java 11 中已经为正式可用状态，你可以在 java.net 包中找到这个API。

```java
//同步
HttpClient client = HttpClient.newHttpClient();
HttpRequest request = HttpRequest.newBuillder(URI.create("http://127.0.0.1:8080/test/")).build();
BodyHandler<String> responseBodyHandler = BodyHandlers.ofString();
HttpResponse<String> response = client.send(request, responseBodyHandler);
String body = response.body();
System.out.println(body);
//异步
HttpClient client = HttpClient.newHttpClient();
HttpRequest request = HttpRequest.newBuillder(URI.create("http://127.0.0.1:8080/test/")).build();
BodyHandler<String> responseBodyHandler = BodyHandlers.ofString();

CompletableFuture<HttpResponse<String>> client.sendAsync(request, responseBodyHandler);

HttpResponse<String> response = sendAsync.get();

String body = response.body();
System.out.println(body);
```

### 移除的一些其他内容

移除项
    移除了 com.sun.wat.AWTUtilities
    移除了 sun.misc.Unsafe.defineClass
    使用了 java.lang.invoke.MethodHandles.Lookup.defineClass 来替代

    移除了 Thread.destroy()以及Thread.stop(Throwable)方法
    移除了 sun.nio.ch.disableSystemWideOverlappingFileLockCheck、sun.locale.formatesdefault属性
    移除了jdk.snmp 模块
    移除了javafx，openjdk 估计是从java10版本就移除了，oracle jdk10 还尚未移除javafx，
    而java11 版本则oracle 的jdk 版本也移除了 javafx
    移除了java mission Control，从JDK中移除之后，需要自己单独下载
    移除了这些Root Certificate ： BaltimoreCybertrust Code Signing CA， SECOM, AOL and Swisscom

废弃项
    - XX+AggressiveOpts选项
    - XX：+UnlockCommericalFeatures
    - XX：+LogCommercialFeatures 选项也不再需要

### 更简化的编译运行程序

JEP 330： 增强java启动器支持运行单个java源代码文件的程序
执行源文件中的第一个类，并且不可以使用别源文件中的自定义类

java code.java

### Unicode 10

Unicode 10 增加了8518个字符，总计达到了136690个字符，并且增加4个脚本，同时还有56个新的emoji表情符号。

### Remove the JavaEE and CORBA Moudles

在java 11 中移除了不太使用的javaEE 模块和CORBA 技术。

### Epsilon垃圾收集器

-XX:+UnlockExperimentalVMOptions -XX:+UseEpsilonGC 程序很快就因为堆空间不足而退出。

使用这个选项的原因：
提供完全被动的GC实现，具有有限的分配限制和尽可能低的延迟开销，但代价是内存占用和内存吞吐量。

众所周知，java实现可广泛选择高度可配置的GC实现，各种可用的收集器最终满足不同的需求，即使它们的可配置性使它们的功能相交，有时更容易维护单独的实现，而不是在现有GC实现上堆积另一个配置选项。

主要用途如下：
    性能测试（它可以帮助过滤掉GC引起的性能假象）
    内存压力测试（例如，知道测试用例应该分配不超过1GB的内存，我们可以使用-Xmx1g -XX:+UseEpsilonGC, 如果程序有问题，则程序会崩溃）
    非常短的JOB任务（对象这种任务，接受GC清理堆那都是浪费空间）
    VM接口测试
    Last-drop 延迟&吞吐改进


### ZGC 这应该是JDK11 最为瞩目的特性，没有之一，但是后面带了Experimental, 说明这还不建议用到生产环境。

ZGC，A Scalable Low-Latency Garbage Collector
用法： -XX:+UnlockExperimentalVMOptions -XX:UseZGC
因为ZGC还处于试验阶段，所以需要通过jvm参数来解锁这个特性。

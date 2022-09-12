# 阿里云 Maven

maven 当前仓库使用阿里免费的仓库进行发布，免去了自建 nexus 的麻烦

https://packages.aliyun.com/maven


# 七大主流的 HttpClient 程序对比

|                   | 优点                 | 缺点                                                                   |
| ----------------- | -------------------- | ---------------------------------------------------------------------- |
| HttpURLConnection | jdk 自带、原始、简单 | 无连接池、性能与效率相对较低、高级功能不方便使用，一般来说不建议使用。 |
| java.net.http.HttpClient | jdk11 正式启用自带HttpClient, 代替之前比较旧的HttpURLConnection | Oracle 收购后大多数企业使用的都还是jdk8,使用的可能性比较小 |
| HttpClient | 1. 支持连接池、多线程 <br> 2. 从官方demo可以看出httpclient只创建一次，被多个线程复用<br> 3.httpclient 4.3 后超时配置到request级 | 1. 由于社区活跃度的问题，Android已经去掉了HttpClient改用okHttp。<br> 2.使用起来需要自己封装<br>3.需要手动关闭httpclient.close() |
| okHttp | 1. 性能方面与HTTPclient类似 <br>2. 不需要手动关闭<br> 3.支持HTTP2 <br> 4. Android4.4 开始换成okhttp | 1. 使用时需要自己封装<br>2. new OkHttpClient()每次使用都需要new出来（从网上看到说作者可能是考虑可能忽略此开销）<br>3.超时配置在client级，没到每个request，这个可能与第二点同原因。<br>4.好像底层实现了多线程的支持，没深入研究 |
| Retrofit | Retrofit 是Square出的基于Okhttp封装的一套RESTful网络请求框架<br>1. restful 风格 <br>2.基于接口编程<br>3.封装度高，基于注解<br>4.无需手动关闭 | 1. 与okhttp 类似， new Retrofit,Builder()每次使用都要new出来 （可以考虑自己实现单例，网上也有些demo） |
| RestTemplate | RestTemplate 是 Spring 提供的用于访问Rest服务的客户端。<br> RestTemplate 提供了多种便捷访问远程http服务的方法，能够大大提高客户端的编写效率 | 1. RestTemplate 只有初始化配置，没有连接池<br>2.RestTemplate 默认的http是HttpURLConnection |
| OpenFeign | 1. 可插拔的注解支持，包括Feign注解和JAX-RS注解。<br>2.支持可插拔的HTTP编码器和解码器（Gson,Jackson, Sax,JAXB, JAX-RS, SOAP).<br>3.支持HTTP请求和响应的压缩。<br>4.支持多种客户端：JDK URLConnection、apache httpclient、okhttp、ribbon | 默认的http是HttpURLConnection |

**总结**

在你还在纠结选择apache httpclient时，Android已经不用它了，改用okhttp了

当你还在纠结选择apache httpclient还是okhttp时，Square已经出了Retrofit，网友已经在说既然你都用了okhttp为何不直接使用Retrofit

总的来说技术变化更新都比较快，得跟上技术的发展。一般来说没用使用springcloud话可以选择Retrofit，如果使用了springcloud可以使用OpenFeign+okHttp。

[jersey-rest-client-with-apache-http-client-4-5-vs-retrofit](https://stackoverflow.com/questions/42199614/jersey-rest-client-with-apache-http-client-4-5-vs-retrofit)


---

# Ehcache

https://www.ehcache.org/

待学习


# 浅拷贝与深拷贝的区别

浅拷贝：创建一个新对象，新对象的属性值和原来对象完全相同，对于非基本类型属性，仍指向原有属性所指向的对象。

深拷贝：创建一个新对象，属性中引用的其他对象也会被克隆，不再指向原有对象。

异同点

深浅克隆都会在堆中新创建一个对象；
区别在于对象属性引用的对象是否也进行了克隆（递归性的，深的克隆，浅的不克隆）；

# yudao Learn



## Web 相关

[Knife4j](https://doc.xiaominfo.com/)

## DB 相关

[redisson](https://github.com/redisson/redisson)

## Config 配置中心相关

[apollo](https://github.com/apolloconfig/apollo)

## 服务保障相关

[lock4j](https://gitee.com/baomidou/lock4j)

[resilience4j](https://github.com/resilience4j/resilience4j)

Resilience4j是一款轻量级，易于使用的容错库.

## 监控相关

[skywalking](https://skywalking.apache.org/)

skywalking 是一个国产开源框架，2015年由个人吴晟（华为开发者）开源 ， 2017年加入Apache孵化器，skywalking是分布式系统的应用程序性能监视工具，专为微服务、云原生架构和基于容器（Docker、K8s、Mesos）架构而设计。SkyWalking 是观察性分析平台和应用性能管理系统。提供分布式追踪、服务网格遥测分析、度量聚合和可视化一体化解决方案

[spring-boot-admin](https://github.com/codecentric/spring-boot-admin)


[opentracing](https://github.com/opentracing)

## Test

[podam](http://mtedone.github.io/podam/)

[jedis-mock](https://github.com/fppt/jedis-mock)

[mockito](https://github.com/mockito/mockito)

## Bpm工作流

[flowable](https://www.flowable.com/open-source/docs/bpmn/ch05a-Spring-Boot/)

## 工具类

[MapStruct](https://mapstruct.org/documentation/stable/reference/html/)

**加解密**

[jasypt](http://www.jasypt.org/)

**代码生成**

[velocity-engine-core](https://velocity.apache.org/)

- [screwv](https://gitee.com/leshalv/screw)
    - 简洁好用的数据库表结构文档生成工具

- [guava](https://guava.dev/)

    - Guava 是一组来自 Google 的核心 Java 库，其中包括新的集合类型（例如 multimap 和 multiset）、不可变集合、图形库以及用于并发、I/O、散列、缓存、原语、字符串等的实用程序！它广泛用于 Google 内部的大多数 Java 项目，也被许多其他公司广泛使用。

- [guice](https://www.jianshu.com/p/7fba7b43146a)
    - Google Guice 一个轻量级的依赖注入框架

- [TransmittableThreadLocal](https://github.com/alibaba/transmittable-thread-local)

- [commons-net网络开发包](https://commons.apache.org/proper/commons-net/)
    - 解决 ftp 连接 

- [jsch](http://www.jcraft.com/jsch/)
    - 解决 sftp 连接

- [Apache Tika - a content analysis toolkit](https://tika.apache.org/)

- [行为验证码](https://github.com/anji-plus/captcha)

- [社交登陆](https://gitee.com/justauth/justauth-spring-boot-starter)

- 短信验证码SMS SDK

```
yunpian-java-sdk
aliyun-java-sdk-core
aliyun-java-sdk-dysmsapi
tencentcloud-sdk-java
```

- [积木报表](http://www.jimureport.com/)

- [Xerces2](https://xerces.apache.org/)
    - Xerces2 在 Apache Xerces 系列中提供了高性能、完全兼容的 XML 解析器。

- [uni-app](https://github.com/dcloudio/uni-app)

[什么是DTO ，DTO 有什么作用](https://blog.csdn.net/weixin_34059951/article/details/92613242)


- [微信开发 Java SDK](https://github.com/Wechat-Group/WxJava)
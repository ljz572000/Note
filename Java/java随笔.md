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

- [Knife4j](https://doc.xiaominfo.com/)

- [MapStruct](https://mapstruct.org/documentation/stable/reference/html/)

- [redisson](https://github.com/redisson/redisson)

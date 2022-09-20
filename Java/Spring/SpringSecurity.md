# 1. 概述

以打飞机举例子：

【认证】你要登机，你需要出示你的 passport 和 ticket，passport 是为了证明你张三确实是你张三，这就是 authentication。

【授权】而机票是为了证明你张三确实买了票可以上飞机，这就是 authorization。


以论坛举例子：

【认证】你要登录论坛，输入用户名张三，密码 1234，密码正确，证明你张三确实是张三，这就是 authentication。
【授权】再一 check 用户张三是个版主，所以有权限加精删别人帖，这就是 authorization 。

认证解决“你是谁”的问题，授权解决“你能做什么”的问题。

在 Java 生态中，目前有 **Spring Security** 和 **Apache Shiro** 两个安全框架，可以完成认证和授权的功能。


```yml
spring:
  # Spring Security 配置项，对应 SecurityProperties 配置类
  security:
    # 配置默认的 InMemoryUserDetailsManager 的用户账号与密码。
    user:
      name: user # 账号
      password: user # 密码
      roles: ADMIN # 拥有角色
```

- 在 spring.security 配置项，设置 Spring Security 的配置，对应 SecurityProperties 配置类。

- 默认情况下，Spring Boot UserDetailsServiceAutoConfiguration 自动化配置类，会创建一个内存级别的 InMemoryUserDetailsManager Bean 对象，提供认证的用户信息。

    - 这里，我们添加了 spring.security.user 配置项，UserDetailsServiceAutoConfiguration 会基于配置的信息创建一个用户 User 在内存中。
    
    - 如果，我们未添加 spring.security.user 配置项，UserDetailsServiceAutoConfiguration 会自动创建一个用户名为 "user" ，密码为 UUID 随机的用户 User 在内存中。

# 运行 单机 nacos mysql 5.7


```bash

docker-compose -f standalone-mysql-5.7.yaml up

```


账号/密码

```txt

nacos/nacos

```


# 停止 单机 nacos mysql 5.7

```bash

docker-compose -f standalone-mysql-5.7.yaml down

```

# nacos derby

```
docker-compose -f standalone-derby.yaml up
```


# nacos 访问地址

```
http://47.106.15.103:8848/nacos/#/login
```

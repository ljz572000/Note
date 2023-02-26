Install Elasticsearch with Docker

https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html


# 单点集群

1. 为 Elasticsearch 和 Kibana 创建一个新的 docker 网络

```
docker network create elastic
```

2. 在Docker中启动Elasticsearch。为Elasticsearch用户生成一个密码并输出到终端，另外还有一个用于注册Kibana的注册令牌。

```
docker run --name es01 --net elastic -p 9200:9200 -p 9300:9300 -it elasticsearch:8.0.1
```

The vm.max_map_count kernel setting must be set to at least 262144 for production use.

```
 sysctl -w vm.max_map_count=262144
```

3. 复制生成的密码和注册令牌，并将其保存在一个安全的地方。这些值只有在你第一次启动Elasticsearch时才会显示。

**tips:** 如果你需要重置Elasticsearch用户或其他内置用户的密码，请运行elasticsearch-reset-password工具。这个工具可以在Docker容器的Elasticsearch/bin目录中找到。比如说。
```
docker exec -it es01 /usr/share/elasticsearch/bin/elasticsearch-reset-password
```

4. 将Docker容器中的http_ca.crt安全证书复制到你的本地机器。

```
docker cp es01:/usr/share/elasticsearch/config/certs/http_ca.crt .
```

5. 打开一个新的终端，使用从Docker容器中复制的http_ca.crt文件，通过认证调用，验证你可以连接到Elasticsearch集群。在提示时输入弹性用户的密码。

```
curl --cacert http_ca.crt -u elastic https://localhost:9200
```

## 注册其他节点

当你第一次启动Elasticsearch时，安装过程默认会配置一个单节点集群。这个过程也会生成一个注册令牌，并将其打印到你的终端。如果你想让一个节点加入现有的集群，用生成的注册令牌启动新的节点。

 **生成注册令牌**
```

注册令牌的有效期为30分钟。如果你需要生成一个新的注册令牌，请在你现有的节点上运行elasticsearch-create-enrollment-token工具。这个工具可以在Docker容器的Elasticsearch bin目录中找到。

例如，在现有的es01节点上运行以下命令，为新的Elasticsearch节点生成一个注册令牌。

docker exec -it es01 /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s node

```

1. 在你启动第一个节点的终端，复制生成的注册令牌，用于添加新的Elasticsearch节点。
2. 在你的新节点上，启动Elasticsearch并包括生成的注册令牌。

   ```
   docker run -e ENROLLMENT_TOKEN="<token>" --name es02 --net elastic -it docker.elastic.co/elasticsearch/elasticsearch:8.0.1
   ```
3. 现在Elasticsearch已经被配置为加入现有的集群。

## 设置JVM堆大小

如果你遇到的问题是，当你的第二个节点启动时，你的第一个节点正在运行的容器退出，明确设置JVM堆大小的值。要手动配置堆的大小，包括ES_JAVA_OPTS变量，并在启动每个节点时设置-Xms和-Xmx的值。例如，下面的命令启动节点es02，并将JVM堆的最小和最大尺寸设置为1GB。

```
docker run -e ES_JAVA_OPTS="-Xms1g -Xmx1g" -e ENROLLMENT_TOKEN="<token>" --name es02 -p 9201:9200 --net elastic -it docker.elastic.co/elasticsearch/elasticsearch:docker.elastic.co/elasticsearch/elasticsearch:8.0.1
```

## 注意点

你现在已经建立了一个测试Elasticsearch的环境。在你开始认真的开发或使用Elasticsearch投入生产之前，回顾一下在生产中使用Docker运行Elasticsearch时的要求和建议。
https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#docker-prod-prerequisites

## 安全证书和密钥编辑

首次启动 Elasticsearch 时，会在 Docker 容器的 /usr/share/elasticsearch/config/certs 目录中生成以下证书和密钥，并允许您将 Kibana 实例连接到受保护的 Elasticsearch 集群并加密节点间 沟通。 这些文件在此处列出以供参考。

http_ca.crt
用于签署该Elasticsearch集群的HTTP层证书的CA证书。
http.p12
包含该节点的HTTP层的密钥和证书的密钥库。
transport.p12
包含集群中所有节点的传输层的密钥和证书的密钥库。

# 用Docker Compose启动一个多节点集群

为了让多节点Elasticsearch集群和Kibana在Docker中启动和运行并启用安全功能，你可以使用Docker Compose。

## 准备好环境

在一个新的、空的目录中创建以下配置文件。这些文件也可以从GitHub上的elasticsearch仓库获得。

## 在启用安全的情况下启动你的集群，并配置
1. 修改.env文件，为ELASTIC_PASSWORD和KIBANA_PASSWORD两个变量输入强密码值。

2. 创建并启动三个节点的Elasticsearch集群和Kibana实例。

```
docker-compose up -d
```

3. 当部署开始后，打开浏览器并导航到http://localhost:5601，访问Kibana，在那里你可以加载样本数据并与你的集群互动。


# 在生产中使用Docker镜像
以下要求和建议适用于在生产中以Docker方式运行Elasticsearch。

设置vm.max_map_count为至少262144

vm.max_map_count内核设置必须设置为至少262144，以便在生产中使用。

# 本地启动kibana访问

文件：ca/*
kibana.yml

Elastic：为 Elasticsearch 启动 HTTPS 访问

https://blog.csdn.net/UbuntuTouch/article/details/105044365



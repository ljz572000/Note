# redis-cluster

https://blog.csdn.net/weixin_50236329/article/details/109771983

现在通过脚本 redis-cluster-config.sh 批量生成配置文件

```
docker network create --subnet 172.77.0.1/24 redis_network
```

```shell
bash redis-cluster.sh
```

运行

```
docker-compose -f redis-cluster.yml up
```

集群配置
redis集群官方提供了配置脚本，4.x和6.x略有不同，以下是以6.x为例；

```
docker exec -it redis6379 redis-cli -p 6379 -a ljz-ljz001 --cluster create 172.77.0.1:6379 172.77.0.1:6380 172.77.0.1:6381 172.77.0.1:6382 172.77.0.1:6383 172.77.0.1:6384 --cluster-replicas 1
```

1. 查看集群通信是否正常

redis6379主节点对它的副本节点redis6384进行ping操作。

```
docker exec -it redis6379 redis-cli -h 172.77.0.1 -p 6384 -a ljz-ljz001 ping
```

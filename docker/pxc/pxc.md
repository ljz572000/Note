# 常见 MySQL 集群方案 - PXC 集群方案（ Percona XtraDB Cluster ）

[PXC集群](https://www.cnblogs.com/crazymagic/articles/13951461.html)
[Docker 搭建mysql 集群](https://blog.csdn.net/qq_41967899/article/details/104276161)

https://www.cxybb.com/article/alwaysbefine/110748717
```
docker network create --subnet 172.66.0.1/24 mysql_network
```


```bash
# 运行
docker-compose -f pxc.yml up

docker-compose -f pxc-follower.yml up

# 停止
docker-compose -f pxc.yml down

docker-compose -f pxc-follower.yml down
```

# skywalking 运行

**先决条件： 安装es7**

**选择h2 作为存储**

```
docker-compose -f skywalking.yml up
```

**选择es 作为存储**

```
docker-compose -f skywalking-es.yml up
```

## 卸载

```
docker-compose -f skywalking.yml down
```

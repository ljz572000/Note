
# Elasticsearch 运行

kibana 登陆密码：elastic/elastic
```
cd es7/

sysctl -w vm.max_map_count=262144
 
docker-compose -f es7/no-kibana-single.yml up -d

docker-compose -f single.yml up -d
```

| 文件 | 解释 |
| ---- | -----|
| sing.yml    | 单台es服务    |
| double.yml    | 双台es服务    |
| elasticsearch.yml    | 3台es服务    |
| no-kibana-single.yml    | no-kibana- 单台es服务    |
| no-kibana-double.yml    | no-kibana- 2台es服务    |
| no-kibana-elasticsearch.yml   | no-kibana- 3台es服务    |

## delete Elasticsearch 运行

```
cd elasticsearch/

docker-compose -f elasticsearch.yml down
```

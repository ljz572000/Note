
# MinIO 运行

```
docker-compose -f MinIO/docker-compose.yml up -d
```
文件保存本地目录
```
docker-compose -f MinIO/share-local.yml up -d
```
## delete MinIO 运行

```
docker-compose -f MinIO/docker-compose.yml down
```

【项目实践】手把手教你自建高性能对象存储服务器

https://www.cnblogs.com/RudeCrab/p/14509755.html


docker run -p 9000:9000 --name minio1 -v ./data:/data -v ./minio\config:/root/.minio minio/minio server /data

```
docker run --name minio --publish 9000:9000 --publish 9001:9001 --env MINIO_FORCE_NEW_KEYS="yes" --env MINIO_ROOT_USER="new-minio-root-user" --env MINIO_ROOT_PASSWORD="new-minio-root-password" --volume minio-persistence:/data bitnami/minio:latest
```

http://docs.minio.org.cn/docs/master/minio-client-quickstart-guide
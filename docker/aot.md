[Graalvm入门跳坑记录](https://blog.csdn.net/q412086027/article/details/113878426)

**构建可执行文件**

```shell
mvn -DskipTests -Pnative clean native:compile
```

**打包成镜像**

```shell
mvn -DskipTests -Pnative clean spring-boot:build-image
```

**运行**

```shell
docker run --rm -p 8080:8080 aot:0.0.1-SNAPSHOT
```

**离线到处与导入**

[docker load报错：Error processing tar file(exit status 1): archive/tar: invalid tar header](https://blog.csdn.net/m0_37763336/article/details/107220077)

```shell
docker save -o aot.tar aot:0.0.1-SNAPSHOT
docker load -i aot.tar
```
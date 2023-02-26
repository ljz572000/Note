# Jenkins

## 运行

```
docker run -p 8080:8080 -p 50000:50000 --restart=on-failure -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts-jdk11
```

密码路径

```
/var/lib/docker/volumes/jenkins_home/_data/secrets
```

设置密码
```
admin
ljz-ljz001
```


方式一（推荐）

先进入 jenkins 的容器中

docker exec -it jenkins容器id /bin/bash

**jdk**

然后通过echo $JAVA_HOME来查看 java 路径在/usr/local中，然后配置进 jenkins 的 JAVA_HOME 中即可

**git**

通过which git查看 git 执行文件路径为/usr/bin/git，把这个复制到 jenkins 路径中

**mvn**

jenkins 容器中一般没有 maven 提供的，所以 jenkins 配置中我使用 install automatically

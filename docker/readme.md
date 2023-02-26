# docker-compose 安装

```
https://github.com/docker/compose

chmod +x /usr/local/bin/docker-compose

```

- 卷删除

```
docker volume prune
```

- 网络删除

```
docker network prune 
```

- sql server images

```
mcr.microsoft.com/mssql/server:2019-latest

mcr.microsoft.com/mssql/server:2017-latest

microsoft/mssql-server-linux:2017-latest
```

```
docker run -it --name record_ubuntu -p 22:22 -d ubuntu:21.10

docker exec -it record_ubuntu bash

passwd  #happy@123

cp -a /etc/apt/sources.list.bak /etc/apt/sources.list 

sed -i "s@http://.*archive.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list
sed -i "s@http://.*security.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list

apt-get update

apt-get upgrade -y

service ssh start

mkdir ~/.ssh
chmod 0700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 0644 ~/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAsXVyYVHm1n8zqXThybxCEVbTBL020eEjfM2KelSIcGz3xVQafoapC84bWOJcIv+Vp4TPY7kFu/vZXqrLqT9i7ZBm0SnCmeePRnSH9BVPxUsYtZ++2YhI/zYYtEhJltkq1uO7+L/3RdDZR8upCAXklNEXAHfCCiyrPVaf4MQcxdMPlBUbmVkMYS5vR+viiRMjBuZp1ozf5myTfJ07762n7MMzlv7IA7z5nhxvkmeaqI3MlH7YSxXYD2E4Mwl8/06KOMYGOSbiG3uE0mEblNgHObTNJITIN8LOUzFJs2YNbc6Wco/SLUCeS1fMA0mJUEjVVaB/wCboNt31o/cf0Dh2wQ== rsa-key-20210604">>~/.ssh/authorized_keys

# passphrase qqq123

docker commit -a "lijinzhou" -m "实习总结PPT" record_ubuntu ljz666/record_ubuntu:20210615
```


```
  "registry-mirrors": [
    "https://0o41t242.mirror.aliyuncs.com"
  ]
```
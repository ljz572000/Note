# 查看文件夹/文件大小

参数 -h 表示使用「Human-readable」的输出，也就是在档案系统大小使用 GB、MB 等易读的格式。

```shell
ll -h
```

**查询文件或文件夹的磁盘使用空间**

```shell
du -h --max-depth=1
```

**查看磁盘的文件系统与使用情形**

```shell
df -h
```
MySQL 集群架构设计

- Read uncommitted
- Read committed
- Repeatable read
- Serializable

https://www.cnblogs.com/myseries/p/10748912.html

> Read committed 这是各种系统中最常用的一种隔离级别，也是SQL Server和Oracle的默认隔离级别。
> Repeatable read 它也是MySql的默认隔离级别。
> 重复读可以解决不可重复读问题。写到这里，应该明白的一点就是，不可重复读对应的是修改，即UPDATE操作。但是可能还会有幻读问题。因为幻读问题对应的是插入INSERT操作，而不是UPDATE操作。

那么这部分内容肯定会涉及到我们的分布式

分布式里边又要说到我们的读写分离

读写分离是基于复制思想的

而复制思想，它的核心文件是我们的binlog

所以有这样一句话

无论你的MySQL集群架构如何设计，他底层的核心技术必然是binlog的传输、读取和写入


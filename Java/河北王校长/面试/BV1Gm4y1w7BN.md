【Java 技术专家归津路-一面实录。年薪过百不如家。】https://www.bilibili.com/video/BV1Gm4y1w7BN

1. MySql 索引 数据结构和时间复杂度

索引使用的是B+ 树

时间复杂度 o(log n)

2. 三层B+树 非叶子节点 有 500 个，叶子节点存储50条数据，能说一下他的消耗时间点吗？

3层 B+ 树 首先会对根节点进行一次IO，然后在根节点进行500个指针的二分查找定位。再加上二层非叶子节点的一次IO。IO到之后在二层非叶子节点的500个指针里面，再进行二分查找的一个定位，再加上叶子节点的一次IO，再加上叶子节点，里面存储50条数据的二分查找的一个定位，二分查找都是o(log n)的一个时间复杂度

3. 一次IO是什么意思呢？

MySql 提取一次B+树的16Kb 内存页。

4. 第二层从哪里提前呢？

如果这条数据是首次查询的话，它是从磁盘的表空间文件里边进行提取。 这是一次磁盘的IO。提取之后，会将他放入到Mysql的缓冲池里面。

第二次查询，如果还命中内存页的话，会直接从缓冲池里面提取。

5. 那缓冲池大小不够，怎么办？

其实缓冲池内部也是用lRU, 进行的内存管理，达到缓冲池最大容量的时候。他会自动淘汰L R U 尾端的非热点数据。

6. 那缓冲池可以人为干预吗？

可以。inno DB 提供了 inno DB Buffer for size 这样的一个参数。理论上的话，缓冲池越大，我们MySQL 的性能越好。因为内存它的一个处理速度会比较快。64位操作系统理论上可以支持2的64次方的一个比特的内存容量。不过大小设置呢。我们需要根据业务的一个数据容量进行设置。L R U 这边也是可以进行调整的。因为MySQL的L R U它的一个数据淘汰机制跟普通的L R U 是不一样的。它是设置了一个L R U 的middle point。 在这个middle point 之前都是热点数据。middle point 之后都是非热点数据。默认情况下，它的一个设置，参数5/8的位置。基于这个基础上，我们还可以去设置，比如说查询了一条数据。我们将它放到了5/8 middle point 位置。如果在多少时间以内有再次的一个访问，我们可以将它提到热点数据，这是一个时间的阈值。我们也可以进行设置。

7. 这么做的好处是什么呢？

其实它这样做是为了避免很多数据的一个提取

普通的LRU 它的一个操作是当我们提前到这些数据以后会直接加入到 L R U的头部。

也就是我们链表的一个high的部分。对于这部分有可能我们仅仅只是做一次这种查询。后边呢我们就不会再查询了。如果按照这种老的形式来说的话，这些数据会占用大部分的头部的热点数据，那么会把真正的热点数据慢慢地往后移。当我们缓冲池的大小达到一个最大容量的时候，这部分本来应该是热点数据的，却在后边有可能被淘汰，而设置这个5/8的这个位置，他先会把我们查询到的这个数据放到L R U 链表的一个中立位置，也就是刚才说的LRU middle point 5/8 的位置。如果我们真的对这部分数据还会再次进行一个查询，那么说明它就是一个热点数据。这个时候我们会考虑将这部分数据从 LRU middle point 的位置，把它给提到我们热点数据的这一部分，这样可以进行第二次的一个查询来确认它是热点数据。其实就是避免了单次查询造成的假热点数据的这种现象。

1. 5/8 是怎么来的

是一个默认的设置。猜测，这是一个估算的值。而且这个参数是可以调整的

9. 一个Mysql 表 id 为主键，价格为辅助索引，这个索引该如何更新呢？

Id 为主键会自动生成一个聚集索引，插入数据的话，id一般主键都是设置为自增聚集索引。聚集索引一般是一种顺序插入，不需要使用MySQL的缓冲池。

缓冲池里面其实有一个insert buffer. 这部分呢就是我们在插入数据的时候，可以先将这部分数据插入到我们的这个插入缓冲里边，然后呢再从我们的这个插入缓冲进行异步的一个更新到我们的磁盘上。

但是对于聚集索引来说，它是一个顺序的插入。我们可以很快地定位到我们叶子节点的最后一个内存页。这样的话，它其实可以直接更新我们的B+树的索引。

但是对于价格来说，它是一个辅助索引，它不是一个自增的，它也有可能重复，而且不是唯一的。

那么插入过程中，可能我们会涉及到需要从我们的磁盘里边提取很多个不同的B+树内存页，那么如果直接提取磁盘。由于磁盘它的一个查询速度不如我们内存来得快。所以这个时候MySQL的设计师设置了一个中间的缓冲池，内部的一个insert buff插入缓冲区。

我们对价格这一部分它在更新B+树的时候，先把这一部分B+树更新到我们insert buff 插入缓冲里边。然后再由master thread 每秒进行检测。如果我们的插入缓冲这部分数据已经满了。我们就可以master thread 就可以将插入缓冲的这一部分，把它更新到我们真正的磁盘持久化的表空间文件里边。

10. 一个叶子节点如果只存储一条MySQL数据该怎么办？

MySQL 叶子节点是最少存放两条数据。

因为如果存放一条数据，它就类似与单链表。

所以官方文档对这一部分，进行了说明。

MySQL的一个叶子节点至少是存放两条数据的。

11. 那我比如说存放两条数据都超过了16kb. 那叶子节点，该怎么存放？

因为理论上讲在没有压缩的情况下，我们一个MySQL的内存页是16kb

存放两条数据都超过了16kb, MySQL 这边会提供一个策略是溢出页。溢出页会存放这一部分行溢出的数据。所以对于我们真正存放到我们这个MySQL内存页里边的数据。他除了包含溢出以内的这些数据，对于溢出以外的这部分数据。它会以一个指针指向我们额外的一个溢出页

12. MySQL事务隔离级别都有什么

MySQL这边有四个事务级别。

- read uncommitted / 读取未提交
- read committed / 读取已提交
- repeatable-read / 可重复读
- serializable / 可串行

13. RR 和 RC 主从同步有什么区别？

Statement Based Replication (SBR)

RR, 它只能配合statement形式的SBR 进行主从复制

read committed 能和这个SBR也能和RBR 进行配合


14. 能你接触的项目哪个使用的多呢？

大部分都是RC 加上 RBR。

read committed 加上raw 形式的 blog format

15. 不考虑事务的隔离性吗

隔离性确实是acid 四大事务特点之一

那业务过程中，RC模式虽然他违反了事务的一个隔离性。

也就是说两个不同的事务线程在对数据进行修改的时候，本应该让他们两个进行隔离。

其中一条事务线程不能够读取到另外一条事务线程所提交的这个数据

但是对于一些互联网项目，包括高并发的项目。他为了展现数据的一个真实的一个变迁的过程，所以它使用了read committed。

拿不可重复读举一个例子。第二次读和第一次读，读的不一致。

恰恰是因为在我们第一次读完之后，第二次读数据之前，这个数据确实是被其他线程修改了。如果我们使用了RC的话，我们就能够去感知它的这个修改的过程。

而RR这一块它是感知不到的。

所以对于我们这个互联网的一些数据的它的数据变迁的一个真实的状态还是更多的会使用**RC加上RBR**的形式。

那对于不可重复读和幻读呢？

我们需要通过我们的代码层面进行控制

16. RC配合RBR的主从架构，以及RR配合SBR的一个主从架构，快在哪里？

RBR模式下，首先如果使用RBR以这种row形式进行主从复制的话。

一般会设置表主键自增的lock mode为2.

也就是说对于所有的insert like这种插入，都会采用一种叫互斥量的形式进行id的一个分发。

传统的，它会采用一个表锁 auto increase locking 这种自证形式。

那么这部分来说，对于我们这个RC加RBR的这种形式，如果有这种数据库的一个插入的话，对于它id自增这一块，它的性能会比较快。

另外呢 RC模式下在修改数据的时候，它是没有间隙锁的。

之所以RR它能够保证我们不发现不可重复读和幻读，是因为他加入了gap lock.

而RC模式没有这个gap lock. 没有gap lock 的话，我们再修改一条数据，没有间隙的控制。另外一个线程可以修改再这个间隙里边的其他数据

这个情况下可以建设我们再这个并发环境下对数据库的一些修改，或者是增加这部分的一个所造成的阻塞

17. 那复制过程中用的什么文件进行通话呢？

用的是二进制文件，binlog

18. binlog 和 redo log 有什么区别

binlog 是一个二进制文件。它记录的是用户对数据的一个修改的操作。

它更像是MySQL数据上层的一个操作。

那么对于binlog, 刚才我们提到了SBR、RBR之所以有S 有R

是因为我们对binlog这一块它的一个format形式进行的一个设置

当我们使用这个binlog_format这个参数，如果等于row的话，就是我们的一个RBR的一个形式。如果使用statement 就是一个SBR的一个形式，它是一个二进制文件

但是对于redo log 来讲，它是记录的物理页的一个修改，也就是innodb 存储引擎里边的一个日志的一个记录

19. 为什么不考虑用redo log 做主从复制

redo log 它的一个记录方式是以块进行记录的

也就是我们redo log 真正的一个文件记录方式。它的这个块的大小和我们磁盘的扇区大小是一样的，都是512字节。

如果我们采用redo log 进行主从复制的话，那么我们主服务器的redo log 它应该是反应的当前所在服务器的，它的一个扇区大小。每一个扇区，每一个offset偏移量，他做的一个修改。

那对于两台服务器来说，它的一个底层磁盘的一个扇区的一个分发以及每一部分数据。它的一个在磁盘上的一个offset 偏移量肯定是不一样的。所以用redo log 这种没有办法进行主从复制。

20. 从MySQL参数到业务阶段的一个调优这块

我想请问一下这个场景是单机部署还是集群部署

单主多从

服务器选型这块需要去考虑吗？

就比如说16核和256G内存 1 T SSD

mysql 版本上有要求吗？

可以按照你的规划进行选择。

那整体场景，我描述一下。

整体场景是一个单主多从的MySQL架构

然后我会采用RC加RBR的一个形式

选取的版本会采用比较主流的5.6版本或者5.7版本

底层的innodb 存储引擎，会使用底层的innodb 存储引擎

那服务器16核 256G内存 和 1T的固态硬盘

首先我会把MySQL的安装包部署到服务器，然后对MySQL进行第一步的参数调优和配置

首先我会对我们的一个MySQL的read IO 和 Write IO进行一个修改。

因为MySQL里面后台有四个线程。master线程，io线程, purge 线程，page cleaner 线程。

io线程分为read IO和write IO。

其中io线程它是对于我们这个磁盘，还是我们的缓冲区进行一个读写的。

对于它的一个压力是非常大的。默认它的一个参数配置是读写线程分别为4个。那么对于我们16核服务器。

它的一个CPU核数比较高，建议将io的读写线程分别调到六个或七个线程。也尽最大的可能性去利用这个核心资源。

那么接下来，我会考虑内存资源的一个利用率问题。就是刚才我们所聊到的一个缓冲池innodb 的一个buffer pool size 一个大小。因为它默认情况下，它的大小太小了。它默认情况下是128M。这是必须要进行调整的。

不过这一步参数具体大小，我们调整为多少。还没有办法在这个阶段明确。需要对我们真正的一个业务数据的一个存储量进行一个估算。

把我们缓冲池的值设置为与我们业务数据量的这个值是一样的。这个参数在这个业务测试阶段还会要进行调整。

这个时候我们可以先大概256G的一个内存

我们可以先将其设置为几十个G，我认为就可以到时候再进行一个详细的调整，不够的话增加

那么第三个参数

由于innodb 它的一个缓冲池，他除了可以设置大小以外，它还可以去设置多个实例。也就是说如果我们有256G的内存。假如说我们将这256G内存都给了innodb, 作为它的一个缓冲池大小。那么对于这么一大块内存管理，我们需要进行一个多实例的负载。也就是在innodb 存储引擎里面还有一个参数叫innodb buffer pool instance. 它的默认值是一。也就是说我们设置的这个缓冲池的大小，他只有一块，它没有做负载。

这个时候呢。我们可以根据我们最终配置的缓冲池的一个大小，进行它的一个多实例的划分。

比如说我们如果最终定64G的整体的一个缓冲区大小，我们为可以调整为两个或者四个，作为这个缓冲池的实例做这个负载均衡。

然后接下来。需要对我们MySQL里面存储的表的一个表空间文件参数进行一个配置。innodb_file_per_table这个参数。默认情况下，这个参数是关闭的。

这是为了干什么呢

是为了使我们每一张表都能够生成自己的一个表空间文件。

如果不打开这个的话，默认情况下整个DB所有表，它的这个数据表空间都会存放在一张共享表空间里边，那么这样共享表空间文件太大，它不利于表空间文件的一个维护，而且对于表空间文件里，它除了存放表的一些数据，他还会存放表的一些索引。

那么我们在对索引进行初次提取的时候，尤其是带对我们的这个B+树，然后呢，找到这个内存页的偏移量。这部分提取的时候文件越大，它的性能越低。

然后下一个参数也是配合我们表空间文件，这个参数进行了一个配合。

虽然我们减少了整体表空间文件的大小，也就是那个共享表空间。但是除了数据索引插入，插入索引缓冲，以及其他的这个数据，回滚段数据、事务数据、二次写缓冲数据。这些还是依然保存到共享表空间文件的。

所以说对于整个DB里边，我们仅仅是将我们数据和插入缓冲。这些比较重要的数据放入到了每一个表下边的这个表空间文件。

而对于其他的数据，像回滚段它会比较大，都还是放到共享表空间文件，这个文件还是IO压力很大。

所以我们还要进一步去把它的一个压力进行一个减小

那么这个共享表空间文件进行一个多磁盘负载。

因为刚才你提到我们的环境里边是一个1T的固态硬盘

我建议将这1T的固态硬盘进行一个磁盘分区

然后用innodb 里边的一个data file pass 进行一个多目录的一个指定

也就是将我们共享的表空间文件，把它同时负载到多个磁盘上

其实这也是为了保证一个高可用性

因为我们也提到了这个需求是单主多从

那么对于单主多从这一块考虑RC加RBR形式

然后开启Id自增的一个参数

auto lock mode 默认为1，我们调整到2.

以互斥量的形式进行一个id分发。提高我们将来在数据进行插入的时候，它的一个插入速度

接下来就是一些，我们对于commit

我们插入过程中commit 一些磁盘策略

那默认它是1，然后每次commit 都会进行一次

如果业务需求对于这部分**fail cognizant**持久化

如果能够容忍丢失一秒的数据的话，我建议可以把它设置为0.

然后每秒我们由master线程进行一个磁盘数据，最终的一个持久化的一个落地。

然后就是接下来，关于我们主从复制里边
对于bin log这一块还是需要调整

因为默认block 它是关闭的

立马就要把我们主服务的binlog进行一个开启

除此之外，binlog 它是刷新到磁盘之前也是有缓冲区的，默认是32kb.

这个暂时可以不修改，因为到这个业务阶段的时候，我们根据我们innodb的status进行两个参数的查询

如果这两个参数查询能够显示出来，完全使用的是32kb的缓冲区，没有经历过disk

也就是我们磁盘的一个binlog的一个数据的IO，那么这个32kb完全够用。

那么对于我们binlog它的一个磁盘刷新，也跟我们的这个重做日志的一个磁盘刷新时一样的。

它是从默认的0，可以调整为1.

避免我们异常宕机导致的bin log 缓存的一个丢失

最后呢。我们需要对于我们的主从关系进行一个配置

其他的从服务器作为主服务器的一个slave

并且这一点可以从服务器这一块时不需要开启bin log的啊

这是我们初始部署对于MySQL一些硬性的一些参数必须要进行的一个调配

那下一个阶段，就是我们真正的一个业务开发阶段

这个阶段调优开始呢？

我会从一个需求开始设计表的表的结构设计

控制单行的一个信息大小

去避免我们B+树的一个删除性的降低

然后根据业务需求进行索引设计

大表可以进行分区，分区字段如何选择

包括开启我们5.6 5.7 版本的一个MRR

必要时，我们可以对单表进行一个水平或者垂直的一个拆分

如果到这一步还没有办法的话，我们就需要进行考虑一些数据备份

那么数据备份的话，现在市场上用的比较多的就是我们的extra backup 这个工具

如果备份还不行，没有办法，单主的话，肯定实现不了。我们就需要使用多主。

然后每一个主服务器都会有从服务器，然后采用一致性哈希也好，或者是根据业务去选取我们的字段，把我们的数据，负载到不同的这个主服务器上。

那么进入下一个阶段就是我们最终的一个压测阶段。

压测阶段一定要开启一个慢查询日志，也就是我们一个long query time.

这个慢查询日志，它在生产上是建议关闭的

因为这部分，它会对每一个SQL 它的一个耗时进行一个统计，这部分比较消耗性能

在压测阶段没有关系，我们可以找到耗时比较长的一些SQL

压测阶段，我们之前还提到了一个内存利用率的一个问题。就是我们说的缓冲池的大小。

当我们压测过程中，我们通过show global status 我们可以查看innodb 的一个读取情况。然后我们看这个缓冲池，它的一个磁盘读取次数，用这些数据去计算一个缓冲池的命中率。一般情况下最优的一个缓冲值大小的设计，它的命中率是99%，如果低于99%的话，我们需要适当的去调大缓冲池的一个大小，直到我们缓冲池的命中率高于99%。

这样的话，我们基本上99%的数据都会利用到缓冲池。而缓冲就是我们的内存处理，它的速度会非常快。

另外还有就是，也就是我们所说的对于我们binlog的一个缓冲区大小的一个调配

我们需要去看一下binlog cache size 32kb 下

对于binlog cache user 和 binlog disc user的这两个参数

它会记录dick user 就是磁盘使用次数

cache user就是缓冲使用次数

如果我们disk 它的使用次数比较小  比如说小于 10% 那么我们认为32kb 大小的这个binlog 的一个擦车 size 就没有必要去调整，用32kb 就可以

如果这部分数据比较多，比如说占了30%、40%、50%

这个时候我们就需要考虑对我们的binlog cache size ，32kb 默认情况下进行一个增加，乘以2，增加到64kb, 再次进行一个压测。

最好是让它能够保证，我们disk user 的次数要占10%左右就可以了。

这一系列的调优下来，就是在我们上线之前，这一块的话应该能够保证一个非常不错的DB性能

21. synchronized和lock的区别

因为 synchronized和lock都是给我们开发者提供的两种加锁方式。

而这两种加锁方式呢，其实是应对不同的加锁场景，所以对于速度上来说，我觉得没有场景的一个加持，没有办法说哪一个更快，哪个更慢


22. jvm 整体架构的原理


23. 使用spring cloud 实现 具体说一下

配置中心 git

24. G group  TCP 加UCP 数据不一致

25. 如何保证数据库和缓存双写一致性？

https://juejin.cn/post/6964531365643550751

https://zhuanlan.zhihu.com/p/490902522



# Note
学习笔记


Lock 会有放弃加锁的逻辑
Synchronized 没有

tryLock


Condition 可以有多个

可重入：同一线程对某一锁多次加锁不会产生死锁
例如:

```java
lock.lock();
lock.lock();
System.out.println(Thread.currentThread().getName());
lock.unlock();
lock.unlock();
```

如果不可重入，这段代码就是自己和自己死锁了。


当程序未正确同步时，就可能会存在数据竞争。Java 内存模型规范对数据竞争的定 义如下。 

⚫ 在一个线程中写一个变量，

⚫ 在另一个线程读同一个变量， 

⚫ 而且写和读没有通过同步来排序。 

顺序一致性内存模型有两大特性

⚫ 一个线程中的所有操作必须按照程序的顺序来执行。 

⚫ （不管程序是否同步）所有线程都只能看到一个单一的操作执行顺序。在顺序一致性内存模型中，每个操作都必须原子执行且立刻对所有线程可见。

![image](https://user-images.githubusercontent.com/44089237/180330592-997de857-7ecc-426d-a3ef-478e292e4011.png)


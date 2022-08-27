## 如果我们在后台修改了商品的价格，搜索页面和商品详情页显示的依然是旧的价格，这样显然不对。该如何解决？

商品服务对商品增删改以后，无需去操作索引库和静态页面，
**只需向MQ发送一条消息（比如包含商品id的消息），也不关心消息被谁接收**。
**搜索服务和静态页面服务监听MQ，接收消息**，
**然后分别去处理索引库和静态页面**（根据商品id去更新索引库和商品详情静态页面）。

# 什么是消息队列

MQ全称为Message Queue，即消息队列。“消息队列”是在消息的传输过程中保存消息的容器。

它是典型的：生产者、消费者模型。生产者不断向消息队列中生产消息，消费者不断的从队列中获取消息。
因为消息的生产和消费都是异步的，而且只关心消息的发送和接收，没有业务逻辑的侵入，
这样就实现了生产者和消费者的解耦。

# 消息队列通常有如下应用场景

1、任务异步处理

通过使用消息队列，我们可以异步处理请求，从而缓解系统的压力。将不需要同步处理的并且耗时长的操作由消息队列通知消息接收方进行异步处理。减少了应用程序的响应时间。

2、应用程序解耦合

MQ相当于一个中介，生产方通过MQ与消费方交互，它将应用程序进行解耦合。

# AMQP和JMS

Advanced Message Queuing Protocol(AMQP)  \ (Java Message Service) JMS


两者间的区别和联系

* JMS是定义了统一的接口，来对消息操作进行统一；AMQP是通过规定协议来统一数据交互的格式
* JMS限定了必须使用Java语言；AMQP只是协议，不规定实现方式，因此是跨语言的。
* JMS规定了两种消息模型；而AMQP的消息模型更加丰富

# 常见MQ产品

* ActiveMQ：基于JMS
* RabbitMQ：基于AMQP协议，erlang语言开发，稳定性好
* RocketMQ：基于JMS，阿里巴巴产品，目前交由Apache基金会
* Kafka：分布式消息系统，高吞吐量

# RabbitMQ的工作原理

<img alt=""  src="https://img-blog.csdnimg.cn/20190610225910220.png">


组成部分说明：

* Broker：消息队列服务进程，此进程包括两个部分：Exchange和Queue
* Exchange：消息队列交换机，按一定的规则将消息路由转发到某个队列，对消息进行过虑。
* Queue：消息队列，存储消息的队列，消息到达队列并转发给指定的
* Producer：消息生产者，即生产方客户端，生产方客户端将消息发送
* Consumer：消息消费者，即消费方客户端，接收MQ转发的消息。

生产者发送消息流程：

1. 生产者和Broker建立TCP连接。

2. 生产者和Broker建立通道。

3. 生产者通过通道消息发送给Broker，由Exchange将消息进行转发。

4. Exchange将消息转发到指定的Queue（队列）

消费者接收消息流程：

1. 消费者和Broker建立TCP连接

2. 消费者和Broker建立通道

3. 消费者监听指定的Queue（队列）

4. 当有消息到达Queue时Broker默认将消息推送给消费者。

5. 消费者接收到消息。

6. ack回复

## 生产消费者模型

在上图的模型中，有以下概念：

* P：生产者，也就是要发送消息的程序

* C：消费者：消息的接受者，会一直等待消息到来。

* queue：消息队列，图中红色部分。可以缓存消息；生产者向其中投递消息，消费者从其中取出消息。

https://blog.csdn.net/kavito/article/details/91403659

安装

https://www.rabbitmq.com/install-windows.html#installer

【学相伴】狂神说 RabbitMQ笔记（简单使用RabbitMQ）

https://blog.csdn.net/qq_44716544/article/details/120100456

RabbitMQ的六种工作模式

https://www.cnblogs.com/Jeely/p/10784013.html

聊一聊RabbitMQ六种工作模式与应用场景

https://blog.csdn.net/weixin_46785144/article/details/120399915
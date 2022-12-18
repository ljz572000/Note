# Overview

This page is an overview of Kubernetes.

Kubernetes is a portable, extensible, open source platform for managing containerized workloads and services, that facilitates both declarative configuration and automation.

- portable adj. 便携式的，轻便的；可移植的，可在不同计算机上使用的；（变更工作或情景时）可转移的，可随带的

Kubernetes 是一个可移植、可扩展的开源平台，用于管理容器化的工作负载和服务，方便进行声明式配置和自动化。

It has a large, rapidly growing ecosystem. 
 
Kubernetes services, support, and tools are widely available.

Kubernetes 拥有一个庞大且快速增长的生态系统，其服务、支持和工具的使用范围广泛。

The name Kubernetes originates from Greek, meaning helmsman or pilot.

Kubernetes 这个名字源于希腊语，意为“舵手”或“飞行员”。

K8s as an abbreviation results from counting the eight letters between the "K" and the "s".

- abbreviation n. 缩略词，缩写形式；缩略，缩写

Google open-sourced the Kubernetes project in 2014. 

Kubernetes combines over 15 years of Google's experience running production workloads at scale with best-of-breed ideas and practices from the community.

- best-of-breed 单项优势最佳组合

## Going back in time 时光回溯

Let's take a look at why Kubernetes is so useful by going back in time.

让我们回顾一下为何 Kubernetes 能够裨益四方。

**Traditional deployment era**: Early on, organizations ran applications on physical servers. 

- Early on 在早期；从事，经营；继续下去

早期，各个组织是在物理服务器上运行应用程序。

There was no way to define resource boundaries for applications in a physical server, and this caused resource allocation issues.

- allocation  n. 配给量，划拨款，份额；分配，分派

由于无法限制在物理服务器中运行的应用程序资源使用，因此会导致资源分配问题。 

For example, if multiple applications run on a physical server, there can be instances where one application would take up most of the resources, and as a result, the other applications would underperform.

- take up 拿起；开始从事；占据（时间，地方）
- unberperform vi.表现不佳；工作不如预期（或同行）

A solution for this would be to run each application on a different physical server.

But this did not scale as resources were underutilized, and it was expensive for organizations to maintain many physical servers.

- underutilize vt. 未充分使用

但是当某个应用程式资源利用率不高时，剩余资源无法被分配给其他应用程式， 而且维护许多物理服务器的成本很高。

**Virtualized deployment era**: As a solution, virtualization was introduced. 

It allows you to run multiple Virtual Machines(VMs) on a single physical server's CPU.

Virtualization allows applications to be isolated between VMs and provides a level of security as the information of one application cannot be freely accessed by another application.

Virtualization allows better utilization of resources in a physical server and allows better scalability because an application can be added or updated easily, reduces hardware costs, and much more.

With virtualization you can present a set of physical resources as a cluster of disposable virtual machines.


- disposable adj. 一次性的，用完即丢弃的；可支配的，可自由使用的；（人，观点）可有可无的，可轻易放弃的

通过虚拟化，你可以将一组物理资源呈现为可丢弃的虚拟机集群。

Each VM is a full machine running all the components, including its own operating system, on top of the virtualized hardware.

**Container deployment era**: Containers are similar to VMs, but they have relaxed isolation properties to share the Operating System(OS) among the applications.

Therefore, containers are considered lightweight. 

Similar to a VM, a container has its own filesystem, share fo CPU, memory, process space, and more. 

As they are decoupled from the underlying infrastructure, they are portable across clouds and OS distributions.

Containers have become popular because they provide extra benefits, such as:

- Agile application creation and deployment: increased ease and efficiency fo container image creation compared to VM image use.
  - agile adj.（动作）敏捷的，灵活的；（思维）机敏的，机灵的；表示项目管理方法的
- Continuous development, integration, and deployment: provides for reliable and frequent container image build and deployment with quick and efficient rollbacks(due to image immutability).
  - immutability n.不变；永恒性；不变性
- Dev and Ops separation of concerns: create application container images as build / release time rather than deployment time,  thereby decoupling applications from infrastructure.
- 关注开发与运维的分离：在构建、发布时创建应用程序容器镜像，而不是在部署时， 从而将应用程序与基础架构分离。
- Observability: not only surfaces OS-level information and metrics, but also application health and other signals.
- Environmental consistency across development, testing, and production: Runs the same on a laptop as it does in the cloud.
  - consistency n. 一致性，连贯性；黏稠度，平滑度
- 跨开发、测试和生产的环境一致性：在笔记本计算机上也可以和在云中运行一样的应用程序。
- Cloud and OS distribution portability: Runs on Ubuntu, RHEL, CoreOS, on-premises, on major public clouds, and anywhere else.
- 跨云和操作系统发行版本的可移植性：可在 Ubuntu、RHEL、CoreOS、本地、 Google Kubernetes Engine 和其他任何地方运行。
- Application-centric management: Raises the level of abstraction from running an OS on virtual hardware to running an application on an OS using logical resources.
- 以应用程序为中心的管理：提高抽象级别，从在虚拟硬件上运行 OS 到使用逻辑资源在 OS 上运行应用程序。
- Loosely coupled, distributed, elastic, liberated micro-services: applications are broken into smaller, independent pieces and can be deployed and managed dynamically – not a monolithic stack running on one big single-purpose machine.
- 松散耦合、分布式、弹性、解放的微服务：应用程序被分解成较小的独立部分， 并且可以动态部署和管理 - 而不是在一台大型单机上整体运行。
- Resource isolation: predictable application performance.
- 资源隔离：可预测的应用程序性能。
- Resource utilization: high efficiency and density.
- 资源利用：高效率和高密度。

## Why you need Kubernetes and what it can do 

Containers are a good way to bundle and run your applications. 

In a production environment, you need to manage the containers that run the applications and ensure that there is no downtime.

-  downtime 停机时间

For example, if a container goes down, another container needs to start. Wouldn't it be easier if this behavior was handled by a system?

That's how Kubernetes comes to the rescue! 

Kubernetes provides you with a framework to run distributed systems resiliently. 

- resiliently adv. 有恢复力地；有弹性地

It takes care of scaling and failover for your application, provides deployment patterns, and more. 

- failover 故障切换

Kubernetes 会满足你的扩展要求、故障转移你的应用、提供部署模式等。

For example: Kubernetes can easily manage a `canary` deployment for your system.

Kubernetes provides you with:

- **Service discovery and load balancing** 
  - `Kubernetes` can expose a container using the DNS name or using their own IP address.  If traffic to a container is high, `Kubernetes` is able to load balance and distribute the network traffic so that the deployment is stable.
- 服务发现和负载均衡
  - Kubernetes 可以使用 DNS 名称或自己的 IP 地址来暴露容器。 如果进入容器的流量很大， Kubernetes 可以负载均衡并分配网络流量，从而使部署稳定。
- **Storage orchestration**
- 存储编排
  - Kubernetes allows you to automatically mount a storage system of your choice, such as local storages, public cloud providers, and more.
  - Kubernetes 允许你自动挂载你选择的存储系统，例如本地存储、公共云提供商等。
- Automated rollouts and rollbacks
- 自动部署和回滚
  - You can describe the desired state for your deployed containers using Kubernetes, and it can change the actual state to the desired state at a controlled rate. For example, you can automate Kubernetes to create new containers for your deployment, remove existing containers and adopt all their resources to the new container.
  - 你可以使用 Kubernetes 描述已部署容器的所需状态， 它可以以受控的速率将实际状态更改为期望状态。 例如，你可以自动化 Kubernetes 来为你的部署创建新容器， 删除现有容器并将它们的所有资源用于新容器。
- Automatic bin packing
- 自动完成装箱计算
  - You provide Kubernetes with a cluster of nodes that it can use to run containerized tasks. You tell Kubernetes how much CPU and memory (RAM) each container needs. Kubernetes can fit containers onto your nodes to make the best use of your resources.
  - 你为 Kubernetes 提供许多节点组成的集群，在这个集群上运行容器化的任务。 你告诉 Kubernetes 每个容器需要多少 CPU 和内存 (RAM)。 Kubernetes 可以将这些容器按实际情况调度到你的节点上，以最佳方式利用你的资源。
- Self-healing
- 自我修复
  - Kubernetes restarts containers that fail, replaces containers, kills containers that don't respond to your user-defined health check, and doesn't advertise them to clients until they are ready to serve.
  - Kubernetes 将重新启动失败的容器、替换容器、杀死不响应用户定义的运行状况检查的容器， 并且在准备好服务之前不将其通告给客户端。
- Secret and configuration management
- 密钥与配置管理
  - Kubernetes lets you store and manage sensitive information, such as passwords, OAuth tokens, and SSH keys. You can deploy and update secrets and application configuration without rebuilding your container images, and without exposing secrets in your stack configuration.
  - Kubernetes 允许你存储和管理敏感信息，例如密码、OAuth 令牌和 ssh 密钥。 你可以在不重建容器镜像的情况下部署和更新密钥和应用程序配置，也无需在堆栈配置中暴露密钥。

## What Kubernetes is not

Kubernetes is not a traditional, all-inclusive PaaS (Platform as a Service) system. 

Since Kubernetes operates at the container level rather than at the hardware level, it provides some generally applicable features common to PaaS offerings, such as deployment, scaling, load balancing, and lets users integrate their logging, monitoring, and alerting solutions.

However, Kubernetes is not monolithic, and these default solutions are optional and pluggable.

Kubernetes provides the building blocks for building developer platforms, but preserves user choice and flexibility where it is important.

Kubernetes:

- Does not limit the types of applications supported. Kubernetes aims to support an extremely diverse variety of workloads, including stateless, stateful, and data-processing workloads. If an application can run in a container, it should run great on Kubernetes.
- Does not deploy source code and does not build your application. Continuous Integration, Delivery, and Deployment (CI/CD) workflows are determined by organization cultures and preferences as well as technical requirements.
- Does not provide application-level services, such as middleware (for example, message buses), data-processing frameworks (for example, Spark), databases (for example, MySQL), caches, nor cluster storage systems (for example, Ceph) as built-in services. Such components can run on Kubernetes, and/or can be accessed by applications running on Kubernetes through portable mechanisms, such as the Open Service Broker.
- Does not dictate logging, monitoring, or alerting solutions. It provides some integrations as proof of concept, and mechanisms to collect and export metrics.
- Does not provide nor mandate a configuration language/system (for example, Jsonnet). It provides a declarative API that may be targeted by arbitrary forms of declarative specifications.
- Does not provide nor adopt any comprehensive machine configuration, maintenance, management, or self-healing systems.
- Additionally, Kubernetes is not a mere orchestration system. In fact, it eliminates the need for orchestration. The technical definition of orchestration is execution of a defined workflow: first do A, then B, then C. In contrast, Kubernetes comprises a set of independent, composable control processes that continuously drive the current state towards the provided desired state. It shouldn't matter how you get from A to C. Centralized control is also not required. This results in a system that is easier to use and more powerful, robust, resilient, and extensible.
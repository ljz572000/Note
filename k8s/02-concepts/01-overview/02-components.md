Kubernetes Components

When you deploy Kubernetes, you get a cluster.

当你部署完 Kubernetes，便拥有了一个完整的集群。

A Kubernetes cluster consists of a set of worker machines, called nodes, that run containerized applications. 

一组工作机器，称为 节点， 会运行容器化应用程序。

Every cluster has at least one worker node.

每个集群至少有一个工作节点。

The worker node(s) host the Pods that are the components of the application workload.

工作节点会托管 Pod ，而 Pod 就是作为应用负载的组件。

The control plane manages the worker nodes and the Pods in the cluster. 

控制平面管理集群中的工作节点和 Pod。 

In production environments, the control plane usually runs across multiple computers and a cluster usually runs multiple nodes, providing fault-tolerance and high availability.

在生产环境中，控制平面通常跨多台计算机运行， 一个集群通常运行多个节点，提供容错性和高可用性。

- fault-tolerance 容错容错性

This document outlines the various components you need to have for a complete and working Kubernetes cluster.

本文档概述了一个正常运行的 Kubernetes 集群所需的各种组件。

![The components of a Kubernetes cluster](https://d33wubrfki0l68.cloudfront.net/2475489eaf20163ec0f54ddc1d92aa8d4c87c96b/e7c81/images/docs/components-of-kubernetes.svg)

The components of a Kubernetes cluster

# Control Plane Components

The control plane's components make global decisions about the cluster (for example, scheduling), as well as detecting and responding to cluster events (for example, starting up a new pod when a deployment's replicas field is unsatisfied).

控制平面组件会为集群做出全局决策，比如资源的调度。 以及检测和响应集群事件，例如当不满足部署的 replicas 字段时， 要启动新的 pod）。

Control plane components can be run on any machine in the cluster. 

However, for simplicity, set up scripts typically start all control plane components on the same machine, and do not run user containers on this machine. 

然而，为了简单起见，设置脚本通常会在同一个计算机上启动所有控制平面组件， 并且不会在此计算机上运行用户容器。 

- 为简单起见

See [Creating Highly Available clusters with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/) for an example control plane setup that runs across multiple machines.

## kube-apiserver 

The API server is a component of the Kubernetes control plane that exposes the Kubernetes API. 

API 服务器是 Kubernetes 控制平面的组件， 该组件负责公开了 Kubernetes API，负责处理接受请求的工作。 

The API server is the front end for the Kubernetes control plane.

API 服务器是 Kubernetes 控制平面的前端。

The main implementation of a Kubernetes API server is kube-apiserver.

Kubernetes API 服务器的主要实现是 kube-apiserver。

kube-apiserver is designed to scale horizontally—that is, it scales by deploying more instances.

kube-apiserver 设计上考虑了水平扩缩，也就是说，它可通过部署多个实例来进行扩缩。

You can run several instances of kube-apiserver and balance traffic between those instances.

你可以运行 kube-apiserver 的多个实例，并在这些实例之间平衡流量。

## etcd 

Consistent and highly-available key value store used as Kubernetes' backing store for all cluster data.

一致且高度可用的键值存储，用作 Kubernetes 的所有集群数据的后台数据库。

If your Kubernetes cluster uses `etcd` as its backing store, make sure you have a back up plan for those data.

如果你的 Kubernetes 集群使用 etcd 作为其后台数据库， 请确保你针对这些数据有一份 备份计划。

You can find in-depth information about etcd in the official [documentation](https://etcd.io/docs/).

## kube-scheduler 

Control plane component that watches for newly created Pods with no assigned node, and selects a node for them to run on.

kube-scheduler 是控制平面的组件， 负责监视新创建的、未指定运行节点（node）的 Pods， 并选择节点来让 Pod 在上面运行。

Factors taken into account for scheduling decisions include: individual and collective resource requirements, hardware/software/policy constraints, affinity and anti-affinity specifications, data locality, inter-workload interference, and deadlines.

调度决策考虑的因素包括单个 Pod 及 Pods 集合的资源需求、软硬件及策略约束、 亲和性及反亲和性规范、数据位置、工作负载间的干扰及最后时限。

## `kube-controller-manager` 

Control plane component that runs controller processes.

`kube-controller-manager` 是控制平面的组件， 负责运行控制器进程。

Logically, each controller is a separate process, but to reduce complexity, they are all compiled into a single binary and run in a single process.

从逻辑上讲， 每个控制器都是一个单独的进程， 但是为了降低复杂性，它们都被编译到同一个可执行文件，并在同一个进程中运行。

Some types of these controllers are:

- Node controller: Responsible for noticing and responding when nodes go down.
- 节点控制器（Node Controller）：负责在节点出现故障时进行通知和响应
- Job controller: Watches for Job objects that represent one-off tasks, then creates Pods to run those tasks to completion.
- 任务控制器（Job Controller）：监测代表一次性任务的 Job 对象，然后创建 Pods 来运行这些任务直至完成
- EndpointSlice controller: Populates EndpointSlice objects (to provide a link between Services and Pods).
- 端点分片控制器（EndpointSlice controller）：填充端点分片（EndpointSlice）对象（以提供 Service 和 Pod 之间的链接）。
- ServiceAccount controller: Create default ServiceAccounts for new namespaces.
- 服务账号控制器（ServiceAccount controller）：为新的命名空间创建默认的服务账号（ServiceAccount）。

## `cloud-controller-manager`

A Kubernetes control plane component that embeds cloud-specific control logic. 

一个 Kubernetes 控制平面组件， 嵌入了特定于云平台的控制逻辑。

The cloud controller manager lets you link your cluster into your cloud provider's API, and separates out the components that interact with that cloud platform from components that only interact with your cluster.

云控制器管理器（Cloud Controller Manager）允许你将你的集群连接到云提供商的 API 之上， 并将与该云平台交互的组件同与你的集群交互的组件分离开来。

The `cloud-controller-manager` only runs controllers that are specific to your cloud provider. 

`cloud-controller-manager` 仅运行特定于云平台的控制器。

If you are running Kubernetes on your own premises, or in a learning environment inside your own PC, the cluster does not have a cloud controller manager.

因此如果你在自己的环境中运行 Kubernetes，或者在本地计算机中运行学习环境， 所部署的集群不需要有云控制器管理器。


As with the `kube-controller-manager`, the `cloud-controller-manager` combines several logically independent control loops into a single binary that you run as a single process. 

与 `kube-controller-manager` 类似，`cloud-controller-manager` 将若干逻辑上独立的控制回路组合到同一个可执行文件中， 供你以同一进程的方式运行。

You can scale horizontally (run more than one copy) to improve performance or to help tolerate failures.

你可以对其执行水平扩容（运行不止一个副本）以提升性能或者增强容错能力。

The following controllers can have cloud provider dependencies:

下面的控制器都包含对云平台驱动的依赖：

- Node controller: For checking the cloud provider to determine if a node has been deleted in the cloud after it stops responding
- Route controller: For setting up routes in the underlying cloud infrastructure
- Service controller: For creating, updating and deleting cloud provider load balancers

- 节点控制器（Node Controller）：用于在节点终止响应后检查云提供商以确定节点是否已被删除
- 路由控制器（Route Controller）：用于在底层云基础架构中设置路由
- 服务控制器（Service Controller）：用于创建、更新和删除云提供商负载均衡器

# Node Components 

`Node components` run on every node, maintaining running pods and providing the Kubernetes runtime environment

节点组件会在每个节点上运行，负责维护运行的 Pod 并提供 Kubernetes 运行环境。

## kubelet 

An agent that runs on each node in the cluster. 

kubelet 会在集群中每个节点（node）上运行。

It makes sure that containers are running in a `Pod`.

它保证容器（containers）都运行在 Pod 中。


The kubelet takes a set of `PodSpecs` that are provided through various mechanisms and ensures that the containers described in those `PodSpecs` are running and healthy. 

kubelet 接收一组通过各类机制提供给它的 PodSpecs， 确保这些 PodSpecs 中描述的容器处于运行状态且健康。 

The kubelet doesn't manage containers which were not created by Kubernetes.

kubelet 不会管理不是由 Kubernetes 创建的容器。

## kube-proxy  

`kube-proxy` is a network proxy that runs on each node in your cluster, implementing part of the `Kubernetes Service `concept.

kube-proxy 是集群中每个节点（node）上所运行的网络代理， 实现 Kubernetes 服务（Service） 概念的一部分。

kube-proxy maintains network rules on nodes. These network rules allow network communication to your Pods from network sessions inside or outside of your cluster.

kube-proxy 维护节点上的一些网络规则， 这些网络规则会允许从集群内部或外部的网络会话与 Pod 进行网络通信。

kube-proxy uses the operating system packet filtering layer if there is one and it's available. Otherwise, kube-proxy forwards the traffic itself.

如果操作系统提供了可用的数据包过滤层，则 kube-proxy 会通过它来实现网络规则。 否则，kube-proxy 仅做流量转发。

## Container runtime 

The container runtime is the software that is responsible for running containers.

容器运行环境是负责运行容器的软件。

Kubernetes supports container runtimes such as `containerd`, `CRI-O`, and any other implementation of the `Kubernetes CRI` (Container Runtime Interface).

Kubernetes 支持许多容器运行环境，例如 containerd、 CRI-O 以及 Kubernetes CRI (容器运行环境接口) 的其他任何实现。

# Addons  插件

Addons use Kubernetes resources (`DaemonSet`, `Deployment`, etc) to implement cluster features. 

插件使用 Kubernetes 资源（DaemonSet、 Deployment 等）实现集群功能。

Because these are providing cluster-level features, namespaced resources for addons belong within the `kube-system` namespace.

因为这些插件提供集群级别的功能，插件中命名空间域的资源属于 kube-system 命名空间。

Selected addons are described below; for an extended list of available addons, please see Addons.

下面描述众多插件中的几种。有关可用插件的完整列表，请参见 插件（Addons）。

## DNS 

While the other addons are not strictly required, all Kubernetes clusters should have cluster DNS, as many examples rely on it.

尽管其他插件都并非严格意义上的必需组件，但几乎所有 Kubernetes 集群都应该有集群 DNS， 因为很多示例都需要 DNS 服务。

Cluster `DNS` is a `DNS` server, in addition to the other `DNS` server(s) in your environment, which serves DNS records for Kubernetes services.

集群 DNS 是一个 DNS 服务器，和环境中的其他 DNS 服务器一起工作，它为 Kubernetes 服务提供 DNS 记录。

Containers started by Kubernetes automatically include this DNS server in their DNS searches.

Kubernetes 启动的容器自动将此 DNS 服务器包含在其 DNS 搜索列表中。

## Web UI (Dashboard)

Dashboard is a general purpose, web-based UI for Kubernetes clusters. 

It allows users to manage and troubleshoot applications running in the cluster, as well as the cluster itself.

- troubleshoot v.解决重大问题；排除……的故障

## Container Resource Monitoring

Container Resource Monitoring records generic time-series metrics about containers in a central database, and provides a UI for browsing that data.

- generic adj. 一般的，通用的；（货物，尤指药品）没有牌子的，无商标的；属的，类的；（生）属的，类的

容器资源监控 将关于容器的一些常见的时间序列度量值保存到一个集中的数据库中， 并提供浏览这些数据的界面。

## Cluster-level Logging 集群层面日志

A cluster-level logging mechanism is responsible for saving container logs to a central log store with search/browsing interface.

集群层面日志机制负责将容器的日志数据保存到一个集中的日志存储中， 这种集中日志存储提供搜索和浏览接口。
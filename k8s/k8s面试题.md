# 什么是ETCD

Etcd是用Go编程语言编写的，是一个分布式键值存储，用于协调分布式工作。因此，Etcd存储Kubernetes集群的配置数据，表示在任何给定时间点的集群状态。

# Node and Pod

**Node** is simple server a physical or virtual machine

**Pod**

- Smallest unit of k8s
- Abstraction over container(Docker container)
- Usually 1 application per Pod
- Each Pod gets its own IP address
- New IP address on re-creation

# Service and Ingress

**Service** 

pods communicate with each other using a service 

- permanent IP address
- lifecycle of Pod and Service NOT connected

**Ingress**

so instead of service the request goes first to ingress and it does the forwarding then to the service 

**ConfigMap**

- external configuration of your application

**Secret**

- used to store secret data
- base64 encoded

**Volumes**

which is data storage 

# Deployment

- blueprint for my-app pods

- you create Deployments

- abstraction of Pods

# Worker machine in K8s cluster

- each Node has multiple Pods on it
- 3 processes must be installed on every Node
  - Kubelet
  - Kube Proxy
  - Container runtime
- Worker Nodes do the actual work

# 什么是Kubelet？

这是一个代理服务，它在每个节点上运行，并使从服务器与主服务器通信。因此，Kubelet处理PodSpec中提供给它的容器的描述，并确保PodSpec中描述的容器运行正常。

# 对Kube-proxy有什么了解？

Kube-proxy可以在每个节点上运行，并且可以跨后端网络服务进行简单的TCP / UDP数据包转发。基本上，它是一个网络代理，它反映了每个节点上Kubernetes API中配置的服务。因此，Docker可链接的兼容环境变量提供由代理打开的群集IP和端口。

# 什么是Kubectl？

Kubectl是一个平台，您可以使用该平台将命令传递给集群。因此，它基本上为CLI提供了针对Kubernetes集群运行命令的方法，以及创建和管理Kubernetes组件的各种方法。
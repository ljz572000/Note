Kubernetes runs your workload by placing containers into Pods to run on Nodes.

A node may be a virtual or physical machine, depending on the cluster. 

Each node is managed by the control plane and contains the services necessary to run Pods.

Typically you have several nodes in a cluster; in a learning or resource-limited environment, you might have only one node.

The components on a node include the kubelet, a container runtime, and the kube-proxy.


# Management 

There are two main ways to have Nodes added to the API server:

1. The kubelet on a node self-registers to the control plane
2. You (or another human user) manually add a Node object

After you create a Node object, or the kubelet on a node self-registers, the control plane checks whether the new Node object is valid. 

For example, if you try to create a Node from the following JSON manifest:

```json
{
  "kind": "Node",
  "apiVersion": "v1",
  "metadata": {
    "name": "10.240.79.157",
    "labels": {
      "name": "my-first-k8s-node"
    }
  }
}
```

Kubernetes creates a Node object internally (the representation). 

Kubernetes checks that a kubelet has registered to the API server that matches the metadata.name field of the Node.

If the node is healthy (i.e. all necessary services are running), then it is eligible to run a Pod. 

Otherwise, that node is ignored for any cluster activity until it becomes healthy.

> Note:
> Kubernetes keeps the object for the invalid Node and continues checking to see whether it becomes healthy.
> You, or a controller, must explicitly delete the Node object to stop that health checking.
>

The name of a Node object must be a valid DNS subdomain name.

Node 对象的名称必须是合法的 DNS 子域名。

## Node name uniqueness 

The name identifies a Node. 

Two Nodes cannot have the same name at the same time. 

Kubernetes also assumes that a resource with the same name is the same object.

In case of a Node, it is implicitly assumed that an instance using the same name will have the same state (e.g. network settings, root disk contents) and attributes like node labels. 

就 Node 而言，隐式假定使用相同名称的实例会具有相同的状态（例如网络配置、根磁盘内容） 和类似节点标签这类属性。

This may lead to inconsistencies if an instance was modified without changing its name. 

这可能在节点被更改但其名称未变时导致系统状态不一致。

If the Node needs to be replaced or updated significantly, the existing Node object needs to be removed from API server first and re-added after the update.

如果某个 Node 需要被替换或者大量变更，需要从 API 服务器移除现有的 Node 对象， 之后再在更新之后重新将其加入。

## Self-registration of Nodes 

When the kubelet flag `--register-node` is true (the default), the kubelet will attempt to register itself with the API server. 

This is the preferred pattern, used by most distros.
 
这是首选模式，被绝大多数发行版选用。

For self-registration, the kubelet is started with the following options:

对于自注册模式，kubelet 使用下列参数启动：

- `--kubeconfig` - Path to credentials to authenticate itself to the API server.
- `--kubeconfig` - 用于向 API 服务器执行身份认证所用的凭据的路径。
- `--cloud-provider` - How to talk to a cloud provider to read metadata about itself.
- `--cloud-provider` - 与某云厂商 进行通信以读取与自身相关的元数据的方式。
- `--register-node` - Automatically register with the API server.
- `--register-node` - 自动向 API 服务注册。
- `--register-with-taints` - Register the node with the given list of taints (comma separated `<key>=<value>:<effect>`). No-op if `register-node` is false.
- `--register-with-taints` - 使用所给的污点列表 （逗号分隔的 `<key>=<value>:<effect>`）注册节点。当 `register-node` 为 false 时无效。
- `--node-ip` - IP address of the node.
- `--node-ip` - 节点 IP 地址
- `--node-labels` - Labels to add when registering the node in the cluster (see label restrictions enforced by the NodeRestriction admission plugin).
- `--node-labels` - 在集群中注册节点时要添加的标签。 （参见 NodeRestriction 准入控制插件所实施的标签限制）。
- `--node-status-update-frequency` - Specifies how often kubelet posts its node status to the API server.
- `--node-status-update-frequency` - 指定 kubelet 向 API 服务器发送其节点状态的频率。

When the `Node authorization `mode and `NodeRestriction admission plugin` are enabled, kubelets are only authorized to create/modify their own Node resource.

当 Node 鉴权模式和 NodeRestriction 准入插件被启用后， 仅授权 kubelet 创建/修改自己的 Node 资源。

## Manual Node administration

You can create and modify Node objects using `kubectl`.

你可以使用 kubectl 来创建和修改 Node 对象。

When you want to create Node objects manually, set the kubelet flag `--register-node=false`.

You can modify Node objects regardless of the setting of `--register-node`. For example, you can set labels on an existing Node or mark it unschedulable.

你可以修改 Node 对象（忽略 --register-node 设置）。 例如，你可以修改节点上的标签或并标记其为不可调度。

You can use labels on Nodes in conjunction with node selectors on Pods to control scheduling. 

你可以结合使用 Node 上的标签和 Pod 上的选择算符来控制调度。

For example, you can constrain a Pod to only be eligible to run on a subset of the available nodes.

例如，你可以限制某 Pod 只能在符合要求的节点子集上运行。

Marking a node as unschedulable prevents the scheduler from placing new pods onto that Node but does not affect existing Pods on the Node. 

如果标记节点为不可调度（unschedulable），将阻止新 Pod 调度到该 Node 之上， 但不会影响任何已经在其上的 Pod。

 This is useful as a preparatory step before a node reboot or other maintenance.

 这是重启节点或者执行其他维护操作之前的一个有用的准备步骤。

 - preparatory adj. 预备性的，准备性的；<英>预备的，预料的

To mark a Node unschedulable, run:

```shell
kubectl cordon $NODENAME
```

See Safely Drain a Node for more details.

更多细节参考安全地腾空节点。

- Drain v.（使）排出，滤干；喝光，喝干；使劳累，使疲惫；

> 说明：
>被 DaemonSet 控制器创建的 Pod 能够容忍节点的不可调度属性。 DaemonSet 通常提供节点本地的服务，即使节点上的负载应用已经被腾空， 这些服务也仍需运行在节点之上。

# Node status

A Node's status contains the following information:

- Addresses / 地址
- Conditions / 状况
- Capacity and Allocatable / 容量与可分配
- Info / 信息

You can use `kubectl` to view a Node's status and other details:

```shell
kubectl describe node <insert-node-name-here>
```

Each section of the output is described below.

下面对输出的每个部分进行详细描述。

## Addresses 

The usage of these fields varies depending on your cloud provider or bare metal configuration.

- HostName: The hostname as reported by the node's kernel. Can be overridden via the kubelet `--hostname-override` parameter.
- ExternalIP: Typically the IP address of the node that is externally routable (available from outside the cluster).
- InternalIP: Typically the IP address of the node that is routable only within the cluster.

## Conditions / 状况

The conditions field describes the status of all `Running` nodes. Examples of conditions include:

| Node Condition	      | Description |
| ----------- | ----------- |
| Ready      | 如节点是健康的并已经准备好接收 `Pod` 则为 True；False 表示节点不健康而且不能接收 `Pod`；`Unknown` 表示节点控制器在最近 `node-monitor-grace-period `期间（默认 40 秒）没有收到节点的消息       |
| DiskPressure   | `True` 表示节点存在磁盘空间压力，即磁盘可用量低, 否则为 `False`        |
| MemoryPressure   | `True` 表示节点存在内存压力，即节点内存可用量低，否则为 `False`        |
| PIDPressure   | `True` 表示节点存在进程压力，即节点上进程过多；否则为 `False`        |
| NetworkUnavailable   | `True` 表示节点网络配置不正确；否则为 `False`        |

> 说明：
> 如果使用命令行工具来打印已保护（Cordoned）节点的细节，其中的 Condition 字段可能包括 SchedulingDisabled。SchedulingDisabled 不是 Kubernetes API 中定义的 Condition，被保护起来的节点在其规约中被标记为不可调度（Unschedulable）。
>

In the Kubernetes API, a node's condition is represented as part of the `.status `of the Node resource. 

在 Kubernetes API 中，节点的状况表示节点资源中.status 的一部分。

For example, the following JSON structure describes a healthy node:

例如，以下 JSON 结构描述了一个健康节点：

```json
"conditions": [
  {
    "type": "Ready",
    "status": "True",
    "reason": "KubeletReady",
    "message": "kubelet is posting ready status",
    "lastHeartbeatTime": "2019-06-05T18:38:35Z",
    "lastTransitionTime": "2019-06-05T11:41:27Z"
  }
]
```

If the `status` of the Ready condition remains `Unknown` or `False` for longer than the `pod-eviction-timeout `(an argument passed to the kube-controller-manager), then the node controller triggers API-initiated eviction for all Pods assigned to that node. 

如果 Ready 状况的 `status` 处于 `Unknown` 或者 `False` 状态的时间超过了 `pod-eviction-timeout` 值（一个传递给 kube-controller-manager 的参数），节点控制器会对节点上的所有 Pod 触发 API 发起的驱逐。

The default eviction timeout duration is five minutes. 

默认的逐出超时时长为 5 分钟。

In some cases when the node is unreachable, the API server is unable to communicate with the kubelet on the node.

某些情况下，当节点不可达时，API 服务器不能和其上的 kubelet 通信。

The decision to delete the pods cannot be communicated to the kubelet until communication with the API server is re-established. 

删除 Pod 的决定不能传达给 kubelet，直到它重新建立和 API 服务器的连接为止。

 In the meantime, the pods that are scheduled for deletion may continue to run on the partitioned node.

 与此同时，被计划删除的 Pod 可能会继续在游离的节点上运行。

- partitioned adj. 分割的；分区的；分段的

The node controller does not force delete pods until it is confirmed that they have stopped running in the cluster.

节点控制器在确认 Pod 在集群中已经停止运行前，不会强制删除它们。

You can see the pods that might be running on an unreachable node as being in the `Terminating` or `Unknown` state. 

你可以看到可能在这些无法访问的节点上运行的 Pod 处于 `Terminating` 或者 `Unknown` 状态。

In cases where Kubernetes cannot deduce from the underlying infrastructure if a node has permanently left a cluster, the cluster administrator may need to delete the node object by hand. 

如果 kubernetes 不能基于下层基础设施推断出某节点是否已经永久离开了集群， 集群管理员可能需要手动删除该节点对象。 

- deduce v. 推断，演绎；<古>对……追本溯源
- adj. 根本的，潜在的；表面下的，下层的；优先的；（数量或水平）实际的

Deleting the node object from Kubernetes causes all the `Pod` objects running on the node to be deleted from the API server and frees up their names.

从 Kubernetes 删除节点对象将导致 API 服务器删除节点上所有运行的 Pod 对象并释放它们的名字。

When problems occur on nodes, the Kubernetes control plane automatically creates `taints` that match the conditions affecting the node.

当节点上出现问题时，Kubernetes 控制面会自动创建与影响节点的状况对应的 污点。 

 The scheduler takes the Node's taints into consideration when assigning a Pod to a Node.

调度器在将 Pod 指派到某 Node 时会考虑 Node 上的污点设置。

- take into consideration 考虑到顾及

Pods can also have tolerations that let them run on a Node even though it has a specific taint.

Pod 也可以设置容忍度， 以便能够在设置了特定污点的 Node 上运行。

See Taint Nodes by Condition for more details.

进一步的细节可参阅根据状况为节点设置污点。

## 容量（Capacity）与可分配（Allocatable）

Describes the resources available on the node: CPU, memory, and the maximum number of pods that can be scheduled onto the node.

这两个值描述节点上的可用资源：CPU、内存和可以调度到节点上的 Pod 的个数上限。

The fields in the `capacity` block indicate the total amount of resources that a Node has.

capacity 块中的字段标示节点拥有的资源总量。

- indicate v.表明，标示；象征，暗示；

The `allocatable` block indicates the amount of resources on a Node that is available to be consumed by normal Pods.

allocatable 块指示节点上可供普通 Pod 消耗的资源量。

You may read more about capacity and allocatable resources while learning how to reserve compute resources on a Node.

可以在学习如何在节点上预留计算资源 的时候了解有关容量和可分配资源的更多信息。

## Info 

Describes general information about the node, such as kernel version, Kubernetes version (`kubelet` and `kube-proxy` version), container runtime details, and which operating system the node uses. 

Info 指的是节点的一般信息，如内核版本、Kubernetes 版本（kubelet 和 kube-proxy 版本）、 容器运行时详细信息，以及节点使用的操作系统。 

The `kubelet` gathers this information from the node and publishes it into the Kubernetes API.

kubelet 从节点收集这些信息并将其发布到 Kubernetes API。

# Heartbeats 

Heartbeats, sent by Kubernetes nodes, help your cluster determine the availability of each node, and to take action when failures are detected.

For nodes there are two forms of heartbeats:

- updates to the `.status` of a Node
- 更新节点的 `.status`
- Lease objects within the `kube-node-lease` namespace. Each Node has an associated Lease object.
- `kube-node-lease` 名字空间中的 Lease（租约）对象。 每个节点都有一个关联的 Lease 对象。

Compared to updates to .status of a Node, a Lease is a lightweight resource. 

Using Leases for heartbeats reduces the performance impact of these updates for large clusters.

使用 Lease 来表达心跳在大型集群中可以减少这些更新对性能的影响。

The kubelet is responsible for creating and updating the `.status` of Nodes, and for updating their related Leases.

- The kubelet updates the node's `.status` either when there is change in status or if there has been no update for a configured interval. The default interval for `.status `updates to Nodes is 5 minutes, which is much longer than the 40 second default timeout for unreachable nodes.
- 当节点状态发生变化时，或者在配置的时间间隔内没有更新事件时，kubelet 会更新 .status。 .status 更新的默认间隔为 5 分钟（比节点不可达事件的 40 秒默认超时时间长很多）。
  - either or 二者择一的；要么……要么……

# Node controller
## Rate limits on eviction 
# Resource capacity tracking
# Node topology
# Graceful node shutdown
# Non Graceful node shutdown
## Pod Priority based graceful node shutdown
# Swap memory management
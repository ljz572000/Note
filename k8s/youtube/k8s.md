# What features do orchestration tools offer?

- High Availability or no down time
- Scalability or high performance
- Disaster recovery - backup and restore

# Kubernetes Components

## Node and Pod

**Node** is simple server a physical or virtual machine

**Pod**

- Smallest unit of k8s
- Abstraction over container(Docker container)
- Usually 1 application per Pod
- Each Pod gets its own IP address
- New IP address on re-creation

The reason is because kubernetes wants to abstract away the container runtime or container technologies, so that you can replace them if you want to and also because you don't have to directly work with docker or whatever container technology you use in a kubernetes so you only interact with the kubernetes layer.

a handful of  一小部分

ephemeral 短命的

## Service and Ingress

**Service** 

pods communicate with each other using a service 

- permanent IP address
- lifecycle of Pod and Service NOT connected

**Ingress**

so instead of service the request goes first to ingress and it does the forwarding then to the service 

tedious adj. 冗长的，单调乏味的

**ConfigMap**

- external configuration of your application

it's basically your external configuration to your application

config map usually contain the configuration data like urls of a database or some other services that you use

part of the external configuration can also be database username and password which may also change in the application deployment process

but putting a password or other credentials in a config map in a plain text format would be insecure

**Secret**

- used to store secret data
- base64 encoded

secret is just like config map but the difference is that it's used to store secret data, credentials 

Volumes

which is data storage 

how it works is that is basically attaches a physical storage on a hard drive to your pod and that storage could be either on local machine meaning on the same server node where the pod is running or it could be on a remote storage meaning outside of the kubernetes it could be a cloud storage or it could be your own premise storage which is not part of the kubernetes cluster

> K8s doesn't manage data persistance!
>

## Deployment

- blueprint for my-app pods

- you create Deployments

- abstraction of Pods

Because there you can specify how many Replicas and you can also scale up or scale down number of replicas of parts That  you need.

deployment is another Abstraction on top of pods which makes It more convenient to interact with the Pods replicate them and do some other Configuration


We can't replicate database using a deployment

And the reason for that is because database has a state which is its data.

Meaning that if we have clones or replicas of the database. they would all need to access the same shared data


StatefulSet

this component is meant specifically for applications like databases.

> Deploying StatefulSet not easy.
>
> DB are often hosted outside of K8s cluster and just have the depolyments or stateless applications that replicate and scale with no problem inside of the kubernetes cluster and communicate with the external database
>

# Kubernetes Architecture

## Worker machine in K8s cluster

- each Node has multiple Pods on it
- 3 processes must be installed on every Node
  - Kubelet
  - Kube Proxy
  - Container runtime
- Worker Nodes do the actual work

the containers is unberneath is *Kubelet* which is a process of kiubernetes Itself.

unlike container runtime that has Interface with both container runtime and node

- Kubelet interacts with both - the container and node
- Kubelet starts the pod with a container inside

Kubernetes cluster is made up of mulitple nodes which also must have container runtime and kubelet services installed 

the third process that is responsible for forwarding requests from services to pods is actually **kube Proxy**

**Managing processes** are done by Master Nodes.

## Master Node

4 processes run on every master node!

1. Api Server
    - cluster gateway gets the initial request of any updates into the cluster or even the queries from cluster
    - act as a gatekeeper for authentication
2. Scheduler
   - Scheduler just decides on which Node new Pod should be scheduled
3.  Controller manager
   - detect cluster state changes
4. etcd is the cluster brain !
    - Cluster changes get stored int the key value store

```mermaid
graph TD;
    [Some request]-->[API Server];
    [API Server]-->[validates request];
    [validates request]-->[other processes];
    [other processes]-->[Pod];
```

# Basic kubectl commands 

## CRUD commands

**create deployment**

`kubectl create deployment [name]`

**Edit deployment**

`kubectl edit deployment [name]`

**Delete deployment**

`kubectl delete deployment`

## Status of different K8s components

`kubectl get nodes | pod | services | replicaset | deployment `

## Debugging pods

**Log to console**

```
kubectl logs [pod name]
```

**Get Interactive Terminal**

```
kubectl exec -it [pod name] -- bin/bash
```

`kubectl create deployment nginx-depl --image=nginx`

- blueprint for creating pods
- most basic configuration for deployment(name and image to use)
- rest defaults

Deployment manages a ReplicaSet

ReplicaSet manages all the replicas of that pod

Pod is an abstraction of a container

```shell
kubectl create deployment nginx-depl --image=nginx

kubectl get deployment

kubectl get pod

kubectl get replicaset

kubectl edit deployment nginx-depl

kubectl create deployment mongo-depl --image=mongo

kubectl logs mongo-depl-8fbdb868c-nd7dg

kubectl describe pod mongo-depl-8fbdb868c-nd7dg

kubectl exec -it mongo-depl-8fbdb868c-nd7dg -- bin/bash

kubectl delete deployment mongo-depl


```

执行配置文件

```
kubectl apply -f [file name]
```


# YAML Configuration File in K8s

## Each configuration file has 3 parts

1. metadata

```yaml
metadata:
  name: nginx-deployment
  labels:
    app: nginx
```

2. specification

Attributes of "spec" are specific to the `kind`!

```yaml
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
```

3. status

Automatically generated and added by Kubernetes!

**Template**

- has it's own "metadata" and "spec" section
- applies to Pod
- Template spec "blueprint for a Pod"

Connecting Deployment to Pods

- Pods get the label through the template blueprint
- This label is matched by the selector

```yaml
selector:
matchLabels:
    app: nginx
```

```shell
kubectl describe service nginx-service
```

查看pod 更多的信息

```shell
kubectl get pod -o wide
```

查看 deployment 更多的信息

```shell
kubectl get deployment nginx-deployment -o yaml > nginx-deployment-result.yaml
```

# Complete Application Setup with kubernetes Components

```
kubectl get all
```

```
echo -n 'username' | base64
```

Secret must be created before the Deployment!

# K8s Namespaces explained

what is a Namespace?

- Organise resources in namespaces
- Virtual cluster inside a cluster

- `kubernetes-dashboard` namesapce is shipped automatically in minicube so it's specific to miniKube installation
- `kube-system` is not meant for your use so basically you shouldn't create anything or shoudn't modify anything
  - Do NOT create or modify in kube-system
  - System processes
  - Master and Kubectl processes
- `kube-public`
  - A configmap, which contains cluster information

```shell
kubectl cluster-info
```

- `kube-node-lease` 
  - heartbeats of nodes
  - each node has associated lease object in namespace
  - determines the availability of a node

- `default`
  - resources you create are located here if you haven't created a new namespace

**Create a Namespace**

```shell
kubectl create namespace my-namespace
```

```shell 
kubectl get namespace
```

the another way creating a namespace

**Create a namespace with a configuration file**

what is a Namespace?

- Cluster inside a cluster
- Default Namespaces

Why to use namespace?

1. Resources grouped in Namespaces
2. Conflicts: Many teams, same application
3. Resource Sharing: Staging and Development
4. Resource Sharing: Blue/ Green Deployment
5. Access and Resource Limits on Namespaces

Characteristics of Namespaces

Each Namespace must define own ConfigMap

Access Service in another Namespace

`db_url: mysql-service.database` 指定不同的Namespace 中的服务

```yml
apiVersion: v1
kind: ConfigMap
metadata: 
    name: mysql-configmap
data:
    db_url: mysql-service.database
```

Components, which can't be created within a Namespace

- live globally in a cluster
- you can't isolate them 

By default, components are created in a default NS

```
kubectl get configmap

kubectl get configmap -n default
```

```
kubectl apply -f mysql-configmap.yaml --namespace=my-namespace
```

```
apiVersion: v1
kind: ConfigMap
metadata: 
    name: mysql-configmap
    namespace: my-namespace
data:
    db_url: mysql-service.database
```

**configuration file over kubectl cmd**

change the active namespace with **kubens**


```
kubens

kubens my-namespace
```

# Kubernetes Ingress explained

- What is Ingress?
- Ingress YAML Configuration
- When do you need Ingress?
- Ingress Controller

IP address and port is not opened!

Routing rules:

Forward request to the internal service.

`paths` = the URL path

```yml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: myapp-ingress
  labels:
    name: myapp-ingress
spec:
  rules:
  - host: myapp.com
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: myapp-internal-service
            port: 
              number: 8080
```

Host: 
    - valid domain address
    - map domain name to Node's IP address, which is the entrypoint

# How to configure Ingress in your Cluster?

You need an implementation for Ingress!

which is Ingress Controller

Ingress Controller Pod evaluates and processes Ingress rules.

- evaluates all the rules
- manages redirections
- entrypoint to cluster
- many third-party implementations
  - K8s Nginx Ingress Controller

```
kubectl get pod -n kube-system
```


```
kubectl apply -f .\dashboard-ingress.yml
```

## Configuring TLS Certificate - https//

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tls-example-ingress
spec:
  rules:
  - host: myapp.com
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: myapp-internal-service
            port: 
              number: 8080

```

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: myapp-secret-tls
  namespace: default
type: kubernetes.io/tls
data:
  tls.crt: base64 encoded cert
  tls.key: base64 encoded key
```

1. Data keys need to be "tls.crt" and "tls.key"
2. Value are file contents NOT file paths/locations
3. Secret component must be in the same namespace as the Ingress component

# Helm explained

- What is Helm?

To package YAML Files and distribute them in public and private repositories  

- What are Helm Charts?

- Bundle of YAML Files
- Create your own Helm Charts with Helm
- Push them to Helm Repository

- How to use them?
- When to use them?
- What is Tiller?

## Helm Chart Structure

Directory structure
```
mychart/
  Chart.yaml
  values.yaml
  charts/
  templates/
```

Top level **mychart** folder -> name of chart
**Chart.yaml** -> meta info about chart
**values.yaml** -> values for the template files
**charts** folder -> chart dependencies
**templates** folder -> the actual template files

# Kubernetes Volumes explained

How to persist data in Kubernetes using volumes?

1. Persistent Volume
2. Persisten Volume Claim
3. Storage Class

Storage Requirements

1. Storage that doesn't depend on the pod lifecycle.
2. Storage must be available on all nodes.
3. Storage needs to survive even if cluster crashes.


## Persisten Volume YAML Example

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-name
spec:
  capacity:
    storage: 5Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Recycle
  storageClassName: slow
  mountOptions:
    - hard
    - nfsvers=4.1
  nfs:
    path: /tmp
    server: 172.17.0.2
```

use Google Cloud Stroge Backend
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-name
  labels:
    failure-domain.beta.kubernetes.io/zone: us-central1-a__us-central1-b
spec:
  capacity:
    storage: 400Gi
  accessModes:
    - ReadWriteOnce
  gcePersistentDisk:
    pdName: my-data-disck
    fsType: ext4
```

Persistent Volumes outside of the namesapces

Accessible to the whole cluster

## Persistent Volume Claim component

声明需要多少存储

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-name
spec:
  resources:
    requests:
      storage: 10Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce

```

 Use that PVC in Pods configuration

 ```yaml
 apiVersion: v1
kind: Pod
metadata:
  name: myapp
spec:
  containers:
  - name: myfrontend
    image: nginx
    volumeMounts:
      - mountPath: "/var/www/html"
        name: mypd
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: pvc-name

 ```

 ## Levels of Volume abstractions

 1. Pod requests the volume through the PV claim

 2. Claim tries to find a volume in cluster

 3. Volume has the actual storage backend

Claim must be in the same namespace!

> why so many abstractions?
>Easier for developers

> For Config and Secret
> 1. Create ConfigMap and/or Secret component
> 2. Mount that into your pod / container.


## Storage Class

Storage Class Persisten Volumes dynamically
when PersistentVolumeClaim claims it

- via "provisioner" attribute
- each storage backend has own provisioner(云供应商 aws)
- internal provisioner - "kubernetes.io"
- external provisioner

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: storage-class-name
provisioner: kubernetes.io/aws-ebs
parameters:
  type: io1
  iopsPerGB: "10"
  fsType: ext4
```

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-name
spec:
  resources:
    requests:
      storage: 10Gi
  storageClassName: storage-class-name
  accessModes:
    - ReadWriteOnce
```

Storage Class usage

1. Pod claims storage via PVC
2. PVC requests storage form SC
3. SC creates PV that meets the needs of the Claim


# Kubernetes StatefulSet explained

- What is StatefulSet？
- Why StatefulSet is used?
- How StatefulSet works and how it's didderent from Deployment?

StatefulSet for stateful applications 

stateful applications

- databases
- applications that store data

## Deployment vs StatefulSet

Deployment: random hash

StatefulSet: fixed ordered names

2 characteristics

1. predictable pod name
2. fixed individual DNS name

when Pod restarts

IP  address changes

name and endpoint stays same

**Replicating stateful apps**

- it's complex
- Kubernetes helps you
- You still need to do a lot:
  - Configuring the cloning and data synchronization
  - Make remote storage available
  - Managing and back-up

Stateful applications not perfect for containerized environments


# Kubernetes Services

- Service
  - stable IP address
  - loadbalancing
  - loose coupling
  - within & outside cluster

- What is a Kubernetes Service and when we need it?
- Different Service types explained
  - ClusterIP services
  - Headless Services
  - NodePort Services
  - LoadBalancer Services
- Differences between them and when to use which one



## Headless Services

- Client wants to communicate with 1 specific Pod directly 
- Pods want to talk directly with specific Pod
- So, not randomly selected
- Use Case: Stateful applications, like database


Option 1 - API call to K8s API Service
  - makes app too tied to K8s API serivce
  - inefficient
Option 2 - DNS Lookup
  - DNS Lookup for Service - return single IP address
  - Set ClusterIP to "Node" - return Pod IP address instead

```yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp
spec:
  clusterIP: Node
  selector:
    app: myapp
  ports:
  - port: <Port>
    targetPort: <Target Port>
```

LoadBalancer Service is an extension of NodePort Service

NodePort Service is an extension of ClusterIP Service

NodePort Service NOT for external connection!

Configure Ingress or LoadBalancer for production environments
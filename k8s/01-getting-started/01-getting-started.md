This section lists the different ways to set up and run Kubernetes. 

When you install Kubernetes, choose an installation type based on: ease of maintenance, security, control, available resources, and expertise required to operate and manage a cluster.

You can download Kubernetes to deploy a Kubernetes cluster on a local machine, into the cloud, or for your own datacenter.

Several Kubernetes components such as `kube-apiserver` or `kube-proxy` can also be deployed as container images within the cluster.

It is **recommended** to run Kubernetes components as container images wherever that is possible, and to have Kubernetes manage those components. Components that run containers - notably, the kubelet - can't be included in this category.

If you don't want to manage a Kubernetes cluster yourself, you could pick a managed service, including `certified platforms`. There are also other standardized and custom solutions across a wide range of cloud and bare metal environments.

# Learning environment

If you're learning Kubernetes, use the tools supported by the Kubernetes community, or tools in the ecosystem to set up a Kubernetes cluster on a local machine. See Install tools.

# Production environment

When evaluating a solution for a production environment, consider which aspects of operating a Kubernetes cluster (or abstractions) you want to manage yourself and which you prefer to hand off to a provider.

For a cluster you're managing yourself, the officially supported tool for deploying Kubernetes is kubeadm.

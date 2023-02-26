查看k8s 版本
```
kubectl version --short
```

[windows单机搭建k8s环境](https://cloud.tencent.com/developer/article/1797416)
[Kubernetes Ingress with Nginx Example](https://matthewpalmer.net/kubernetes-app-developer/articles/kubernetes-ingress-guide-nginx-example.html)

```
https://github.com/kubernetes/ingress-nginx/blob/controller-v1.2.1/deploy/static/provider/cloud/1.21/deploy.yaml
```

启动Kubernetes API Server 访问代理

```
kubectl proxy
```

```
kubectl apply -f dashboard-adminuser.yaml
```

```
kubectl -n kube-system create token admin-user
```
# Android Http 通信

要在您的应用中执行网络操作，您的清单必须包含以下权限

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

## 设计安全的网络通信

在向应用添加网络功能之前，您需要确保应用中的数据和信息在通过网络传输时处于安全状态。为此，请遵循以下网络安全最佳做法

* 最大限度地减少您通过网络传输的敏感或个人[用户数据](https://developer.android.google.cn/training/articles/security-tips.html#UserData)的数量
* 通过 [SSL](https://developer.android.google.cn/training/articles/security-ssl.html) 发送来自您应用的所有网络流量
* 考虑创建一个[网络安全配置](https://developer.android.google.cn/training/articles/security-config.html)，该配置允许您的应用信任自定义 CA 或限制在安全通信方面取得其信任的系统 CA 集。

Android 对于Http 网络通信，提供了标准的Java接口——`HttpURLConnection`接口和Apache的接口——`HttpClient`接口。

## URL 加载网络资源

URL类提供了多个构造器用于创建URL对象。

获得对象后，可以使用下列表所示的方法来访问该URL资源。

| 方法                           | 说明                                               |
| ------------------------------ | -------------------------------------------------- |
| String getFile()               | 获取此URL的资源名                                  |
| String getHost()               | 获取此URL的主机名                                  |
| String getPath()               | 获取此URL的路径部分                                |
| int getPort()                  | 获取此URL的端口号                                  |
| String getProtocol()           | 获取此URL的协议名                                  |
| String getQuery()              | 获取此URL的查询字符串部分                          |
| URLConnection openConnection() | 表示到URL所用引用的远程对象的连接                  |
| InputStream openStream()       | 打开与此URL的连接，返回用于读取该资源的InputStream |

使用URL加载网络资源的一般步骤如下

1. 获取URL对象。
2. 调取openStream() 方法打开URL的连接，获取URL的资源输入流。
3. 通过输入流InputStream进行文件读写。
4. 关闭输入流。


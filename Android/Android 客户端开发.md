# Android 客户端开发

Android客户端代码包说明

| 包名                                | 说明                                       |
| ----------------------------------- | ------------------------------------------ |
| cn.sharesdk.onekeyshare             | 社会化分享依赖包                           |
| food.neusoft.com.food               | 总包                                       |
| food.neusoft.com.food.activity      | 存放所有的Activity类                       |
| food.neusoft.com.food.adapter       | 存放适配器类                               |
| food.neusoft.com.food.domain        | 存放相关的实体类，如商品信息、订单信息等   |
| food.neusoft.com.food.Fragment.main | 存放Fragment类，Fragment主要用于页面的导航 |
| food.neusoft.com.food.thread        | 线程，网络相关的工具类                     |
| food.neusoft.com.food.utils         | 通用工具包                                 |
| food.neusoft.com.food.view          | 自定义控件，自定义ViewPager顶部轮播图      |
| food.neusoft.com.food.widget        | 自定义组件                                 |
| food.neusoft.com.food.wxapi         | 微信API,项目集成微信时采用                 |

## Android框架使用

### AsyncHttpClient 框架

​	AsyncHttpClient 基于Apache HttpClient, 所有的请求都独立在UI主线程之外，通过回调方法处理请求结果，采用**Handler**机制传递信息。

​	创建异步请求，一般使用静态的HttpClient 对象，调用相应的方法，通常涉及**AsyncHttpClient**, **RequestParams**, **AsyncHttpResponseHandler** 3个类的使用。

​	**AsyncHttpClient**类通常用于在Android应用程序中创建异步请求，如GET、POST、PUT 和 DELETE 等，请求参数通过RequestParams实例创建，响应通过重写匿名内部类ResponseHandlerInterface的方法处理。使用AsyncHttpClient执行网络请求时，最终都会调用sendRequest（）方法，在这个方法内部将请求参数封装成AsyncHttpRequest交由内部的线程池执行。

​	**RequestParams**类用于创建AsyncHttpClient 实例中请求参数的集合，参数可以是String、File和InputStream等等。

​	**AsyncHttpResponseHandler**继承自ResponseHandlerInterface类，主要用于拦截和处理由AsyncHttpClient创建的请求。在匿名类AsyncHttpResponseHandler中重写`onSuccess(int, org.apache.http.Header[],byte[],Throwable)`, onStart(), onFinish(), onRetry() 和 onProgress(int, int)等方法。


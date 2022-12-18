# React 创建项目

```
npx create-react-app onlineBookStore_2
create-react-app onlineBookReact

cd xxx

npm start
```

# 打包发布

```
npm run build
npm install -g serve
serve build
```

# 项目工程包

```
src
	- api	ajax相关
	- assets 公共资源
	- components 非路由组件
	- config 配置
	- pages 路由组件
	- utils 工具模块
		App.js 应用根组件
		index.js 入口js
```

# 添加ant-d

```
npm add antd

//实现组件的按需打包
npm add react-app-rewired customize-cra babel-plugin-import


```

引入路由

```
npm add react-router-dom
```

```
import {} from 'react-router-dom';
import {BrowserRouter} from 'react-router-dom';
```

# 添加less

```
npm add less less-loader
```



# git 创建并切换分支

```
git config --global user.email "ljz572000@foxmail.com"
git config --global user.name "lijinzhou"
git checkout -b dev

//远程dev
git checkout -b dev origin/dev

//查看当前分支
git branch
```

# 前台表单验证与数据收集

```
 1. 高阶函数create
   1). 一类特别的函数
       a. 接受函数类型的参数
       b. 返回值是函数
   2). 常见
       a. 定时器： setTimeout()/setInterval()
       b. Promise: Promise(()=> {}) then (value => {}, reason => {})
       c. 数组遍历相关的方法：forEach()/filter()/map()/
  2. 高阶组件Form
  包装Form组件生成一个新的组件：Form(Login)
  新组件会向Form组件传递一个强大的对象属性：form
2. 高阶组件
	1). 本质是一个函数
	2). 接受一个组件，返回一个新的组件，包装组件会向被包装组件传入特定属性。
	3） 作用：扩展组件的功能
	4） 高阶组件也是高阶函数： 接收一个组件函数，返回是个新的组件函数
```

# 前后台交互

```
npm add axios
```

## 封装ajax请求模块

```
import axios from 'axios'

 export default function ajax(url,data={},type='GET'){
     if(type==='GET'){
         return axios.get(
             url,{params: data}
         )
     }else{
         return axios.post(
             url,data
         )
     }
 }
 
 
 ********************
 /**
 * 包含应用中所有接口请求函数的模块
 */
import ajax from './ajax'
 // 登陆
//  export function reqLogin(){
//      ajax()
//  }

export const reqLogin = (username, password) => ajax('/login',{username,password},'POST');
```

# async 和 await

1. 作用？

简化promise对象的使用：不用再使用then()来指定成功/失败的回调函数，以同步编码（没有回调函数了）方式实现异步流程

2. 哪里写await?

在返回promise 的表达式左侧写await: 不想要promise,想要promise异步执行的成功的value数据

3. 哪里写async?

await 所在函数（最近的）定义的左侧写async

能发送异步ajax请求的函数模块

封装axios库

函数的返回值是promise对象

1. 优化：统一处理请求异常

    在外层包一个自己创建的promise对象，在请求出错时，不reject(error),而是显示错误提示。

# 界面跳转

事件中跳转

```
this.props.history.replace('/');
this.props.history.push('/');
```

重定向

```
return <Redirect to='/login'/>
```

# 持久化

使用库 https://github.com/marcuswestin/store.js 

```
npm add store
```



# 使用Bcrypt

网址： https://segmentfault.com/a/1190000008841988 

```
npm install bcrypt
```

# 路由分级

```
user
admin
login
forgot
register

```



.slice()方法创建了squares数组的一个副本，而不是直接在现有的数组上进行修改**

```
const squares = this.state.squares.slice();
```

# 为什么不可变性在 React 中非常重要

一般来说，有两种改变数据的方式。第一种方式是直接修改变量的值，第二种方式是使用新的一份数据替换旧数据。

[note](https://react.docschina.org/tutorial/tutorial.html#why-immutability-is-important)

* 简化复杂的功能

* 跟踪数据的改变

* 确定在 React 中何时重新渲染 

# 函数组件

如果你想写的组件只包含一个render方法，并且不包含state,那么使用**函数组件**就会更简单。我们不需要定义一个继承于React.Component的类，我们可以定义一个函数，函数接受props作为参数，然后返回需要渲染的元素。

# 部署nignx

```
docker run --name ljz-nginx -v /some/content:/usr/share/nginfx/html:ro -d nginx

docker run -it --name ljz-nginx  -p 8080:80 -p 31:22 -d nginx
```

# 点击函数不起作用

```
 <Icon type="check" key="check" onClick={() => this.showBuyNow(item)} />,
```


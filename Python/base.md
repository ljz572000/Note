# String

**strip()**

去除前后的空格

```python
string = """    geeks for geeks    """
print(string.strip())
# geeks for geeks  
```

去除字符子串
```
print(string.strip(' geeks'))
# for
```

# python 中的星号

https://zhuanlan.zhihu.com/p/46791479

# python中的类型提示(定义函数时加入箭头->)

https://blog.csdn.net/leviopku/article/details/105236840

# yield 

简单地讲，yield 的作用就是把一个函数变成一个 generator，带有 yield 的函数不再是一个普通函数，Python 解释器会将其视为一个 generator，调用 fab(5) 不会执行 fab 函数，而是返回一个 iterable 对象！

https://www.runoob.com/w3cnote/python-yield-used-analysis.html

# 深入理解Python 中的 yield from语法

https://zhuanlan.zhihu.com/p/267966140

协程的出现，刚好可以解决以上的问题

1. 协程是在单线程里实现任务的切换的
2. 利用同步的方式去实现异步
3. 不再需要锁，提高了并发性能

# 电子书

* [人生苦短，我用python](https://www.cnblogs.com/derek1184405959/p/8579428.html) - zhang_derek *(内含丰富的笔记以及各类教程)*
* [Matplotlib 3.0.3 中文文档](http://www.osgeo.cn/matplotlib/) (Online)
* [Numpy 1.16 中文文档](http://www.osgeo.cn/numpy/) (Online)
* [Python 3.8.0a3中文文档](http://www.osgeo.cn/cpython/) (Online) *(目前在线最全的中文文档了)*
* [Python 中文学习大本营](http://www.pythondoc.com)
* [Python 最佳实践指南](https://pythonguidecn.readthedocs.io/zh/latest/)
* [Python Cookbook第三版](http://python3-cookbook.readthedocs.io/zh_CN/latest/) - David Beazley、Brian K.Jones、熊能(翻译)
* [Python教程 - 廖雪峰的官方网站](http://www.liaoxuefeng.com/wiki/0014316089557264a6b348958f449949df42a6d3a2e542c000)
* [Python进阶](https://interpy.eastlakeside.com) - eastlakeside
* [Python之旅](https://web.archive.org/web/20191217091745/http://funhacks.net/explore-python/) - Ethan *(:card_file_box: archived)*
* [Tornado 6.1 中文文档](http://www.osgeo.cn/tornado/) (Online) *(网络上其他的都是较旧版本的)*


#### Django

* [Django 1.11.6 中文文档](https://www.yiyibooks.cn/xx/Django_1.11.6/index.html)
* [Django 2.2.1 中文文档](http://www.osgeo.cn/django/) (Online) *(这个很新，也很全)*
* [Django 搭建个人博客教程 (2.1)](https://www.dusaiphoto.com/article/detail/2) - 杜赛 (HTML)
* [Django book 2.0](http://djangobook.py3k.cn/2.0/)
* [Django Girls 教程 (1.11)](https://tutorial.djangogirls.org/zh/) (HTML)

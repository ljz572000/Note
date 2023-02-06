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

# zip()

更正式地说： zip() 返回元组的迭代器，其中 i -该元组包含 i -每个论点中的第个元素都是可接受的。

```python
# -*- coding: utf-8 -*-

if __name__ == '__main__':
    for item in zip([1, 2, 3], ['sugar', 'spice', 'everything nice']):
        print(item)
```

# Python元组和列表的区别

http://c.biancheng.net/view/4363.html

元组和列表最大的区别就是，列表中的元素可以进行任意修改

```python
# -*- coding: utf-8 -*-

if __name__ == '__main__':
    listDemo = []
    tupleDemo = ()
    print("list size {}", listDemo.__sizeof__())
    print("tuple size {}", tupleDemo.__sizeof__())
```

可以看到，对于列表和元组来说，虽然它们都是空的，但元组却比列表少占用 16 个字节，这是为什么呢？

事实上，就是由于列表是动态的，它需要存储指针来指向对应的元素（占用 8 个字节）。另外，由于列表中元素可变，所以需要额外存储已经分配的长度大小（占用 8 个字节）。但是对于元组，情况就不同了，元组长度大小固定，且存储元素不可变，所以存储空间也是固定的。

即元组要比列表更加轻量级，所以从总体上来说，**元组的性能速度要由于列表**。

另外，Python 会在后台，对静态数据做一些资源缓存。通常来说，因为垃圾回收机制的存在，如果一些变量不被使用了，Python 就会回收它们所占用的内存，返还给操作系统，以便其他变量或其他应用使用。

但是对于一些静态变量（比如元组），如果它不被使用并且占用空间不大时，Python 会暂时缓存这部分内存。这样的话，当下次再创建同样大小的元组时，Python 就可以不用再向操作系统发出请求去寻找内存，而是可以直接分配之前缓存的内存空间，这样就能大大加快程序的运行速度。

```
list size {} 40
tuple size {} 24
```

#  python范围和名称空间

这个 global 语句可用于指示特定变量在全局范围内，并应在全局范围内反弹；

语句 nonlocal 语句指示特定变量位于封闭范围内，并应在该范围内反弹。

```python
# -*- coding: utf-8 -*-

def scope_test():
    def do_local():
        spam = "local spam"

    def do_nonlocal():
        nonlocal spam
        spam = "nonlocal spam"

    def do_global():
        global spam
        spam = "global spam"

    spam = "test spam"
    do_local()
    print("After local assignment:", spam)
    do_nonlocal()
    print("After nonlocal assignment:", spam)
    do_global()
    print("After global assignment:", spam)


scope_test()
print("In global scope:", spam)
```

```python
After local assignment: test spam
After nonlocal assignment: nonlocal spam
After global assignment: nonlocal spam
In global scope: global spam
```

# python也支持多重继承的形式



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

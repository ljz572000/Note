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
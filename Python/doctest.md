# doctest 

单元测试类库

 python3 -m doctest -v doctest.py

 -v等同verbose参数

 或
 
 doctest.testmod(verbose=True) 

```python
import doctest

def fib(n):
    """ 
    Calculates the n-th Fibonacci number iteratively  

    >>> fib(0)
    0
    >>> fib(1)
    1
    >>> fib(10) #正确值为55
    56            
    >>> fib(15)
    610
    >>> 

    """
    a, b = 0, 1
    for i in range(n):
        a, b = b, a + b
    return a

if __name__ == "__main__": 
    doctest.testmod(verbose=True)
```
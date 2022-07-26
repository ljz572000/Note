# random库

生成1<=n<=10 之间的数字

```python
import random
index = random.randint(1,10)
index
```

# numpy 库

问题：numpy中的array与Python内置的list有什么区别？

* list中的数据类不必相同的，而array的中的类型必须相同
* list中的数据类型保存的是数据的存放的地址，简单的说就是指针，并非数据

```python
import numpy as np
alist = [1,2,3]
blist = ['1',2,3]
aarry = np.array(alist)
barry = np.array(blist)
aarry,barry
# (array([1, 2, 3]), array(['1', '2', '3'], dtype='<U1'))
```

## empty()

随机数生成矩阵

```python
import numpy as np
labels = np.empty(5)
labels
# array([9.66111301e-312, 9.73175853e-315, 9.66209334e-312, 9.66219724e-312,
#       8.90104239e-307])
```

## zeros()

生成零矩阵

```python
import numpy as np 
a = np.zeros(4)
a
# array([0., 0., 0., 0.])
```

# matplotlib 库

```python
import matplotlib.pyplot as plt
plt.figure(figsize=(12, 12))
# 设置窗体大小
```


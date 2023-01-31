# 什么情况下索引会失效

LOL

1. L 当like以%开头索引会失效 ‘%xxx’

2. O `or`  链接前后有一个是非索引字段的时候，索引失效

3. L “联合查询” A、B两个字段被定义为联合索引  A 就是我们联合索引的首个索引列 一定要从首个索引列开始。

select a,b from table where a > 3 and b>5

会使用索引

select a,b from table where b > 5

不会使用索引

4. + - x / 索引失效

select table from table where age - 1 = 10

5. not 失效

select table from table where age <> 10

6. null 不确定是否失效

select table from table where age is not null

是否有铅笔盒  建议设置默认值 
来保证我的这个字段不出现空值

7. no method  索引字段用到函数中，一定要看一下索引是否失效

select table from table where dataadd ( fieldname, -1) = (2022年1月28号）

current_date -1

8. no  MySQL CONVERT() 

原本是varchar，where 条件是用int.

select table from table where age = 123   不适用索引

select table from table where age = ‘123’   适用索引


不一样的版本，表现不一样


mysql 5.6 版本之前

select * from where a >3

走全表扫描，三次IO

离散读的这个概念

先在辅助索引里面获取id. 回表聚簇索引随机查每个三次io.  5个就是15次。

有一个阈值是20万条


5.6 之后 引入MRR 优化

先在辅助索引里面获取id. 放于缓存里边。

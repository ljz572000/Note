# Shell

Shell是一个命令行解释器，它为用户提供了一个向Linux内核发送请求以便运行程序的界面系统级程序，用户可以用shell来启动、挂起、停止甚至是编写一些程序。

1. 脚本以#!/bin/bash开头
2. 脚本需要有可执行权限

```
 #!/bin/bash
echo "hello world"
```

## Shell 的变量介绍

Shell 中的变量为：系统变量和用户自定义变量；

系统变量：`$HOME`、`$PWD`、`$SHELL`、`$USER`等等.

1. 定义变量

```shell
test=100
```
2. 撤销变量

```shell
test=100
unset test
```

3. 声明静态变量

静态变量, 不能unset

```shell
readonly test=100
```

**定义变量的规则**

1. 变量名称可以由字母、数字和下划线组成，但是不能以数字开头。

2. 等号两侧不能有空格

3. 变量名称一般 习惯大写


**赋值**

```shell
A=100
B=$A
echo $B
echo $(date)
```

**设置环境变量**

编辑`/etc/profile`文件中定义

**注释**

多行注释

```shell
:<<!
echo $(date)
!
```

单行注释

```yaml
# echo $(date)
```

### 位置参数变量

基础语法

`$n`

n 为数字，`$0` 代表命令本身，`$1-$9`代表第一到第九个参数，十以上的参数需要用大括号包含，如`${10})`

`$*` 

这个变量代表命令行中所有的参数，`$*`把所有的参数看成一个整体

`$@` 

这个变量也代表命令行中所有的参数，不过`$@`把每个参数区分对待

`$#`

这个变量代表命令行中所有参数的个数

`$$`

当前进程的进程号

`$!`

后台运行的最后一个进程的进程号

`$?`

最后一次执行的命令的返回状态。如果这个变量的值为0，证明上一个命令正确执行；如果这个变量的值为非0（具体是哪一个数，由命令自己来决定），则证明上一个命令执行不正确。

`$((m+n))`

`$[m+n]`

`expr m + n`

进行运算

比较

`=`  字符串相等

```shell
if [ "123" = "123" ] 
then
    echo "equal"
fi
```

`-lt` 小于
`-le`	小于等于
`-eq`	等于
`-gt` 大于
`-ge` 大于等于
`-ne`	不等于

`-f` 文件存在并且是一个常规的文件
`-e`	文件存在
`-d`	文件存在并是一个目录



### 流程控制

**if判断**

```shell
A=456
if [ $A = "123" ] 
then
    echo "123"
elif [ $A = "456" ]
then
    echo "456"
fi
```

**case 语句**


```shell
case $1 in
1)
    echo "Monday"
    ;;
"2")
    echo "Feburary"
    ;;
*)
    echo "other"
    ;;
esac
```

**for Loop**

```shell
for i in "$@"
do
    echo "the num is $i"
done
```

```shell
SUM=0
for (( i=1; i<=100; i++ ))
do
    SUM=$[$SUM+$i]
done
echo "sum=$SUM"
```

**While Loop**

```shell
SUM=0
i=0
while ((  i<=100 ))
do
    SUM=$[$SUM+$i]
    i=$[$i+1]
done
echo "sum=$SUM"
```

## 读取控制台输入

`-p`

指定读取值时的提示符

`-t`

指定读取值时等待的时间（秒），如果没有在指定的时间内输入，就不再等待了。


```
read -p "please input a number A="  A
echo "$A"
```

## 函数

basename

```shell
echo "$(basename E:/skill/test.sh )"
```

dirname

```shell
echo "$(dirname E:/skill/test.sh )"
```

自定义函数

```shell
function getSum(){
    SUM=$[$n1+$n2]
    echo "sum=$SUM"
}

read -p "please input a number A: " n1
read -p "please input a number B: " n2

#use getSum
getSum $n1 $n2
```

## 数据备份综合案例

1. 每天凌晨2:10备份数据库 DB 到 `/data/backup/db`
2. 备份开始和备份结束能够给出相应的提示信息
3. 备份后的文件要求以备份时间为文件名，并打包成`.tar.gz`的形式，比如: `2022-12-18_2118.tar.gz`
4. 在备份的同时，检查是否有10天前的备份的数据库文件，如果有就将其删除.

```shell
#!/bin/bash

BACKUP=/home/ljz/DBBackup

DATETIME=$(date +%Y_%m_%d%H%M%S)

echo "======backup start========"
echo "=====backup path $BACKUP/$DATETIME.tar.gz"

HOST=localhost
  
DB_USER=root

DB_PWD=qqq123

DATABASE=student

[ ! -d "$BACKUP/$DATETIME" ] && mkdir -p "$BACKUP/$DATETIME"

#Backup instruction

mysqldump -u${DB_USER} -p${DB_PWD} --host=${HOST} $DATABASE | gzip > $BACKUP/$DATETIME/$DATETIME.sql.gz

cd $BACKUP
tar -zcvf $DATETIME.tar.gz $DATETIME

#DELETE TEMPORARY DIRCOTER
rm -rf $BACKUP/$DATETIME

#delete backup files older than 10 days

find $BACKUP -mtime +10 -name "*.tar.gz" -exec rm -rf {} \;

echo "backup files complete!"        

```
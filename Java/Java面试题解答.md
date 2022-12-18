# 1. JDK 1.8 新特性

## 1.1 default 关键字

在java里面，我们通常都是认为接口里面是只能有抽象方法，不能有任何方法的实现的，那么在jdk1.8里面打破了这个规定，引入了新的关键字default，通过使用default修饰方法，可以让我们在接口里面定义具体的方法实现，如下。

```java
public interface NewCharacter {
    public void test1();

    public default void test2(){
        System.out.println("我是新特性1");
    }
}
```

那这么定义一个方法的作用是什么呢？为什么不在接口的实现类里面再去实现方法呢？

其实这么定义一个方法的主要意义是定义一个默认方法，也就是说这个接口的实现类实现了这个接口之后，不用管这个default修饰的方法，也可以直接调用，如下。

```java
public class NewCharacterImpl implements NewCharacter{
    @Override
    public void test1() {

    }

    public static void main(String[] args) {
        NewCharacter nca = new NewCharacterImpl();
        nca.test2();
    }
}
```

所以说这个default方法是所有的实现类都不需要去实现的就可以直接调用，那么比如说`jdk`的集合List里面增加了一个sort方法，那么如果定义为一个抽象方法，其所有的实现类如`arrayList`,`LinkedList`等都需要对其添加实现，那么现在用default定义一个默认的方法之后，其实现类可以直接使用这个方法了，这样不管是开发还是维护项目，都会大大简化代码量。

## 1.2 Lambda 表达式

Lambda 表达式是`jdk 1.8` 里面的一个重要的更新，这意味着java也开始承认了函数式编程,并且尝试引入其中。

首先，**什么式函数式编程**，引用廖雪峰先生的教程里面的解释就是说：**函数式编程就是一种抽象程度很高的编程范式，纯粹的函数式编程语言编写的函数没有变量，因此，任意一个函数只要输入确定，输出就是确定的，这种纯函数我们称之为没有副作用。而允许使用变量的程序设计语言，由于函数内部的变量状态不确定，同样的输入，可能得到不同的输出，因此，这种函数是有副作用的。函数式编程的一个特点就是，允许把函数本身作为参数传入另一个函数，还允许返回一个函数！**

​	简单的来说就是，函数也是一等公民了，在java里面一等公民有变量，对象，那么函数式编程语言里面函数也可以跟变量，对象一样使用了，也就是说函数既可以作为参数，也可以作为返回值了，看一下下面这个例子。

 **这是常规的Collections的排序的写法，需要对接口方法**

```java
public class Main {

    public static void main(String[] args) {
        List<String> list = Arrays.asList("aaa","fsa","ser","eere");
        Collections.sort(list, new Comparator<String>() {
            @Override
            public int compare(String o1, String o2) {
                System.out.println(o1+"  "+o2.compareTo(o1)+" "+o2);
                return o2.compareTo(o1);
            }
        });
        for (String string : list) {
            System.out.println(string);
        }
    }
}
```

**知识点补充 Comparator **

Comparator 是一个接口

对任意类型集合对象进行整体排序,排序时将此接口的实现传递给`Collections.sort`方法或者`Arrays.sort`方法排序.

实现`int compare(T o1, T o2);`

```
//对users按年龄进行排序
		Collections.sort(stus, new Comparator<Student>() {

			@Override
			public int compare(Student s1, Student s2) {
				// 升序
				//return s1.getAge()-s2.getAge();
				return s1.getAge().compareTo(s2.getAge());
				// 降序
				// return s2.getAge()-s1.getAge();
				// return s2.getAge().compareTo(s1.getAge());
			}
		});
		// 输出结果
```

**这是带参数类型的Lambda的写法**

```java
public class Main {

    public static void main(String[] args) {
        List<String> list = Arrays.asList("aaa","aa","ad","ab");
        Collections.sort(list, (Comparator<? super String>)(String a,String b)->{
            return b.compareTo(a);
        }
        );
        for (String string : list) {
            System.out.println(string);
        }
    }
}
```

**这是不带参数的lambda的写法**

```java
public class Main {

    public static void main(String[] args) {
        List<String> list = Arrays.asList("aaa","aa","ad","ab");
        Collections.sort(list, (a,b) ->b.compareTo(a));
        for (String string : list) {
            System.out.println(string);
        }
    }
}
```

可以看到不带参数的写法一句话就搞定了排序的问题,所以引入lambda 表达式的一个最直观的作用就是大大的简化了代码的开发，就像一些编程语言Scala, python等都是支持函数式的写法的.**当然,不是所有的接口都可以通过这种方法来调用, 只有函数式接口才行, jdk 1.8 里面定义了好多个函数式接口，我们可以自己定义一个来调用，下面说一下什么式函数式接口。**

函数式接口

定义: "函数式接口"是指仅仅只包含一个抽象方法的接口，每一个该类型的lambda表达式都会被匹配到这个抽象方法。`jdk 1.8 `提供了一个 `@FunctionalInterface`注解来定义函数式接口, 如果我们定义的接口不符合函数式的规范便会报错.

```java
@FunctionalInterface
public interface MyLamda {
    
    public void test1(String y);

//这里如果继续加一个抽象方法便会报错
//    public void test1();
    
//default方法可以任意定义
    default String test2(){
        return "123";
    }
    
    default String test3(){
        return "123";
    }

//static方法也可以定义
    static void test4(){
        System.out.println("234");
    }

}
```

## 1.3 方法与构造函数引用

jdk1.8提供了另外一种调用方式::，当 你 需 要使用 方 法 引用时 ， 目 标引用 放 在 分隔符::前 ，方法 的 名 称放在 后 面 ，即`ClassName :: methodName` 。例如 ，`Apple::getWeight`就是引用了Apple类中定义的方法`getWeight`。请记住，不需要括号，因为你没有实际调用这个方法。方法引用就是Lambda表达式`(Apple a) -> a.getWeight()`的快捷写法，如下示例。

```java
//先定义一个函数式接口
@FunctionalInterface
public interface TestConverT<T, F> {
    F convert(T t);
}
```

测试如下，可以以::形式调用。

```java
public void test(){
    TestConverT<String, Integer> t = Integer::valueOf;
    Integer i = t.convert("111");
    System.out.println(i);
}
```

　此外，对于构造方法也可以这么调用。

```java
//实体类User和它的构造方法
public class User {    
    private String name;
    
    private String sex;

    public User(String name, String sex) {
        super();
        this.name = name;
        this.sex = sex;
    }
}
//User工厂
public interface UserFactory {
    User get(String name, String sex);
}
//测试类
    UserFactory uf = User::new;
    User u = uf.get("ww", "man");
```

这里的User::new就是调用了User的构造方法，Java编译器会自动根据`UserFactory.get`方法的签名来选择合适的构造函数。

## 1.4 局部变量限制

Lambda表达式也允许使用自由变量（不是参数，而是在外层作用域中定义的变量），就像匿名类一样。 它们被称作捕获Lambda。 Lambda可以没有限制地捕获（也就是在其主体中引用）实例变量和静态变量。但局部变量必须显式声明为final，或事实上是final。
　　为什么局部变量有这些限制？
　　（1）实例变量和局部变量背后的实现有一个关键不同。实例变量都存储在堆中，而局部变量则保存在栈上。如果Lambda可以直接访问局部变量，而且Lambda是在一个线程中使用的，则使用Lambda的线程，可能会在分配该变量的线程将这个变量收回之后，去访问该变量。因此， Java在访问自由局部变量时，实际上是在访问它的副本，而不是访问原始变量。如果局部变量仅仅赋值一次那就没有什么区别了——因此就有了这个限制。
　　（2）这一限制不鼓励你使用改变外部变量的典型命令式编程模式。

```java
final int num = 1;
Converter<Integer, String> stringConverter =
        (from) -> String.valueOf(from + num);
stringConverter.convert(2); 
```

## 1.5 `java.time`

1.8之前JDK自带的日期处理类非常不方便，我们处理的时候经常是使用的第三方工具包，比如commons-lang包等。不过1.8出现之后这个改观了很多，比如日期时间的创建、比较、调整、格式化、时间间隔等。这些类都在`java.time`包下。比原来实用了很多。

### *1.5.1* `LocalDate/LocalTime/LocalDateTime`

　　`LocalDate`为日期处理类、`LocalTime`为时间处理类、`LocalDateTime`为日期时间处理类，方法都类似，具体可以看API文档或源码，选取几个代表性的方法做下介绍。

　　now相关的方法可以获取当前日期或时间，of方法可以创建对应的日期或时间，parse方法可以解析日期或时间，get方法可以获取日期或时间信息，with方法可以设置日期或时间信息，plus或minus方法可以增减日期或时间信息；

### *1.5.2* `TemporalAdjusters`

 　　这个类在日期调整时非常有用，比如得到当月的第一天、最后一天，当年的第一天、最后一天，下一周或前一周的某天等。

###  1.5.3 `DateTimeFormatter`

 　　以前日期格式化一般用`SimpleDateFormat`类，但是不怎么好用，现在1.8引入了`DateTimeFormatter`类，默认定义了很多常量格式（ISO打头的），在使用的时候一般配合`LocalDate/LocalTime/LocalDateTime`使用，比如想把当前日期格式化成`yyyy-MM-dd hh:mm:ss`的形式:

```java
LocalDateTime dt = LocalDateTime.now();  
DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd hh:mm:ss");         
System.out.println(dtf.format(dt));
```

## 1.6 流

　定义：**流是Java API的新成员**，它允许我们以声明性方式处理数据集合（通过查询语句来表达，而不是临时编写一个实现）。就现在来说，我们可以把它们看成**遍历数据集的高级迭代器**。此外，**流还可以透明地并行处理**，也就是说我们不用写多线程代码了。

　　Stream 不是集合元素，它不是数据结构并不保存数据，它是有关算法和计算的，它更像一个高级版本的 Iterator。**原始版本的 Iterator，用户只能显式地一个一个遍历元素并对其执行某些操作**；**高级版本的 Stream**，用户只要给出需要对其包含的元素执行什么操作，比如 “过滤掉长度大于 10 的字符串”、“获取每个字符串的首字母”等，Stream 会隐式地在内部进行遍历，做出相应的数据转换。

　　Stream 就如同一个迭代器（Iterator），单向，不可往复，数据只能遍历一次，遍历过一次后即用尽了，就好比流水从面前流过，一去不复返。而和迭代器又不同的是，Stream 可以并行化操作，迭代器只能命令式地、串行化操作。顾名思义，当使用串行方式去遍历时，每个 item 读完后再读下一个 item。而使用并行去遍历时，数据会被分成多个段，其中每一个都在不同的线程中处理，然后将结果一起输出。Stream 的并行操作依赖于 Java7 中引入的 Fork/Join 框架（JSR166y）来拆分任务和加速处理过程。

　　流的操作类型分为两种：

- **Intermediate**：一个流可以后面跟随零个或多个 intermediate 操作。其目的主要是打开流，做出某种程度的数据映射/过滤，然后返回一个新的流，交给下一个操作使用。这类操作都是惰性化的（lazy），就是说，仅仅调用到这类方法，并没有真正开始流的遍历。
- **Terminal**：一个流只能有一个 terminal 操作，当这个操作执行后，流就被使用“光”了，无法再被操作。所以这必定是流的最后一个操作。Terminal 操作的执行，才会真正开始流的遍历，并且会生成一个结果，或者一个 side effect。

 　 在对于一个 Stream 进行多次转换操作 (Intermediate 操作)，每次都对 Stream 的每个元素进行转换，而且是执行多次，这样时间复杂度就是 N（转换次数）个 for 循环里把所有操作都做掉的总和吗？其实不是这样的，转换操作都是 lazy 的，多个转换操作只会在 Terminal 操作的时候融合起来，一次循环完成。我们可以这样简单的理解，Stream 里有个操作函数的集合，每次转换操作就是把转换函数放入这个集合中，在 Terminal 操作的时候循环 Stream 对应的集合，然后对每个元素执行所有的函数。

# 2. java 集合框架

Java 集合框架主要包括两种类型的容器，一种是集合（Collection），存储一个元素集合，另一种是图（Map），存储键/值对映射。(Collection、Map 是接口)

**Collection 接口**又有 3 种子类型，List、Set 和 Queue，再下面是一些抽象类，最后是具体实现类，常用的有 `ArrayList`、`LinkedList`、`HashSet`、`LinkedHashSet`、`HashMap`、`LinkedHashMap` 等等。

集合框架是一个用来代表和操纵集合的统一架构。所有的集合框架都包含如下内容：

* **接口：**是代表集合的抽象数据类型。例如 Collection、List、Set、Map 等。之所以定义多个接口，是为了以不同的方式操作集合对象

* **实现（类）：**是集合接口的具体实现。从本质上讲，它们是可重复使用的数据结构，例如：`ArrayList`、`LinkedList`、`HashSet`、`HashMap`。

* **算法：**是实现集合接口的对象里的方法执行的一些有用的计算，例如：搜索和排序。这些算法被称为多态，那是因为相同的方法可以在相似的接口上有着不同的实现。

![img](images/java-coll.png)

### 2.1 Set和List的区别

- 1. Set 接口实例存储的是无序的，不重复的数据。List 接口实例存储的是有序的，可以重复的元素。
- 2. Set检索效率低下，删除和插入效率高，插入和删除不会引起元素位置改变 **<实现类有`HashSet`,`TreeSet`>**。
- 3. List和数组类似，可以动态增长，根据实际存储的数据的长度自动增长List的长度。查找元素效率高，插入删除效率低，因为会引起其他元素位置改变 **<实现类有`ArrayList`,`LinkedList`,Vector>** 。

## 集合实现类（集合类）

Java提供了一套实现了Collection接口的标准集合类。其中一些是具体类，这些类可以直接拿来使用，而另外一些是抽象类，提供了接口的部分实现。

| **序号** | **类描述**                                                   |
| -------- | ------------------------------------------------------------ |
|          | **AbstractCollection** 实现了大部分的集合接口。              |
|          | **AbstractList** 继承于AbstractCollection 并且实现了大部分List接口。 |
|          | **AbstractSequentialList** 继承于 AbstractList ，提供了对数据元素的链式访问而不是随机访问。 |
|          | LinkedList 该类实现了List接口，允许有null（空）元素。主要用于创建链表数据结构，该类没有同步方法，如果多个线程同时访问一个List，则必须自己实现访问同步，解决方法就是在创建List时候构造一个同步的List。例如： |
|          | ArrayList 该类也是实现了List的接口，实现了可变大小的数组，随机访问和遍历元素时，提供更好的性能。该类也是非同步的,在多线程的情况下不要使用。ArrayList 增长当前长度的50%，插入删除效率低。 |
|          | **AbstractSet** 继承于AbstractCollection 并且实现了大部分Set接口。 |
|          | HashSet 该类实现了Set接口，不允许出现重复元素，不保证集合中元素的顺序，允许包含值为null的元素，但最多只能一个。 |
|          | LinkedHashSet 具有可预知迭代顺序的 `Set` 接口的哈希表和链接列表实现。 |
|          | TreeSet 该类实现了Set接口，可以实现排序等功能。              |
|          | **AbstractMap** <br/>实现了大部分的Map接口。                 |
|          | HashMap <br/>HashMap 是一个散列表，它存储的内容是键值对(key-value)映射。<br/>该类实现了Map接口，根据键的HashCode值存储数据，具有很快的访问速度，最多允许一条记录的键为null，不支持线程同步。 |
|          | TreeMap <br/>继承了AbstractMap，并且使用一颗树。             |
|          | WeakHashMap  继承AbstractMap类，使用弱密钥的哈希表。         |
|          | LinkedHashMap <br/>继承于HashMap，使用元素的自然顺序对元素进行排序. |
|          | IdentityHashMap <br/>继承AbstractMap类，比较文档时使用引用相等。 |


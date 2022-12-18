# Java 字符串池

在工作中，String类是我们使用频率非常高的一种对象类型。JVM为了提升性能和减少内存开销，避免字符串的重复创建，其维护了一块特殊的内存空间，这就是我们今天要讨论的核心，即字符串池（String Pool）。字符串池由String类私有的维护。

在Java中有两种创建字符串对象的方式:

1.  采用字面值的方式赋值

```java
public class StringTest{
    public static void main(String[] args){
        String str = "aaa";
        String str2 = "aaa";
        System.out.println(str == str2);
    }
}
```
采用字面值的方式创建一个字符串时，**JVM首先会去字符串池中查找是否存在"aaa"这个对象，如果不存在，则在字符串池中创建"aaa"这个对象，然后将池中"aaa"这个对象的引用地址返回给字符串常量str**，这样str会指向池中"aaa"这个字符串对象；如果存在，则不创建任何对象，直接将池中"aaa"这个对象的地址返回，赋给字符串常量。

2.  采用new关键字新建一个字符串对象

```java
public class StringTest2{
    public static void main(String[] args){
        String str3 = new String("aaa");
        String str4 = new String("aaa");
        System.out.prinln(str3 == str4);

    }
}
```

采用new关键字新建一个字符串对象时，JVM首先在字符串池中查找有没有"aaa"这个字符串对象，如果有，则不在池中再去创建"aaa"这个对象了，直接在**堆中创建一个"aaa"字符串对象**，然后**将堆中的这个"aaa"对象的地址返回赋给引用str3**，这样，**str3就指向了堆中创建的这个"aaa"字符串对象**；如果没有，则首先在字符串池中创建一个"aaa"字符串对象，然后再在**堆中创建一个"aaa"字符串对象**，然后将堆中这个"aaa"字符串对象的地址返回赋给str3引用，这样，str3指向了堆中创建的这个"aaa"字符串对象。

字符串池的实现有一个前提条件：**String对象是不可变的**。因为这样可以保证多个引用可以同事指向字符串池中的同一个对象。如果字符串是可变的，那么一个引用操作改变了对象的值，对其他引用会有影响，这样显然是不合理的。

**字符串池的优缺点**：字符串池的优点就是避免了相同内容的字符串的创建，节省了内存，省去了创建相同字符串的时间，同时提升了性能；另一方面，字符串池的缺点就是牺牲了JVM在常量池中遍历对象所需要的时间，不过其时间成本相比而言比较低。

intern方法使用：一个初始为空的字符串池，它由类String独自维护。当调用 intern方法时，如果池已经包含一个等于此String对象的字符串（用equals(oject)方法确定），**则返回池中的字符串**。否则，将此String对象添加到池中，并返回此String对象的引用。 对于任意两个字符串s和t，当且仅当s.equals(t)为true时，s.instan() == t.instan才为true。所有字面值字符串和字符串赋值常量表达式都使用 intern方法进行操作。

**GC回收**：字符串池中维护了共享的字符串对象，这些字符串不会被垃圾收集器回收。

# StringBuffer 和 StringBuilder

当对字符串进行修改的时候，需要使用StringBuffer 和 String Builder 类。
和 String 类不同的是，StringBuffer 和 StringBuilder 类的对象能够被多次的修改，并且不产生新的未使用对象。


在使用 StringBuffer 类时，每次都会对 StringBuffer 对象本身进行操作，而不是生成新的对象，所以如果需要对字符串进行修改推荐使用 StringBuffer。

StringBuilder 类在 Java 5 中被提出，它和 StringBuffer 之间的最大不同在于 StringBuilder 的方法不是线程安全的（不能同步访问）。

由于 StringBuilder 相较于 StringBuffer 有速度优势，所以多数情况下建议使用 StringBuilder 类。


The Java compiler converts source code to byte code.


Java 10 feature
* var
* Consumer<T>
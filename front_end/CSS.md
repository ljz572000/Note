# 介绍

（Cascading Style Sheets）`css`可以用来为网页创建样式表，通过样式表可以对网页进行装饰。

# 三种格式

**内联样式**

将`css`样式编写到元素的style属性当中

不方便后期的维护，不推荐使用

**内部样式**

将CSS样式编写到head中的style标签里

将样式表编写到style标签中，也可以使表现和结构进一步分离它也是我们推荐的使用方式

**外部样式表**

将样式表编写到外部的CSS文件中

```html
<link rel=”stylesheet”	type=”text/css”	href=”style.css”>
```

# CSS选择器

## 元素选择器

作用:通过元素选择器可以选择页面中的所有指定元素

```css
p{
color: red;
}
```

## id 选择器

作用:通过元素的id属性值选中唯一的一个元素

```css
#p1{
font-size: 30px;
} 
```

## 类选择器

通过元素的class属性值选中一组元素

```css
.p2{
	color: red;
}
.hello{
	font-size: 30px;
}
```

## 选择器分组

通过选择器分组可以同时选中多个选择器对应的元素

```css
#p1,.p2,h1{
		background-color: yellow;
}
```

## 通配选择器

它可以用来选中页面中的所有元素

```css
*{}
```

## 复合选择器(交集选择器)

可以选中同时满足多个选择器的元素

```css
.p3{
	   background-color: yellow;
   } 
   span.p3{
	   background-color: blue;
   }
```

## 元素之间的关系

父元素：直接包含子元素的元素

子元素：直接被父元素包含的元素

祖先元素：直接或间接包含后代的元素的元素，

​		父元素也是祖先元素

后代元素：直接或间接被祖先元素包含的元素，

​		子元素也是后代元素

兄弟元素：拥有相同父元素的元素叫做兄弟元素

## 后代元素选择器

选中指定元素的后代元素

```css
#d1 span{
		color: red;
}
#d1 p span{
		font-size: 30px;
}
```

## 子元素选择器

选中指定父元素的指定子元素

语法：

​	父元素	> 子元素

## 子元素的伪类

### :first-child

可以选中第一个子元素

### :last-child

可以选中最后一个子元素

### :nth-child(n)

可以选中任意位置的子元素

该选择器后边可以指定一个参数,指定要选中第几个元素

even表示偶数位置的子元素

odd表示奇数位置的子元素

:first-of-type 

:last-of-type 

:nth-of-type

和first-child这些非常类似，只不过child,是在所有的子元素中排列,而type,是在当前类型的子元素中排列

## 兄弟元素选择器

为span后的一个p元素设置一个背景颜色为黄色

后一个兄弟选择器

作用：可以选中一个元素后紧挨着的指定的兄弟元素

语法：	前一个+后一个

​			

选中后边的所有兄弟元素

语法：前一个~后边所有

```css
<style>
span ~ p{
			 background-color: aqua
		 }
</style>
```

## 属性选择器

为所有具有title属性值的p元素，设置一个背景颜色为黄色

title属性，这个属性可以给任何标签指定

当鼠标移入到元素上时，元素中的title属性值将会作为提示文字显示

属性选择器

作用：可以根据元素中的属性或属性值来选取指定元素

[属性名] 选取含有指定属性的元素

[属性名="属性值"] 选取含有指定属性值的元素

[属性名^="属性值"]	选取属性值以指定内容开头的元素

[属性名$="属性值"]	选取属性值以指定内容结尾的元素

[属性名*="属性值"]	选取属性值包含指定内容的元素

```css
p[title]{
	background-color: red
} 
p[title=hello]{
	 background-color: green;
}
/*
 为title属性值以he开头的元素设置一个背景颜色为黄色
*/
 p[title^='he']{
	background-color: yellow; 
}
		 
/*
为title属性值以o结尾的元素设置一个背景颜色为黄色
 */
p[title$='o']{
	background-color: yellow; 
}
/*
为title属性值包含he的元素设置一个背景颜色为黄色
*/
p[title*='he']{
	background-color: yellow; 
}
```

## 伪类选择器

伪类专门用来表示元素的一种特殊状态

### :link

表示普通的链接（没访问过的链接）

### :visited

表示访问过的链接（浏览器是通过历史记录来判断一个链接是否被访问过）

由于涉及到用户隐私问题，所以使用visited伪类只能设置字体颜色

### :hover

表示鼠标移入的状态

### :active

表示超链接被点击的状态

### :focus

表示获取焦点

### ::selection

表示选中状态

**注意**：  hover和active也可以为其他元素设置

IE6中，不支持对超链接以外的元素设置hover和active

#### 伪类的顺序

**涉及到a的伪类一共有四个**

:link   :visited  :hover  :active

而这四个选择器的优先级

```css
 a:link{
color: red;
}
a:visited{
color: green;
}
a:hover{
color:blue;
}
a:active{
color: black;
}
input:focus{
 background-color:aqua;
}
p::selection{
	  background-color:orange;
}
</style>
</head>
<body>
<a href="#">访问过的链接</a>
<br>
<br>
<a href="#">没访问过的链接</a>
<br>
<!--文本框获取焦点以后，修改背景颜色-->
<input type="text" />
	<p>我是一个段落</p>
</body>
```

# 伪元素

使用伪元素来表示元素中的一些特殊的位置

## first-letter

为p中的第一个字符设置一个特殊的样式

```css
p:first-letter {
			font-size: 20px;
} 
```

## first-line

为p中的第一行设置一个背景颜色为黄色

```css
p:first-line {
			color: red;
}
```

## before

表示元素最前边的部分

## after

表示元素最后边的部分

**一般结合content这个样式一起使用**

**通过content可以向before或after的位置添加一些内容**

```html
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title></title>
		<style type="text/css">
		 p:before{
			 content: 'p:before';
		 }
		 p:after{
			 content:'p:after';
		 }
		</style>
	</head>
	<body>

		<p>我是一个段落
			<br>
			我是一个段落
			我是一个段落
			我是一个段落 
			我是一个段落</p>
	</body>
</html>
```

# **否定伪类**

作用：可以从已选中的元素中剔除出某些元素

```css
p:not(.hello){
			 background-color:red;
}
```

# **样式的继承**

像儿子可以继承父亲的遗产一样，在CSS中，祖先元素上的样式，

也会被他的后代元素所继承

利用继承，可以将一些基本的样式设置给祖先元素，这样所有的后代

元素将会自动继承这些样式

但是并不是所有样式都会被子元素所继承，比如：背景相关的样式，就不会被继承

# **选择器的优先级**

内联样式，优先级	1000

id选择器，优先级	100

类和伪类，优先级	10

元素选择器，	优先级	1

通配符*，	优先级	0

继承的样式没有优先级

# 长度单位

## 像素px

一个像素就相当于我们屏幕中的一个小点

我们的屏幕实际上就是由这些像素点构成的

但是这些像素点，是不能直接看见。

不同显示器一个像素的大小也不相同，

显示效果越好越清晰，像素就越小，反之像素越大

## 百分比%

也可以将单位设置为一个百分比的形式，

这样浏览器将会根据其父元素的样式来计算该值

当父元素属性发生变化时，子元素也会按照比例发生改变

在我们创建一个自适应的页面时，经常使用百分比作为单位

## em

em和百分比类似，它是相对于当前元素的字体大小来计算

1em=1 font-size

使用em时，当字体大小发生改变时，em也会随之改变

当设置字体相关的样式，经常会使用em

# 十六进制RGB值

在CSS可以直接使用颜色的单词来表示不同的颜色

也可以使用RGB值来表示不同的颜色

所谓RBG值指的是通过Red Green Blue 三原色

## 浓度

也可以采用一个百分数来设置，需要以个0%-100%之间的数字

使用百分数最终也会转换为0-255之间的书

0%表示0

100%表示255

## 十六进制

00表示没有，相当于rgb中的0

ff表示最大，相当于rgb中的255

像这种两位重复的颜色，可以简写

比如：#ff0000 可以写成#f00

#abd #aabbcc

# 字体

设置文字大小，浏览器一般默认的文字大小都是16px;

font-size设置的并不是文字本身的大小

在页面中，每个文字都是处在一个看不见的框中，我们设置的font-size实际上是**设置格的高度**，并不是字体的大小

该样式可以同时指定多个字体，多个字体之间使用“，”分开

当采用多个字体时，浏览器会优先使用前边的字体，

如果前边没有在尝试下一个

# 字体分类(font-family)

字体分成5大分类

* serif(衬线字体)

* sans-serif（非衬线字体）

* monospace（等宽字体）

- cursive（草书字体）

- fantasy（虚幻字体）

```html
<p style="font-size: 50px;font-family: serif;">serif(衬线字体)</p>
<p style="font-size: 50px;font-family: sans-serif;">sans-serif（非衬线字体）</p>
<p style="font-size: 50px;font-family: monospace;">monospace（等宽字体）</p>
<p style="font-size: 50px;font-family: cursive;">cursive（草书字体）</p>
<p style="font-size: 50px;font-family: fantasy;">fantasy（虚幻字体）</p>
```

# 字体样式

## font-style

可选值：

normal:默认值，文字正常显示

italic:文字以斜体显示

oblique:文字会以倾斜效果显示

## font-weight

可以用来设置文字的加粗效果

可选值:

normal 默认值，文字正常显示

bold 文字加粗显示

## font-variant

设置小型大写字母

**tips**

在CSS中还为我们提供了一个样式叫font

使用该样式可以同时设置字体相关的所有样式

可以将字体的样式的值，统一写在font的样式中。

不同的值之间使用空格隔开，

使用font设置样式时，斜体加粗 小型大写字母 没有顺序要求 甚至可写可不写

如果不写则使用默认值，但是文字的大小和字体必须写，

而且字体必须是最后一个样式

大小必须是倒数第二个

实际上使用简写也会有一个比较好的性能

font: italic small-caps bold 60px sans-serif;

# 行高

在CSS并没有为我们提供一个直接设置行间距的方式

我们只能通过设置行高来间接设置行间距，行高越大行间距越大

使用**line-height**来设置行高

**行间距= 行高-字体大小**

```css
.p1{
	   font-size: 20px;
	   line-height: 1.5;
}

```

对于单行文本来说，可以将行高设置为和父元素的高度一致

这样可以使单行文本在父元素中垂直居中

```
.box{
   width:200px;
   height: 200px;
   background-color: #bfa;
   line-height: 200px;
}
```

在font中也可以指定行高

在字体大小后也可以添加/行高，来指定行高，该值使可选的

如果不指定则使用默认值

# 文本样式

## text-transform

可选值：

* none 默认值

- capitalize 单词首字母大写，通过空格来识别

- uppercase 所有单词的字母都大写

- lowercase 所有的字母都小写

## text-decoration

- none：默认值

- underline: 为文本添加下划线

- overline:为文本添加上划线

- line-through:为文本添加删除线

##  letter-spacing

 letter-spacing: 10px;

可以指定字符间距

## word-spacing

可以设置单词之间的距离

实际上就是设置词与词之间空格的大小

## text-align

用于设置文本的对齐方式

可选值

left，文本默认左对齐

right:文本靠右对齐

center:文本居中对齐

justify:两端对齐

通过调整文本之间的空格的大小,来达到一个两端对齐的目的

## text-indent

用来设置首行缩进

当给它指定一个正值时，会自动向右侧缩进指定的像素

如果为它指定一个负值。则会向左移动指定的像素，

通过这种方式可以将一些不想显示的文字隐藏起来

# 盒子模型-边框

![1566874392634](box-model.png)

使用width来设置盒子内容区的宽度

使用height来设置盒子内容区的高度

width和height只是设置的盒子内容区的大小，而不是盒子整个的大小，盒子可见框的大小由内容区，内边框和边框共同决定

## border

border-width:边框的宽度

border-color:边框的颜色

border-style:边框的样式

### border-width

- 指定了四个值，则四个值分别设置给上右下左，按照顺时针的方向设置

* 指定了三个值：上 左右 下

- 两个值设置: 上下 左右

- 指定一个值: 四边全都是该值

除了border-width，在CSS中还提供了四个border-xxx-width

xxx的值可能是top right bottom left 

专门来设置指定边的宽度

### border-style

可选值：

* none: 默认值，没有边框

* solid: 实线

* dotted 点状边框

* dashed 虚线

* double 双线

* style也可以分别设置指定的四个边框的样式

### 边框的简写样式

通过它可以同时设置四个边框的样式，宽度，颜色

而没有颜色要求

# 盒模式-内边距padding

内边距（padding),指的是盒子的内容区与盒子边框之间的距离

一共有四个方向的内边距，可以通过，

padding-top

padding-right

padding-bottom

padding-left

来设置四个方向的内边距

内边距会**影响盒子的可见性的大小**，元素的背景会延伸到内边距

盒子的大小由内容区，内边距和边框共同决定

盒子可见框的宽度=border-left-wdith+padding-left-width+

border-right-width+padding-right-width

盒子可见框的高度	= border-top-wdith...

# 盒模式-外边距

外边距指的是当前盒子与其他盒子之间的距离，他不会影响可见框的大小，而会影响到盒子的位置

盒子有四个方向的外边距：

margin-top

margin-right

margin-bottom

margin-left

设置负值往反方向移动

margin还可以设置为auto,auto一般只设置给水平方向的margin

如果只指定，左外边距或右外边距的margin为auto则会将外边距设置为最大值

如果垂直方向设置为auto,则外边距默认就是0

如果将left和right同时设置为auto,则会将两侧的外边距设置为相同的值，就可以使元素自动在父元素中居中，所以我们经常将左右外边距设置成auto,以使子元素在父元素中水平居中

# 垂直外边距的重叠

网页中垂直方向的相邻外边距会发生外边距的重叠

所谓的外边距重叠指兄弟元素之间的相邻外边距会取最大值而不是取和

如果父子元素的垂直外边距相邻了，则子元素的外边距会设置给父元素

# 浏览器默认样式

浏览器为了在页面中没有样式时，也可以有一个比较好的显示效果，所以为很多的元素都设置了一些默认的margin和padding

而它的默认样式正常情况下我们是不需要使用的

需要去掉默认的margin和padding

# 内联元素的盒模型

内联元素不能设置width和height

# display和visibility

内联元素不支持宽高

通过display样式可以设置修改元素的类型

可选值：

inline:可以将一个元素作为内联元素显示

block:可以将一个元素设置块元素显示

inline-block:将一个元素转换为行内元素

可以使一个元素既有行内元素的特点又有块元素的特点

既可以设置宽高，又不会独占一行

none:不显示元素，并且元素不会在页面中继续占有位置

visibility

可以用来设置元素的隐藏和显示的状态

可选值：	

visible: 默认值，元素默认会在页面显示;

hidden 元素会隐藏不显示

使用visibility和hidden 隐藏的元素虽然不会在页面中显示

但是它的位置会依然保持

# Overflow

子元素默认是存在于父元素的内容去中，理论上讲子元素的最大可以等于父元素内容区大小

如果子元素的大小超过了父元素的内容区，则超过的大小会在父元素以外的位置显示

超出父元素的内容，我们称为溢出的内容；

父元素默认使将溢出的内容，在父元素外边显示

可以通过overflow可以设置父元素如何处理溢出内容：

可选值：

visible 默认值，不会对溢出内容做出处理

hidden 溢出的内容，会被修剪，不会显示

scroll 会为父元素添加滚动条，通过拖动滚动条来查看完整内容

该属性不论内容是否溢出，都会添加水平和垂直双方向的滚动条

auto,会根据需求自动添加滚动条,需要水平就添加水平,需要垂直就添加垂直

# 文档流

文档流处在网页的最底层，它表示的是一个页面中的位置

我们所创建的元素默认都是处在文档流中

元素在文档流中的特点

块元素

1.块元素在文档流中会独占一行，块元素会自上向下排列

2.块元素在文档流中默认宽度是父元素的100%

3.块元素在文档流中的高度默认被内容撑开

内联元素

1.内联元素在文档流中只占自身的大小，会默认从左向右排列

如果一行不足以容纳所有的内联元素，则会换到下一行，

继续自左向右

2.内联元素在文档流中的高度默认被内容撑开

当元素的高度或宽度的值为auto时。此时指定的内边距不会影响可见框的大小

但是会自动修改宽度，以适应内边距

		<div style="background-color: #BBFFAA;padding-left:200px;">a</div>
	
		<div style="width: 100px;height: 100px;background-color: #FFFF00"></div>

​		<span style="background-color: yellowgreen">我是一个span</span>

​		<span style="background-color: yellowgreen">我是一个span</span>

​		<span style="background-color: yellowgreen">我是一个span</span>

# 浮动

块元素在文档流中默认是**垂直排列**，所以这个**三个div自上而下排开**

如果希望块元素在页面中水平排列，可以使用块元素脱离文档流

使用**float来使元素浮动，从而脱离文档流**

可选值

* none:默认值，元素默认在文档流中排列

* left：元素会立即脱离文档流，向页面的左侧浮动

* right：元素会立即脱离文档流，向页面的右侧浮动

当为一个元素设置浮动以后（float属性是一个非none的值）

元素会立即脱离文档流，元素脱离文档流以后，他下边的元素会立即向上移动元素浮动以后，会尽量向页面的左上或右上浮动，

直到遇到父元素的边框或者其他的浮动元素

如果浮动元素上边是一个没有浮动的块元素，则浮动元素不会超过块元素

浮动元素不会超过他上边的兄弟元素，最多一边齐

浮动的元素不会盖住文字，文字会自动环绕在浮动元素的周围

所以我們可以通過浮動來設置文字環繞圖片的效果

# 高度坍塌问题

在文档流中，父元素的高度默认是被子元素撑开的，也就是子元素多高，父元素就多高. 但是当为子元素设置浮动以后，子元素就会完全脱离文档流此时将会导致子元素无法撑起父元素的高度，导致父元素的高度塌陷, 由于父元素塌陷了，则父元素下的所有元素都会向上移动，导致布局紊乱

所以一定要避免高度塌陷的问题

我们可以将父元素的高度写死，以避免塌陷的问题出现

但是一旦高度写死，父元素的高度将不能自动适应子元素的高度

所以该方案不推荐使用

## 解决高度坍塌问题

根据W3C的标准，在页面中元素都隐含一个属性叫Block formatting Context

简称BFC，该属性可以设置打开或者关闭，默认是关闭的。

当开启元素的BFC以后，元素将会具有如下的特性：

1.父元素的垂直外边距不会和子元素重叠

2.开启BFC的元素不会被浮动元素所覆盖

3.开启BFC的元素可以包含浮动的子元素			

如何开启元素的BFC

 1.设置元素浮动

使用这种方式开启，虽然可以撑开父元素，但是会导致父元素的宽度丢失,而且使用这种方式也会导致下边的元素上移，不能解决问题。

2.设置元素绝对定位

3.设置元素为inline-block

使用这种方式开启，虽然可以撑开父元素，但是会导致父元素的宽度丢失

4.将元素的overflow设置为一个非visible的值

推荐使用：将overflow设置为hidden是副作用最小的开启BFC的方式。

但是IE6并不支持

在IE6中虽然没有BFC，但是具有另一个隐含的属性叫Has Layout

该属性的作用和BFC类似，所以IE6浏览器可以通过开启Has Layout来解决该问题

开启方式很多，我们直接使用一种副作用最小的，

直接将元素的zoom设置为1即可。

zoom表示放大的意思,后边跟着一个数值,写几就将元素放大几倍

zoom:1表示不放大元素,但是通过该样式可以开启hasLayout

## 解决高度塌陷的最终方案

### 1.0

由于受到box1的影响，box2整体向上移动了100px,

我们有时希望清楚其他元素浮动对当前元素产生的影响，这时可以使用clear来完成

clear可以用来清除其他元素对当前元素的影响

可选值：

* none,	默认值，不清楚浮动

* left,	清除左侧浮动元素对当前元素的影响

* right，	清除右侧浮动元素对当前元素的影响

* both，	清除两侧浮动元素对当前元素的影响

​		清除对它影响最大的那个元素的浮动

```html
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title></title>
		<style type="text/css">
			.box1 {
				width: 100px;
				height: 100px;
				background-color: yellow;
				/**
				 * 设置box1向左浮动
				 */
				float: left; 
			}

			.box2 {
				width: 200px;
				height: 200px;
				background-color: yellowgreen;
				/**
				 * 由于受到box1的影响，box2整体向上移动了100px,
					我们有时希望清楚其他元素浮动对当前元素产生的影响，这时可以使用clear来完成
					clear可以用来清除其他元素对当前元素的影响
					可选值：
						none,	默认值，不清楚浮动
						left,	清除左侧浮动元素对当前元素的影响
						right，	清除右侧浮动元素对当前元素的影响
						both，	清除两侧浮动元素对当前元素的影响
									清除对它影响最大的那个元素的浮动
				 */
				
				/* 清除box1对box2产生的影响 
					清除浮动以后，元素会回到其他元素浮动之前的位置
				*/
				/* clear:left; */
				float: right;
			}

			.box3 {
				width: 300px;
				height: 300px;
				background-color: skyblue;
				clear: left;
			}
		</style>
	</head>
	<body>
		<div class="box1"></div>
		<div class="box2"></div>
		<div class="box3"></div>
	</body>
</html>
```

### 2.0

```html
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title></title>
		<style type="text/css">
			.box1{
				border: 1px solid red;
			}
			.box2{
				width: 100px;
				height: 100px;
				background-color: blue;
				
				float: left;
			}
			/* 解决高度塌陷方案二:
				可以直接在高度塌陷的父元素的最后,添加一个空白的div
				由于这个div并没有浮动,所以他是可以撑开父元素的高度的
				然后在对其进行清楚浮动,这样可以通过空白的div来撑开父元素的高度
				基本没有副作用
				 
				 使用这种方式虽然可以解决问题，但是会在页面中添加多余的结构。
			*/
			.clear{
				clear: both;
			}
		</style>
	</head>
	<body>
		<div class="box1">
			<div class="box2"></div>
			<div class="clear"></div>
		</div>
	</body>
</html>
```

### 3.0

```html
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title></title>
		<style type="text/css">
			.box1{
				border: 1px solid red;
			}
			.box2{
				width: 100px;
				height: 100px;
				background-color: blue;
				
				float: left;
			}
			/* 通过after伪类,选中box1的后边 */
			/* 可以通过after伪类向元素的最后添加一个空白的块元素,然后对其清除浮动
				这样做和添加一个div的原理一样,可以达到一个相同的效果
				而且不会在页面中添加多余的div,这是我们最推荐使用的方式,几乎没有副作用 */
			.clearfix:after{
				/* 添加一个内容 */
				content: "";
				/* 转换为一个块元素 */
				display: block;
				/*清除两侧的浮动*/
				clear: both;
			}
			/* 在IE6中不支持after伪类, 
				所以在IE6中还需要使用hasLayout来处理 */
			.clearfix{
				zoom: 1;
			}
		</style>
	</head>
	<body>
		<div class="box1 clearfix">
			<div class="box2"></div>
		</div>
	</body>
</html>
```



# 导航条练习

```html
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>导航条</title>
		<style type="text/css">
			/* 2.清楚默认样式 */
			*{
				margin: 0;
				padding: 0;
			}
			/* 设置ul */
			.nav{
				list-style: none;
				background-color: #6495ED;
				width: 1000px;
				/*
				在IE6中，如果为元素指定了一个宽度，则默认开启haslayout
				*/
				/* 设置居中 */
				margin: 50px auto;
				overflow: hidden;
			}
			.nav li{
				/* 设置li向左浮动 */
				float: right;
				/* 会出现高度塌陷问题 */
				width: 12.5%;
			}
			.nav a{
				/* 将a转换为块元素 */
				display: block;
				/* 为a指定一个宽度 */
				width: 100%;
				/*设置文字居中*/
				text-align: center;
				/* 设置一个上下内边距 */
				padding: 5px 0;
				/* 去除下划线 */
				text-decoration: none;
				/*设置字体颜色*/
				color: white;
				font-weight: bold;
			}
			/*使用伪类，当鼠标移动时变色*/
			.nav a:hover{
				background-color: darkred;
			}
		</style>
	</head>
	<body>
		
		<!--1.创建导航条的结构-->
		<ul class="nav">
			<li><a href="#">首页</a></li>
			<li><a href="#">新闻</a></li>
			<li><a href="#">联系</a></li>
			<li><a href="#">关于</a></li>
			<li><a href="#">首页</a></li>
			<li><a href="#">新闻</a></li>
			<li><a href="#">联系</a></li>
			<li><a href="#">关于</a></li>
		</ul>
	</body>
</html>
```

# 开班信息-标题

```html
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title></title>
		<style type="text/css">
			/* 清除默认样式 */
			* {
				margin: 0;
				padding: 0;
			}

			/* 统一所有元素的字体 */
			body {
				/* 12像素/1倍行高 */
				font: 12px/1 "microsoft yahei";
			}

			/* 设置outer的大小 */
			.outer {
				width: 300px;
				/* height: 473px; */
				/* background-color: #bfa; */
				/* 设置outer居中 */
				/* 上下0左右auto */
				margin: 50px auto;
			}

			/* 设置title的边框 */
			.title {
				/* 设置上边框 */
				border-top: 2px #019e8b solid;
				/* 设置盒子高度 */
				height: 36px;
				/* 设置背景样式 */
				background-color: #f5f5f5;
				/* 设置行高 */
				/* 然后标题中的元素居中 */
				/* 行高和父元素一致 */
				line-height: 36px;
				/*设置titlte的内边距*/
				padding: 0px 22px 0px 16px;
				/* 不会溢出因为没有设置宽度 */
			}

			/* 设置title的超链接 */
			.title a {
				float: right;
				/* 设置字体颜色 */
				color: red;
			}

			/* 设置h3 */
			.title h3 {
				font: 16px/36px "microsoft yahei";
			}

			/* 设置内容 */
			.content {
				border: 1px solid #deddd9;
				/* 设置内边距 */
				padding: 0px 28px 0px 20px;
			}

			/* 设置内容中的超链接 */
			.content a {
				color: black;
				/* 去除超链接的下划线 */
				text-decoration: none;
				/* 设置字体大小 */
				font-size: 12px;
			}
			
			/* 为超链接添加一个伪类 */
			.content a:hover{
				color: red;
				/* 为超链接添加下划线 */
				text-decoration: underline;
			}
			
			/* 设置内容中的标题 */
			.content h3{
				margin-top: 14px;
				margin-bottom: 16px;
			}

			/* 设置右侧a的样式 */
			.content .right {
				/* 设置一个向右浮动 */
				float: right;
			}

			/* 设置ul样式 */
			.content ul {
				/* 去除项目框 */
				list-style: none;
				/* 为ul设置一个下边框 虚线dashed*/
				border-bottom: 1px dashed #DEDDD9;
				
			}
			
			.content .no-border {
				border: none;
			}
			

			/* 设置内容中的红色字体 */
			.content .red {
				color: red;
				font-weight: bold;
			}
			/* 设置内容中的li */
			.content li{
				margin-bottom: 15px;
			}
		</style>
	</head>
	<body>
		<!-- 创建一个外层div，容纳整个内容 -->
		<div class="outer">
			<!--  开班信息的头部 -->
			<div class="title">
				<a href="#">16年面授开班计划</a>
				<h3>近期开班</h3>

			</div>
			<!-- 开班信息的主要内容 -->
			<div class="content">
				<h3><a href="#">JavaEE+云计算-全程就业班</a></h3>
				<ul>
					<li>
						<a class="right" href="#"><span class="red">预约报名</span></a>
						<a href="#">开班时间： <span class="red">2016-04-27</span></a>
					</li>
					<li>
						<a class="right" href="#"><span class="red">无座，名额爆满</span></a>
						<a href="#">开班时间： <span class="red">2016-04-27</span></a>
					</li>
					<li>
						<a class="right" href="#"><span >开班盛况</span></a>
						<a href="#">开班时间： <span >2016-04-27</span></a>
					</li>
					<li>
						<a class="right" href="#"><span >开班盛况</span></a>
						<a href="#">开班时间： <span >2016-04-27</span></a>
					</li>
					<li>
						<a class="right" href="#"><span >开班盛况</span></a>
						<a href="#">开班时间： <span >2016-04-27</span></a>
					</li>
				</ul>
				<h3><a href="#">Android+人工智能-全程就业班</a></h3>
				<ul>
					<li>
						<a class="right" href="#"><span class="red">预约报名</span></a>
						<a href="#">开班时间： <span class="red">2016-04-27</span></a>
					</li>
					<li>
						<a class="right" href="#"><span >开班盛况</span></a>
						<a href="#">开班时间： <span >2016-04-27</span></a>
					</li>
					<li>
						<a class="right" href="#"><span >开班盛况</span></a>
						<a href="#">开班时间： <span >2016-04-27</span></a>
					</li>
					<li>
						<a class="right" href="#"><span >开班盛况</span></a>
						<a href="#">开班时间： <span >2016-04-27</span></a>
					</li>
				</ul>
				<h3><a href="#">前端+HTML5-全程就业班</a></h3>
				<ul class="no-border">
					<li>
						<a class="right" href="#"><span class="red">预约报名</span></a>
						<a href="#">开班时间： <span class="red">2016-04-27</span></a>
					</li>
					<li>
						<a class="right" href="#"><span >开班盛况</span></a>
						<a href="#">开班时间： <span >2016-04-27</span></a>
					</li>
				</ul>
			</div>
		</div>
	</body>
</html>
```

# 定位position

定位指的是将指定元素摆放到页面的任意位置

通过定位可以任意的摆放元素

通过position属性来设置元素的位置

可选值：

static:默认值，元素没有开启定位

relative：开启元素的相对定位

absolute：开启元素的绝对定位

fixed:开启元素的固定定位（也是绝对定位的一种)

## 相对定位

当我们元素的position属性设置为relative时,则开启了元素的相对定位

1.当开启了元素的相对定位以后，而不设置偏移量时，元素不会发生任何移动

2.相对定位是相对于元素在文档中的原来的位置进行的定位

3.相对定位的元素不会脱离文档流

4.相对定位会使元素提升一个层级

5.相对定位不会改变元素的性质，快还是块，内联元素还是内联元素

当开启了元素的定位(position属性值是一个非static的值)时,
可以通过left right top bottom 四个属性来设置元素的偏移量
left元素相对于其定位位置的左侧偏移量
right元素相对于其定位位置的右侧偏移量
top元素相对于其定位位置的顶部偏移量
bottom元素相对于其定位位置的底部偏移量 

通常偏移量只需要使用两个就可以对一个元素进行定位了
一般会选择一个水平方向的偏移量和一个垂直方向的偏移量

```html
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title></title>
		<style type="text/css">
			.box1 {
				width: 200px;
				height: 200px;
				background-color: red;
			}
			.box2 {
				width: 200px;
				height: 200px;
				background-color: yellow;
				position:relative;
		left: 200px;
		top: 200px;				
}
.box3 {
	width: 200px;
	height: 200px;
	background-color: blue;
}
</style>
</head>
<body>
		<div class="box1"></div>
		<div class="box2"></div>
		<div class="box3"></div>
	</body>
</html>
```

## 绝对定位

当position属性设置为absolute时,则开启了元素的绝对定位

绝对定位:

1.开启绝对定位,会使元素脱离文档流

2.开启绝对定位以后,如果不设置偏移量,则元素的位置不会发生变化 

3.绝对定位是相对于离他最近的开启了定位的祖先元素进行定位的

(一般开启了子元素的绝对定位，都会开启父元素的相对定位）

如果所有的祖先元素都没有开启定位，则相对于浏览器坐标原点定位的

4.绝对定位会使元素提升一个层级

5.绝对定位会改变元素的性质，内联元素变成块元素

块元素的宽度和高度都被内容撑开

```html
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title></title>

		<style type="text/css">
			.box1 {
				width: 200px;
				height: 200px;
				background-color: red;
			}

			.box2 {
				width: 200px;
				height: 200px;
				background-color: yellow;
				/* */
					
				position: absolute;
				left: 0px;
			}

			.box3 {
				width: 300px;
				height: 300px;
				background-color: yellowgreen;
			}
			.box4{
				width: 300px;
				height: 300px;
				background-color: orange;
				/* 开启box4的相对定位 */
				position: relative;
			}
		</style>

	</head>
	<body>
		<div class="box1"></div>
		<div class="box4">
			<div class="box2"></div>
		</div>
		
		<div class="box3"></div>
	</body>
</html>
```

## 固定定位

当元素的position属性设置为fixed时,则开启了元素的固定定位

固定定位也是一种绝对定位，他的特点和绝对定位一样

不同的是：

固定定位永远都会相对于浏览器窗口进行定位

固定定位会固定在浏览器窗口某个位置，不会随滚动条滚动

例如：中奖广告 IE6不支持

```html
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title></title>
		<style type="text/css">
			.box1 {
				width: 200px;
				height: 200px;
				background-color: red;
			}
			.box2 {
				width: 200px;
				height: 200px;
				background-color: yellow;
				position: fixed;	
				left: 0px;
				top: 0px;
			}
			.box3 {
				width: 200px;
				height: 200px;
				background-color: yellowgreen;
			}
		</style>
	</head>
	<body style="5000px">
		<div class="box1"></div>
		<div class="box4" style="width: 300px;height: 300px; position: relative; background-color: orange;">
			<div class="box2"></div>
		</div>
		<div class="box3"></div>
	</body>
</html>
```

# 元素的层级

如果定位元素的层级是一样的,则下边的元素会盖住上边的元素

通过z-index属性可以用来设置元素的层级

可以为z-index指定一个正整数作为值,该值将会作为当前元素的层级

层级越高,越优先显示		 

对于没有开启定位的元素不能使用z-index

```html
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title></title>
		<style type="text/css">
			.box1 {
				width: 200px;
				height: 200px;
				background-color: red;
				position: relative;

				z-index: 2;
			}

			.box2 {
				width: 200px;
				height: 200px;
				background-color: yellow;
				/* 开启绝对定位 */
				position: absolute;
				top: 100px;
				left: 100px;
				/* */
				z-index: 1;
			}

			.box3 {
				width: 200px;
				height: 200px;
				background-color: yellowgreen;
				position: relative;
			}

			.box4 {
				width: 200px;
				height: 200px;
				background-color: orange;
				position: relative;
				父元素的层级再高也不会盖住子元素
				z-index: 2;
			}

			.box5 {
				width: 100px;
				height: 100px;
				background-color: skyblue;
				position: absolute;
				z-index: 1;
			}
		</style>
	</head>
	<body style="height: 5000px;">
		<div class="box1"></div>
		<div class="box2"></div>
		<div class="box3"></div>
		<div class="box4">
			<div class="box5"></div>
		</div>
	</body>
</html>
```

# 模糊Opacity

opacity可以用来设置元素背景的透明,

它需要一个0-1之间的值

* 0表示完全透明

* 1表示完全不透明

* 0.5表示半透明

 opacity属性在IE8及以下浏览器中不支持

 需要使用如下属性

* alpha(opacity=透明度)

* 0表示完全透明

* 100表示完全不透明

* 50表示半透明

# 背景

使用background-image:来设置背景图片

* 如果背景图片大于元素,默认会显示图片的左上角

* 如果背景图片和元素一样大,则会将背景元素全部显示

* 如果背景图片小于元素大小，则会默认将背景图片平铺以充满元素									

* 可以同时为一个元素指定背景颜色和背景图片,这样背景将会作为背景图片的底色

一般情况下设置背景颜色时都会同时指定一个背景颜色

background通过该样式可以同时设置所有背景相关的样式

-没有先后顺序的要求，谁在前谁在后都行

-也没有数量的要求，不写的样式使用默认值

`background: #bfa url(img/loginlogo.jpg) no-repeat center center fixed;`

## background-repeat

用于设置背景图片的重复方式

可选值:

* repeat:默认值,背景图片会双方向重复(平铺)

* no-repeat:背景图片不会重复

* repeat-x:背景图片沿x轴重复

* repeat-y:背景图片沿y轴重复

```html
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title></title>
		<style type="text/css">
			.box1{
				width: 1920px;
				height: 1080px;
				background-color: #BBFFAA;
				margin: 0px auto;
				background-image: url(img/loginlogo.jpg);
				/* */
				/* */
						background-repeat:repeat-y;
			}
		</style>
		<!-- <link rel="stylesheet" type="text/css" href="css/33.css"/> -->
	</head>
	<body>
		<div class="box1"></div>
	</body>
</html>
```

## background-position

背景图片默认是贴着元素的左上角显示

通过background-position可以调整背景图片在元素中的位置

可选值:

-可以使用top right left bottom center中的两个值

来指定一个背景图片的位置

top left 左上

bottom right 右下

如果只给出一个值，则第二个值默认是center

也可以指定两个偏移量，

第一个值是水平偏移量

-如果指定的是正值，则图片会向右移动指定的像素

-如果指定的是负值，则图片会向左移动指定的像素

第二个值是垂直偏移量

-如果指定的是正值，则图片会向下移动指定的像素

-如果指定的是负值，则图片会向上移动指定的像素

## background-attachment

用来设置背景图片是否随页面一起滚动

可选值:

-scroll,默认值,背景图片随窗口滚动

-fixed,背景图片不随窗口滚动

-设置为fixed时,

背景图片的定位永远相对于浏览器的窗口 					

不随窗体滚动的图片，我们一般都是设置给body，而不是设置给其他元素

# 按钮练习

做完功能以后,发现在第一次切换图片时,会发现图片有一个非常快的闪烁

这个闪烁会造成一次不佳的用户体验

产生问题的原因:

背景图片是以外部资源的形式加载进网页的,浏览器每加载一个外部资源就需要单独的发送一次请求,但是我们外部资源并不是同时加载的,浏览器会在资源被使用时才去加载资源

我们这个练习,一上来浏览器只会加载link.png由于hover和active的状态没有马上触发,

所以hover.png和active.png并不是立即加载的

当hover被触发时,浏览器才去加载hover.png

当active被触发时,浏览器才去加载active.png

由于加载图片需要一定的时间,所以在加载和显示过程会有一段的时间,背景图片无法显示,

导致出现闪烁 

为了解决该问题，可以将三个图片整合为一张图片，

这样可以同时将三张图片一起加载，就不会出现闪烁的问题了

然后通过background-position来切换要显示的图片的位置，这种技术叫做图片整合技术（CSS-Sprite）

优点：

1.将多个图片整合为一张图片里，浏览器只需要发送一次请求，可以同时加载多个图片

提高访问效率，提高用户体验。

2.将多个图片整合为一张图片，减小了图片的总大小，提高请求的速度，增加了用户体验

```html
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title></title>
		<style type="text/css">
			/* */
			
			.btn:link {
				/* 因为a是内联元素,所以首先要将内联元素转换为块元素 */
				display: block;
				/* 设置宽高 */
				width: 32px;
				height: 26px;
				background-color: black;
				background-image: url(img/weibo.gif);
				/* 动态按钮使用a的伪类设置 */
			}

			.btn:hover {
				/* 设置背景图片
				background-image:url(.....); */
				/* 当是hover状态时,希望图片可以向左移动
				
				background-position: -93px 0px; */
			}

			.btn:active {
				/* 设置背景图片
				background-image:url(.....); */
				/* 当是active状态时,希望图片可以向左移动
				
				background-position: -93*2px 0px; */
			}
		</style>
	</head>
	<body>
		<!-- 创建一个超链接 -->
		<a href="https://www.weibo.com/" class="btn"></a>
	</body>
</html>
```

# 雪碧图的制作和使用

```html
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title></title>
		<style type="text/css">
			.box1 {
				width: 76px;
				height: 54px;
				background-image: url(img/css_sprites.png);
			}

			.box2  {
				width: 24px;
				height: 21px;
				background-image: url(img/css_sprites.png);
				background-position: -130px -53px;
			}
		</style>
	</head>
	<body>
		<div class="box1"></div>
		<div class="box2"></div>
	</body>
</html>
```

# 完善clearfix

子元素和父元素相邻的垂直外边距会发生重叠,子元素的外边距会传递给父元素

使用空的table标签可以隔离父子元素的外边距,阻止外边距的重叠 

解决父子元素的外边距重叠

经过修改后的clearfix是一个多功能的

既可以解决高度塌陷,又可以确保父元素和子元素的垂直外边距不会重叠

```css
.box1:before{

		content: "";

/*可以将一个元素设置为表格显示*/

		display: table;
}
```

```html
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title></title>
		<style type="text/css">
			.box1 {
				width: 300px;
				height: 300px;
				background-color: #bfa;
			}
			.box2 {
				width: 200px;
				height: 200px;
				background-color: yellow;
				
				margin-top: 100px;
			}
			.box3{
				border: 10px red solid;
			}
			.box4{
				width: 100px;
				height: 100px;
				background-color: yellowgreen;
				float: left;
			}
			.clearfix:after,
			.clearfix:before{
				content: "";
				display: table;
				clear: both;
			}
			.clearfix{
				zoom:1;
			}
		</style>
	</head>
	<body>
		<div class="box3 clearfix">
			<div class="box4"></div>
		</div>
		<div class="box1 clearfix">
			<div class="box2"></div>
		</div>
	</body>
</html>
```

# display:grid

主要属性：
grid-template-columns：//竖向排列
grid-template-rows：//横向排列

# cursor

cursor 属性规定要显示的光标的类型（形状）

# list-style-type

属性设置**列表项**标记的类型

# border-radius

属性允许您为元素添加圆角边框

# @media

使用 @media 查询，你可以针对不同的媒体类型定义不同的样式。

 @media 可以针对不同的屏幕尺寸设置不同的样式，特别是如果你需要设置设计响应式的页面，@media 是非常有用的。

 当你重置浏览器大小的过程中，页面也会根据浏览器的宽度和高度重新渲染页面。
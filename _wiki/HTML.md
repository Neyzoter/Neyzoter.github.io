---
layout: wiki
title: HTML
categories: HTML
description: HTML语法
keywords: HTML
---

# 1. HTML简介

[HTML 参考手册](http://www.w3school.com.cn/tags/index.asp)

[HTML 全局属性](<http://www.w3school.com.cn/tags/html_ref_standardattributes.asp>)

**HTML**

- HTML 指的是超文本标记语言 (**H**yper **T**ext **M**arkup **L**anguage)
- HTML 不是一种编程语言，而是一种*标记语言* (markup language)
- 标记语言是一套*标记标签* (markup tag)
- HTML 使用*标记标签*来描述网页

**HTML标签tag**

- HTML 标签是由*尖括号*包围的关键词，比如 `<html>`
- HTML 标签通常是*成对出现*的，比如 `<b>` 和` </b>`
- 标签对中的第一个标签是*开始标签*，第二个标签是*结束标签*
- 开始和结束标签也被称为*开放标签*和*闭合标签*

**简单举例**

```html
<html>
<body>

<h1>我的第一个标题</h1>

<p>我的第一个段落。</p>

</body>
</html>
```

- `<html> `与 `</html>` 之间的文本描述网页
- `<body>` 与 `</body> `之间的文本是可见的页面内容
- `<h1>` 与 `</h1>` 之间的文本被显示为标题
- `<p>` 与 `</p>` 之间的文本被显示为段落

# 2. HTML基础

## 2.1 标签

**HTML 标题**

HTML 标题（Heading）是通过` <h1> - <h6> `等标签进行定义的。

```html
<h1>This is a heading</h1>
<h2>This is a heading</h2>
<h3>This is a heading</h3>
```

**段落**

```html
<p>This is a paragraph.</p>
<p>This is another paragraph.</p>
```

**链接**

```html
<a href="http://www.w3school.com.cn">This is a link</a>
```

**图像**

图像的名称和尺寸是以属性的形式提供的

```html
<img src="w3school.jpg" width="104" height="142" />
```

## 2.2 元素

HTML 元素指的是从开始标签（start tag）到结束标签（end tag）的所有代码。


| 开始标签                  | 元素内容            | 结束标签 |
| ------------------------- | ------------------- | -------- |
| `<p>`                     | This is a paragraph | `</p>`   |
| `<a href="default.htm" >` | This is a link      | `</a>`   |
| `<br />`                  |                     |          |

**实例**

```html
<!--<html> 元素定义了整个 HTML 文档-->
<html>
<!--<body> 元素定义了 HTML 文档的主体-->
<body>
<p>This is my first paragraph.</p>
</body>
</html>
```

**空元素**

在开始标签中添加斜杠，比如` <br />`，是关闭空元素的正确方法，HTML、XHTML 和 XML 都接受这种方式。****

## 2.3 属性

HTML 标签可以拥有*属性*。属性提供了有关 HTML 元素的*更多的信息*。

属性总是以名称/值对的形式出现，比如：`name="value"`。

属性总是在 HTML 元素的*开始标签*中规定。

```html
<a href="http://www.w3school.com.cn">This is a link</a>
```

`-->`

<a href="http://www.w3school.com.cn">This is a link</a>

**实例**

```
<h1 align="center"> 拥有关于对齐方式的附加信息
```

```
<body bgcolor="yellow"> 拥有关于背景颜色的附加信息。
```

```
<table border="1"> 拥有关于表格边框的附加信息。
```

**属性注意点**

* 属性值应该始终被包括在引号内。双引号是最常用的，不过使用单引号也没有问题。
* 在某些个别的情况下，比如属性值本身就含有双引号，那么您必须使用单引号，如`name='Bill "HelloWorld" Gates'`

**大多数HTML元素的属性**

| 属性  | 值                 | 描述                                   |
| :---- | :----------------- | :------------------------------------- |
| class | *classname*        | 规定元素的类名（classname）            |
| id    | *id*               | 规定元素的唯一 id                      |
| style | *style_definition* | 规定元素的行内样式（inline style）     |
| title | *text*             | 规定元素的额外信息（可在工具提示中显示 |

## 2.4 标题`<h>`

**标题**

标题（Heading）是通过 `<h1> - <h6>` 等标签进行定义的。

`<h1>` 定义最大的标题。`<h6>` 定义最小的标题

**水平线**

```html
<p>This is a paragraph</p>
<!--<hr />水平线-->
<hr />
<p>This is a paragraph</p>
```

## 2.5 段落`<p>`

浏览器会自动地在段落的前后添加空行。（`<p>` 是块级元素）

浏览器会移除源代码中多余的**空格和空行**。所有连续的空格或空行都会被算作一个空格。注：`<br/>`可以连续。

## 2.6 样式style

`style`提供了一种改变所有 HTML 元素的样式的通用方法。

通过 HTML 样式，能够通过使用 style 属性直接将样式添加到 HTML 元素，或者间接地在独立的样式表中（CSS 文件）进行定义。

```html
<html>
<!--body  背景  定义为黄色-->
<!--style 属性淘汰了“旧的” bgcolor 属性-->
<body style="background-color:yellow">
<!--h2  背景  定义为红色-->
<h2 style="background-color:red">This is a heading</h2>
<!--p  背景  定义为绿色-->    
<p style="background-color:green">This is a paragraph.</p>
</body>
</html>
```

```html
<html>
<body>
<h1 style="font-family:verdana">A heading</h1>
<!--font-family、color 以及 font-size 属性分别定义元素中文本的字体系列、颜色和字体尺寸  -->
<!--style 属性淘汰了旧的 <font> 标签-->
<p style="font-family:arial;color:red;font-size:20px;">A paragraph.</p>
</body>
</html>
```

```html
<html>
<body>
<!--文本对齐方式  style 属性淘汰了旧的 "align" 属性-->
<h1 style="text-align:center">This is a heading</h1>
<p>The heading above is aligned to the center of this page.</p>
</body>
</html>
```

## 2.7 格式化

* **文本格式化**

```html
<html>
<body>
<b>This text is bold</b>
<br />
<strong>This text is strong</strong>
<br />
<big>This text is big</big>
<br />
<em>This text is emphasized</em>
<br />
<i>This text is italic</i>
<br />
<small>This text is small</small>
<br />
This text contains
<sub>subscript</sub>
<br />
This text contains
<sup>superscript</sup>
</body>
</html>
```

`-->`

`======= 输出开始  =======`

<b>This text is bold</b>

<strong>This text is strong</strong>

<big>This text is big</big>

<em>This text is emphasized</em>

<i>This text is italic</i>

<small>This text is small</small>

<sub>subscript</sub>

<sup>superscript</sup>

`=======  输出结束  =======`

* **预格式文本pre**

```
<html>
<body>
<pre>
这是
预格式文本。
它保留了      空格
和换行。
</pre>
<p>pre 标签很适合显示计算机代码：</p>
<pre>
for i = 1 to 10
     print i
next i
</pre>
</body>
</html>
```

`-->`

`=======  输出开始  =======`

<pre>
这是
预格式文本。
它保留了      空格
和换行。
</pre>

<p>pre 标签很适合显示计算机代码：</p>

<pre>
for i = 1 to 10
     print i
next i
</pre>

`=======  输出结束  =======`

* **地址address**

```html
<!DOCTYPE html>
<html>
<body>
<address>
Written by <a href="mailto:webmaster@example.com">Donald Duck</a>.<br> 
Visit us at:<br>
Example.com<br>
Box 564, Disneyland<br>
USA
</address>
</body>
</html>
```

`-->`

`=======  输出开始  =======`

<address>
Written by <a href="mailto:webmaster@example.com">Donald Duck</a>.<br> 
Visit us at:<br>
Example.com<br>
Box 564, Disneyland<br>
USA
</address>

`=======  输出结束  =======`

* **缩写abbr和首字母acronym缩写**

  在某些浏览器中，当您把鼠标移至缩略词语上时，title 可用于展示表达的完整版本。

  仅对于 IE 5 中的 acronym 元素有效。

  对于 Netscape 6.2 中的 abbr 和 acronym 元素都有效。

```html
<html>
<body>
<abbr title="etcetera">etc.</abbr>
<br />
<acronym title="World Wide Web">WWW</acronym>
</body>
</html>
```

`-->`

`=======  输出开始  =======`

<abbr title="etcetera">etc.</abbr>

<acronym title="World Wide Web">WWW</acronym>

`=======  输出结束  =======`

```html
...
<p><dfn title="World Health Organization">WHO</dfn> 成立于 1948 年。</p>
...
```

`-->`

`=======  输出开始  =======`

<p><dfn title="World Health Organization">WHO</dfn> 成立于 1948 年。</p>

`=======  输出结束  =======`

* **文字方向bdo**

  如果您的浏览器支持 bi-directional override (bdo)，下一行会从右向左输出 (rtl)；

```html
<html>
<body>
<bdo dir="rtl">
Here is some Hebrew text
</bdo>
</body>
</html>
```

`-->`


<bdo dir="rtl">
Here is some Hebrew text
</bdo>

* **引用blockquote和q**

  使用 blockquote 元素的话，浏览器会插入换行和外边距，而 q 元素不会有任何特殊的呈现。

```html
...
<blockquote>
这是长的引用。
</blockquote>
<q>
这是短的引用。
</q>
...
```

`-->`

<blockquote>
这是长的引用。
</blockquote>
<q>这是短的引用。</q>

* **删除del和插入ins**

  此例演示如何标记删除文本和插入文本。大多数浏览器会改写为删除文本和下划线文本。一些老式的浏览器会把删除文本和下划线文本显示为普通文本。

```html
...
<p>一打有 <del>二十</del> <ins>十二</ins> 件。</p>
...
```

`-->`

<p>一打有 <del>二十</del> <ins>十二</ins> 件。</p>

## 2.8 CCS

* **外部样式**

  当样式需要被应用到很多页面的时候，外部样式表将是理想的选择。

  ```html
  <head>
  <link rel="stylesheet" type="text/css" href="mystyle.css">
  </head>
  ```

* **内部样式**

  当单个文件需要特别样式时，就可以使用内部样式表。你可以在 head 部分通过 <style> 标签定义内部样式表。

  ```html
  <head>
  <style type="text/css">
  body {background-color: red}
  p {margin-left: 20px}
  </style>
  </head>
  ```

* **内联样式**

  当特殊的样式需要应用到个别元素时，就可以使用内联样式。 使用内联样式的方法是在相关的标签中使用样式属性。样式属性可以包含任何 CSS 属性。

  ```html
  <p style="color: red; margin-left: 20px">
  This is a paragraph
  </p>
  ```

## 2.9 链接

* **target属性**

  如果把链接的 target 属性设置为 "_blank"，该链接会在新窗口中打开。

  ```html
  <a href="http://www.w3school.com.cn/" target="_blank">Visit W3School!</a>
  ```

* **name属性**

  创建一个书签，对锚进行命名

  ```html
  <a name="tips">基本的注意事项 - 有用的提示</a>
  ```

  在同一个文档中创建指向该锚的链接

  ```html
  <a href="#tips">有用的提示</a>
  ```

  也可以在其他页面中创建指向该锚的链接

  ```html
  <a href="http://www.w3school.com.cn/html/html_links.asp#tips">有用的提示</a>
  ```

## 2.10 图像

`<img>` 是空标签，意思是说，它只包含属性，并且没有闭合标签。

`src `指 "source"。源属性的值是图像的 URL 地址。

alt 属性用来为图像定义一串预备的可替换的文本。

```html
<img src="boat.gif" alt="Big Boat">
```

## 2.11 列表

* **无序（号）列表**

```html
<html>
<body>
<ul>
  <li>咖啡</li>
  <li>茶</li>
  <li>牛奶</li>
</ul>
</body>
</html>
```

`-->`

`=======  输出开始  =======`

<ul>
  <li>咖啡</li>
  <li>茶</li>
  <li>牛奶</li>
</ul>

`=======  输出结束  =======`

* **有序（号）列表**

```html
<!DOCTYPE html>
<html>
<body>
<ol>
  <li>咖啡</li>
  <li>牛奶</li>
  <li>茶</li>
</ol>
<ol start="50">
  <li>咖啡</li>
  <li>牛奶</li>
  <li>茶</li>
</ol>
</body>
</html>

```

`-->`

`=======  输出开始  =======`

<ol>
  <li>咖啡</li>
  <li>牛奶</li>
  <li>茶</li>
</ol>
<ol start="50">
  <li>咖啡</li>
  <li>牛奶</li>
  <li>茶</li>
</ol>

`=======  输出结束  =======`

## 2.12 块和内联元素

块级元素在浏览器显示时，通常会以新行来开始（和结束），如`<h1>, <p>, <ul>, <table>`

内联元素在显示时通常不会以新行开始，`<b>, <td>, <a>, <img>`

| 标签     | 描述                                       |
| :------- | :----------------------------------------- |
| `<div>`  | 定义文档中的分区或节（division/section）。 |
| `<span>` | 定义 span，用来组合文档中的行内元素。      |

**`<div>`元素**

HTML `<div> `元素是块级元素，它是可用于组合其他 HTML 元素的容器。

<div> 元素没有特定的含义。除此之外，由于它属于块级元素，浏览器会在其前后显示折行。

如果与 CSS 一同使用，`<div>` 元素可用于对大的内容块设置样式属性。

`<div>` 元素的另一个常见的用途是文档布局。它取代了使用表格定义布局的老式方法。使用 `<table> `元素进行文档布局不是表格的正确用法。`<table> `元素的作用是显示表格化的数据。

```html
<!DOCTYPE html>
<html>
<head>
<style>
.cities {
    background-color:black;
    color:white;
    margin:20px;
    padding:20px;
}	
</style>
</head>
<body>
<div class="cities">
<h2>London</h2>
<p>London is the capital city of England. It is the most populous city in the United Kingdom, with a metropolitan area of over 13 million inhabitants.</p>
<p>Standing on the River Thames, London has been a major settlement for two millennia, its history going back to its founding by the Romans, who named it Londinium.</p>
</div> 
<div class="cities">
<h2>Paris</h2>
<p>Paris is the capital and most populous city of France.</p>
<p>Situated on the Seine River, it is at the heart of the 蝜e-de-France region, also known as the rion parisienne.</p>
<p>Within its metropolitan area is one of the largest population centers in Europe, with over 12 million inhabitants.</p>
</div>
<div class="cities">
<h2>Tokyo</h2>
<p>Tokyo is the capital of Japan, the center of the Greater Tokyo Area, and the most populous metropolitan area in the world.</p>
<p>It is the seat of the Japanese government and the Imperial Palace, and the home of the Japanese Imperial Family.</p>
<p>The Tokyo prefecture is part of the world's most populous metropolitan area with 38 million people and the world's largest urban economy.</p>
</div>
</body>
</html>
```

**`<span>`元素**

HTML` <span>` 元素是内联元素，可用作文本的容器。

`<span>` 元素也没有特定的含义。

当与 CSS 一同使用时，`<span>` 元素可用于为部分文本设置样式属性。

```html
<!DOCTYPE html>
<html>
<head>
<style>
  span.red {color:red;}
</style>
</head>
<body>
<h1>My <span class="red">Important</span> Heading</h1>
</body>
</html>
```

<p>My <span class="red">Important</span> Heading</p>

## 2.13 布局

说明：

id 选择器可以为标有特定 id 的 HTML 元素指定特定的样式。

id 选择器以"**#**"" 来定义。

id 属性规定 HTML 元素的唯一的 id。

id 在 HTML 文档中必须是唯一的。

```html
<!DOCTYPE html>
<html>

<head>
<style>
#header {
    background-color:black;
    color:white;
    text-align:center;
    padding:5px;
}
#nav {
    line-height:30px;
    background-color:#eeeeee;
    height:300px;
    width:100px;
    float:left;
    padding:5px;	      
}
#section {
    width:350px;
    float:left;
    padding:10px;	 	 
}
#footer {
    background-color:black;
    color:white;
    clear:both;
    text-align:center;
   padding:5px;	 	 
}
</style>
</head>

<body>
<!--id选择器由#定义-->
<div id="header">
<h1>City Gallery</h1>
</div>

<div id="nav">
London<br>
Paris<br>
Tokyo<br>
</div>

<div id="section">
<h2>London</h2>
<p>
London is the capital city of England. It is the most populous city in the United Kingdom,
with a metropolitan area of over 13 million inhabitants.
</p>
<p>
Standing on the River Thames, London has been a major settlement for two millennia,
its history going back to its founding by the Romans, who named it Londinium.
</p>
</div>

<div id="footer">
Copyright ? W3Schools.com
</div>

</body>
</html>

```

<img src = "/images/wiki/HTML/layout_css.png" alt="结果">

## 2.14 [响应式设计](<http://www.w3school.com.cn/html/html_responsive.asp>)

- RWD 指的是响应式 Web 设计（Responsive Web Design）
- RWD 能够以可变尺寸传递网页
- RWD 对于平板和移动设备是必需的

Bootstrap 是最流行的开发响应式 web 的 HTML, CSS, 和 JS 框架。

## 2.15 框架

同一个浏览器窗口中显示不止一个页面，每个框架都独立于其他的框架。

```html
<!--第一列frame_a.htm被设置为占据浏览器窗口的 25%。第二列frame_b.htm被设置为占据浏览器窗口的 75%-->
<frameset cols="25%,75%">
   <frame src="frame_a.htm">
   <frame src="frame_b.htm">
</frameset>
```

**注意**：不能将` <body></body>` 标签与 `<frameset></frameset>` 标签同时使用！不过，假如你添加包含一段文本的 `<noframes>` 标签，就必须将这段文字嵌套于 `<body></body> `标签内。

```html
<html>
<frameset cols="25%,50%,25%">
  <frame src="/example/html/frame_a.html">
  <frame src="/example/html/frame_b.html">
  <frame src="/example/html/frame_c.html">
<!--如果浏览器不支持frame，noframe内使用body-->
<noframes>
<body>您的浏览器无法处理框架！</body>
</noframes>
</frameset>
</html>
```

## 2.16 内联框架iframe

iframe 用于在网页内显示网页

`<iframe src="URL"></iframe>`

## 2.17 背景

`<body>` 拥有两个配置背景的标签。背景可以是颜色或者图像。

```html
<body bgcolor="#000000">
<body bgcolor="rgb(0,0,0)">
<body bgcolor="black">
```

```html
<body background="clouds.gif">
<body background="http://www.w3school.com.cn/clouds.gif">
```

## 2.18 脚本

`<script>` 标签用于定义客户端脚本，比如 JavaScript。


script 元素既可包含脚本语句，也可通过 src 属性指向外部脚本文件。

必需的 type 属性规定脚本的 MIME 类型。

JavaScript 最常用于图片操作、表单验证以及内容动态更新。

```html
<!--脚本会向浏览器输出“Hello World!”-->
<script type="text/javascript">
document.write("Hello World!")
</script>
```
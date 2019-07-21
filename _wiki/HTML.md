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

## 2.9 链接a

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

## 2.10 图像img

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

`<div>` 元素没有特定的含义。除此之外，由于它属于块级元素，浏览器会在其前后显示折行。


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

<img src = "/images/wiki/HTML/layout_css.png" alt="结果" width="500">

## 2.14 [响应式设计](<http://www.w3school.com.cn/html/html_responsive.asp>)

- RWD 指的是响应式 Web 设计（Responsive Web Design）
- RWD 能够以可变尺寸传递网页
- RWD 对于平板和移动设备是必需的

Bootstrap 是最流行的开发响应式 web 的 HTML, CSS, 和 JS 框架。

## 2.15 框架frame

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

## 2.18 脚本script

`<script>` 标签用于定义客户端脚本，比如 JavaScript。


script 元素既可包含脚本语句，也可通过 src 属性指向外部脚本文件。

必需的 type 属性规定脚本的 MIME 类型。

JavaScript 最常用于图片操作、表单验证以及内容动态更新。

```html
<!--脚本会向浏览器输出“Hello World!”-->
<script type="text/javascript">
document.write("Hello World!")
</script>
<!--noscript标签提供无法使用脚本时的替代内容，比方在浏览器禁用脚本时，或浏览器不支持客户端脚本时。-->
<noscript>Your browser does not support JavaScript!</noscript>
```

**应对老式浏览器**

如果浏览器压根没法识别 <script> 标签，那么 <script> 标签所包含的内容将以文本方式显示在页面上。为了避免这种情况发生，你应该将脚本隐藏在注释标签当中。那些老的浏览器（无法识别 <script> 标签的浏览器）将忽略这些注释，所以不会将标签的内容显示到页面上。而那些新的浏览器将读懂这些脚本并执行它们，即使代码被嵌套在注释标签内。

```html
<script type="text/javascript">
<!--
document.write("Hello World!")
//-->
</script>
```

## 2.19 头部head

`<head>` 元素是所有头部元素的容器。`<head>` 内的元素可包含脚本，指示浏览器在何处可以找到样式表，提供元信息，等等，标签有`<title>`、`<base>`、`<link>`、`<meta>`、`<script>` 以及 `<style>`

* **`<title>`**

  定义浏览器**工具栏标题**

  提供页面被添加到**收藏夹时显示的标题**

  显示在**搜索引擎**结果中的页面标题

* **base**

  `<base>` 标签为页面上的所有链接规定默认地址或默认目标（target）

  ```html
  <head>
  <base href="http://www.w3school.com.cn/images/" />
  <!--默认开一个新的窗口-->
  <base target="_blank" />
  </head>
  ```

* **link**

  `<link>` 标签定义文档与外部资源之间的关系，最常用于连接样式表。

  ```html
  <head>
  <link rel="stylesheet" type="text/css" href="mystyle.css" />
  </head>
  ```

* **style**

  `<style>` 标签用于为 HTML 文档定义样式信息，在 style 元素内规定 HTML 元素在浏览器中呈现的样式。

  ```html
  <head>
  <style type="text/css">
  <!--定义body样式-->
  body {background-color:yellow}
  <!--定义p样式-->
  p {color:blue}
  </style>
  </head>
  ```

* **meta**

  元数据（metadata）是关于数据的信息，**始终位于 head 元素中**。通常，meta 元素被用于规定页面的描述、关键词、文档的作者、最后修改时间以及其他元数据。

  元数据可用于浏览器（如何显示内容或重新加载页面），搜索引擎（关键词），或其他 web 服务。

  ```html
  <!--针对搜索引擎的描述-->
  <meta name="description" content="Free Web tutorials on HTML, CSS, XML" />
  <!--针对搜索引擎的关键词-->
  <meta name="keywords" content="HTML, CSS, XML" />
  ```

* **script**

  `<script>` 标签用于定义客户端脚本，比如 JavaScript。

## 2.20 实体

HTML中某些字符是预留的，如不能使用小于号（<）和大于号（>），代替方式：

```
&entity_name;
或者
&#entity_number;
```

小于号: `&lt`或者`&#60`

不间断空格: `&nbsp`，实现多个空格

| 显示结果 | 描述              | 实体名称            | 实体编号  |
| :------- | :---------------- | :------------------ | :-------- |
|          | 空格              | `&nbsp;`            | `&#160;`  |
| `<`      | 小于号            | `&lt;`              | `&#60;`   |
| `>`      | 大于号            | `&gt;`              | `&#62;`   |
| `&`      | 和号              | `&amp;`             | `&#38;`   |
| `"`      | 引号              | `&quot;`            | `&#34;`   |
| `'`      | 撇号              | `&apos; `(IE不支持) | `&#39;`   |
| `￠`     | 分（cent）        | `&cent;`            | `&#162;`  |
| `£`      | 镑（pound）       | `&pound;`           | `&#163;`  |
| `¥`      | 元（yen）         | `&yen;`             | `&#165;`  |
| `€`      | 欧元（euro）      | `&euro;`            | `&#8364;` |
| `§`      | 小节              | `&sect;`            | `&#167;`  |
| `©`      | 版权（copyright） | `&copy;`            | `&#169;`  |
| `®`      | 注册商标          | `&reg;`             | `&#174;`  |
| `™`      | 商标              | `&trade;`           | `&#8482;` |
| `×`      | 乘号              | `&times;`           | `&#215;`  |
| `÷`      | 除号              | `&divide;`          | `&#247;`  |

## 2.21统一资源定位器URL

Uniform Resource Locator

**特点**

* URL 只能使用 ASCII 字符集来通过因特网进行发送。

* 由于 URL 常常会包含 ASCII 集合之外的字符，URL 必须转换为有效的 ASCII 格式。

* URL 编码使用` "%" `其后跟随两位的十六进制数来替换非 ASCII 字符。

* URL 不能包含空格。URL 编码通常使用 `+` 来替换空格。

**格式**

`scheme://host.domain:port/path/filename`

- scheme - 定义因特网服务的类型。最常见的类型是 http
- host - 定义域主机（http 的默认主机是 www）
- domain - 定义因特网域名，比如 w3school.com.cn
- `:`port - 定义主机上的端口号（http 的默认端口号是 80）
- path - 定义服务器上的路径（如果省略，则文档必须位于网站的根目录中）。
- filename - 定义文档/资源的名称

## 2.22 [颜色](<http://www.w3school.com.cn/html/html_colornames.asp>)

aqua, black, blue, fuchsia, gray, green, lime, maroon, navy, olive, purple, red, silver, teal, white, yellow。

## 2.23 `<!DOCTYPE>`声明

 [DOCTYPE 参考手册](http://www.w3school.com.cn/tags/tag_doctype.asp)

`<!DOCTYPE>` 不是 HTML 标签。它为浏览器提供一项信息（声明），即 HTML 是用什么版本编写的。

| 版本      | 年份 |
| :-------- | :--- |
| HTML      | 1991 |
| HTML+     | 1993 |
| HTML 2.0  | 1995 |
| HTML 3.2  | 1997 |
| HTML 4.01 | 1999 |
| XHTML 1.0 | 2000 |
| HTML5     | 2012 |
| XHTML5    | 2013 |

```html
<!-- html 5 -->
<!DOCTYPE html>
<!-- HTML 4.01 -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<!-- XHTML 1.0 -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
```

# 3. HTML表单form

HTML 表单用于搜集不同类型的用户输入。

`<form>` 元素定义 HTML 表单

## 3.1 表单属性

| 属性           | 描述                                                       |
| :------------- | :--------------------------------------------------------- |
| accept-charset | 规定在被提交表单中使用的字符集（默认：页面字符集）。       |
| action         | 规定向何处提交表单的地址（URL）（提交页面）。              |
| autocomplete   | 规定浏览器应该自动完成表单（默认：开启）。                 |
| enctype        | 规定被提交数据的编码（默认：url-encoded）。                |
| method         | 规定在提交表单时所用的 HTTP 方法（默认：GET）。            |
| name           | 规定识别表单的名称（对于 DOM 使用：document.forms.name）。 |
| novalidate     | 规定浏览器不验证表单。                                     |
| target         | 规定 action 属性中地址的目标（默认：_self）。              |

**Method属性**

```html
<!--如果表单提交是被动的（比如搜索引擎查询），并且没有敏感信息。表单数据在页面地址栏中是可见的-->
<form action="action_page.php" method="GET">
<!--如果表单正在更新数据，或者包含敏感信息（例如密码）,在页面地址栏中被提交的数据是不可见的-->
<form action="action_page.php" method="POST">    
```

*[POST和GET的区别](<https://www.oschina.net/news/77354/http-get-post-different>)*

1.来自W3CSchool

- GET在浏览器回退时是无害的，而POST会再次提交请求。
- GET产生的URL地址可以被Bookmark，而POST不可以。
- GET请求会被浏览器主动cache，而POST不会，除非手动设置。
- GET请求只能进行url编码，而POST支持多种编码方式。
- GET请求参数会被完整保留在浏览器历史记录里，而POST中的参数不会被保留。
- GET请求在URL中传送的参数是有长度限制的，而POST么有。
- 对参数的数据类型，GET只接受ASCII字符，而POST没有限制。
- GET比POST更不安全，因为参数直接暴露在URL上，所以不能用来传递敏感信息。
- GET参数通过URL传递，POST放在Request body中。

2.POST的内容放在request body，GET放在url，本质上都是TCP协议

> 如果你用GET服务，在request body偷偷藏了数据，不同服务器的处理方式也是不同的，有些服务器会帮你卸货，读出数据，有些服务器直接忽略，所以，虽然GET可以带request body，也不能保证一定能被接收到哦。

3.GET产生一个TCP数据包；POST产生两个TCP数据包

## 3.2 输入input

[输入类型](<http://www.w3school.com.cn/html/html_form_input_types.asp>)：password（密码替换为星号）、text、submit（提交）、radio（单选按钮）、checkbox（复选框）、button（按钮，onclick执行相应程序）

<u>**HTML5输入类型**</u>：number（数字，可限制范围）、data（日期）、color、range（一定范围的滑块控件）、month（年份月份）、week（年周）、time（时分）、datetime-local（日期和时间）、email（邮箱，可验证邮箱正确性，智能手机可自动提示输入.com）、search（搜索，类似常规文本字段）、url（地址，自动验证）

**文本输入text**

```html
<form>
 First name:<br>
 <!--<input> 元素是最重要的表单元素-->
 <!--type包括text（文本输入） radio（单选按钮输入）  submit（提交表单按钮）-->
 <!--如果要正确地被提交，每个输入字段必须设置一个 name 属性。-->   
<input type="text" name="firstname">
<br>
 Last name:<br>
<input type="text" name="lastname">
</form> 
```

<img src = "/images/wiki/HTML/test_input.png" alt="输入文本" width="200">

**单选按钮radio**

```html
<form>
<input type="radio" name="sex" value="male" checked>Male
<br>
<input type="radio" name="sex" value="female">Female
</form> 
```

<img src = "/images/wiki/HTML/radio_input.png" alt="输入单选按钮" width="200">

**提交submit**

```html
<!--action指定表单处理程序-->
<form action="action_page.php">
First name:<br>
<input type="text" name="firstname" value="Mickey">
<br>
Last name:<br>
<input type="text" name="lastname" value="Mouse">
<br><br>
<!--表单处理程序（form-handler）提交表单的按钮-->
<input type="submit" value="Submit">
</form> 
```

<img src = "/images/wiki/HTML/submit_input.png" alt="提交" width="200">

**按钮button**

onclick执行程序`alert('Hello World!')`。

```html
<form>
<input type="button" onclick="alert('Hello World!')" value="Click Me!">
</form>
```

**数字number**

限制输入数字1-5

```html
<form>
<input type="number" name="quantity" min="1" max="5">
</form>
```

**日期date**

根据浏览器支持，日期选择器会出现输入字段中。

```html
<input type="date" name="bday">
```

**颜色color**

```html
<form>
<input type="color" name="favcolor">
</form>
```

<img src = "/images/wiki/HTML/select_color.png" alt="提交" width="200">

**滑块range**

根据浏览器支持，输入字段能够显示为滑块控件，可用限制min、max、step、value。

```html
<form>
<input type="range" name="points" min="0" max="10">
</form> 
```

**月份month**

```html
<form>
  Birthday (month and year):
  <input type="month" name="bdaymonth">
</form>
```

**周week**

选择周和年

```html
<form>
  Select a week:
  <input type="week" name="week_year">
</form>
```

**时间time**

时分

```html
<form>
  Select a time:
  <input type="time" name="usr_time">
</form>
```

**日期和时间datetime-local**

```html
<form>
  Birthday (date and time):
  <input type="datetime-local" name="bdaytime">
</form>
```

**邮箱email**

根据浏览器支持，能够在被提交时自动对电子邮件地址进行验证。

某些智能手机会识别 email 类型，并在键盘增加 ".com" 以匹配电子邮件输入。

```html
<form>
  E-mail:
  <input type="email" name="email">
</form>
```

**搜索search**

```html
<form>
  Search Google:
  <input type="search" name="googlesearch">
</form>
```

**网址url**

根据浏览器支持，在提交时能够自动验证 url 字段。

```html
<form>
  Add your homepage:
  <input type="url" name="homepage">
</form>
```

**输入input限制**

| 属性      | 描述                               |
| :-------- | :--------------------------------- |
| disabled  | 规定输入字段应该被禁用。           |
| max       | 规定输入字段的最大值。             |
| maxlength | 规定输入字段的最大字符数。         |
| min       | 规定输入字段的最小值。             |
| pattern   | 规定通过其检查输入值的正则表达式。 |
| readonly  | 规定输入字段为只读（无法修改）。   |
| required  | 规定输入字段是必需的（必需填写）。 |
| size      | 规定输入字段的宽度（以字符计）。   |
| step      | 规定输入字段的合法数字间隔。       |
| value     | 规定输入字段的默认值。             |

**[输入input属性](<http://www.w3school.com.cn/html/html_form_attributes.asp>)**

*前期版本支持*

value ：规定输入字段的初始值。

readonly ：规定输入字段为只读（不能修改）。

disabled ：规定输入字段是禁用的，被禁用的元素是不可用和不可点击的。被禁用的元素不会被提交。

size ：规定输入字段的尺寸（以字符计），不是最小也不是最大，只是显示出来的效果。

maxlength ：规定输入字段允许的最大长度。

*HTML5开始支持*

autocomplete ：规定表单或输入字段是否应该自动完成，当自动完成开启，浏览器会基于用户之前的输入值自动填写值。（可以把表单form的 autocomplete 设置为 on，同时把特定的输入字段设置为 off，反之亦然。）autocomplete 属性适用于 `<form>` 以及如下 `<input>` 类型：text、search、url、tel、email、password、datepickers、range 以及 color。

form ：不同于表单，是表单属性，指示输入属于哪个表单

height 和 width ：input高度和宽度

list ：list 属性引用的` <datalist> `元素中包含了 `<input>` 元素的预定义选项。

```html
<input list="browsers">
<datalist id="browsers">
   <option value="Internet Explorer">
   <option value="Firefox">
   <option value="Chrome">
   <option value="Opera">
   <option value="Safari">
</datalist> 
```

min 和 max：input最小和最大值。

multiple ：如果设置，规定允许用户在 `<input> `元素中输入一个以上的值，适用于email和file。

```html
<!DOCTYPE HTML>
<html>
<body>
<form action="/example/html5/demo_form.asp" method="get">
选择图片：<input type="file" name="img" multiple="multiple" />
<input type="submit" />
</form>
<p>请尝试在浏览文件时选取一个以上的文件。</p>
</body>
</html>
```

pattern ：规定用于检查 `<input>` 元素值的正则表达式，适用于text、search、url、tel、email、and password。

```html
Country code: 
<!--只能包含3个字母的输入字段-->
<input type="text" name="country_code" pattern="[A-Za-z]{3}" title="Three letter country code">
```

placeholder ：规定用以描述输入字段预期值的提示（样本值或有关格式的简短描述），适用于text、search、url、tel、email 以及 password。

required ：如果设置，则规定在提交表单之前必须填写输入字段。

step ：规定 `<input>` 元素的合法数字间隔。

## 3.3 下拉列表`select`

```html
<!DOCTYPE html>
<html>
<body>
<form action="/demo/demo_form.asp">
<select name="cars">
	<option value="volvo">Volvo</option>
	<option value="saab">Saab</option>
	<!--通过 selected 属性预选择某些选项-->
	<option value="fiat" selected>Fiat</option>
	<option value="audi">Audi</option>
</select>
<br><br>
<input type="submit">
</form>
</body>
</html>
```


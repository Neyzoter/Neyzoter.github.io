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

* 文本格式化

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

* 预格式文本

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

* 地址

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

* 缩写和首字母缩写

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

* 文字方向

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


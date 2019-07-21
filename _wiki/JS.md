---
layout: wiki
title: JavaScript
categories: JavaScript
description: JavaScript语法
keywords: JavaScript
---

# 1. JavaScript简介

## 1.1 资源

[JS实例](<http://www.w3school.com.cn/js/js_examples.asp>)

## 1.2 简介

JS可以做什么：

```html
<!DOCTYPE html>
<html>
<body>
<h2>JavaScript 能做什么？</h2>
<p>JavaScript 能够改变 HTML 属性值。</p>
<p>在本例中，JavaScript 改变了图像的 src 属性值。</p>
<!--通过getElementById查找id为"myImage"的HTML元素，并修改器参数src-->
<button onclick="document.getElementById('myImage').src='/i/eg_bulbon.gif'">开灯</button>
<img id="myImage" border="0" src="/i/eg_bulboff.gif" style="text-align:center;">
<button onclick="document.getElementById('myImage').src='/i/eg_bulboff.gif'">关灯</button>
</body>
</html>
```

在 HTML 中，JavaScript 代码必须位于 `<script>` 与 `</script> `标签之间。

**脚本放置位置**

1.脚本可被放置与 HTML 页面的 `<body> `或 `<head> `部分中，或兼而有之。

2.外部脚本

```js
//myScript.js
function myFunction() {
   document.getElementById("demo").innerHTML = "段落被更改。";
}
```

```html
<!--在html中使用以上js脚本-->
<script src="myScript.js"></script>
```

3.外部引用

可通过完整的 URL 或相对于当前网页的路径引用外部脚本：

```html
<script src="https://www.w3school.com.cn/js/myScript1.js"></script>
```

# 2.JavaScript语法

## 2.1 输出

JavaScript 不提供任何内建的打印或显示函数。方案：

（1）使用 `window.alert()` 写入警告框

（2）使用 `document.write() `写入 HTML 输出

（3）使用 `innerHTML` 写入 HTML 元素

（4）使用 `console.log() `写入浏览器控制台

**实例**

- 使用 `window.alert()` 写入警告框

  

- 使 `document.write() `写入 HTML 输出

  

- 使用 `innerHTML` 写入 HTML 元素

  

- 使用 `console.log() `写入浏览器控制台
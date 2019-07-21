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
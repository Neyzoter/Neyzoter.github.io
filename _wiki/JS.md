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

  能够使用**警告框**来显示数据

  ```html
  <!DOCTYPE html>
  <html>
  <body>
  <h1>我的第一张网页</h1>
  <p>我的第一个段落</p>
  <script>
  window.alert(5 + 6);
  </script>
  </body>
  </html>  
  ```

- 使 `document.write() `写入 HTML 输出

  ```html
  <!DOCTYPE html>
  <html>
  <body>
  <h1>我的第一张网页</h1>
  <p>我的第一个段落</p>
  <script>
  document.write(5 + 6);
  </script>
  </body>
  </html> 
  ```

  在 HTML 文档完全加载后使用 **document.write()** 将**删除所有已有的 HTML**

  ```html
  <!DOCTYPE html>
  <html>
  <body>
  <h1>我的第一张网页</h1>
  <p>我的第一个段落</p>
  <!--点击按钮后，出现11，上面的h1和p均消失-->
  <button onclick="document.write(5 + 6)">试一试</button>
  </body>
  </html>
  ```

- 使用 `innerHTML` 写入 HTML 元素

    ```html
    <!DOCTYPE html>
    <html>
    <body>
    <h1>我的第一张网页</h1>
    <p>我的第一个段落</p>
    <p id="demo"></p>
    <script>
     document.getElementById("demo").innerHTML = 5 + 6;
    </script>
    </body>
    </html> 
    ```

- 使用 `console.log() `写入浏览器控制台

  ```html
  <!DOCTYPE html>
  <html>
  <body>
  <h1>我的第一张网页</h1>
  <p>我的第一个段落</p>
  <script>
  console.log(5 + 6);
  </script>
  </body>
  </html>
  ```

## 2.2 语句

* 忽略空格

  ```js
  var person = "Bill";
  var person="Bill"; 
  ```

* 折行

  ```js
  document.getElementById("demo").innerHTML =
   "Hello Kitty.";
  ```

* 代码块

  ```js
  function myFunction() {
      document.getElementById("demo").innerHTML = "Hello Kitty.";
      document.getElementById("myDIV").innerHTML = "How are you?";
  }
  ```

* **关键词**

  | 关键词        | 描述                                              |
  | :------------ | :------------------------------------------------ |
  | break         | 终止 switch 或循环。                              |
  | continue      | 跳出循环并在顶端开始。                            |
  | debugger      | 停止执行 JavaScript，并调用调试函数（如果可用）。 |
  | do ... while  | 执行语句块，并在条件为真时重复代码块。            |
  | for           | 标记需被执行的语句块，只要条件为真。              |
  | function      | 声明函数。                                        |
  | if ... else   | 标记需被执行的语句块，根据某个条件。              |
  | return        | 退出函数。                                        |
  | switch        | 标记需被执行的语句块，根据不同的情况。            |
  | try ... catch | 对语句块实现错误处理。                            |
  | var           | 声明变量。                                        |

## 2.3 变量

- 名称可包含字母、数字、下划线和美元符号
- 名称必须以字母、`$` 或 `_ `开头开头
- 名称对大小写敏感（y 和 Y 是不同的变量）
- 保留字（比如 JavaScript 的关键词）无法用作变量名称

```html
<p id="demo"></p>

<script>
var carName = "porsche";
document.getElementById("demo").innerHTML = carName; 
</script>
```

```js
//一条语句多个变量
//不带有值的变量，它的值将是 undefined
var person = "Bill Gates", carName = "porsche", price = 15000;
```

```js
//重复声明，carName的值还是"porsche"
var carName = "porsche";
var carName; 
```

`3+5+"8" = 8+"8" = "88"`

`"8"+3+5 = "835"`

## 2.4 运算

* 计算

| 运算符 | 描述 |
| :----- | :--- |
| `+`    | 加法 |
| `-`    | 减法 |
| `*`    | 乘法 |
| `**`   | 幂   |
| `/`    | 除法 |
| `%`    | 系数 |
| `++`   | 递增 |
| `--`   | 递减 |

* 赋值

| 运算符 | 例子   | 等同于    |
| :----- | :----- | :-------- |
| =      | x = y  | x = y     |
| +=     | x += y | x = x + y |
| -=     | x -= y | x = x - y |
| *=     | x *= y | x = x * y |
| /=     | x /= y | x = x / y |
| %=     | x %= y | x = x % y |

* 比较运算符

| 运算符 | 描述                      |
| :----- | :------------------------ |
| `==`   | 等于，如5=="5"为true      |
| `===`  | 等值等型，如5=="5"为false |
| `!=`   | 不相等                    |
| `!==`  | 不等值或不等型            |
| `>`    | 大于                      |
| `<`    | 小于                      |
| `>=`   | 大于或等于                |
| `<=`   | 小于或等于                |
| `?`    | 三元运算符                |

* 逻辑运算

| 运算符 | 描述   |
| :----- | :----- |
| `&&`   | 逻辑与 |
| `||`   | 逻辑或 |
| `!`    | 逻辑非 |

* 位运算

  JavaScript 使用 32 位有符号数。该运算中的任何数值运算数都会被转换为 32 位的数。结果会被转换回 JavaScript 数。

  在 JavaScript 中，`~ `5 不会返回 10，而是返回 -6。

| 运算符 | 描述         | 例子      | 等同于        | 结果 | 十进制 |
| :----- | :----------- | :-------- | :------------ | :--- | :----- |
| `&`    | 与           | 5 `&` 1   | 0101 `&` 0001 | 0001 | 1      |
| `|`    | 或           | 5 `|` 1   | 0101 `|` 0001 | 0101 | 5      |
| `~`    | 非           | `~` 5     | `~`0101       | 1010 | 10     |
| `^`    | 异或         | 5 `^ `1   | 0101 `^ `0001 | 0100 | 4      |
| `<<`   | 零填充左位移 | 5 `<<` 1  | 0101 `<<` 1   | 1010 | 10     |
| `>>`   | 有符号右位移 | 5` >>` 1  | 0101 `>> `1   | 0010 | 2      |
| `>>>`  | 零填充右位移 | 5 `>>>` 1 | 0101 `>>>` 1  | 0010 | 2      |
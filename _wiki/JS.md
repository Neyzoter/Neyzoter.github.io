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
| `%`    | 余数 |
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

| 运算符 | 描述                       |
| :----- | :------------------------- |
| `==`   | 等于，如5=="5"为true       |
| `===`  | 等值等型，如5==="5"为false |
| `!=`   | 不相等                     |
| `!==`  | 不等值或不等型             |
| `>`    | 大于                       |
| `<`    | 小于                       |
| `>=`   | 大于或等于                 |
| `<=`   | 小于或等于                 |
| `?`    | 三元运算符                 |

* 逻辑运算

| 运算符 | 描述   |
| :----- | :----- |
| `&&`   | 逻辑与 |
| `||`   | 逻辑或 |
| `!`    | 逻辑非 |

* 位运算

  JavaScript 使用 32 位有符号数。该运算中的任何数值运算数都会被转换为 32 位的数。结果会被转换回 JavaScript 数。

  在 JavaScript 中，`~ 5` 不会返回 10，而是返回 -6。解释：`~00000000000000000000000000000101` 将返回 `11111111111111111111111111111010`。

| 运算符 | 描述         | 例子      | 等同于        | 结果 | 十进制 |
| :----- | :----------- | :-------- | :------------ | :--- | :----- |
| `&`    | 与           | 5 `&` 1   | 0101 `&` 0001 | 0001 | 1      |
| `|`    | 或           | 5 `|` 1   | 0101 `|` 0001 | 0101 | 5      |
| `~`    | 非           | `~` 5     | `~`0101       | 1010 | 10     |
| `^`    | 异或         | 5 `^ `1   | 0101 `^ `0001 | 0100 | 4      |
| `<<`   | 零填充左位移 | 5 `<<` 1  | 0101 `<<` 1   | 1010 | 10     |
| `>>`   | 有符号右位移 | 5` >>` 1  | 0101 `>> `1   | 0010 | 2      |
| `>>>`  | 零填充右位移 | 5 `>>>` 1 | 0101 `>>>` 1  | 0010 | 2      |

## 2.5 数据类型

**数据类型**

数值、字符串、数组、布尔值、对象、undefined、null（属于对象）。

```js
var length = 7;                             // 数字
var lastName = "Gates";                      // 字符串
var cars = ["Porsche", "Volvo", "BMW"];         // 数组
var y = true;                                //布尔值
var x = {firstName:"Bill", lastName:"Gates"};    // 对象，包括两个属性——firstName和lastName
var v;                                             //undefined类型
var p = null;                                  // 值是 null，但是类型仍然是对象
```

*注*：js只有一种数值类型，可以不用小数点。支持科学计数法，如`123e5`等同于``12300000`。

*null和undefined区别*

```js
typeof undefined              // undefined
typeof null                   // object
null === undefined            // false，值不相等
null == undefined             // true
```

**不同类型相加**

```js
/* 数字和字符串相加，js将数字视为字符串*/
var x = 911 + "Porsche";
//等同于
var x = "911" + "Porsche";

// 多个数字相加
var x = 911 + 7 + "Porsche";
// =>
"918Porsche"
```

**typeof的使用**

typeof返回两种类型：function和object。

```c
typeof {name:'Bill', age:62} // 返回 "object"
typeof [1,2,3,4]             // 返回 "object" (并非 "array")，数组即对象
typeof null                  // 返回 "object"
typeof function myFunc(){}   // 返回 "function"
```

## 2.6 函数

**举例**

```js
var x = myFunction(4, 3);        // 调用函数，返回值被赋值给 x

function myFunction(a, b) {
    return a * b;                // 函数返回 a 和 b 的乘积
}
```

输出结果

```
56
```

**引用函数对象和引用函数结果**

```js
function toCelsius(fahrenheit) {
    return (5/9) * (fahrenheit-32);
}

document.getElementById("demo").innerHTML = toCelsius;//引用函数对象
var x = toCelsius(50);//引用函数结果
```

## 2.7 对象

**举例**

```js
//对象包括firstName、lastName、id、fullName等属性
var person = {
  firstName: "Bill",
  lastName : "Gates",
  id       : 678,
  fullName : function() {
    return this.firstName + " " + this.lastName;
  }
};
```

**访问对象属性**

```js
// objectName.propertyName
person.lastName;
// objectName["propertyName"]
person["lastName"];
// objectName.methodName()
name = person.fullName;
```

**不要将字符串、数值和布尔值声明为对象**

会增加代码复杂性，降低执行速度。

```js
// 将字符串、数值和布尔值声明为对象
var x = new String();        // 把 x 声明为 String 对象
var y = new Number();        // 把 y 声明为 Number 对象
var z = new Boolean();       //	把 z 声明为 Boolean 对象
```

## 2.8 事件

HTML事件是指发生在HTML元素上的“事情”——网页完成加载、输入字段改变、按钮点击等，JS能够处理HTML事件。

JS处理HTML事件的格式：

```html
<element event='一些 JavaScript'>
<element event="一些 JavaScript">
```

举例

```html
<!-- 点击按钮，通过js获取时间 -->
<button onclick="document.getElementById('demo').innerHTML=Date()">时间是？</button>
<p id="demo"></p>
```

常见的HTML事件

| 事件        | 描述                         |
| :---------- | :--------------------------- |
| onchange    | HTML 元素已被改变            |
| onclick     | 用户点击了 HTML 元素         |
| onmouseover | 用户把鼠标移动到 HTML 元素上 |
| onmouseout  | 用户把鼠标移开 HTML 元素     |
| onkeydown   | 用户按下键盘按键             |
| onload      | 浏览器已经完成页面加载       |

## 2.9 字符串

**转意符**

| 代码 | 结果       |
| :--- | :--------- |
| `\b` | 退格键     |
| `\f` | 换页       |
| `\n` | 新行       |
| `\r` | 回车       |
| `\t` | 水平制表符 |
| `\v` | 垂直制表符 |

**代码换行**

```js
// 运算符后换行
document.getElementById("demo").innerHTML =
"Hello Kitty.";
// 字符串中换行需要使用反斜杠\或者通过运算符+连接两个字符串
document.getElementById("demo").innerHTML = "Hello \
Kitty!";
document.getElementById("demo").innerHTML = "Hello "+
"Kitty!";
// !!!! 代码不可以通过反斜杠换行
// 以下为错误代码
document.getElementById("demo").innerHTML = \ 
"Hello Kitty!";
```

**判断字符串相等**

```js
var x = "Bill";             
var y = new String("Bill");
// (x == y) 为 true，因为 x 和 y 的值相等

var x = "Bill";             
var y = new String("Bill");
// (x === y) 为 false，因为 x 和 y 的类型不同（字符串与对象）
```

*注*：两个对象比较，始终为false。

```js
var x = new String("Bill");             
var y = new String("Bill");
// (x == y) 为 false，因为 x 和 y 是不同的对象
```

**字符串方法**

* 字符串长度

  ```js
  var txt = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  var sln = txt.length;
  ```

* 查找字符串中的字符串

  ```js
  var str = "The full name of China is the People's Republic of China.";
  // 未找到返回-1
  var pos = str.indexOf("China");// 首次出现的索引，无法设置正则表达式
  var pos = str.indexOf("China", 18);// 设置起始位置
  var pos = str.lastIndexOf("China"); //最后一次出现的索引
  var pos = str.search("China");//效果等同于indexOf("China")，不能设置第二个开始位置参数
  ```

* 提取部分字符串

  ```js
  slice(start, end);//提取字符串的某个部分并在新字符串中返回被提取的部分,如果某个参数为负，则从字符串的结尾开始计数
  substring(start, end);//无法接收负的索引
  substr(start, length); //可指定长度
  ```

* 替换字符串内容

  ```js
  str = "Please visit Microsoft Microsoft!";
  var n = str.replace("Microsoft", "W3School");//只替换第一个匹配字符串，不改变原字符串，返回一个新的字符串
  var m = str.replace("/MICROSOFT/i", "W3School");// /i表示大小写不敏感
  var x = str.replace("/Microsoft/g", "W3School");// /g表示替换所有匹配
  ```

  结果

  ```
  n = "Please visit W3School Microsoft!"
  m = "Please visit W3School Microsoft!"
  x = "Please visit W3School W3School!"
  ```

* 大小写转换

  ```js
  var text1 = "Hello World!";       // 字符串
  var text2 = text1.toUpperCase();  // text2 是被转换为大写的 text1
  var text3 = text1.toLowerCase();  // text2 是被转换为小写的 text1
  ```

* 连接字符串

  ```js
  var text = "Hello" + " " + "World!";
  var text = "Hello".concat(" ","World!");
  ```

* 剔除字符串两边空白

  ```js
  var str = "       Hello World!        ";
  var str1 = str.replace(/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g, '');//剔除两边空格
  var str2 = str.trim(); //剔除两边空格，IE8或者更低版本不支持trim
  ```

  结果

  ```
  str1 = "Hello World!"
  ```

* 提取字符串字符

  ```js
  var str = "HELLO WORLD";
  str.charAt(0);            // 返回字符串中指定下标（位置）的字符串 返回 H
  
  var str = "HELLO WORLD";
  str.charCodeAt(0);         // 返回字符串中指定索引的字符 unicode 编码 返回 72
  
  var str = "HELLO WORLD";
  str[0];                   // 返回 H  1.不适用 Internet Explorer 7 或更早的版本;2.只读，无法修改
  ```

* 字符串转数组

  ```js
  var txt = "a,b,c,d,e";   // 字符串
  var c1 = txt.split(",");          // 用逗号分隔
  var c2 = txt.split("");   //分割所有字符
  ```

  结果

  ```js
  c1 = ["a","b","c","d","e"]
  c2 = ["a",",","b",",","c",",","d",",","e"]
  ```

## 2.10 数值

JS的数值始终是64位浮点数，其中 0 到 51 存储数字（片段），52 到 62 存储指数，63 位存储符号

整数（不使用指数或科学计数法）会被精确到 15 位。

```js
var x = 999999999999999;   // x 将是 999999999999999
var y = 9999999999999999;  // y 将是 10000000000000000
```

小数的最大数是 17 位，但是浮点的算数并不总是 100% 精准：

```js
var x = 0.2 + 0.1;         // x 将是 0.30000000000000004
```

支持16进制

```js
var x = 0xFF;             // x 将是 255
```

进制转换

```js
var myNumber = 128;
myNumber.toString(16);     // 返回 80，16进制
myNumber.toString(8);      // 返回 200，8进制
myNumber.toString(2);      // 返回 10000000，2进制
```

## 2.11 数组

**数组介绍**

数组是一种特殊类型的对象，typeof一个数组会返回object

实例

```js
var cars = ["Saab", "Volvo", "BMW"];
document.getElementById("demo").innerHTML = cars[0]; 
```

**数组方法**

* 增加删除元素

  ```js
  var fruits = ["Banana", "Orange", "Apple", "Mango"];
  fruits.push("Lemon");                // 向 fruits 末尾添加一个新元素 (Lemon)
  fruits.pop();                // 从 fruits 删除最后一个元素（"Lemon"）
  fruits.shift();                 // 从 fruits 删除第一个元素 "Banana"
  fruits.unshift("Banana");                 // 向 fruits 开头添加一个新元素 "Banana"
  fruits[0] = "Kiwi";        // 把 fruits 的第0个元素改为 "Kiwi"
  delete fruits[0];           // 把 fruits 中的首个元素改为 undefined
  ```

* 长度

  ```js
  var fruits = ["Banana", "Orange", "Apple", "Mango"];
  fruits.length;                       // fruits 的长度是 4
  ```

* 遍历数组

  ```js
  fruits = ["Banana", "Orange", "Apple", "Mango"];
  fruits.forEach(myFunction);  // 使用foreach遍历数组，并使用myFunction处理数据
  function myFunction(value) {
    text += "<li>" + value + "</li>";
  }
  ```

* 识别数组

  ```js
  Array.isArray(fruits);     // 返回 true
  // typeof 一个数组返回object
  ```

* 数组结合

  join

* 数组排序

  ```js
  var fruits = ["Banana", "Orange", "Apple", "Mango"];
  fruits.sort();            // 对 fruits 中的元素进行排序
  fruits.reverse();         // 反转元素顺序
  ```

  
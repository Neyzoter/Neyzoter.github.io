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
  fruits.sort();            // 对 fruits 中的元素进行排序, ！！！针对字符串，如果对于数字会出错，如20大于100
  fruits.reverse();         // 反转元素顺序
  ```

  修正sort对于数字排序的错误：

  ```js
  var points = [40, 100, 1, 5, 25, 10];
  // function是比值函数，返回结果小于0,则将第一个数放在比第二个数更低
  points.sort(function(a, b){return a - b}); 
  ```

  实现随机排序

  ```js
  var points = [40, 100, 1, 5, 25, 10];
  points.sort(function(a, b){return 0.5 - Math.random()}); 
  ```

* 使用`Math`，得到最大最小值

  ```js
  function myArrayMax(arr) {
      // Math.max.apply([1, 2, 3]) 等于 Math.max(1, 2, 3)
      return Math.max.apply(null, arr);
  }
  ```

* 数组迭代

  ```js
  var txt = "";
  var numbers = [45, 4, 9, 16, 25];
  // 除了IE8以及更低版本，都支持foreach
  numbers.forEach(myFunction);  // 对每个元素进行myFunction处理
  
  // 接收三个参数：项目值、项目索引、数组本身
  function myFunction(value, index, array) {
    txt = txt + value + "<br>"; 
  }
  ```

* 根据数组迭代创建新数组

  **处理每个元素组建新数组**

  `map() `方法通过对每个数组元素执行函数来创建新数组。

  `map() `方法不会对没有值的数组元素执行函数。

  `map()` 方法不会更改原始数组。

  ```js
  var numbers1 = [45, 4, 9, 16, 25];
  // 除了IE8以及更低版本，均支持
  var numbers2 = numbers1.map(myFunction);
  
  function myFunction(value, index, array) {
    return value * 2;
  }
  ```

  结果

  ```
  numbers2 = [90,8,18,32,50]
  ```

  **过滤某些元素组建新数组**

  `filter()`方法创建一个包含通过测试的数组元素的新数组。

  ```js
  var numbers = [45, 4, 9, 16, 25];
  // 除了IE8以及更低版本，均支持
  var over18 = numbers.filter(myFunction);
  
  function myFunction(value, index, array) {
    return value > 18;
  }
  
  //可以省略后面两个参数
  //function myFunction(value) {
  //  return value > 18;
  //}
  ```

  结果

  ```
  over18 = [45,25]
  ```

* 处理每个元素得到最终结果

  `reduce()` 方法在每个数组元素上运行函数，以生成（减少它）单个值。

  `reduce() `方法在数组中从左到右工作。另请参见` reduceRight()`。

  `reduce() `方法不会减少原始数组。

  ```js
  var numbers1 = [45, 4, 9, 16, 25];
  // 除了IE8以及更低版本，均支持
  var sum = numbers1.reduce(myFunction);
  
  var sum1 = numbers1.reduce(myFunction, 100);// 可以接收一个初始值
  
  // 将所有元素的加起来
  // 参数： 总数（初始值/先前返回的值）、项目值、项目索引、数组本身
  function myFunction(total, value, index, array) {
    return total + value;
  }
  ```

  结果

  ```
  sum = 99
  sum1 = 199
  ```

* 检查每个元素是否通过测试

  `every() `方法检查所有数组值是否通过测试。

  ```js
  var numbers = [45, 4, 9, 16, 25];
  // 检查是否全部大于18
  var allOver18 = numbers.every(myFunction);
  
  function myFunction(value, index, array) {
    return value > 18;
  }
  ```

* 检查是否有元素通过测试

  `some()` 方法检查某些数组值是否通过了测试。

  ```js
  var numbers = [45, 4, 9, 16, 25];
  var someOver18 = numbers.some(myFunction);
  // 参数：项目值、项目索引、数组本身
  function myFunction(value, index, array) {
    return value > 18;
  }
  ```

* 搜索元素

  **根据索引搜索**

  ```js
  var fruits = ["Apple", "Orange", "Apple", "Mango"];
  // 除了 Internet Explorer 8 或更早的版本, 均支持
  // array.indexOf(item, start)
  // item: 必需。要检索的项目
  // start：可选。从哪里开始搜索。负值将从结尾开始的给定位置开始，并搜索到结尾。
  var a = fruits.indexOf("Apple");
  
  var b = fruits.lastIndexOf("Apple");
  ```

  结果

  ```
  a = 0
  b = 2
  ```

  **根据条件搜索**

  ```js
  var numbers = [4, 9, 16, 25, 29];
  var first = numbers.find(myFunction);
  
  function myFunction(value, index, array) {
    return value > 18;
  }
  ```

## 2.12 日期

**Date**

JavaScript 从 0 到 11 计算月份。

```js
// 用当前日期和时间创建新的日期对象
// Tue Apr 02 2019 09:01:19 GMT+0800 (中国标准时间)
new Date()
// 7个数字分别指定年、月、日、小时、分钟、秒和毫秒
new Date(year, month, day, hours, minutes, seconds, milliseconds)
// 1970年 1 月 1 日加上milliseconds毫秒
new Date(milliseconds)
new Date(date string)
```

**UTC时间**

toUTCString() 方法将日期转换为 UTC 字符串（一种日期显示标准）

```js
var d = new Date();
// Sun, 04 Aug 2019 07:10:25 GMT
document.getElementById("demo").innerHTML = d.toUTCString();
```

**日期字符串**

toDateString() 方法将日期转换为日期字符串

```js
var d = new Date();
// Sun Aug 04 2019
document.getElementById("demo").innerHTML = d.toDateString();
```

**日期获取方法**

| 方法                | 描述                                 |
| :------------------ | :----------------------------------- |
| `getDate()`         | 以数值返回天（1-31）                 |
| `getDay()`          | 以数值获取周名（0-6）                |
| `getFullYear()`     | 获取四位的年（yyyy）                 |
| `getHours()`        | 获取小时（0-23）                     |
| `getMilliseconds()` | 获取1秒中的毫秒（0-999）             |
| `getMinutes()`      | 获取分（0-59）                       |
| `getMonth()`        | 获取月（0-11）                       |
| `getSeconds()`      | 获取秒（0-59）                       |
| `getTime()`         | 获取时间（从 1970 年 1 月 1 日至今） |

**日期设置方法**

| 方法                | 描述                                         |
| :------------------ | :------------------------------------------- |
| `setDate()`         | 以数值（1-31）设置日                         |
| `setFullYear()`     | 设置年（可选月和日）                         |
| `setHours()`        | 设置小时（0-23）                             |
| `setMilliseconds()` | 设置毫秒（0-999）                            |
| `setMinutes()`      | 设置分（0-59）                               |
| `setMonth()`        | 设置月（0-11）                               |
| `setSeconds()`      | 设置秒（0-59）                               |
| `setTime()`         | 设置时间（从 1970 年 1 月 1 日至今的毫秒数） |

## 2.13 [Math对象](https://www.w3school.com.cn/jsref/jsref_obj_math.asp)

**四舍五入**

```js
Math.round(6.8);    // 返回 7
Math.round(2.3);    // 返回 2
```

**向上舍入**

```js
Math.ceil(6.4);     // 返回 7
```

**向下舍入**

```js
Math.floor(2.7);    // 返回 2
```

**次幂**

```js
Math.pow(8, 2); // 返回 64
```

**平方根**

```js
Math.sqrt(64);      // 返回 8
```

**绝对值**

```js
Math.abs(-4.7);     // 返回 4.7
```

**随机数**

0到1的随机数，包括0，但不包括1。

```js
Math.random();     // 返回随机数
```

**常数**

```js
Math.E          // 返回欧拉指数（Euler's number）
Math.PI         // 返回圆周率（PI）
Math.SQRT2      // 返回 2 的平方根
Math.SQRT1_2    // 返回 1/2 的平方根
Math.LN2        // 返回 2 的自然对数
Math.LN10       // 返回 10 的自然对数
Math.LOG2E      // 返回以 2 为底的 e 的对数（约等于 1.414）
Math.LOG10E     // 返回以 10 为底的 e 的对数（约等于0.434）
```

**Math函数表**

| 方法               | 描述                                                     |
| :----------------- | :------------------------------------------------------- |
| `abs(x)`           | 返回 x 的绝对值                                          |
| `acos(x)`          | 返回 x 的反余弦值，以弧度计                              |
| `asin(x)`          | 返回 x 的反正弦值，以弧度计                              |
| `atan(x)`          | 以介于 -PI/2 与 PI/2 弧度之间的数值来返回 x 的反正切值。 |
| `atan2(y,x)`       | 返回从 x 轴到点 (x,y) 的角度                             |
| `ceil(x)`          | 对 x 进行上舍入                                          |
| `cos(x)`           | 返回 x 的余弦                                            |
| `exp(x)`           | 返回 Ex 的值                                             |
| `floor(x)`         | 对 x 进行下舍入                                          |
| `log(x)`           | 返回 x 的自然对数（底为e）                               |
| `max(x,y,z,...,n)` | 返回最高值                                               |
| `min(x,y,z,...,n)` | 返回最低值                                               |
| `pow(x,y)`         | 返回 x 的 y 次幂                                         |
| `random()`         | 返回 0 ~ 1 之间的随机数                                  |
| `round(x)`         | 把 x 四舍五入为最接近的整数                              |
| `sin(x)`           | 返回 x（x 以角度计）的正弦                               |
| `sqrt(x)`          | 返回 x 的平方根                                          |
| `tan(x)`           | 返回角的正切                                             |

## 2.14 逻辑

**布尔值**

可以使用 `Boolean()` 函数来确定表达式（或变量）是否为真

```js
Boolean(10 > 9)        // 返回 true
(10 > 9)              // 也返回 true
10 > 9                // 也返回 true
```

**值的true或者false**

```js
// 所有具有“真实”值的即为 True
100
3.14
-15
"Hello"
"false"
7 + 1 + 3.14
5 < 6 

// 所有不具有“真实”值的即为 False
var x = 0;
Boolean(x);       // 返回 false
x = -0;
Boolean(x);       // 返回 false
x = "";
Boolean(x);       // 返回 false
var y;
Boolean(y);       // 返回 false
x = null;
Boolean(x);       // 返回 false
x = false;
Boolean(x);       // 返回 false
x = 10 / "H";
Boolean(x);       // NaN  返回 false
```

**条件运算符**

```js
variablename = (condition) ? value1:value2
```

## 2.15 条件语句

- 使用 `if` 来规定要执行的代码块，如果指定条件为 `true`
- 使用 `else` 来规定要执行的代码块，如果相同的条件为` false`
- 使用 `else if` 来规定要测试的新条件，如果第一个条件为` false`
- 使用 `switch` 来规定多个被执行的备选代码块

```js
switch(表达式) {
     case n:
        代码块
        break;
     case n:
        代码块
        break;
     default:
        默认代码块
} 
```

## 2.16 for/while循环

- `for `- 多次遍历代码块
- `for/in` - 遍历对象属性
- `while` - 当指定条件为 true 时循环一段代码块
- `do/while` - 当指定条件为 true 时循环一段代码块

```js
var person = {fname:"Bill", lname:"Gates", age:62}; 

var text = "";
var x;
for (x in person) {
    text += person[x];
}
```

## 2.17 数据类型转换

```js
String(123);       // 从数值文本 123 返回字符串
(123).toString();

String(false)        // 返回 "false"

String(Date())      // 返回 "Sun Aug 04 2019 15:30:42 GMT+0800 (China Standard Time)"
```

## 2.18 位运算

| 运算符 | 名称         | 描述                                                     |
| :----- | :----------- | :------------------------------------------------------- |
| `&`    | AND          | 如果两位都是 1 则设置每位为 1                            |
| `|`    | OR           | 如果两位之一为 1 则设置每位为 1                          |
| `^`    | XOR          | 如果两位只有一位为 1 则设置每位为 1                      |
| `~`    | NOT          | 反转所有位                                               |
| `<<`   | 零填充左位移 | 通过从右推入零向左位移，并使最左边的位脱落。             |
| `>>`   | 有符号右位移 | 通过从左推入最左位的拷贝来向右位移，并使最右边的位脱落。 |
| `>>>`  | 零填充右位移 | 通过从左推入零来向右位移，并使最右边的位脱落。           |

## 2.19 正则表达式

**语法**

```
/pattern/modifiers;
```

实例

```js
// /i表示将索引修改为大小写不敏感
var patt = /w3school/i;
```

**修饰词**

| 修饰符 | 描述                                                     |
| :----- | :------------------------------------------------------- |
| i      | 执行对大小写不敏感的匹配。                               |
| g      | 执行全局匹配（查找所有匹配而非在找到第一个匹配后停止）。 |
| m      | 执行多行匹配。                                           |

| 表达式  | 描述                       |
| :------ | :------------------------- |
| `[abc]` | 查找方括号之间的任何字符。 |
| `[0-9]` | 查找任何从 0 至 9 的数字。 |
| `(x|y)` | 查找由 \| 分隔的任何选项。 |

| `\d`     | 查找数字。                                  |
| -------- | ------------------------------------------- |
| `\s`     | 查找空白字符。                              |
| `\b`     | 匹配单词边界。                              |
| `\uxxxx` | 查找以十六进制数 xxxx 规定的 Unicode 字符。 |

| 量词 | 描述                                |
| :--- | :---------------------------------- |
| `n+` | 匹配任何包含至少一个 n 的字符串。   |
| `n*` | 匹配任何包含零个或多个 n 的字符串。 |
| `n?` | 匹配任何包含零个或一个 n 的字符串。 |

**正则表达式函数**

* 搜索字符串是否存在

  ```js
  var patt = /e/;
  patt.test("The best things in life are free!"); 
  
  /e/.test("The best things in life are free!");
  ```

  结果

  ```
  true
  ```

* 返回搜索到的文本

  ```js
  /e/.exec("The best things in life are free!");
  ```

  结果

  ```
  e
  ```

## 2.20 异常

**异常处理**

```js
try {
     供测试的代码块
}
 catch(err) {
     处理错误的代码块
} 
```

## 2.21 Hoisting

JavaScript 声明会被提升，而初始化不会被提升。

```js
var x = 5; // 初始化 x
 
elem = document.getElementById("demo"); // 查找元素
elem.innerHTML ="x is " x + " and y is " + y;           // 显示 x 和 y
 
var y = 7; // 初始化 y 
```

结果

```
x is 5 and y is undefined
```

说明：在输出时，y已经声明但是还没有初始化。

## 2.22 严格模式

**使用方法**

（**只能**）通过在脚本或函数的**开头**添加 `"use strict"; `来声明严格模式

```js
"use strict";
```

**严格模式不允许事项**

* 不允许在不声明变量（对象）的情况下使用变量（对象）

* 不允许删除函数

* 不允许重复参数名

* 不允许八进制数值

  ```js
  "use strict";
  var x = 010;             // 这将引发错误
  ```

* 不允许转意字符

  ```js
  "use strict";
  var x = \010;            // 这将引发错误
  ```

* 不允许写入只读

  ```js
  "use strict";
  var obj = {get x() {return 0} };
  
  obj.x = 3.14;            // 这将引发错误
  ```

* 不允许删除不可删除的属性

* 不运行使用的变量名

  eval、arguments、implements、interface、let、package、private、protected、public、static、yield

## 2.23 this关键字

- 在方法中，this 指的是所有者对象。

```js
var person = {
  firstName: "Bill",
  lastName : "Gates",
  id       : 678,
  fullName : function() {
      // this是指person对象
    return this.firstName + " " + this.lastName;
  }
};
```

- 单独的情况下，this 指的是全局对象。

  ```js
  var x = this; // 全局对象 [object Window]
  ```

- 在函数中，this 指的是全局对象或者未定义（严格模式）。

  ```js
  function myFunction() {
    return this;// 全局对象 [object Window]
  }
  
  "use strict";
  function myFunction() {
    return this; // 严格模式下，this为未定义(undefined)
  }
  ```

- 在事件中，this 指的是接收事件的元素。

  ```html
  <!DOCTYPE html>
  <html>
  <body>
  <h1>JavaScript <b>this</b> 关键词</h1>
  <button onclick="this.style.display='none'">单击来删除我！</button>
  </body>
  </html>
  
  ```

## 2.24 块作用域

**`let`修饰词** 

一般的`{}`相当与没有作用，

```js
var x = 10;
// 此处 x 为 10
{ 
  var x = 6;
  // 此处 x 为 6
}
// 此处 x 为 6


```

用`let`声明变量，则表示变量只在`{}`有作用。

```js
var x = 10;
// 此处 x 为 10
{ 
  let x = 6;
  // 此处 x 为 6
}
// 此处 x 为 10
```

```js
let i = 7;
for (let i = 0; i < 10; i++) {
  // 一些语句
}
// 此处 i 为 7
```

**`const`修饰词**

类似与`let`，但是`const`修饰的变量不能重新赋值：

```js
const PI = 3.141592653589793;
PI = 3.14;      // 会出错
PI = PI + 10;   // 也会出错
```

```js
var x = 10;
// 此处，x 为 10
{ 
  const x = 6;
  // 此处，x 为 6
}
// 此处，x 为 10
```

## 2.25 JSON

```js
{
"employees":[
    {"firstName":"Bill", "lastName":"Gates"}, 
    {"firstName":"Steve", "lastName":"Jobs"},
    {"firstName":"Alan", "lastName":"Turing"}
]
}
```

# 3.JS HTML DOM

## 3.1 HTML DOM

当网页被加载时，浏览器会创建页面的文档对象模型（DOM, Document Object Model）。

<img src="/images/wiki/js/ct_htmltree.gif" width="600" alt="HTML DOM树">

## 3.2 HTML DOM方法

HTML DOM可以通过JS访问。

```html
<html>
<body>
<p id="demo"></p>
<script>
<!--getElementById找到ID为"demo"的元素，innerHTML属性可用于获取或替换 HTML 元素的内容-->
document.getElementById("demo").innerHTML = "Hello World!";
</script>
</body>
</html>
```

## 3.3 HTML DOM Document对象

文档代表此网页，可从document访问网页的元素

* **查找元素**

  | 方法                                    | 描述                   |
  | :-------------------------------------- | :--------------------- |
  | document.getElementById(*id*)           | 通过元素 id 来查找元素 |
  | document.getElementsByTagName(*name*)   | 通过标签名来查找元素   |
  | document.getElementsByClassName(*name*) | 通过类名来查找元素     |

* **修改元素**

  | 方法                                       | 描述                   |
  | :----------------------------------------- | :--------------------- |
  | element.innerHTML = *new html content*     | 改变元素的 inner HTML  |
  | element.attribute = *new value*            | 改变 HTML 元素的属性值 |
  | element.setAttribute(*attribute*, *value*) | 改变 HTML 元素的属性值 |
  | element.style.property = *new style*       | 改变 HTML 元素的样式   |

* **添加和删除元素**

  | 方法                              | 描述             |
  | :-------------------------------- | :--------------- |
  | document.createElement(*element*) | 创建 HTML 元素   |
  | document.removeChild(*element*)   | 删除 HTML 元素   |
  | document.appendChild(*element*)   | 添加 HTML 元素   |
  | document.replaceChild(*element*)  | 替换 HTML 元素   |
  | document.write(*text*)            | 写入 HTML 输出流 |

* **添加时间处理**

  | 方法                                                     | 描述                            |
  | :------------------------------------------------------- | :------------------------------ |
  | document.getElementById(id).onclick = function(){*code*} | 向 onclick 事件添加事件处理程序 |

* **查找HTML对象**

  DOM Level为版本。

  | 属性                         | 描述                                            | DOM LEVEL |
  | :--------------------------- | :---------------------------------------------- | :-------- |
  | document.anchors             | 返回拥有 name 属性的所有` <a>` 元素。           | 1         |
  | document.applets             | 返回所有 `<applet>` 元素（HTML5 不建议使用）    | 1         |
  | document.baseURI             | 返回文档的绝对基准 URI                          | 3         |
  | document.body                | 返回 `<body>` 元素                              | 1         |
  | document.cookie              | 返回文档的 cookie                               | 1         |
  | document.doctype             | 返回文档的 doctype                              | 3         |
  | document.documentElement     | 返回` <html>` 元素                              | 3         |
  | document.documentMode        | 返回浏览器使用的模式                            | 3         |
  | document.documentURI         | 返回文档的 URI                                  | 3         |
  | document.domain              | 返回文档服务器的域名                            | 1         |
  | document.domConfig           | 废弃。返回 DOM 配置                             | 3         |
  | document.embeds              | 返回所有 `<embed> `元素                         | 3         |
  | document.forms               | 返回所有 `<form> `元素                          | 1         |
  | document.head                | 返回 `<head> `元素                              | 3         |
  | document.images              | 返回所有 `<img>` 元素                           | 1         |
  | document.implementation      | 返回 DOM 实现                                   | 3         |
  | document.inputEncoding       | 返回文档的编码（字符集）                        | 3         |
  | document.lastModified        | 返回文档更新的日期和时间                        | 3         |
  | document.links               | 返回拥有 href 属性的所有 `<area> `和 `<a> `元素 | 1         |
  | document.readyState          | 返回文档的（加载）状态                          | 3         |
  | document.referrer            | 返回引用的 URI（链接文档）                      | 1         |
  | document.scripts             | 返回所有` <script>` 元素                        | 3         |
  | document.strictErrorChecking | 返回是否强制执行错误检查                        | 3         |
  | document.title               | 返回` <title> `元素                             | 1         |
  | document.URL                 | 返回文档的完整 URL                              | 1         |

## 3.4 JS改变HTML元素样式

* **改变样式**

  ```html
  document.getElementById(id).style.property = new style
  ```

* **使用事件**

  点击按钮时，更改 id="id1" 的 HTML 元素的样式

  ```html
  <!DOCTYPE html>
  <html>
  <body>
  <h1 id="id1">我的标题 1</h1>
  <button type="button" onclick="document.getElementById('id1').style.color = 'red'">
  点击我！
  </button>
  </body>
  </html>
  ```

## 3.5 使用JS创建HTML动画

```html
<!DOCTYPE html>
<html>
<style>
#container {
  width: 400px;
  height: 400px;
  position: relative;
  background: yellow;
}
#animate {
  width: 50px;
  height: 50px;
  position: absolute;
  background-color: red;
}
</style>
<body>
<p><button onclick="myMove()">单击我</button></p> 
<div id ="container">
  <div id ="animate"></div>
</div>
<script>
function myMove() {
  var elem = document.getElementById("animate");   
  var pos = 0;
  var id = setInterval(frame, 5);
  function frame() {
    if (pos == 350) {
      clearInterval(id);
    } else {
      pos++; 
      elem.style.top = pos + "px"; 
      elem.style.left = pos + "px"; 
    }
  }
}
</script>
</body>
</html>

```

## 3.6 HTML DOM 事件

* **事件类型**
  - 当用户点击鼠标时
  - 当网页加载后
  - 当图像加载后
  - 当鼠标移至元素上时
  - 当输入字段被改变时
  - 当 HTML 表单被提交时
  - 当用户敲击按键时

* **事件句柄**

  | 属性        | 此事件发生在何时...                  |
  | :---------- | :----------------------------------- |
  | onabort     | 图像的加载被中断。                   |
  | onblur      | 元素失去焦点。                       |
  | onchange    | 域的内容被改变。                     |
  | onclick     | 当用户点击某个对象时调用的事件句柄。 |
  | ondblclick  | 当用户双击某个对象时调用的事件句柄。 |
  | onerror     | 在加载文档或图像时发生错误。         |
  | onfocus     | 元素获得焦点。                       |
  | onkeydown   | 某个键盘按键被按下。                 |
  | onkeypress  | 某个键盘按键被按下并松开。           |
  | onkeyup     | 某个键盘按键被松开。                 |
  | onload      | 一张页面或一幅图像完成加载。         |
  | onmousedown | 鼠标按钮被按下。                     |
  | onmousemove | 鼠标被移动。                         |
  | onmouseout  | 鼠标从某元素移开。                   |
  | onmouseover | 鼠标移到某元素之上。                 |
  | onmouseup   | 鼠标按键被松开。                     |
  | onreset     | 重置按钮被点击。                     |
  | onresize    | 窗口或框架被重新调整大小。           |
  | onselect    | 文本被选中。                         |
  | onsubmit    | 确认按钮被点击。                     |
  | onunload    | 用户退出页面                         |

* **键盘/鼠标属性**

  | 属性          | 描述                                         |
  | :------------ | :------------------------------------------- |
  | altKey        | 返回当事件被触发时，"ALT" 是否被按下。       |
  | button        | 返回当事件被触发时，哪个鼠标按钮被点击。     |
  | clientX       | 返回当事件被触发时，鼠标指针的水平坐标。     |
  | clientY       | 返回当事件被触发时，鼠标指针的垂直坐标。     |
  | ctrlKey       | 返回当事件被触发时，"CTRL" 键是否被按下。    |
  | metaKey       | 返回当事件被触发时，"meta" 键是否被按下。    |
  | relatedTarget | 返回与事件的目标节点相关的节点。             |
  | screenX       | 返回当某个事件被触发时，鼠标指针的水平坐标。 |
  | screenY       | 返回当某个事件被触发时，鼠标指针的垂直坐标。 |
  | shiftKey      | 返回当事件被触发时，"SHIFT" 键是否被按下。   |

* **其他DOM事件/属性**

  https://www.w3school.com.cn/jsref/dom_obj_event.asp

## 3.7 HTML DOM的时间监听器

* **实例**

  ```html
  <!DOCTYPE html>
  <html>
  <body>
  <h2>JavaScript addEventListener()</h2>
  <p>此示例使用 addEventListener() 方法将 click 事件附加到按钮。</p>
  <button id="myBtn">试一试</button>
  <p id="demo"></p>
  <script>
  document.getElementById("myBtn").addEventListener("click", displayDate);
  function displayDate() {
    document.getElementById("demo").innerHTML = Date();
  }
  </script>
  </body>
  </html>
  ```

* **语法**

  ```html
  <!--单个元素支持多个事件监听器-->
  element.addEventListener(event, function, useCapture);
  element.addEventListener(event, function, useCapture);
  ```

  第一个参数是事件的类型（比如 "click" 或 "mousedown"）。

  第二个参数是当事件发生时我们需要调用的函数。

  第三个参数是布尔值，指定使用事件冒泡还是事件捕获。此参数是可选的。

  > 在冒泡中(false，默认)，最内侧元素的事件会首先被处理，然后是更外侧的：首先处理 `<p> `元素的点击事件，然后是 `<div> `元素的点击事件。
  >
  > 在捕获中(true)，最外侧元素的事件会首先被处理，然后是更内侧的：首先处理 `<div>` 元素的点击事件，然后是 `<p>` 元素的点击事件。

* **窗口对象添加事件处理程序**

  添加当用户调整窗口大小时触发的事件监听器

  ```html
  <!DOCTYPE html>
  <html>
  <body>
  <h1>JavaScript addEventListener()</h1>
  <p>此例在 window 对象上使用 addEventListener() 方法。</p>
  <p>尝试调整此浏览器窗口的大小以触发“resize”事件处理程序。</p>
  <p id="demo"></p>
  <script>
      // function是匿名函数
  window.addEventListener("resize", function(){
    document.getElementById("demo").innerHTML = Math.random();
  });
  </script>
  </body>
  </html>
  
  ```

* **传递参数**

  ```html
  element.addEventListener("click", function(){ myFunction(p1, p2); });
  ```

* **移除事件监听器**

  `removeEventListener`

## 3.8 DOM导航

* **节点**

  - 术语（父、子和同胞，parent、child 以及 sibling）用于描述这些关系。
  - 在节点树中，顶端节点被称为根（根节点）。
  - 每个节点都有父节点，除了根（根节点没有父节点）。
  - 节点能够拥有一定数量的子
  - 同胞（兄弟或姐妹）指的是拥有相同父的节点。

* 结构

  ```html
  <html>
     <head>
         <title>DOM 教程</title>
     </head>
    <body>
         <h1>DOM 第一课</h1>
         <p>Hello world!</p>
     </body>
  </html> 
  ```

  <img src="/images/wiki/js/dom_navigate.gif" width="600" alt="HTML 节点关系">

  - `<html>` 是根节点
  - `<html>` 没有父
  - `<html>` 是`<head>` 和 `<body>` 的父
  - `<head>` 是 `<html>` 的第一个子
  - `<body>` 是 `<html>` 的最后一个子
  - `<head> `有一个子：`<title>`
  - `<title>` 有一个子（文本节点）："DOM 教程"
  - `<body> `有两个子：`<h1>` 和` <p>`
  - `<h1>` 有一个子："DOM 第一课"
  - `<p> `有一个子："Hello world!"
  - `<h1>` 和` <p> `是同胞

* **通过JS导航**
  - parentNode
  - childNodes[*nodenumber*]
  - firstChild
  - lastChild
  - nextSibling
  - previousSibling

* **举例**

  ```html
  <!DOCTYPE html>
  <html>
  <body>
  
  <h1 id="id01">我的第一张网页</h1>
  <p id="id02"></p>
  
  <script>
  document.getElementById("id02").innerHTML = document.getElementById("id01").childNodes[0].nodeValue;// id02变为和id01一样的内容
  </script>
  
  </body>
  </html>
  ```

* **删除节点**

  ```html
  <div id="div1">
  <p id="p1">这是一个段落。</p>
  <p id="p2">这是另一个段落。</p>
  </div>
  
  <script>
  var parent = document.getElementById("div1");
  var child = document.getElementById("p1");
  parent.removeChild(child);
  </script>
  ```

## 3.9 集合

`getElementsByTagName()` 方法返回 *HTMLCollection* 对象。

```js
// 获取所有p
var x = document.getElementsByTagName("p");
```

# 4.JS Browser BOM

浏览器对象模型（BOM, Browser Object Model）。

## 4.1 Window对象

* **实例**

  ```html
  <!DOCTYPE html>
  <html>
  <body>
  
  <p id="demo"></p>
  
  <script>
  var w = window.innerWidth
  || document.documentElement.clientWidth
  || document.body.clientWidth;
  
  var h = window.innerHeight
  || document.documentElement.clientHeight
  || document.body.clientHeight;
  
  var x = document.getElementById("demo");
  x.innerHTML = "浏览器内窗宽度：" + w + "，高度：" + h + "。";
  </script>
  
  </body>
  </html>
  
  ```

* **其他方法**

  ```
  window.open() - 打开新窗口
  window.close() - 关闭当前窗口
  window.moveTo() -移动当前窗口
  window.resizeTo() -重新调整当前窗口
  ```

## 4.2 Window Screen

- screen.width - 访问者屏幕宽度
- screen.height - 访问者屏幕的高度
- screen.availWidth - 访问者屏幕的可用宽度，即宽度减去工具条等
- screen.availHeight - 访问者屏幕的可用高度
- screen.colorDepth - 显示一种颜色的比特数
- screen.pixelDepth - 屏幕的像素深度

## 4.3 Window Location

- window.location.href 返回当前页面的 href (URL)
- window.location.hostname 返回 web 主机的域名
- window.location.pathname 返回当前页面的路径或文件名
- window.location.protocol 返回使用的 web 协议（http: 或 https:）
- window.location.assign 加载新文档

## 4.4 Window History

- history.back() - 等同于在浏览器点击后退按钮
- history.forward() - 等同于在浏览器中点击前进按钮

## 4.5 Window Navigator

window.navigator对象包含有关访问者的信息。

* navigator.appName - 浏览器应用名称，“Netscape” 是 IE11、Chrome、Firefox 和 Safari 的应用程序名称。
* navigator.appCodeName - 浏览器的应用程序代码名称“Mozilla” 是 Chrome、Firefox、IE、Safari 和 Opera 的应用程序代码名称。
* navigator.platform - 浏览器平台，Linux x86_64
* navigator.cookieEnabled - cookies是否使能

## 4.6 Window 弹出框

* **警告框**

  如果要确保信息传递给用户，通常会使用警告框。

  当警告框弹出时，用户将需要单击“确定”来继续。

  ```js
  window.alert("sometext");
  ```

* **确认框**

  如果您希望用户验证或接受某个东西，则通常使用“确认”框。

  当确认框弹出时，用户将不得不单击“确定”或“取消”来继续进行。

  如果用户单击“确定”，该框返回 true。如果用户单击“取消”，该框返回 false。

  ```js
  window.confirm("sometext");
  ```

* **提示框**

  如果您希望用户在进入页面前输入值，通常会使用提示框。

  当提示框弹出时，用户将不得不输入值后单击“确定”或点击“取消”来继续进行。

  如果用户单击“确定”，该框返回输入值。如果用户单击“取消”，该框返回 NULL

  ```js
  window.prompt("sometext","defaultText");
  ```

## 4.7 JS Timing 事件

window 对象允许以指定的时间间隔执行代码。这些时间间隔称为定时事件。

通过 JavaScript 使用的有两个关键的方法：

- setTimeout(*function*, *milliseconds*)

  在等待指定的毫秒数后执行函数。

- setInterval(*function*, *milliseconds*)

  等同于 setTimeout()，但持续重复执行该函数。

setTimeout() 和 setInterval() 都属于 HTML DOM Window 对象的方法。

```js
myVar1 = setTimeout(function, milliseconds);//等待指定毫秒后执行函数
clearTimeout(myVar1);//停止myVar这个Timing事件

myVar2 = setInterval(function, milliseconds);
clearInterval(myVar2);
```

## 4.8 JS Cookies

Cookie 是在您的计算机上存储在小的文本文件中的数据。

当 web 服务器向浏览器发送网页后，连接被关闭，服务器会忘记用户的一切。

Cookie 是为了解决“如何记住用户信息”而发明的：

- 当用户访问网页时，他的名字可以存储在 cookie 中。
- 下次用户访问该页面时，cookie 会“记住”他的名字。

Cookie 保存在名称值对中，如：

```
username = Bill Gates
```

当浏览器从服务器请求一个网页时，将属于该页的 cookie 添加到该请求中。这样服务器就获得了必要的数据来“记住”用户的信息。

* **JS创建Cookie**

  ```js
  // 创建简单的cookie
  document.cookie = "username=Bill Gates";
  // 添加cookie有效日期，默认情况下，浏览器关闭时会删除cookie
  document.cookie = "username=John Doe; expires=Sun, 31 Dec 2017 12:00:00 UTC";
  //通过 path 参数，您可以告诉浏览器 cookie 属于什么路径。
  document.cookie = "username=Bill Gates; expires=Sun, 31 Dec 2017 12:00:00 UTC; path=/";
  ```

* **JS读取cookie**

  ```js
  var x = document.cookie;
  ```

  document.cookie 会在一条字符串中返回所有 cookie，比如：cookie1=value; cookie2=value; cookie3=value;

* **JS删除cookie**

  将cookie的有效日期设置为过去

  ```js
  document.cookie = "username=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
  ```

* **实例**

  ```js
  // 设置cookie
  function setCookie(cname, cvalue, exdays) {
      var d = new Date();
      d.setTime(d.getTime() + (exdays*24*60*60*1000));
      var expires = "expires="+ d.toUTCString();
      document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
  } 
  // 获取cookie
  function getCookie(cname) {
      var name = cname + "=";
      var decodedCookie = decodeURIComponent(document.cookie);
      var ca = decodedCookie.split(';');
      for(var i = 0; i <ca.length; i++) {
          var c = ca[i];
          while (c.charAt(0) == ' ') {
              c = c.substring(1);
           }
           if (c.indexOf(name) == 0) {
              return c.substring(name.length, c.length);
           }
       }
      return "";
  } 
  // 检查cookie
  function checkCookie() {
      var username = getCookie("username");
      if (username != "") {
          alert("Welcome again " + username);
      } else {
          username = prompt("Please enter your name:", "");
          if (username != "" && username != null) {
              setCookie("username", username, 365);
          }
      }
  } 
  ```

# 5.JS AJAX

## 5.1 AJAX介绍

AJAX = **A**synchronous **J**avaScript **A**nd **X**ML.

AJAX的功能：

- 不刷新页面更新网页
- 在页面加载后从服务器请求数据
- 在页面加载后从服务器接收数据
- 在后台向服务器发送数据

```html
<!DOCTYPE html>
<html>
<body>

<div id="demo">
<h1>XMLHttpRequest 对象</h1>
<button type="button" onclick="loadDoc()">修改内容</button>
</div>

<script>
function loadDoc() {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      document.getElementById("demo").innerHTML =
      this.responseText;
    }
  };
    //获取数据，GET访问，地址，异步为true
  xhttp.open("GET", "/example/js/ajax_info.txt", true);
    //发送数据
  xhttp.send();
}
</script>

</body>
</html>

```

AJAX 并非编程语言。AJAX 仅仅组合了：

- 浏览器内建的 XMLHttpRequest 对象（从 web 服务器请求数据）
- JavaScript 和 HTML DOM（显示或使用数据）

**ajax运行过程**

<img src="/images/wiki/js/ajax.gif" width="600" alt="ajax过程">

1. 网页中发生一个事件（页面加载、按钮点击）
2. 由 JavaScript 创建 XMLHttpRequest 对象
3. XMLHttpRequest 对象向 web 服务器发送请求
4. 服务器处理该请求
5. 服务器将响应发送回网页
6. 由 JavaScript 读取响应
7. 由 JavaScript 执行正确的动作（比如更新页面）

## 5.2 AJAX - XMLHttpRequest 对象

XMLHttpRequest 对象用于同幕后服务器交换数据。这意味着可以更新网页的部分，而不需要重新加载整个页面。

* **跨域访问**

  出于安全原因，现代浏览器不允许跨域访问。这意味着尝试加载的网页和 XML 文件都必须位于相同服务器上。

  要解决该问题，在后端服务器内运行跨域访问——`@CrossOrigin`（org.springframework.web.bind.annotation.*），打开CROS。

* **XMLHttpRequest对象方法**

  | 方法                                          | 描述                                                         |
  | :-------------------------------------------- | :----------------------------------------------------------- |
  | new XMLHttpRequest()                          | 创建新的 XMLHttpRequest 对象                                 |
  | abort()                                       | 取消当前请求                                                 |
  | getAllResponseHeaders()                       | 返回头部信息                                                 |
  | getResponseHeader()                           | 返回特定的头部信息                                           |
  | open(*method*, *url*, *async*, *user*, *psw*) | 规定请求method：请求类型 GET 或 POSTurl：文件位置async：true（异步）或 false（同步）user：可选的用户名称psw：可选的密码 |
  | send()                                        | 将请求发送到服务器，用于 GET 请求                            |
  | send(*string*)                                | 将请求发送到服务器，用于 POST 请求                           |
  | setRequestHeader()                            | 向要发送的报头添加标签/值对                                  |

  ```js
  /***  GET   */
  // Math.random()随机数，防止返回一个缓存
  // xhttp.open("GET", "demo_get.asp", true);
  xhttp.open("GET", "demo_get.asp?t=" + Math.random(), true);
  xhttp.send();
  // GET携带信息
  xhttp.open("GET", "demo_get2.asp?fname=Bill&lname=Gates", true);
  xhttp.send();
  ```

  ```js
  /***  POST   */
  xhttp.open("POST", "ajax_test.asp", true);
  // 如需像 HTML 表单那样 POST 数据，请通过setRequestHeader() 添加一个 HTTP 头部。
  xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  xhttp.send("fname=Bill&lname=Gates");
  
  ```

  | 方法                                | 描述                                                         |
  | :---------------------------------- | :----------------------------------------------------------- |
  | setRequestHeader(*header*, *value*) | 向请求添加 HTTP 头部*header*：规定头部名称*value*：规定头部值 |

* **XMLHttpRequest对象属性**

  | 属性               | 描述                                                         |
  | :----------------- | :----------------------------------------------------------- |
  | onreadystatechange | 定义当 readyState 属性发生变化时被调用的函数                 |
  | readyState         | 保存 XMLHttpRequest 的状态。0：请求未初始化1：服务器连接已建立2：请求已收到3：正在处理请求4：请求已完成且响应已就绪 |
  | responseText       | 以字符串返回响应数据                                         |
  | responseXML        | 以 XML 数据返回响应数据                                      |
  | status             | 返回请求的状态号200: "OK"403: "Forbidden"404: "Not Found"如需完整列表请访问 [Http 消息参考手册](https://www.w3school.com.cn/tags/ref_httpmessages.asp) |
  | statusText         | 返回状态文本（比如 "OK" 或 "Not Found"）                     |

  **onreadystatechange的使用**

  通过 XMLHttpRequest 对象，您可以定义当请求接收到应答时所执行的函数。

  ```js
  xhttp.onreadystatechange = function() {
      // 
    if (this.readyState == 4 && this.status == 200) {
      document.getElementById("demo").innerHTML = this.responseText;
    }
  };
  xhttp.open("GET", "ajax_info.txt", true);
  xhttp.send();
  ```

  | 属性               | 描述                                                         |
  | :----------------- | :----------------------------------------------------------- |
  | onreadystatechange | 定义了当 readyState 属性发生改变时所调用的函数。             |
  | readyState         | 保存了 XMLHttpRequest 的状态。0: 请求未初始化；1: 服务器连接已建立；2: 请求已接收；3: 正在处理请求；4: 请求已完成且响应已就绪 |
  | status             | 200: "OK"；403: "Forbidden"；404: "Page not found"；如需完整列表，请访问 [Http 消息参考手册](https://www.w3school.com.cn/tags/ref_httpmessages.asp) |
  | statusText         | 返回状态文本（例如 "OK" 或 "Not Found"）                     |

## 5.3 AJAX XML

```html
<!DOCTYPE html>
<html>
<style>
table,th,td {
  border : 1px solid black;
  border-collapse: collapse;
}
th,td {
  padding: 5px;
}
</style>
<body>

<h1>XMLHttpRequest 对象</h1>

<button type="button" onclick="loadDoc()">获取我的音乐列表</button>
<br><br>
<table id="demo"></table>

<script>
function loadDoc() {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      myFunction(this);
    }
  };
  xhttp.open("GET", "/demo/music_list.xml", true);
  xhttp.send();
}
function myFunction(xml) {
  var i;
  var xmlDoc = xml.responseXML;
  var table="<tr><th>艺术家</th><th>曲目</th></tr>";
  var x = xmlDoc.getElementsByTagName("TRACK");
  for (i = 0; i <x.length; i++) { 
    table += "<tr><td>" +
    x[i].getElementsByTagName("ARTIST")[0].childNodes[0].nodeValue +
    "</td><td>" +
    x[i].getElementsByTagName("TITLE")[0].childNodes[0].nodeValue +
    "</td></tr>";
  }
  document.getElementById("demo").innerHTML = table;
}
</script>

</body>
</html>

```

## 5.4 AJAX PHP

```html
<!DOCTYPE html>
<html>
<body>

<h1>XMLHttpRequest 对象</h1>

<h2>请在下面的输入字段中键入字母 A-Z：</h2>

<p>搜索建议：<span id="txtHint"></span></p> 

<p>姓名：<input type="text" id="txt1" onkeyup="showHint(this.value)"></p>

<script>
function showHint(str) {
  var xhttp;
  if (str.length == 0) { 
    document.getElementById("txtHint").innerHTML = "";
    return;
  }
    // 1 创建 XMLHttpRequest 对象
  xhttp = new XMLHttpRequest();
    // 2 创建当服务器响应就绪时执行的函数
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
        // 4 显示php返回的内容
      document.getElementById("txtHint").innerHTML = this.responseText;
    }
  };
    // 3 发送请求到服务器上的 PHP 文件（gethint.php）,添加到 gethint.php 的 q 参数
  xhttp.open("GET", "/demo/gethint.php?q="+str, true);
  xhttp.send();   
}
</script>

</body>
</html>

```

# 6.JS JSON

## 6.1 JSON简介

JSON: JavaScript Object Notation（JavaScript 对象标记法）。

* **JSON 发送**

  ```js
  var myObj = { name:"Bill Gates",  age:62, city:"Seattle" };
  var myJSON =  JSON.stringify(myObj);
  window.location = "demo_json.php?x=" + myJSON;
  ```

* **接受数据**

  ```js
  var myJSON = '{ "name":"Bill Gates",  "age":62, "city":"Seattle" }';
  var myObj =  JSON.parse(myJSON);
  document.getElementById("demo").innerHTML = myObj.name;
  ```

* **存储数据**

  ```js
  myObj = { name:"Bill Gates",  age:62, city:"Seattle" };
  myJSON =  JSON.stringify(myObj);
  localStorage.setItem("testJSON", myJSON);
  ```

# 7.JS/jQuery选择器

jQuery 由 John Resig 于 2006 年创建。它旨在处理浏览器不兼容性并简化 HTML DOM 操作、事件处理、动画和 Ajax。

十多年来，jQuery 一直是世界上最受欢迎的 JavaScript 库。

但是，在 JavaScript Version 5（2009）之后，大多数 jQuery 实用程序都可以通过几行标准 JavaScript 来解决
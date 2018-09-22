---
layout: wiki
title: JSON/XML
categories: JSON/XML
description: JSON/XML语法
keywords: JSON, XML
---

# 1、JSON
## 1.1 介绍
JavaScript Object Notation(JavaScript 对象表示法) JavaScript Object Notation(JavaScript对象表示法)。非常多的动态编程语言（PHP、JSP、.NET）支持JSON。

JSON 是存储和交换文本信息的语法。

JSON 比 XML 更小、更快，更易解析。

JavaScript 程序能够使用内建的 eval() 函数，用 JSON 数据来生成原生的 JavaScript 对象。

## 1.2 第一个代码
NB-IoT的设备描述文件：

```json
{
    "devices": [
        {
            "manufacturerId": "Huawei",
            "manufacturerName": "Huawei",
            "model":  "NBIoTDevice",
            "protocolType": "CoAP",
            "deviceType": "WaterMeter",
            "serviceTypeCapabilities": [
                {
                    "serviceId": "WaterMeterBasic",
                    "serviceType": "WaterMeterBasic",
                    "option": "Mandatory"
                },
                {
                    "serviceId": "WaterMeterAlarm",
                    "serviceType": "WaterMeterAlarm",
                    "option": "Mandatory"
                },
                {
                    "serviceId": "Battery",
                    "serviceType": "Battery",
                    "option": "Optional"
                },
                {
                    "serviceId": "DeliverySchedule",
                    "serviceType": "DeliverySchedule",
                    "option": "Mandatory"
                },
                {
                    "serviceId": "Connectivity",
                    "serviceType": "Connectivity",
                    "option": "Mandatory"
                }
            ]
        }
    ]
}
```

## 1.3 JSON语法

### 1.3.1 JSON语法规则
1、数据在名称/值对中

JSON的数据书写格式：名称/值对

名称（双引号中）:数值

2、数据由逗号分隔

3、大括号保存对象

4、中括号保存数组（可以包含多个对象）

```json
{ "site":["name":"菜鸟教程" , "url":"www.runoob.com"] }
```

其中"site"是对象名称。

### 1.3.2 JSON值
数字（整数或浮点数）、字符串（在双引号中）、逻辑值（true 或 false）、数组（在中括号中）、对象（在大括号中）、null

### 1.3.3 JSON使用JSP语法
访问

```json
site[0].name;
```

修改数据

```json
site[0].name="菜鸟";
```

## 1.4 JSON对象
### 1.4.1 对象语法
在大括号中书写。

对象可以包含多个**key/value(键/值)**对。

key必须是字符串，value可以是合法的JSON数据类型(字符串, 数字, 对象, 数组, 布尔值或 null)。

key 和 value 中使用冒号分割。

每个 key/value 对使用逗号分割

### 1.4.2 访问对象值

方法1：用.来访问

```json
var myObj, x;
myObj = { "name":"runoob", "alexa":10000, "site":null };
x = myObj.name;
```

方法2：用[]访问

```json
var myObj, x;
myObj = { "name":"runoob", "alexa":10000, "site":null };
x = myObj["name"];
```

### 1.4.3 循环对象

用for-in来循环对象的属性，返回

name

alexa

site

```json
var myObj = { "name":"runoob", "alexa":10000, "site":null };
for (x in myObj) {
    document.getElementById("demo").innerHTML += x + "<br>";
}
```

用for-in来循环对象的属性，用[]访问

```json
var myObj = { "name":"runoob", "alexa":10000, "site":null };
for (x in myObj) {
    document.getElementById("demo").innerHTML += myObj[x] + "<br>";
}

```

### 1.4.4 嵌套JSON对象
```json

myObj = {
    "name":"runoob",
    "alexa":10000,
    "sites": {
        "site1":"www.runoob.com",
        "site2":"m.runoob.com",
        "site3":"c.runoob.com"
    }
}
```

用.或者[]访问

```json
x = myObj.sites.site1;
// 或者
x = myObj.sites["site1"];
```

### 1.4.5 删除对象
关键字delete删除

```json
delete myObj.sites.site1;
//或者
delete myObj.sites["site1"];
```

## 1.5 JSON对象中的数组
### 1.5.1 JSON数组语法
JSON 数组在中括号中书写。

JSON 中数组值必须是合法的 JSON 数据类型（字符串, 数字, 对象, 数组, 布尔值或 null）。
```json
{
"name":"网站",
"num":3,
"sites":[ "Google", "Runoob", "Taobao" ]
}
```

### 1.5.2 循环数组
for-in循环数组，并用[]索引

```json
for (i in myObj.sites) {
    x += myObj.sites[i] + "<br>";
}
```

### 1.5.3 删除数组元素
关键字delete删除数组元素

```json
delete myObj.sites[1];
```


# 2、XML
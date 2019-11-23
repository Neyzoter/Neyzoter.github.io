---
layout: wiki
title: Scala
categories: Scala
description: Scala编程语言笔记
keywords: Scala, Java, Spark
---

# 1.Scala介绍

# 2.Scala语法

## 2.1 方法与函数

* **方法声明**

  如果不写等于号和方法主体，则隐式声明为抽象

  ```scala
  def functionName ([参数列表]) : [return type]
  ```

* **方法定义**

  ```scala
  def functionName ([参数列表]) : [return type] = {
     function body
     return [expr]
  }
  ```

  举例

  ```scala
  object add{
     def addInt( a:Int, b:Int ) : Int = {
        var sum:Int = 0
        sum = a + b
  
        return sum
     }
  }
  ```

  ```scala
  // 如果方法没有返回值，可以返回为 Unit，这个类似于 Java 的 void,
  object Hello{
     def printMe( ) : Unit = {
        println("Hello, Scala!")
     }
  }
  ```

  
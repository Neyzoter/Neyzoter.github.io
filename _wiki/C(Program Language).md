---
layout: wiki
title: C Program Language
categories: C 
description: C语言的一些注意点
keywords: C, 语法
---

# 关键字
## volatile
编译时，不进行优化。如一些特殊的变量在中断时会被修改，为了保证每次都从该变量的地址中读取。

如

```
volatile int i = 10;

int j = i;

.....

int k = i;
```

在省略号中，对于i没有改变，但是k=i这一步还是会从i的地址中读取数据。如果没有volatile，则k=i这一步会将上次i的数值放到k中，而不是从i的地址中读取。
## const
定义常量，如果一个变量被const修饰，它的值不能改变。

* 作用：

1、预编译指令#define只是对值进行简单的替换，不能进行类型检查；

2、保护被修饰的东西，防止意外修改，增强程序的健壮性；

3、将const修饰的变量放在符号表中，称为编译期间的常量，没有了存储和读内存的操作，效率高。

* 用法

1、修饰局部变量

```

const int i = 5;

int const i = 5;

```

两种写法相同，需要给变量初始化，之后无法修改。

```

const char * str = "fasdaddf";

```

有const修饰，如果后期修改内容，则会报错。如str[4] = 'x';

2、常量指针和指针常量



```

const int * n;

或者

int const * n;

```

常量指针(在星号左边)说的是不能通过这个指针改变变量的值，但是还是可以通过其他的引用来改变变量的值的；也可以改变指针的值。


```

int * const n;

```

指针常量（在星号右边）的指针地址不能改变，但是地址指向的数值可以改变。

其他作用可以上网查阅。

## static
修饰函数或者变量。

1、隐藏功能

static修饰的函数和变量，在其他文件中不可见。

也就是说在不同文件中，用static可以定义相同名字的变量，也不能通过extern来调用其他文件中的函数或者变量。

2、保持变量的持久

3、默认初始化为0

全局变量也具有该效果。
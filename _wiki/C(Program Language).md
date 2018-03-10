---
layout: wiki
title: C Program Language
categories: C 
description: C语言的一些注意点
keywords: C, 语法
---

# 关键字
## volatile
* 作用

编译时，不进行优化。如一些特殊的变量在中断时会被修改，为了保证每次都从该变量的地址中读取。

如

```
volatile int i = 10;

int j = i;

.....

int k = i;
```

在省略号中，对于i没有改变，但是k=i这一步还是会从i的地址中读取数据。如果没有volatile，则k=i这一步会将上次i的数值放到k中，而不是从i的地址中读取。
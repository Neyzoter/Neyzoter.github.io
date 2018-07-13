---
layout: post
title: Python的参数输入报错问题
categories: Python
description: positional argument follows keyword argument
keywords: Python, 参数输入
---

> 原创
> 
> 转载请注明出处，侵权必究

# 1、问题

```Python
X = identity_block(X, f = 3, [64, 64, 256], stage=2, block='b')
```
报错：

SyntaxError: positional argument follows keyword argument

# 2、分析
因为f = 3, [64, 64, 256]这里位置参数[64, 64, 256]在关键字参数f=3后面了。

在Python中，首先需要满足位置参数，也就是说位置参数必须在关键字参数前面。

# 3、改正
第一种解决方案，将前面的关键字参数f = 3变为位置参数 3。

```Python
X = identity_block(X, 3, [64, 64, 256], stage=2, block='b')
```

第二种解决方案，位置参数[64, 64, 256]改为位置参数filters = [64, 64, 256].

```Python
X = identity_block(X, f = 3, filters = [64, 64, 256], stage=2, block='b')
```
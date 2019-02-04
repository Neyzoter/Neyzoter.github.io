---
layout: wiki
title: R
categories: R
description: R语言语法
keywords: R,Time Series Analysis
---

# 1、R语言基础
## 1.1 数据类型
### 1.1.1 原子类型
**逻辑型Logical**(TRUE,FALSE)

```r
v <- TRUE 
print(class(v))
```

输出数据类型

```
[1] "logical"
```

**数字型Numeric**(12.3,5,999)

```r
v <- 23.5
print(class(v))
```

输出数据类型

```
[1] "numeric"
```

**整型Integer**(1L,0L)

```r
v <- 19L
print(class(v))
```

数据数据类型

```
[1] "integer"
```

**复合型Complex**(3 + 2i)

```r
v <- 2+5i
print(class(v))
```

输出数据类型

```
[1] "complex"
```

**字符型Character**('a' , '"good", "TRUE", '23.4')

```r
v <- "TRUE"
print(class(v))
```

输出数据类型

```
[1] "character"
```

**原型Raw**("Hello" 被存储为 48 65 6c 6c 6f)

```r
v <- charToRaw("Hello")
print(class(v))
```

输出数据类型

```
[1] "raw"
```

### 1.1.2 Vector向量
用函数**c()**将多个元素创建向量

```r
# Create a vector.
apple <- c('red','green',"yellow")
print(apple)

# Get the class of the vector.
print(class(apple))
```

输出

```
[1] "red"    "green"  "yellow"
[1] "character"
```

*注：*输出的数据类型为原子类型，如果全部为numeric则输出numeric；如果包含numeric和character则输出character

### 1.1.3 列表List
列表是一个R对象，它可以在其中包含许多不同类型的元素，如**向量**，**函数**甚至其中的另一个**列表**。

```r
# Create a list.
list1 <- list(c(2,5,3),21.3,sin)

# Print the list.
print(list1)
```

输出

```
[[1]]
[1] 2 5 3

[[2]]
[1] 21.3

[[3]]
function (x)  .Primitive("sin")
```
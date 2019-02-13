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

### 1.1.4 Matrices 矩阵
矩阵是二维矩形数据集。 它可以使用矩阵函数的向量输入创建。

```r
# Create a matrix.
M = matrix( c('a','a','b','c','b','a'), nrow = 2, ncol = 3, byrow = TRUE)
print(M)
```

输出

```
     [,1] [,2] [,3]
[1,] "a"  "a"  "b" 
[2,] "c"  "b"  "a"
```

### 1.1.5 Arrays 数组
数组函数使用一个dim属性创建所需的维数。 在下面的例子中，我们创建了一个包含两个元素的数组，每个元素为3x3个矩阵。

```r
# Create an array.
a <- array(c('green','yellow'),dim = c(3,3,2))
print(a)
```

输出

```
, , 1

     [,1]     [,2]     [,3]    
[1,] "green"  "yellow" "green" 
[2,] "yellow" "green"  "yellow"
[3,] "green"  "yellow" "green" 

, , 2

     [,1]     [,2]     [,3]    
[1,] "yellow" "green"  "yellow"
[2,] "green"  "yellow" "green" 
[3,] "yellow" "green"  "yellow"  
```

### 1.1.6 Factors 因子
因子是使用向量创建的r对象。 它将向量与向量中元素的不同值一起存储为标签，类似于集合set。 标签总是字符，不管它在输入向量中是数字还是字符或布尔等。 它们在统计建模中非常有用。

**nlevels函数给出级别计数。**

```r
# Create a vector.
apple_colors <- c('green','green','yellow','red','red','red','green')

# Create a factor object.
factor_apple <- factor(apple_colors)

# Print the factor.
print(factor_apple)
print(nlevels(factor_apple))
```

输出

```
[1] green  green  yellow red    red    red    yellow green 
Levels: green red yellow
# applying the nlevels function we can know the number of distinct values
[1] 3
```
### 1.1.7 Data Frames 数据帧
数据帧是表格数据对象。 与数据帧中的矩阵不同，每列可以包含不同的数据模式。 第一列可以是数字，而第二列可以是字符，第三列可以是逻辑的。 它是等长度的向量的列表。

```r
# Create the data frame.
BMI <- 	data.frame(
   gender = c("Male", "Male","Female"), 
   height = c(152, 171.5, 165), 
   weight = c(81,93, 78),
   Age = c(42,38,26)
)
print(BMI)
```

输出

```
  gender height weight Age
1   Male  152.0     81  42
2   Male  171.5     93  38
3 Female  165.0     78  26  
```

# 2、R语言常用函数
## 2.1 模型
* lm

线性模型

```r
modle = lm(tempdub~month.)
```

* fitted(=fitted.value)

得到模型的拟合数值

```r
win.graph(width = 4.875,height = 2.5,pointsize = 8)
plot(y=rstudent(model),x=as.vector(fitted(model)),xlab='Fitted Trend Values',ylab='Standardized Residuals')
points(y=rstudent(model),x=as.vector(fitted(model)),pch = as.vector(season(tempdub)),col = 'black')
```


## 2.2 统计参数
* rstudent

残差 X_t = Y_t - u_t(样本 - 平均值)

```r
plot(y=rstudent(model),x=as.vector(time(tempdub)),xlab='Time',ylab='Standardized Residuals',type='o')
```

* qqnorm

正态得分或者分位数-分位数(QQ)图，用于验证正态性。横坐标：理论分位数；纵坐标：样本分位数。

```r
qqnorm(rstudent(model))
```

* acf(Auto- and Cross- Covariance and -Correlation Function Estimation)

样本自相关系数。输出不同r_k，k为样本相隔的个数；输出水平虚线（0加减2倍样本自相关系数的近似标准误差，即±2/sqrt(n))

eg.Y_1,Y_2,...,Y_10

如果k = 2，则r_2 = f({Y_1,Y_3},{Y_2,Y_4},...)

```r
acf(rstudent(model))
```

* diff

差分，可设置差分阶数

```r
plot(diff(ima22.s,defference = 2),ylab = 'Defference twice',type = 'o') # 二阶阶差分数据
```

## 2.3 可视化
* points(x,y,type='p',...)

在特定坐标画点，可以画字符、有颜色的点、背景（具体见说明）

## 2.4 工具函数
* as.vector

生成一个向量
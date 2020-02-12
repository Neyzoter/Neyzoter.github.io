---
layout: wiki
title: Golang
categories: Golang
description: Golang语言语法
keywords: Go, 分布式, 并行计算
---

# 1. Go语言

## 1.1 Go语言介绍

> Go是从2007年末由Robert Griesemer, Rob Pike, Ken Thompson主持开发，后来还加入了Ian Lance Taylor, Russ Cox等人，并最终于2009年11月开源，在2012年早些时候发布了Go 1稳定版本。现在Go的开发已经是完全开放的，并且拥有一个活跃的社区。Go 语言被设计成一门应用于搭载 Web 服务器，存储集群或类似用途的巨型中央服务器的系统编程语言。对于高性能分布式系统领域而言，Go 语言无疑比大多数其它语言有着更高的开发效率。它提供了海量并行的支持，这对于游戏服务端的开发而言是再好不过了。

Go语言简介、安全、并行，而且具备内存管理、数组安全、编译迅速等功能。

# 2. Go语言基础

## 2.1 Go代码结构

```go
// 定于包名
package main

// 引入某个包
import "fmt"

// 程序开始执行的函数。main 函数是每一个可执行程序所必须包含的，一般来说都是在启动后第一个执行的函数（如果有 init() 函数则会先执行该函数）。
func main() {
   /* 这是我的第一个简单的程序 */
   fmt.Println("Hello, World!")
}
```

另外，当标识符（包括常量、变量、类型、函数名、结构字段等等）以一个大写字母开头，如：Group1，那么使用这种形式的标识符的对象就可以被外部包的代码所使用（客户端程序需要先导入这个包），这被称为导出（像面向对象语言中的 public）；标识符如果以小写字母开头，则对包外是不可见的，但是他们在整个包的内部是可见并且可用的（像面向对象语言中的 private ）

```bash
# 执行go代码
$ go run hello.go
```

## 2.2 Go基础语法

* **标识符**

  标识符用来命名变量、类型等程序实体。一个标识符实际上就是一个或是多个字母(A~Z和a~z)数字(0~9)、下划线`_`组成的序列，但是第一个字符必须是字母或下划线而不能是数字。

* **关键字和预定义标识符**

  关键字

  |          |             |        |           |        |
  | -------- | ----------- | ------ | --------- | ------ |
  | break    | default     | func   | interface | select |
  | case     | defer       | go     | map       | struct |
  | chan     | else        | goto   | package   | switch |
  | const    | fallthrough | if     | range     | type   |
  | continue | for         | import | return    | var    |

  预定义标识符

  |        |         |         |         |        |         |           |            |         |
  | ------ | ------- | ------- | ------- | ------ | ------- | --------- | ---------- | ------- |
  | append | bool    | byte    | cap     | close  | complex | complex64 | complex128 | uint16  |
  | copy   | false   | float32 | float64 | imag   | int     | int8      | int16      | uint32  |
  | int32  | int64   | iota    | len     | make   | new     | nil       | panic      | uint64  |
  | print  | println | real    | recover | string | true    | uint      | uint8      | uintptr |

## 2.3 数据类型

### 2.3.1 基础数据类型

| 序号 | 类型和描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | **布尔型** 布尔型的值只可以是常量 true 或者 false。一个简单的例子：`var b bool = true` |
| 2    | **数字类型** 整型 int 和浮点型 float，Go 语言支持整型和浮点型数字，并且原生支持复数，其中位的运算采用补码。 |
| 3    | **字符串类型:** 字符串就是一串固定长度的字符连接起来的字符序列。Go的字符串是由单个字节连接起来的。Go语言的字符串的字节使用UTF-8编码标识Unicode文本。 |
| 4    | **派生类型:** 包括：(a) 指针类型（Pointer）(b) 数组类型(c) 结构化类型(struct)(d) 联合体类型 (union)(e) 函数类型(f) 切片类型(g) 接口类型（interface）(h) Map 类型(i) Channel 类型 |

整数类型：

| 序号 | 类型和描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | **uint8** 无符号 8 位整型 (0 到 255)                         |
| 2    | **uint16** 无符号 16 位整型 (0 到 65535)                     |
| 3    | **uint32** 无符号 32 位整型 (0 到 4294967295)                |
| 4    | **uint64** 无符号 64 位整型 (0 到 18446744073709551615)      |
| 5    | **int8** 有符号 8 位整型 (-128 到 127)                       |
| 6    | **int16** 有符号 16 位整型 (-32768 到 32767)                 |
| 7    | **int32** 有符号 32 位整型 (-2147483648 到 2147483647)       |
| 8    | **int64** 有符号 64 位整型 (-9223372036854775808 到 9223372036854775807) |

浮点型

| 序号 | 类型和描述                        |
| :--- | :-------------------------------- |
| 1    | **float32** IEEE-754 32位浮点型数 |
| 2    | **float64** IEEE-754 64位浮点型数 |
| 3    | **complex64** 32 位实数和虚数     |
| 4    | **complex128** 64 位实数和虚数    |

**变量初始值**

| 数据类型 | 初始化默认值 |
| :------- | :----------- |
| int      | 0            |
| float32  | 0            |
| pointer  | nil          |

### 2.3.2 Go语言变量

* **变量定义**

    go语言的变量定义如下：

    ```go
    /*  单变量声明 */
    // 第一种：制定变量类型
    var v_name v_type
    v_name = value

    // 第二种：根据值自行判定变量类型
    var v_name = value

    // 第三种，省略var, 注意 :=左侧的变量不应该是已经声明过的，否则会导致编译错误
    c : = 10

    /*  多变量声明 */
    //类型相同多个变量, 非全局变量
    var vname1, vname2, vname3 type
    vname1, vname2, vname3 = v1, v2, v3

    //和python很像,不需要显示声明类型，自动推断
    var vname1, vname2, vname3 = v1, v2, v3 

     //出现在:=左侧的变量不应该是已经被声明过的，否则会导致编译错误
    vname1, vname2, vname3 := v1, v2, v3

    //类型不同多个变量, 全局变量, 局部变量不能使用这种方式
    var (
        vname1 v_type1
        vname2 v_type2
    )
    ```
    
    实例：
    
    ```go
    package main
    var a = "w3cschoolW3Cschool教程"
    var b string = "w3cschool.cn"
    var c bool
    
    func main(){
        println(a, b, c)
    }
    ```
    
    输出：
    
    ```
    w3cschoolW3Cschool教程 w3cschool.cn false
    ```

* **值类型和引用类型**

  1.  int、float、bool 和 string 这些基本类型都属于值类型，使用这些类型的变量直接指向存在内存中的值
  2. 更复杂的数据通常会需要使用多个字，这些数据一般使用引用类型保存，如`r1 = r2`，则r1和r2指向同一个内存空间

* **`:=赋值操作注意点`**

  `：=`只能用于初始时，在其他时候不能使用

* **快速交换变量**

  ```go
  a,b = b,a
  ```

* **抛弃值**

  `_`可以用于抛弃某个值，比如用在函数返回的值。

  ```go
  _, value = Func();
  ```

### 2.3.3 Go语言常量

常量是一个简单值的标识符，在程序运行时，不会被修改。定义方式如下，

```go
const identifier [type] = value
```

举例

```go
// 多变量定义
const c_name1, c_name2 = value1, value2
// 枚举类型
const (
    Unknown = 0
    Female = 1
    Male = 2
)
// iota表示特殊常量，可以认为是一个可以被编译器修改的常量
// 在每一个const关键字出现时，被重置为0，然后再下一个const出现之前，每出现一次iota，其所代表的数字会自动增加1。
const (
    a = iota
    b = iota
    c = iota
)
const (
    a = iota
    b
    c
)
const (
    a = iota   //0
    b          //1
    c          //2
    d = "ha"   //独立值，iota += 1
    e          //"ha"   iota += 1
    f = 100    //iota +=1
    g          //100  iota +=1
    h = iota   //7,恢复计数
    i          //8
)

const (
    i=1<<iota     // 1
    j=3<<iota     // 3<<1 = 6
    k             // 3<<2 = 12
    l             // 3<<3 = 24
)
```

以下是常量计算表达式，**常量表达式中，函数必须是内置函数，否则编译不过**

```go
var str = "123"
// 获取长度
len(str)

unsafe.Sizeof(str)
```

## 2.4 运算符

**算术运算符**

| 运算符 | 描述 | 实例               |
| :----- | :--- | :----------------- |
| +      | 相加 | A + B 输出结果 30  |
| -      | 相减 | A - B 输出结果 -10 |
| *      | 相乘 | A * B 输出结果 200 |
| /      | 相除 | B / A 输出结果 2   |
| %      | 求余 | B % A 输出结果 0   |
| ++     | 自增 | A++ 输出结果 11    |
| --     | 自减 | A-- 输出结果 9     |

**关系运算符**

| 运算符 | 描述                                                         | 实例              |
| :----- | :----------------------------------------------------------- | :---------------- |
| ==     | 检查两个值是否相等，如果相等返回 True 否则返回 False。       | (A == B) 为 False |
| !=     | 检查两个值是否不相等，如果不相等返回 True 否则返回 False。   | (A != B) 为 True  |
| >      | 检查左边值是否大于右边值，如果是返回 True 否则返回 False。   | (A > B) 为 False  |
| <      | 检查左边值是否小于右边值，如果是返回 True 否则返回 False。   | (A < B) 为 True   |
| >=     | 检查左边值是否大于等于右边值，如果是返回 True 否则返回 False。 | (A >= B) 为 False |
| <=     | 检查左边值是否小于等于右边值，如果是返回 True 否则返回 False。 | (A <= B) 为 True  |

**逻辑运算符**

| 运算符 | 描述                                                         | 实例               |
| :----- | :----------------------------------------------------------- | :----------------- |
| &&     | 逻辑 AND 运算符。 如果两边的操作数都是 True，则条件 True，否则为 False。 | (A && B) 为 False  |
| \|\|   | 逻辑 OR 运算符。 如果两边的操作数有一个 True，则条件 True，否则为 False。 | (A \|\| B) 为 True |
| !      | 逻辑 NOT 运算符。 如果条件为 True，则逻辑 NOT 条件 False，否则为 True。 | !(A && B) 为 True  |

**位运算符**

| 运算符 | 描述                                                         | 实例                                   |
| :----- | :----------------------------------------------------------- | :------------------------------------- |
| &      | 按位与运算符"&"是双目运算符。 其功能是参与运算的两数各对应的二进位相与。 | (A & B) 结果为 12, 二进制为 0000 1100  |
| \|     | 按位或运算符"\|"是双目运算符。 其功能是参与运算的两数各对应的二进位相或 | (A \| B) 结果为 61, 二进制为 0011 1101 |
| ^      | 按位异或运算符"^"是双目运算符。 其功能是参与运算的两数各对应的二进位相异或，当两对应的二进位相异时，结果为1。 | (A ^ B) 结果为 49, 二进制为 0011 0001  |
| <<     | 左移运算符"<<"是双目运算符。左移n位就是乘以2的n次方。 其功能把"<<"左边的运算数的各二进位全部左移若干位，由"<<"右边的数指定移动的位数，高位丢弃，低位补0。 | A << 2 结果为 240 ，二进制为 1111 0000 |
| >>     | 右移运算符">>"是双目运算符。右移n位就是除以2的n次方。 其功能是把">>"左边的运算数的各二进位全部右移若干位，">>"右边的数指定移动的位数。 | A >> 2 结果为 15 ，二进制为 0000 1111  |

**幅值运算符**

| 运算符 | 描述                                           | 实例                                  |
| :----- | :--------------------------------------------- | :------------------------------------ |
| =      | 简单的赋值运算符，将一个表达式的值赋给一个左值 | C = A + B 将 A + B 表达式结果赋值给 C |
| +=     | 相加后再赋值                                   | C += A 等于 C = C + A                 |
| -=     | 相减后再赋值                                   | C -= A 等于 C = C - A                 |
| *=     | 相乘后再赋值                                   | C *= A 等于 C = C * A                 |
| /=     | 相除后再赋值                                   | C /= A 等于 C = C / A                 |
| %=     | 求余后再赋值                                   | C %= A 等于 C = C % A                 |
| <<=    | 左移后赋值                                     | C <<= 2 等于 C = C << 2               |
| >>=    | 右移后赋值                                     | C >>= 2 等于 C = C >> 2               |
| &=     | 按位与后赋值                                   | C &= 2 等于 C = C & 2                 |
| ^=     | 按位异或后赋值                                 | C ^= 2 等于 C = C ^ 2                 |
| \|=    | 按位或后赋值                                   | C \|= 2 等于 C = C \| 2               |

**其他运算符**

| 运算符 | 描述             | 实例                       |
| :----- | :--------------- | :------------------------- |
| &      | 返回变量存储地址 | &a; 将给出变量的实际地址。 |
| *      | 指针变量。       | *a; 是一个指针变量         |

## 2.5 条件语句

### 2.5.1 if语句

```go
if 布尔表达式 {
   /* 在布尔表达式为 true 时执行 */
}
if 布尔表达式 {
   /* 在布尔表达式为 true 时执行 */
} else {
  /* 在布尔表达式为 false 时执行 */
}
```

举例

```go
package main

import "fmt"

func main() {
   /* 定义局部变量 */
   var a int = 10
 
   /* 使用 if 语句判断布尔表达式 */
   if a < 20 {
       /* 如果条件为 true 则执行以下语句 */
       fmt.Printf("a 小于 20\n" )
   }
   fmt.Printf("a 的值为 : %d\n", a)
}
```

### 2.5.2 switch语句

switch 语句用于基于不同条件执行不同动作，每一个 case 分支都是唯一的，从上直下逐一测试，直到匹配为止。。

switch 语句执行的过程从上至下，直到找到匹配项，**匹配项后面也不需要再加break**

```go
switch var1 {
    case val1:
        ...
    case val2:
        ...
    default:
        ...
}
```

### 2.5.3 select语句

select是Go中的一个控制结构，类似于用于通信的switch语句。每个case必须是一个通信操作，要么是发送要么是接收。

select随机执行一个可运行的case。如果没有case可运行，它将阻塞，直到有case可运行。一个默认的子句应该总是可运行的。

```
select {
	// 通信条件
    case communication clause  :
       statement(s);      
    case communication clause  :
       statement(s); 
    /* 你可以定义任意数量的 case */
    default : /* 可选 */
       statement(s);
}
```

举例

```go
package main

import "fmt"

func main() {
   var c1, c2, c3 chan int
   var i1, i2 int
   select {
      case i1 = <-c1:
         fmt.Printf("received ", i1, " from c1\n")
      case c2 <- i2:
         fmt.Printf("sent ", i2, " to c2\n")
      case i3, ok := (<-c3):  // same as: i3, ok := <-c3
         if ok {
            fmt.Printf("received ", i3, " from c3\n")
         } else {
            fmt.Printf("c3 is closed\n")
         }
      default:
         fmt.Printf("no communication\n")
   }    
}
```

## 2.6 循环语句

### 2.6.1 for语句

```go
// 和c的for一样
for init; condition; post { }
// 和c的while一样
for condition { }
// 和c的for(;;)一样
for { }
// for循环的range格式可以对 slice、map、数组、字符串等进行迭代循环
for key, value := range oldMap {
    newMap[key] = value
}
```

举例

```go
package main

import "fmt"

func main() {

   var b int = 15
   var a int

   numbers := [6]int{1, 2, 3, 5} 

   /* for 循环 */
   for a := 0; a < 10; a++ {
      fmt.Printf("a 的值为: %d\n", a)
   }

   for a < b {
      a++
      fmt.Printf("a 的值为: %d\n", a)
      }

   for i,x:= range numbers {
      fmt.Printf("第 %d 位 x 的值 = %d\n", i,x)
   }   
}
```

### 2.6.2 循环控制语句

* **break**

  和c相同

* **continue**

  和c相同

* **goto**

  和c相同

  举例

  ```go
  package main
  
  import "fmt"
  
  func main() {
     /* 定义局部变量 */
     var a int = 10
  
     /* 循环 */
     LOOP: for a < 20 {
        if a == 15 {
           /* 跳过迭代 */
           a = a + 1
           goto LOOP
        }
        fmt.Printf("a的值为 : %d\n", a)
        a++     
     }  
  }
  ```

## 2.7 函数

```go
// 普通函数
func function_name( [parameter list] ) [return_types]{
   函数体
}
// 函数方法，可以供variable_data_type类型的变量，相当于对象的方法
func (variable_name variable_data_type) function_name() [return_type]{
   /* 函数体*/
}
// 匿名函数，可以实现闭包
func getSequence() func() int {
   i:=0
   return func() int {
      i+=1
     return i  
   }
}
```

### 2.7.1 函数定义

函数定义格式如下，

```go
func function_name( [parameter list] ) [return_types]{
   函数体
}
```

`parameter list`参数列表支持值传递和引用传递。

`return_types`返回类型，可以包括多个返回。

举例

```go
/* 函数返回两个数的最大值 */
func max(num1, num2 int) int{
   /* 声明局部变量 */
   result int

   if (num1 > num2) {
      result = num1
   } else {
      result = num2
   }
   return result 
}

```

```go
package main

import "fmt"

func swap(x, y string) (string, string) {
   return y, x
}

func main() {
   a, b := swap("Mahesh", "Kumar")
   fmt.Println(a, b)
}
```

```go
package main

import "fmt"

func main() {
   /* 定义局部变量 */
   var a int = 100
   var b int= 200

   fmt.Printf("交换前，a 的值 : %d\n", a )
   fmt.Printf("交换前，b 的值 : %d\n", b )

   /* 调用 swap() 函数
   * &a 指向 a 指针，a 变量的地址
   * &b 指向 b 指针，b 变量的地址
   */
   swap(&a, &b)

   fmt.Printf("交换后，a 的值 : %d\n", a )
   fmt.Printf("交换后，b 的值 : %d\n", b )
}

// 实现引用传递
func swap(x *int, y *int) {
   var temp int
   temp = *x    /* 保存 x 地址上的值 */
   *x = *y      /* 将 y 值赋给 x */
   *y = temp    /* 将 temp 值赋给 y */
}
```

### 2.7.2 函数方法

Go 语言中同时有函数和方法。一个方法就是一个包含了接受者的函数，接受者可以是命名类型或者结构体类型的一个值或者是一个指针。格式为，

```go
func (variable_name variable_data_type) function_name() [return_type]{
   /* 函数体*/
}
```

举例，

```go
package main

import (
   "fmt"  
)

/* 定义函数 */
type Circle struct {
  radius float64
}

func main() {
  var c1 Circle
  c1.radius = 10.00
  fmt.Println("Area of Circle(c1) = ", c1.getArea())
}

//该 method 属于 Circle 类型对象中的方法
func (c Circle) getArea() float64 {
  //c.radius 即为 Circle 类型对象中的属性
  return 3.14 * c.radius * c.radius
}
```

### 2.7.3 闭包

Go 语言支持匿名函数，可作为闭包。匿名函数是一个"内联"语句或表达式。匿名函数的优越性在于可以直接使用函数内的变量，不必申明。

```go
package main

import "fmt"

// func() 是1个匿名函数
func getSequence() func() int {
   i:=0
   return func() int {
      i+=1
     return i  
   }
}

func main(){
   /* nextNumber 为一个函数，函数 i 为 0 */
   nextNumber := getSequence()  

   /* 调用 nextNumber 函数，i 变量自增 1 并返回 */
   fmt.Println(nextNumber())
   fmt.Println(nextNumber())
   fmt.Println(nextNumber())
   
   /* 创建新的函数 nextNumber1，并查看结果 */
   nextNumber1 := getSequence()  
   fmt.Println(nextNumber1())
   fmt.Println(nextNumber1())
}
```

输出

```
1
2
3
1
2
```

## 2.8 变量作用域

```go
package main

import "fmt"

/* 声明全局变量 */
var g int

func main() {

   /* 声明局部变量 */
   var a, b int

   /* 初始化参数 */
   a = 10
   b = 20
   g = a + b

   fmt.Printf("结果： a = %d, b = %d and g = %d\n", a, b, g)
}
```

## 2.9 数组

### 2.9.1 一维数组

```go
var variable_name [SIZE] variable_type
```

* **初始化数组**

    ```go
    // 初始化数组中 {} 中的元素个数不能大于 [] 中的数字
    var balance = [5]float32{1000.0, 2.0, 3.4, 7.0, 50.0}
    // 省略数组长度
    var balance = []float32{1000.0, 2.0, 3.4, 7.0, 50.0}
    ```

* **访问数组元素**

  ```
  float32 salary = balance[9]
  ```

### 2.9.2 多维数组

```go
var variable_name [SIZE1][SIZE2]...[SIZEN] variable_type
```

* **初始化数组**

  ```go
  a = [3][4]int{  
   {0, 1, 2, 3} ,   /*  第一行索引为 0 */
   {4, 5, 6, 7} ,   /*  第二行索引为 1 */
   {8, 9, 10, 11}   /*  第三行索引为 2 */
  }
  ```

* **数组访问**

  ```go
  int val = a[2][3]
  ```

举例，

```go
package main

import "fmt"

func main() {
   /* 数组 - 5 行 2 列*/
   var a = [5][2]int{ {0,0}, {1,2}, {2,4}, {3,6},{4,8}}
   var i, j int

   /* 输出数组元素 */
   for  i = 0; i < 5; i++ {
      for j = 0; j < 2; j++ {
         fmt.Printf("a[%d][%d] = %d\n", i,j, a[i][j] )
      }
   }
}
```

### 2.9.3 向函数传递数组

```go
// 设定数组长度
void myFunction(param [10]int){
   // 函数体
}

// 不设定数组长度
void myFunction(param []int){
	// 函数体
}
```


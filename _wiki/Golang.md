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

* **数据类型转换**

  ```go
  type_name(expression)
  ```

  举例，

  ```go
  package main
  
  import "fmt"
  
  func main() {
     var sum int = 17
     var count int = 5
     var mean float32
     
     mean = float32(sum)/float32(count)
     fmt.Printf("mean 的值为: %f\n",mean)
  }
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

## 2.10 指针

### 2.10.1 指针

```go
var var_name *var-type
```

举例，

```go
package main

import "fmt"

func main() {
   var a int= 20   /* 声明实际变量 */
   var ip *int        /* 声明指针变量 */

   ip = &a  /* 指针变量的存储地址 */

   fmt.Printf("a 变量的地址是: %x\n", &a  )

   /* 指针变量的存储地址 */
   fmt.Printf("ip 变量的存储地址: %x\n", ip )

   /* 使用指针访问值 */
   fmt.Printf("*ip 变量的值: %d\n", *ip )
}
```

### 2.10.2 指针数组

举例，

```go
package main

import "fmt"

const MAX int = 3

func main() {
   a := []int{10,100,200}
   var i int
   var ptr [MAX]*int;

   for  i = 0; i < MAX; i++ {
      ptr[i] = &a[i] /* 整数地址赋值给指针数组 */
   }

   for  i = 0; i < MAX; i++ {
      fmt.Printf("a[%d] = %d\n", i,*ptr[i] )
   }
}
```

### 2.10.3 函数有指针参数

举例，

```go
package main

import "fmt"

func main() {
   /* 定义局部变量 */
   var a int = 100
   var b int= 200

   fmt.Printf("交换前 a 的值 : %d\n", a )
   fmt.Printf("交换前 b 的值 : %d\n", b )

   /* 调用函数用于交换值
   * &a 指向 a 变量的地址
   * &b 指向 b 变量的地址
   */
   swap(&a, &b);

   fmt.Printf("交换后 a 的值 : %d\n", a )
   fmt.Printf("交换后 b 的值 : %d\n", b )
}

func swap(x *int, y *int) {
   var temp int
   temp = *x    /* 保存 x 地址的值 */
   *x = *y      /* 将 y 赋值给 x */
   *y = temp    /* 将 temp 赋值给 y */
}
```

## 2.11 结构体

语法：

```go
// 结构体定义
type struct_variable_type struct {
   member definition;
   member definition;
   ...
   member definition;
}
// 变量声明
variable_name := structure_variable_type {value1, value2...valuen}
```

举例，

```go
package main

import "fmt"

type Books struct {
   title string
   author string
   subject string
   book_id int
}

func main() {
   var Book1 Books        /* 声明 Book1 为 Books 类型 */
   var Book2 Books        /* 声明 Book2 为 Books 类型 */

   /* book 1 描述 */
   Book1.title = "Go 语言"
   Book1.author = "www.w3cschool.cn"
   Book1.subject = "Go 语言教程"
   Book1.book_id = 6495407

   /* book 2 描述 */
   Book2.title = "Python 教程"
   Book2.author = "www.w3cschool.cn"
   Book2.subject = "Python 语言教程"
   Book2.book_id = 6495700

   /* 打印 Book1 信息 */
   fmt.Printf( "Book 1 title : %s\n", Book1.title)
   fmt.Printf( "Book 1 author : %s\n", Book1.author)
   fmt.Printf( "Book 1 subject : %s\n", Book1.subject)
   fmt.Printf( "Book 1 book_id : %d\n", Book1.book_id)

   /* 打印 Book2 信息 */
   fmt.Printf( "Book 2 title : %s\n", Book2.title)
   fmt.Printf( "Book 2 author : %s\n", Book2.author)
   fmt.Printf( "Book 2 subject : %s\n", Book2.subject)
   fmt.Printf( "Book 2 book_id : %d\n", Book2.book_id)
}
```

## 2.12 切片

Go 数组的长度不可改变，在特定场景中这样的集合就不太适用，Go中提供了一种灵活，功能强悍的内置类型切片("动态数组"),与数组相比切片的长度是不固定的，可以追加元素，在追加时可能使切片的容量增大。

### 2.12.1 定义切片

```go
// 声明一个未指定大小的数组来定义切片
var identifier []type

// 使用make创建切片
// make([]T, length, capacity)
var slice1 []type = make([]type, len)
slice1 := make([]type, len)
```

### 2.12.2 切片初始化

```go
// 直接初始化切片，[]表示是切片类型，{1,2,3}初始化值依次是1,2,3.其cap=len=3
// 区别于数组的是切片未指定长度
s :=[] int {1,2,3 } 

// 初始化切片s,是数组arr的引用
// 如果arr改变，则切片也会改变
s := arr[:]
s := arr[startIndex:] 
// arr的下标startIndex到endIndex-1的元素
s := arr[startIndex:endIndex] 
s := arr[:endIndex] 
```

### 2.12.3 相关函数

* **len()**

  可以获取切片的长度

* **cap()**

  可以获取切片最长的长度

* **append()**

  向切片追加元素

* **copy()**

  拷贝切片，可以用于创建一个新的更大的切片并把原分片的内容都拷贝过来

举例，

```go
package main

import "fmt"

func main() {
   var numbers []int
   printSlice(numbers)

   /* 允许追加空切片 */
   numbers = append(numbers, 0)
   printSlice(numbers)

   /* 向切片添加一个元素 */
   numbers = append(numbers, 1)
   printSlice(numbers)

   /* 同时添加多个元素 */
   numbers = append(numbers, 2,3,4)
   printSlice(numbers)

   /* 创建切片 numbers1 是之前切片的两倍容量*/
   numbers1 := make([]int, len(numbers), (cap(numbers))*2)

   /* 拷贝 numbers 的内容到 numbers1 */
   copy(numbers1,numbers)
   printSlice(numbers1)   
}

func printSlice(x []int){
   fmt.Printf("len=%d cap=%d slice=%v\n",len(x),cap(x),x)
}
```

输出，

```
len=0 cap=0 slice=[]
len=1 cap=2 slice=[0]
len=2 cap=2 slice=[0 1]
len=5 cap=8 slice=[0 1 2 3 4]
len=5 cap=16 slice=[0 1 2 3 4]
```

## 2.13 范围（Range）

Go 语言中 range 关键字用于for循环中迭代数组(array)、切片(slice)、链表(channel)或集合(map)的元素。在数组和切片中它返回元素的索引值，在集合中返回 key-value 对的 key 值。

```go
package main
import "fmt"
func main() {
    //这是我们使用range去求一个slice的和。使用数组跟这个很类似
    nums := []int{2, 3, 4}
    sum := 0
    for _, num := range nums {
        sum += num
    }
    fmt.Println("sum:", sum)
    //在数组上使用range将传入index和值两个变量。上面那个例子我们不需要使用该元素的序号，所以我们使用空白符"_"省略了。有时侯我们确实需要知道它的索引。
    for i, num := range nums {
        if num == 3 {
            fmt.Println("index:", i)
        }
    }
    //range也可以用在map的键值对上。
    kvs := map[string]string{"a": "apple", "b": "banana"}
    for k, v := range kvs {
        fmt.Printf("%s -> %s\n", k, v)
    }
    //range也可以用来枚举Unicode字符串。第一个参数是字符的索引，第二个是字符（Unicode的值）本身。
    for i, c := range "go" {
        fmt.Println(i, c)
    }
}
```

输出，

```go
sum: 9
index: 1
a -> apple
b -> banana
0 103
1 111
```

## 2.14 集合（Map）

Map 是一种无序的键值对的集合。Map 最重要的一点是通过 key 来快速检索数据，key 类似于索引，指向数据的值。

Map 是一种集合，所以我们可以像迭代数组和切片那样迭代它。不过，Map 是无序的，我们无法决定它的返回顺序，这是因为 Map 是使用 hash 表来实现的。

### 2.14.1 定义Map

```go
/* 声明变量，默认 map 是 nil */
var map_variable map[key_data_type]value_data_type

/* 使用 make 函数 */
map_variable = make(map[key_data_type]value_data_type)
```

举例，

```go
package main

import "fmt"

func main() {
   var countryCapitalMap map[string]string
   /* 创建集合 */
   countryCapitalMap = make(map[string]string)
   
   /* map 插入 key-value 对，各个国家对应的首都 */
   countryCapitalMap["France"] = "Paris"
   countryCapitalMap["Italy"] = "Rome"
   countryCapitalMap["Japan"] = "Tokyo"
   countryCapitalMap["India"] = "New Delhi"
   
   /* 使用 key 输出 map 值 */
   for country := range countryCapitalMap {
      fmt.Println("Capital of",country,"is",countryCapitalMap[country])
   }
   
   /* 查看元素在集合中是否存在 */
   captial, ok := countryCapitalMap["United States"]
   /* 如果 ok 是 true, 则存在，否则不存在 */
   if(ok){
      fmt.Println("Capital of United States is", captial)  
   }else {
      fmt.Println("Capital of United States is not present") 
   }
}
```

输出，

```
Capital of France is Paris
Capital of Italy is Rome
Capital of Japan is Tokyo
Capital of India is New Delhi
Capital of United States is not present
```

### 2.14.2 删除元素

使用delete()函数来删除Map中的元素

```go
package main

import "fmt"

func main() {   
   /* 创建 map */
   countryCapitalMap := map[string] string {"France":"Paris","Italy":"Rome","Japan":"Tokyo","India":"New Delhi"}
   
   fmt.Println("原始 map")   
   
   /* 打印 map */
   for country := range countryCapitalMap {
      fmt.Println("Capital of",country,"is",countryCapitalMap[country])
   }
   
   /* 删除元素 */
   delete(countryCapitalMap,"France");
   fmt.Println("Entry for France is deleted")  
   
   fmt.Println("删除元素后 map")   
   
   /* 打印 map */
   for country := range countryCapitalMap {
      fmt.Println("Capital of",country,"is",countryCapitalMap[country])
   }
}
```

输出，

```
原始 map
Capital of France is Paris
Capital of Italy is Rome
Capital of Japan is Tokyo
Capital of India is New Delhi
Entry for France is deleted
删除元素后 map
Capital of Italy is Rome
Capital of Japan is Tokyo
Capital of India is New Delhi
```

## 2.15 接口

Go 语言提供了另外一种数据类型即接口，它把所有的具有共性的方法定义在一起，任何其他类型只要实现了这些方法就是实现了这个接口。

```go
/* 定义接口 */
type interface_name interface {
   method_name1 [return_type]
   method_name2 [return_type]
   method_name3 [return_type]
   ...
   method_namen [return_type]
}

/* 定义结构体 */
type struct_name struct {
   /* variables */
}

/* 实现接口方法 */
func (struct_name_variable struct_name) method_name1() [return_type] {
   /* 方法实现 */
}
...
func (struct_name_variable struct_name) method_namen() [return_type] {
   /* 方法实现*/
}
```

举例，

```go
package main
import (
    "fmt"
)
type Phone interface {
    call()
}
type NokiaPhone struct {
}
func (nokiaPhone NokiaPhone) call() {
    fmt.Println("I am Nokia, I can call you!")
}
type IPhone struct {
}
func (iPhone IPhone) call() {
    fmt.Println("I am iPhone, I can call you!")
}
func main() {
    // 定义为Phone接口
    var phone Phone
    // 初始化为NokiaPhone
    phone = new(NokiaPhone)
    phone.call()
    phone = new(IPhone)
    phone.call()
}
```

输出，

```
I am Nokia, I can call you!
I am iPhone, I can call you!
```

## 2.16 错误处理

Go 语言通过内置的错误接口提供了非常简单的错误处理机制。

error类型是一个接口类型，这是它的定义：

```go
type error interface {
    Error() string
}
```

使用errors.New 可返回一个错误信息

```go
func Sqrt(f float64) (float64, error) {
    if f < 0 {
        return 0, errors.New("math: square root of negative number")
    }
    // 实现
}
```

举例，

```go
package main

import (
    "fmt"
)

// 定义一个 DivideError 结构
type DivideError struct {
    dividee int
    divider int
}

// 结构体DivideError实现error接口
func (de *DivideError) Error() string {
    strFormat := `
    Cannot proceed, the divider is zero.
    dividee: %d
    divider: 0
`
    return fmt.Sprintf(strFormat, de.dividee)
}

// 定义 int 类型除法运算的函数
func Divide(varDividee int, varDivider int) (result int, errorMsg string) {
    if varDivider == 0 {
            dData := DivideError{
                    dividee: varDividee,
                    divider: varDivider,
            }
            errorMsg = dData.Error()
            return
    } else {
            return varDividee / varDivider, ""
    }

}

func main() {

    // 正常情况
    if result, errorMsg := Divide(100, 10); errorMsg == "" {
            fmt.Println("100/10 = ", result)
    }
    // 当被除数为零的时候会返回错误信息
    if _, errorMsg := Divide(100, 0); errorMsg != "" {
            fmt.Println("errorMsg is: ", errorMsg)
    }

}
```

输出，

```
100/10 =  10
errorMsg is:  
   Cannot proceed, the divider is zero.
  dividee: 100
  divider: 0
```

## 2.17 Go的关键字

- go：用于并行
- chan：用于channel通讯
- select：用于选择不同类型的通讯
- defer someCode：在函数退出之前执行

# 3. Go语言进阶

## 3.1 CGO编程



## 3.2 汇编语言



## 3.3 RPC和Protobuf

RPC的全程是远程过程调用。

### 3.3.1 Go的RPC实例

* **简单实例**

  将HelloService类型注册为RPC服务：

  ```go
  type HelloService struct {}
  // 按照Go的RPC规则：方法只能有两个可序列化的参数，其中第二个参数是指针类型，并且返回一个error类型，同时必须是公开的方法
  func (p *HelloService) Hello(request string, reply *string) error {
      // reply是需要返回的数据
      *reply = "hello:" + request
      return nil
  }
  
  // 将HelloService 作为RPC服务
  func main() {
      rpc.RegisterName("HelloService", new(HelloService))
  
      listener, err := net.Listen("tcp", ":1234")
      if err != nil {
          log.Fatal("ListenTCP error:", err)
      }
  
      conn, err := listener.Accept()
      if err != nil {
          log.Fatal("Accept error:", err)
      }
  
      rpc.ServeConn(conn)
  }
  ```

  请求RPC服务的过程：

  ```go
  func main() {
      // 建立RPC连接
      client, err := rpc.Dial("tcp", "localhost:1234")
      if err != nil {
          log.Fatal("dialing:", err)
      }
  
      var reply string
      // 调用具体的RPC方法，即HelloService.Hello
      err = client.Call("HelloService.Hello", "hello", &reply)
      if err != nil {
          log.Fatal(err)
      }
  
      fmt.Println(reply)
  }
  ```

  * **更加安全的RPC接口**

    （1）RPC服务器

    RPC规范分为：首先是服务的名字，然后是服务要实现的详细方法列表，最后是注册该类型服务的函数

    ```go
    // 服务名字
    const HelloServiceName = "path/to/pkg.HelloService"
    
    // 要实现的详细方法列表
    type HelloServiceInterface = interface {
        Hello(request string, reply *string) error
    }
    
    // 注册RPC服务的方法
    // HelloServiceInterface接口作为一个RPC服务
    func RegisterHelloService(svc HelloServiceInterface) error {
        return rpc.RegisterName(HelloServiceName, svc)
    }
    
    
    ```

    主函数

    ```go
    
    // 结构体HelloService实现了接口HelloServiceInterface
    type HelloService struct {}
    func (p *HelloService) Hello(request string, reply *string) error {
        *reply = "hello:" + request
        return nil
    }
    
    func main() {
        RegisterHelloService(new(HelloService))
    
        listener, err := net.Listen("tcp", ":1234")
        if err != nil {
            log.Fatal("ListenTCP error:", err)
        }
    
        for {
            conn, err := listener.Accept()
            if err != nil {
                log.Fatal("Accept error:", err)
            }
    		// go：表示用于并行
            go rpc.ServeConn(conn)
        }
    }
    ```

    （2）客户端

    ```go
    const HelloServiceName = "path/to/pkg.HelloService"
    
    func main() {
        client, err := rpc.Dial("tcp", "localhost:1234")
        if err != nil {
            log.Fatal("dialing:", err)
        }
    
        var reply string
        // 以服务名字+方法的方式调用
        err = client.Call(HelloServiceName+".Hello", "hello", &reply)
        if err != nil {
            log.Fatal(err)
        }
    }
    ```

* **跨语言的RPC**

  标准库的RPC默认采用Go语言特有的gob编码，因此从其它语言调用Go语言实现的RPC服务将比较困难。Go语言的RPC框架有两个比较有特色的设计：**一个是RPC数据打包时可以通过插件实现自定义的编码和解码；另一个是RPC建立在抽象的io.ReadWriteCloser接口之上的，我们可以将RPC架设在不同的通讯协议之上**。

  （1）服务器

  ```go
  func main() {
      rpc.RegisterName("HelloService", new(HelloService))
  
      listener, err := net.Listen("tcp", ":1234")
      if err != nil {
          log.Fatal("ListenTCP error:", err)
      }
  
      for {
          conn, err := listener.Accept()
          if err != nil {
              log.Fatal("Accept error:", err)
          }
  		// 使用jsonrpc编码，实现RPC服务
          go rpc.ServeCodec(jsonrpc.NewServerCodec(conn))
      }
  }
  ```

  （2）客户端

  ```go
  func main() {
      conn, err := net.Dial("tcp", "localhost:1234")
      if err != nil {
          log.Fatal("net.Dial:", err)
      }
  
      client := rpc.NewClientWithCodec(jsonrpc.NewClientCodec(conn))
  
      var reply string
      err = client.Call("HelloService.Hello", "hello", &reply)
      if err != nil {
          log.Fatal(err)
      }
  
      fmt.Println(reply)
  }
  ```

  底层来看，其实客户端和服务器间的通信都通过JSON格式的方式实现，比如

  ```go
  type clientResponse struct {
      Id     uint64           `json:"id"`
      Result *json.RawMessage `json:"result"`
      Error  interface{}      `json:"error"`
  }
  
  type serverResponse struct {
      Id     *json.RawMessage `json:"id"`
      Result interface{}      `json:"result"`
      Error  interface{}      `json:"error"`
  }
  ```

* **在HTTP上的RPC**

  ```go
  func main() {
      rpc.RegisterName("HelloService", new(HelloService))
  	//RPC的服务架设在“/jsonrpc”路径
      http.HandleFunc("/jsonrpc", func(w http.ResponseWriter, r *http.Request) {
          var conn io.ReadWriteCloser = struct {
              io.Writer
              io.ReadCloser
          }{
              ReadCloser: r.Body,
              Writer:     w,
          }
  		// 每次HTTP请求处理一次RPC方法调用
          rpc.ServeRequest(jsonrpc.NewServerCodec(conn))
      })
  
      http.ListenAndServe(":1234", nil)
  }
  ```

  客户端HTTP请求：

  ```bash
  curl localhost:1234/jsonrpc -X POST \
      --data '{"method":"HelloService.Hello","params":["hello"],"id":0}'
  ```

### 3.3.2 ProtoBuf

Protobuf是Protocol Buffers的简称，它是Google公司开发的一种数据描述语言，通过附带工具生成代码并实现将结构化数据序列化的功能。

可以通过Protobuf来最终保证RPC的接口规范和安全。首先创建hello.proto文件，包装HelloService服务中要用到的字符串类型。

```protobuf
// 采用proto3的语法
syntax = "proto3";

//package指令指明当前是main包
package main;
// message关键字定义一个新的String类型，在最终生成的Go语言代码中对应一个String结构体
message String {
    string value = 1;
}
```

使用protoc指令将proto文件转化为go文件，下面的代码去掉了很多XXX开头的变量，

```bash
# protoc generates go
protoc --go_out=. rpc.proto
```

```go
type String struct {
    Value string `protobuf:"bytes,1,opt,name=value" json:"value,omitempty"`
}

func (m *String) Reset()         { *m = String{} }
func (m *String) String() string { return proto.CompactTextString(m) }
func (*String) ProtoMessage()    {}
func (*String) Descriptor() ([]byte, []int) {
    return fileDescriptor_hello_069698f99dd8f029, []int{0}
}

func (m *String) GetValue() string {
    if m != nil {
        return m.Value
    }
    return ""
}
```

基于新的String类型，我们可以重新实现HelloService服务，

```go
type HelloService struct{}

func (p *HelloService) Hello(request *String, reply *String) error {
    reply.Value = "hello:" + request.GetValue()
    return nil
}
```

也可以使用protoc生成rpc服务代码，不过需要执行rpc的类型，protoc自带了grpc

```bash
# generate rpc service with grpc plugin
protoc --go_out=plugins=grpc:. hello.proto
```

**定制代码生成插件**

Protobuf的protoc编译器是通过插件机制实现对不同语言的支持。比如protoc命令出现`--xxx_out`格式的参数，那么protoc将首先查询是否有内置的xxx插件，如果没有内置的xxx插件那么将继续查询当前系统中是否存在protoc-gen-xxx命名的可执行程序，最终通过查询到的插件生成代码。对于Go语言的protoc-gen-go插件来说，里面又实现了一层静态插件系统。比如protoc-gen-go内置了一个gRPC插件，用户可以通过`--go_out=plugins=grpc`参数来生成gRPC相关代码，否则只会针对message生成相关代码。

下面是一个protoc-gen-go的插件接口，

```go
// A Plugin provides functionality to add to the output during
// Go code generation, such as to produce RPC stubs.
type Plugin interface {
    // Name identifies the plugin.
    Name() string
    // Init is called once after data structures are built but before
    // code generation begins.
    Init(g *Generator)
    // Generate produces the code generated by the plugin for this file,
    // except for the imports, by calling the generator's methods P, In,
    // and Out.
    Generate(file *FileDescriptor)
    // GenerateImports produces the import declarations for this file.
    // It is called after Generate.
    GenerateImports(file *FileDescriptor)
}
```

我们可以设计一个netrpcPlugin插件，用于为标准库的RPC框架生成代码：

```go
import (
    "github.com/golang/protobuf/protoc-gen-go/generator"
)

// 插件名称
type netrpcPlugin struct{ *generator.Generator }

func (p *netrpcPlugin) Name() string                { return "netrpc" }
func (p *netrpcPlugin) Init(g *generator.Generator) { p.Generator = g }

//调用自定义的genImportCode函数生成导入代码
func (p *netrpcPlugin) GenerateImports(file *generator.FileDescriptor) {
    if len(file.Service) > 0 {
        p.genImportCode(file)
    }
}

//Generate方法调用自定义的genServiceCode方法生成每个服务的代码
func (p *netrpcPlugin) Generate(file *generator.FileDescriptor) {
    for _, svc := range file.Service {
        p.genServiceCode(svc)
    }
}

func (p *netrpcPlugin) genImportCode(file *generator.FileDescriptor) {
    p.P("// TODO: import code")
}

func (p *netrpcPlugin) genServiceCode(svc *descriptor.ServiceDescriptorProto) {
    p.P("// TODO: service code, Name = " + svc.GetName())
}
// 注册Plugin
func init() {
    generator.RegisterPlugin(new(netrpcPlugin))
}
```

具体插件安装见[Protobuf](https://books.studygolang.com/advanced-go-programming-book/ch4-rpc/ch4-02-pb-intro.html)



## 3.4 Go和Web



## 3.5 分布式系统
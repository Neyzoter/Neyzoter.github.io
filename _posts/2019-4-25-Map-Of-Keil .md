---
layout: post
title: Map文件解析
categories: MCU
description: STM32编译代码后，生成的map文件解析
keywords: STM32, keil, map
---

> 原创
>
> 转载请注明出处，侵权必究

## 1、keil的map简介

在做stm32项目的时候，经常会遇到进入HardFault死循环的问题，主要原因如下：

- 数组越界操作；
- 内存溢出，访问越界；
- 堆栈溢出，程序跑飞；
- 中断处理错误；

我们可以通过keil生成的map文件来查看程序互相依赖，内存大小，程序大小等信息来判断。

map文件生成格式可以配置（Project \-\> Options for Target \-\> Listing）

<img src="/images/posts/2019-4-25-Map-of-Keil/mapSet.png" width="600" alt="map文件配置" />

## 2、map文件解析

### 2.1 Section Cross References

模块、段(入口)交叉引用，各个源文件生成的模块、段（定义的入口）之间相互引用的关系，需要勾上Listing的Cross Reference才能输出到map文件。

举例

```
main.o(i.System_Initializes) refers to bsp.o(i.BSP_Initializes) for BSP_Initializes
```

main模块(main.o)中的System_Initializes函数(i.System_Initializes)，引用（或者说调用）了bsp模块(bsp.o)中的BSP_Initializes函数或者变量。

### 2.2 Removing Unused input sections from the image

移除未使用的模块，需要勾上Listing的Unuaed Sections Info才能输出到map文件。

最后还有一个统计信息：

`52 unused section(s) (total 2356 bytes) removed from the image.`

1.总共有52段没有被调用；

2.没有被调用的大小为2356 字节；

### 2.3 Image Symbol Table

映射符号表，需要勾上Listing的Symbols才能输出到map文件。

<img src="/images/posts/2019-4-25-Map-of-Keil/imageSymbols.jpg" width="600" alt="Image Symbol Table" />

> C语言存储结构补充

<img src="/images/posts/2019-4-25-Map-of-Keil/TextDataBssStackHeapSystem.png" width="600" alt="C语言存储结构" />

>**text**：程序
>文字区段（text segment）也称为程序段（code segment），存放可执行命令（instructions）。
>
>该区段通常位于 heap 或 stack 之後，避免因 heap 或 stack 溢出或者覆盖 CPU 指令。
>
>**data**：初始化静态变量
>初始化数据区段（initialized data segment）存储已经初始化的静态变量，例如有经过初始化的 C 语言的全局变量（global variables）以及静态变量（static variables），分为RW-data和RO-data。
>
>**bss**（Block Started by Symbol segment）：未初始化静态变量
>未初始化数据
>
>**stack**：栈
>栈（stack segment）用于存储函数的局部变量，以及各种函数调用时需要存储的信息（比如函数返回的存储器地址、函数状态等），每一次的函數呼叫就會在栈上建立一個 stack frame（栈帧），存储该次调用的所有数据于状态，这样以来同一个函数被调用多次时，就会有不同栈帧，不会相互干扰。
>
>**heap**：动态配置变量
>heap 區段的記憶體空間用於儲存動態配置的變數，例如 C 語言的 malloc 以及 C++ 的 new 所建立的變數都是儲存於此。
>
>栈（Stack）一般的状态会从高低值往低地址成长，而 heap 相反。
>
>**system**：命令列参数和环境变量
>system 区段用于存储一些命令列参数和环境变量，和系统有关。

符号映射表分为**局部符号（Local Symbol）**和**全局符号（Global Symbol）**两部分。

**注意**：局部符号不代表局部变量，static变量也是局部符号，但是不是局部变量。

>* Global symbols（模块内部定义的全局符号）
>
>由模块m定义并能被其他模块引用的符号。例如，非static C函数和非static C全局变量
>
>* External symbols（外部定义的全局符号）
>
>由其他模块定义并被模块m引用的全局符号
>
>* Local symbols（本模块的局部符号）
>
>仅由模块m定义和引用的本地符号。例如，在模块m中定义的带static的C函数和全局变量
> 注意：**链接器的局部符号不是指程序中的局部变量（分配在栈中的临时性变量）**，链接器不关心这种局部变量

每个符号都会输出以下主要内容：

| 符号            | 意义           | 说明                                                         |
| --------------- | -------------- | ------------------------------------------------------------ |
| Symbol Name     | 符号名称       | .data、.bss、Stack、.constdata等                             |
| Value           | 存储对应的地址 | 0x0800xxxx指存储在FLASH里面的代码、变量等；0x2000xxxx指存储在内存RAM中的变量Data等。 |
| Ov Type         | 符号对应的类型 | Number、Section、Thumb Code、Data等，全局、静态变量等位于0x2000xxxx的内存RAM中。 |
| Size            | 存储大小       | 我们怀疑内存溢出，可以查看代码存储大小来分析。               |
| Object(Section) | 段目标         | 一般指所在模块（所在源文件）                                 |

**我对OvType的理解**：Number指没有占用内存空间的一些符号（`ABSOLUTE`），比如`#programa _printf_a `中的`_printf_a`；Section包括.bss（未初始化变量）、.data（初始化的变量）、.text（程序）；Thumb Code大度表示静态函数（static function()）表示只能在本文件中可见，*static修饰的变量是局部符号，但是不是局部变量*；Data中一般包含static变量或者const变量。

### 2.4 Memory Map of the image

内存（映射）分布，需要勾上Listing的Memory Map才能输出到map文件。

<img src="/images/posts/2019-4-25-Map-of-Keil/MMOI.bmp" width="600" alt="Memory Map of the image" />

**Image Entry point : 0x08000131**：指映射入口地址。

**Load Region LR_IROM1 (Base: 0x08000000, Size: 0x000004cc, Max: 0x00080000, ABSOLUTE):**

指加载区域位于LR_IROM1开始地址0x08000000，大小有0x000004cc，这块区域最大为0x00080000.

**执行区域**：对应我们目标配置中的区域

Execution Region ER_IROM1

Execution Region RW_IRAM1

<img src="/images/posts/2019-4-25-Map-of-Keil/T.png" width="600" alt="Target" />

**执行区域ER_IROM1/RW_IRAM1主要内容：**（分成ER_IROM1和RW_IRAM1两部分）

| 符号         | 意义     | 说明                                                         |
| ------------ | -------- | ------------------------------------------------------------ |
| Base Addr    | 存储地址 | 0x0800xxxxFLASH地址和0x2000xxxx内存RAM地址。                 |
| Size         | 存储大小 |                                                              |
| Type         | 类型     | Data：数据类型；Code：代码类型；Zero：未初始化变量类型；PAD(padding)：补白类型（ARM处理器是32位的，如果定义一个8位或者16位变量就会剩余一部分，这里就是指的“补充”的那部分） |
| Attr         | 属性     | RO：存储与ROM中的段；RW：存储与RAM中的段                     |
| Section Name | 段名     | “Section Cross References”指的模块、段一样，RESET、.ARM、 .text、 i、 .data、 .bss、 HEAP、 STACK等 |
| Object       | 目标     |                                                              |

### 2.5 Image component sizes

存储组成大小，需要勾上Listing的Size Info才能输出到map文件。

<img src="/images/posts/2019-4-25-Map-of-Keil/Image component sizes.bmp" width="600" alt="存储组成大小" />

**Code**：指代码的大小；

**RO-data**：指除了内联数据(inline data)之外的常量数据；

**RW-data**：指可读写（RW）、已初始化的**全局变量数据**（**说明**：RW-data已初始化的数据会存储在Flash中，上电会从FLASH搬移至RAM中。）

**ZI-data**：指未初始化（ZI）的**全局变量数据**;

## 3、内存移除排查方法

查看`Image Symbol Table`的局部符号`Local Symbol`使用情况。`static`修饰的局部符号会单独标出来，而不是以`.data`或者`.bss`形式标出来。以下图为例，

<img src="/images/posts/2019-4-25-Map-of-Keil/LocalSymbol.png" width="600" alt="局部符号" />

`wifi_user_main.o`文件内包含`.bss`和`.data`变量外还有两个`static const`修饰的变量`oid_list`和`oid_type`。`oid_list`和`oid_type`是局部符号，但是不是局部变量，并不会压入栈空间。`STACK`表示启动文件中设置的栈空间大小。

具体操作：

1.保证方法调用不要太深，不然诸多方法的局部变量会堆积在栈中；

2.根据**局部变量**（而不是局部符号）需要设定栈空间。


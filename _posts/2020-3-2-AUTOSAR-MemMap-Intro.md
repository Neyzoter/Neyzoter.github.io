---
layout: post
title: AUTOSAR的MemMap介绍
categories: Life
description: AUTOSAR的MemMap介绍
keywords: AUTOSAR, MemMap

---



> 原创

# 1.MemMap介绍

## 2.1 MemMap的作用

对于许多ECU而言，**内存映射（MemMap）**是非常重要的，具体包括以下优点：

1. 避免RAM的浪费

   在同一个模块下定义了不同类型的变量（比如8bit、16bit、32bit），则为了对齐，会在不同类型变量间留间隙。比如8bit变量和32bit变量存放在一起，在两个变量都要对齐到32bit。

2. 特殊RAM用途

   比如一些变量通过位掩码来获取，如果map到RAM可以通过编译器的位掩码功能来加快执行效率

3. 特殊ROM用途

   一些频繁执行的函数可以映射到RAM中，而不经常执行的函数可以映射到外部ROM。

4. 同一段代码用在bootloader和应用

   如果同一个模块同时需要被bootloader和应用使用，则需要同时映射到不同的段中

5. 支持内存保护

   使用硬件存储器保护需要将模块变量分离到不同的存储器区域。内部变量映射到受保护的内存中，用于数据交换的缓冲区映射到不受保护的内存中。

6. 支持分区

   可以将一个模块的变量映射到不同的分区中

# 2.MemMap使用

## 2.1 MemMap.h文件配置

在模块使用MemMap之前，需要对应配置MemMap.h文件。可以为每个模块或者每个SWC都配置一个MemMap.h文件。

比如我们为SWC1配置一个`Swc1_MemMap.h`。

```c
/*段开始*/
#define MEMMAP_ERROR
// ....
/* COMMON_CODE代码段开始 */
#if defined SWC1_START_SECTION_COMMON_CODE
#pragma section ftext
#undef SWC1_START_SECTION_COMMON_CODE
#undef MEMMAP_ERROR
/* UNBANKED_CODE代码段开始 */
#elif defined SWC1_START_SECTION_UNBANKED_CODE
#pragma section code text
#undef SWC1_START_SECTION_UNBANKED_CODE
#undef MEMMAP_ERROR
// ....
#endif

/*段结束*/
// ....
/* module and ECU specific section mappings */
#if defined SWC1_STOP_SECTION_COMMON_CODE
#pragma section ftext
#undef SWC1_STOP_SECTION_COMMON_CODE
#undef MEMMAP_ERROR
#elif defined SWC2_STOP_SECTION_UNBANKED_CODE
#pragma section code text
#undef SWC2_STOP_SECTION_UNBANKED_CODE
#undef MEMMAP_ERROR
// ....
#endif

```

## 2.2 在模块中使用MemMap

下面是一个使用MemMap的范式，

```c
// 定义对应的段名称，在上述MemMap.h文件中会使用#if define来找到对应的段信息
// <PREFIX>一般可以是SWC名称
// <MEMORY_ALLOCATION_KEYWORDS>表示对应的代码段名册和那个
#define <PREFIX>_START_SEC_<MEMORY_ALLOCATION_KEYWORDS>
// 引用MemMap.h，进而找到对应的段
#include <MemMap.h>
/* 此处定义代码、变量、常数等 */
/* … */
#define <PREFIX>_STOP_SEC_<MEMORY_ALLOCATION_KEYWORDS>
#include <MemMap.h>
```

比如我们要在`Rte_SWC1.c`文件中创建一个函数，则将该代码放到对应的代码段中。

```c
#define SWC1_START_SECTION_COMMON_CODE
#include "Swc1_MemMap.h"
void run(void) {
    //....
}
#define SWC1_STOP_SECTION_COMMON_CODE
#include "Swc1_MemMap.h"
```

具体作用过程如下，

```
Rte_SWC1.c文件
1. #define SWC1_START_SECTION_COMMON_CODE -> 定义了 SWC1_START_SECTION_COMMON_CODE
2. #include "Swc1_MemMap.h" -> 调用 Swc1_MemMap.h

Swc1_MemMap.h文件
1. #define MEMMAP_ERROR -> 定义MEMMAP_ERROR
2. #if defined SWC1_START_SECTION_COMMON_CODE -> 发现定义了SWC1_START_SECTION_COMMON_CODE
3. #pragma section ftext -> 设置存储到对应的段
4. #undef SWC1_START_SECTION_COMMON_CODE -> 取消SWC1_START_SECTION_COMMON_CODE定义
5. #undef MEMMAP_ERROR -> 取消MEMMAP_ERROR定义，在本文件中如果发现MEMMAP_ERROR定义则会报错

然后回到Rte_SWC1.c文件
1. 函数定义
void run(void) {
    //....
}
2. #define SWC1_STOP_SECTION_COMMON_CODE -> 定义了 SWC1_STOP_SECTION_COMMON_CODE
3. #include "Swc1_MemMap.h" -> 调用 Swc1_MemMap.h

Swc1_MemMap.h
1. #define MEMMAP_ERROR -> 定义MEMMAP_ERROR
2. #if defined SWC1_STOP_SECTION_COMMON_CODE -> 发现定义了SWC1_STOP_SECTION_COMMON_CODE
3. #pragma section ftext -> 设置存储到对应的段
4. #undef SWC1_STOP_SECTION_COMMON_CODE -> 取消SWC1_STOP_SECTION_COMMON_CODE定义
5. #undef MEMMAP_ERROR -> 取消MEMMAP_ERROR定义，在本文件中如果发现MEMMAP_ERROR定义则会报错
```


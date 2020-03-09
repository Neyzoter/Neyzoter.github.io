---
layout: post
title: Core21.0.0如何组织模块已有代码
categories: AUTOSAR
description: Core21.0.0如何组织模块已有代码
keywords: AUTOSAR
---

> Core21.0.0是原ARCORE公司（已被VECTOR收购）的符合AUTOSAR规范的代码，本文对该代码进行梳理

# 1、[工程介绍](<https://github.com/Neyzoter/autosar_core21.0.0>)

`Rte.mk: examples\HelloWorld\HelloWorld\config\stm32_stm3210c\Rte\Config\Rte.mk`（编译RTE功能的`.o`文件进内核）

`*.mk: examples\HelloWorld\HelloWorld\config\stm32_stm3210c\`下的`*.mk`（将各种模块加入到`MOD_USE`变量, 会在`rules.mk`中转化为一个个`USE_XXX`变量，赋值为`y`(表示编译进内核)）或者`examples\HelloWorld\HelloWorld\config\stm32_stm3210c\Rte\Config`下的`*.mk`（将RTE相关目标文件`.o`加入到内核编译，也是编译过程）

`cc_gcc.mk`:配置编译器（`CFLAGS`）、预处理器、链接器（`LDFLAGS`、`LDOUT`、`LDMAPFILE`）、汇编器（`ASFLAGS`、`ASOUT`）、Dumper、归档（`AROUT`），说明: 这里`$(COMPILER)`是`gcc`, 所以指向`cc_$(COMPILER.mk)`, 还有`cc_armcc.mk`、`cc_iar.mk`等

`gcc.mk: \core\system\Os\osal\arm\armv7_m\scripts\gcc.mk`   一些gcc的乱七八糟的配置

`project_defaults.mk: core\scripts\project_defaults.mk `

`board_common.mk`: 对所有的架构添加编译信息`obj-$()`、模块`mod.mk`文件调用（`EcuM`、`Rtm`、`Gpt`等）、一些文件的路径(如`stm32f10x_xxx.h/.c`)、移除`warning`

```
<anydir>                         - 工程
|--- config
|    |--- [config files]         - Overrides default module configurations
|    '--- <board>
|         '--- [config files]    - Overrides all other module configurations
|
|--- makefile                    - 2.8 添加路径, 工程配置2.8.1
|--- [build_config.mk]           - 2.3 依次调用Rte.mk（见说明）、*.mk（见说明）、加入模块MOD_USE
'--- obj-<arch>

<Arctic Core>                    - core
|--- makefile                    - 1 顶层makefile，会进行板子是否支持，目录是否存在的检查和配置，目标all调用core/scripts/rules.mk
|--- boards
|    |--- <board>
|    |    |--- [config files]    - Default module configurations
|    |    '--- build_config.mk   - 2.2 特定电路板的配置变量、必须的MOD_USE(MCU KERNEL)和预定义def-y
|    |
|    |--- build_config_bsw.mk    - 2.1 配置可用模块(MOD_AVAIL)、代码覆盖率测试工具
|    '--- board_common.mk        - 2.9 针对不同芯片架构、模块添加编译规则（见说明）
|
'--- scrips
     |--- config.mk
     |--- project_defaults.mk    - 2.8.1 添加路径、构建工程结构
     |--- rules.mk               - 2 build设置(2.1-2.2)、模块配置（2.3-2.4, 给模块定义y:内核编译）、工具配置(2.5-2.7)、工程makefile(2.8-2.9)、顶层目标、规则(编译、链接)
     |--- version_check.mk       - 2.4 版本检查
     |--- cc_gcc.mk              - 2.5 编译器通用支持,调gcc.mk（见说明）
     |--- cc_pclint.mk           - 2.6 pclint设置
     '--- cc_cclint.mk           - 2.7 cclint设置
```

# 2、组织MCAL过程

```
<anydir>                         - 工程
|--- config
|    '--- <board>
|         |--- Rte
|         |    |--- Config       
|         |    |--- Contract     
|         |    '--- MemMap       
|         '--- [config files]    - 将各种模块加入到MOD_USE变量
|
|--- makefile                    
|--- build_config.mk             
'--- obj-<arch>
```

**过程**

1.`/examples/<proj>/config/<board>`文件夹下的`*.mk`文件将模块添加到`MOD_USE`变量

2.变量`MOD_USE`在`rules.mk`中逐个转化为变量`USE_XXX`为`y`（比如`USE_PWM`
，表示使用`PWM`模块），指示编译进内核

3.编译

3.1 `boards/board_common.mk`根据`USE_XXX`决定是否执行编译底层MCAL文件进内核（例如`obj-
$(CFG_STM32F1X)-$(USE_PWM) += stm32f10x_tim.o`，如果`$(CFG_STM32F1X)`或者`$(USE_PWM)`不是`y`，则不会将`stm32f10x_tim.o`编译得到）

3.2 .c/.h文件会根据是否定义了使用模块（USE_XXX）来决定是否生成函数体、结构体等，如

```c
//core/boards/generic/EcuM_PBcfg.c
#if defined(USE_PDUR)
	.PduRConfig = &PduR_Config,
#endif
```

3.3 .c/.h文件会根据是否定义了使用模块（USE_XXX）来决定是否包含（include）.h文件，如

```c
//core/system/BswM/src/BswM.c
#if defined(USE_PDUR)
	#include "PduR.h"
#endif
```

**示意图**

```
$(MOD_USE) -- 指示编译进内核 --> USE_XXX = y ------ 编译（进内核） ------>  eg.obj-$(CFG_STM32F1X)-$(USE_PWM) += stm32f10x_tim.o
   *.mk         rules.mk                    boards/board_common.mk      
                                            -----> 编译c/h文件内函数和结构体等
                                            -----> 包含模块头文件
```

note:

```
*.mk : examples/HelloWorld/HelloWorld/config/stm32_stm3210c/Rte/Config/*.mk
rules.mk : /core/scripts/rules.mk
boards/board_common.mk : core/boards/board_common.mk
```

# 3、组织RTE接口

```
<anydir>                         - 工程
|--- config
|    '--- <board>
|         |--- Rte
|         |    |--- Config       - *.mk内加入所有RTE相关的目标.o文件
|         |    |--- Contract     - 软件组件接口（SR模式、CS模式等）
|         |    '--- MemMap       - 内存映射：包含MemMap.h，然后undef错误定义
|         '--- [config files]
|
|--- makefile                    
|--- build_config.mk             
'--- obj-<arch>
```
---
layout: post
title: Redpine Signals RS9113 WIFI模块的SPI程序移植
categories: MCU
description: Redpine Signals RS9113的SPI程序移植
keywords: WIFI, 5G,Keil
---
> 原创
>
> 转载请注明出处，侵权必究

# 1、RS9113简介

RS9113-N00-D1C是Redpine Signals推出的一款支持2.4/5GHz的WIFI模组。

<img src="/images/posts/2018-7-26-Redpine-WIFI-SPI-Code-Transplant/RS.png" width="600" alt="RS有内部天线的模组内部结构" />

# 2、SPI通信代码移植
# 2.1 移植源代码到工程
第1步，加入binary到工程

RS9113.NBZ.WC.GEN.OSI.1.6.6\host（包含at、binary和sapis三个文件夹）中除了binary文件夹都删除，复制到MCU工程文件夹下。

这个RS9113.NBZ.WC.GEN.OSI.1.6.6是Redpine官方提供的源代码。1.6.6表示的是版本号。

第2步，工程文件夹添加

在Manage Projects Items -> Project Items -> Groups中添加以下三个文件夹。

<img src="/images/posts/2018-7-26-Redpine-WIFI-SPI-Code-Transplant/threeFiles.png" width="600" alt="添加3个文件夹" />

第3步，添加文件

WLAN_CORE中添加 \\RS9113.NBZ.WC.GEN.OSI.1.6.8\\host\\binary\\apis\\wlan\\core\\src中所有c文件

WLAN_HAL中添加 \\RS9113.NBZ.WC.GEN.OSI.1.6.8\\host\\binary\\apis\\intf\\spi\\src中的文件（用于SPI相关）和 \FreeRTOS_F4_Demo\host\binary\apis\hal\src中所有文件。

WLAN_APP 中添加 \\RS9113.NBZ.WC.GEN.OSI.1.6.8\\host\\binary\\apis\\wlan\\ref_apps\\src中**除了**rsi_wifi_state_mc.c的所有文件。

第4步，添加路径。

在Keil工程中添加路径。

<img src="/images/posts/2018-7-26-Redpine-WIFI-SPI-Code-Transplant/include.png" width="700" alt="添加路径" />

```
..\host\binary\apis\hal\include;
..\host\binary\apis\intf\spi\include;
..\host\binary\apis\wlan\core\include;
..\host\binary\apis\wlan\ref_apps\include	
```

第5步，添加宏定义

rsi_global\.h中添加

``` #define WLAN_ENABLE 1```

rsi_api.h中添加SPI接口宏（默认就有，如果没有就添加一下）

```#define RSI_INTERFACE RSI_SPI```

第6步，编译和修改warning和error

主要包括：

* 函数声明的时候，函数参数括号内没有加void

第二行是正确的。

```cpp
void rsi_interrupt_handler();
void rsi_interrupt_handler(void);
```

* 中断处理函数

屏蔽掉函数内的处理。

```cpp
void rsi_interrupt_handler(void)
{
	//中断不在这里处理
//  rsi_app_cb.pkt_pending = RSI_TRUE;
//  rsi_irq_disable();
}

```

* 类型不匹配

char改成uint8

和rsi_uSocket 类型不匹配的就强制转化为rsi_uSocket

* 声明函数

uint8* rsi_itoa(uint32 val, uint8 *str)函数没有声明，找到后，在相应的h文件中声明。

## 2.2 修改底层硬件

第1步，移植SPI配置

第2步，修改rsi_spi_recv和rsi_spi_send

第3步，移植复位IO

第4步，移植中断

rsi_app_cb.pkt_pending = 1;//RSI_TRUE;

## 2.3 封装自己的函数

1、开始测试

WIFI_BOOT()

```cpp

char WIFI_BOOT(void)
{
	/*清除Buff数据*/
	rsi_app_cb.pkt_pending=0;
	memset(&rsi_app_cb, 0, sizeof(rsi_app_cb));	
	/*检查SPi是否和模块正常通讯*/
	/*检查SPI  IO 硬件是否正常*/
	RspCode = rsi_sys_init();
	if(RspCode != 0)
	{
		return 1;
	}
	/*加载BOOT*/
	do{																					//GPIO_Bypass
		RspCode = rsi_waitfor_boardready();
		if((RspCode < 0) && (RspCode != -3))
			return 1;
	}while(RspCode == -3);
	/*选择固件*/
	RspCode = rsi_select_option(RSI_HOST_BOOTUP_OPTION);
	if(RspCode < 0)
		return 1;
	/*等待card read  Rsp=0x89*/
	RspCode=Read_PKT();
	if(RspCode!=0x89||rsi_app_cb.error_code!=0)
	{		
		//TODO
		return 1;//Hard_reset();
	}
	
	return 0;
}

```

2、连接硬件

3、rsi_sys_init能正常执行

说明移植成功。











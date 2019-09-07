---
layout: wiki
title: Eclipse Plugin Dev
categories: Eclipse
description: Eclipse Plugin开发
keywords: Eclipse, GUI, Plugin, AUTOSAR
---

# 1.介绍

## 1.1 SWT/JFace技术

SWT（Standard Didget Toolkit，标准图形工具箱）是一种用Java开发的GUI程序的技术。SWT技术吸取AWT/Swing的特点，会针对某个目标平台（如Windows、Macos、Linux等）进行判断，目标平台上有的控件，SWT会直接使用，已达到较快的处理速度和本地化的显示效果，目标平台上没有的控件，SWT则会采用Swing的方法进行绘制，使得支持该控件。

JFace则是一套基于SWT的工具箱，将常用的界面操作包装了起来，对界面设计进行了更高层次的抽象。其可同SWT协同工作，而不是将SWT的实现隐藏起来。开发者可以同时使用JFace和SWT进行开发。

## 1.2 插件技术和OSGI

将Eclipse平台和其他各种功能的组件插接起来，就构成了一个可用的程序体系。比如平台加上JDT模块（Java Development Toolkit）就成了Java IDE，加上CDT就是一个C/C++ IDE。凡遵循这套拓展规则的模块，都可以方便地往体系中增加或者删除。为了解决过多插件占用大量内存的问题，Eclipse采用延迟装在技术，只有在一个插件在被其他模块调用的时候，才会将其装载到内存中。

最初的Eclipse插件框架设计使得其发展受到限制，比如Eclipse系统启动会检查所有的插件，并构造一张静态的插件索引表，而这张表不能再运行时修改，从而造成每次添加或者删除插件时，都必须重新启动整个平台。从3.0开始，Eclipse对内核重新构建，保留原有声明与实现分离的插件技术（每一个希望被别的程序拓展的模块必须**声明**一系列拓展点，希望在此模块上拓展功能的程序模块，则需要按照拓展点的声明来**实现**拓展，称为Eclipse Runtime）的同时，对OSGi（Open Services Gateway initiative，开放式服务网关协议）做了实现，组成新的框架Equinox。OSGi是一套基于Java的开放式接口协议。

*什么是OSGi*：:在不同的模块中做到彻底的分离，而不是逻辑意义上的分离，是物理上的分离，也就是说在运行部署之后都可以在不停止服务器的时候直接把某些模块拿下来，其他模块的功能也不受影响。

## 1.3 RCP技术

Eclipse RCP（Rich Client Platform）是帮助开发者创建和部署*富客户端*（为用户提供了丰富功能体验的客户端程序）平台。

## 1.4 EMF技术

EMF（Eclipse Modeling Framework，Eclipse建模框架）就是一项致力于简化建模工作的项目。
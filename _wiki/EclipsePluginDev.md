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


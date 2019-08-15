---
layout: post
title: Artop Demonstrator使用过程
categories: [AUTOSAR, Softwares]
description: 记录一次Artop Demonstrator使用过程
keywords: AUTOSAR, ARTop, Automotive, 汽车电子
---

> 原创
>

### 1、Open the Artop perspective

**Window** `->` **Open Perspective** `->` **Other** `->` **Artop**

### 2、Create a new AUTOSAR project

**File** `->` **New **`->` **AUTOSAR Project** 

<img src="/images/posts/2019-8-15-Record-Artop-Demo-Usage/newArProj.png" width="400" alt="创建工程" />

填写`Project name`，可通过`AUTOSAR release options`选择AUTOSAR版本。

`Import ECU Configuration Parameters`选项表示自动添加Ecu参数定义。

### 3、Create a new AUTOSAR file

**File** `->` **New **`->` **AUTOSAR file** 

<img src="/images/posts/2019-8-15-Record-Artop-Demo-Usage/newArFile.png" width="400" alt="创建ar文件" />

可以修改`File name`。

选中`With an ARPackage`后，自动添加ARPackage，不过我们也可以手工加入。

### 4、Create a new ARPackage

**AUTOSAR** （工程子目录下，见下图）`-右键->` **new child** `->` **ARPackage**，此时可以保存一下`.arxml`文件。

<img src="/images/posts/2019-8-15-Record-Artop-Demo-Usage/AUTOSARchild.png" width="400" alt="AUTOSAR子文件" />

### 5、Explore AUTOSAR Project

双击**AUTOSAR**下的元素，通过编辑器看到信息，通过下面的Properties看到树结构。

<img src="/images/posts/2019-8-15-Record-Artop-Demo-Usage/ARPackageDisp.png" width="400" alt="ARPackage属性" />

### 6、Create AUTOSAR object

**AR Package** `-右键->`**New Child** `->` **ECU Instance**

<img src="/images/posts/2019-8-15-Record-Artop-Demo-Usage/ECUelement.png" width="400" alt="ARPackage属性" />

### 7、Edit object properties using the editor

可通过**Properties**修改各个属性，比如修改ECU元素的**Short Name**，则会将该元素的名称的改成这个（注意保存）。

### 8、Manual Validation of AUTOSAR models

**AUTSOAR** `-右键->` **Validation** `->` **Validate** 

<img src="/images/posts/2019-8-15-Record-Artop-Demo-Usage/validation.png" width="400" alt="validation" />


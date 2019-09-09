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

EMF（Eclipse Modeling Framework，Eclipse建模框架）就是一项致力于简化建模工作（将实际生活中的例子抽象成Java对象来建立结构化的数据模型）的项目。包括：

* **EMF**

  EMF项目的核心框架，允许用户通过编写Java接口，从Rose导入UML类图等方法生成一个描述用户需要的数据模型的元模型（Meta Model）。元模型称为Ecore，描述数据模型中包含哪些**对象**，对象中有哪些**属性**和**方法**，以及这些**对象之间的关系**。

  <img src="/images/wiki/EclipsePluginDev/EMF_Process.png" width="500" alt="EMF原理">

* **EMF Edit**

  提供数据模型编辑相关的功能，为数据模型提供各种功能的适配器，使得生成的数据模型可以直接作为Jface的内容提供来源。

* **EMF CodeGen**

  用于从ECore中生成数据模型的代码。生成的数据模型代码除了包含数据模型的接口和实现外，还包含一个工厂类用于生成数据模型的实例，以及一个Package类型，其中包含了数据模型的元数据。同时，CodeGen也可以生成一个基于Eclipse RCP的编辑器，用来对数据模型的内容进行编辑。

## 1.5 GEF技术

GEF（Graphical Editing Framework）是为了方便开发者开发基于RCP的，支持**图形化编辑**的程序界面而设计的一套框架。GEF可以开发几乎任何和图形界面相关的应用程序，如UML类图、流程图、GUI设计工具，设置是所见即所得的排版工具。如下是GEF开发的一个逻辑电路模拟器：

<img src="/images/wiki/EclipsePluginDev/GEF_Dev_Logical_Circuit_Func.png" width="700" alt="EMF原理">

GEF开发了一套就要SWT的轻量级绘图系统，称为Draw2D。Draw2D的所有操作基于一个SWT Canvas对象，在Canvas上面利用画线、填充等基本操作进行画图。

**GEF技术说明**

GEF不仅能够将数据模型用图形的方式直观地展示出来，而且允许用户和模型进行交互（通过鼠标和键盘的操作添加/删除一个模型，修改模型中的文字等）。

GEF基于MVC的设计思想，将显示的图形和底层的数据模型分离开来，两者之间用控制器相连。用户的操作被捕获后，由控制器翻译成针对数据模型进行操作的命令对象并执行这些命令；数据模型的内容改变后，控制器又收到通知，随后会根据模型的变化刷新作为视图的图形界面。大部分的消息监听和转发工作由GEF架构完成，用户只需要编写数据模型、Draw2D的视图以及少量的控制代码就能够对图形显示和编辑的功能。

**Draw2D和Swing的比较**：

1.Swing致力于GUI开发，画出来主要是文本框、按钮等图形界面控件；

2.Draw2D致力于图形化编辑，精力集中于此类技术，如图形的复合嵌套、图形之间的连接线绘制等；

3.两者都是轻量级绘图系统。

以下是Draw2D绘制UML类图的例子：

<img src="/images/wiki/EclipsePluginDev/Draw2D_DrawUML.png" width="700" alt="Draw2D绘制UML类图">

# 2.SWT/JFace概述

 SWT提供一套通用的API，使得开发出的图形程序不仅可以不加修饰地在平台间移植，而且在外观上和速度上与使用C/C++等语言在操作系统平台上开发出来的本地图形程序毫无差别（因为使用了JNI技术，是Sun公司为Java语言设计的用来与C/C++程序交互的技术，即将Java语言编写的接口和C语言编写的函数绑定，调用Java接口就等于调用C函数），还可以使用鼠标拖放操作、系统托盘等高级的系统服务。

## 2.1 SWT结构浅析

*第一层*是SWT的API

*第二层*是JNI相关的代码。

*第三层*是使用C语言编写的操作系统本地胴体链接库文件。

<img src="/images/wiki/EclipsePluginDev/SWT_Layer.png" width="700" alt="SWT的三层结构">

## 2.2 SWT API结构

SWT 的API包括【布局类、组件类、事件类和图形类】（具体说明见[《Eclipse插件开发学习笔记》](https://pan.baidu.com/s/1nKCw2EyOBFlNe3MDMpZyMw)  提取码：z8k3）。

<img src="/images/wiki/EclipsePluginDev/SWT_API.png" width="700" alt="SWT的API">

## 2.3 JFace

JFace是基于SWT的一套图形工具包，没有为SWT提供任何新的功能，只是将一些较繁琐而且常用的图形操作封装起来，使得开发工作更简便。JFace完全使用SWT API开发，没有涉及SWT平台部分，JFace没有不同平台版本之分。

JFace的组成（具体介绍见《Eclipse插件开发学习笔记》）：

<img src="/images/wiki/EclipsePluginDev/JFace_Contain.png" width="700" alt="JFace的组成">

## 2.4 SWT与Swing

<img src="/images/wiki/EclipsePluginDev/Swing_UI.png" width="700" alt="Swing的UI机制">

## 2.5 编写并发布SWT程序

具体说明见《Eclipse插件开发学习笔记》

# 3.SWT编程基础

未完待续，具体说明见《Eclipse插件开发学习笔记》

## 3.1 Display和Shell

SWT程序中至少需要一个Display对象，进而和操作系统交互，创建Display对象的线程称为UI线程。

SWT中Shell代表一个窗口。

## 3.2 控件

<img src="/images/wiki/EclipsePluginDev/SWT_Controller.png" width="700" alt="SWT的控件继承结构">

## 3.3 图形资源

图形资源使得程序界面更加丰富多彩，继承自`org.eclipse.swt.graphics.Resource`，包括颜色资源（`org.eclipse.swt.graphics.Color`）、图片资源、Font资源等。

## 3.4 高级内容

### 3.4.1 系统托盘

### 3.4.2 利用Region构造不规则窗口

### 3.4.3 SWT中使用Swing

# 4.使用基本控件与对话框

未完待续，具体说明见《Eclipse插件开发学习笔记》

## 4.1 Button

## 4.2 Label

## 4.3 Text

## 4.4 List

## 4.5 Combo

Combo控件由一个文本框和一个列表组合而成。

<img src="/images/wiki/EclipsePluginDev/Combo.png" width="700" alt="Combo控件">

## 4.6 Toolbar和ToolItem

## 4.7 Menu和MenuItem

## 4.8 CoolBar和CoolItem

## 4.9 TabFolder和TabItem

* **TabFolder**

  <img src="/images/wiki/EclipsePluginDev/tabfolder.png" width="700" alt="tabfolder控件">

## 4.10 对话框

# 5.容器与布局管理器

未完待续，具体说明见《Eclipse插件开发学习笔记》

## 5.1 Composite

Composite容器是SWT控件体系中最基础的容器类型，是其他所有容器类型的父类。Composite设计思想来自于设计模式中的[组合模式（Composite Pattern）](http://neyzoter.cn/wiki/DesignPattern/)。一个Composite容器中可以包含任意多的基本控件或子容器控件，父容器像处理基本控件一样对子容器发送各种消息。

不过Composite容器和基本控件一样，需要一个父控件，比如在Shell（父控件）中创建一个有边框的Composte。如下所示，

<img src="/images/wiki/EclipsePluginDev/Shell_Constains_Composite.png" width="700" alt="有边框的Composite">

## 5.2 Group

Group容器是Composite容器的子类，直接继承自Composite容器，为包含在其中的控件提供了默认的边框，并且可以支持在边框左上方显示一行文字表弟。

<img src="/images/wiki/EclipsePluginDev/Group_Create.png" width="700" alt="Group控件创建">

## 5.3 Shell

无论是Composite和Group，都创建在一个父容器里面，而Shell是一个不需要父容器的顶层容器。

## 5.4 容器上下文菜单设置

容器上下文菜单（Context Menu）是指在容器上单击鼠标右键时弹出的菜单，包含于当前位置最相关的操作选项。

## 5.5 容器颜色、背景和鼠标指针设置

和基本控件一样，对容器的背景色的设置是通过setBackgroud函数完成的，而setBackgroudImage将一张图片设置为容器的背景。

## 5.6 布局管理概述

布局管理（Layout Management）负责在容器的尺寸发生变化时，按照布局重新设置其中的子控件的位置和尺寸。

# 6.界面开发工具

未完待续，具体说明见《Eclipse插件开发学习笔记》

## 6.1 安装Visual Editor

Visual Editor是一种可视化界面设计工具。

## 6.2 使用Visual Editor



## 6.3 其他工具介绍

# 7.高级控件使用

未完待续，具体说明见《Eclipse插件开发学习笔记》

## 7.1 列表、表格和树

列表、表格和树等高级控件显示复杂的结构化数据类型。JFace为高级控件提供了查看器（Viewer），简化使用高级控件，主要包括JFace列表查看器、JFace表格查看器、JFace树查看器等。

## 7.2 文本编辑器

StyledText控件实现了为不同的文字使用不同的属性的功能，而Text控件无法做到。

## 7.3 滚动条、Scrollable、ScrolledComposite和滑动条

## 7.4 进度条与进度指示器

进度条可以用来动态显示工作进度，进度条无法接受用户键盘或者鼠标的输入。

进度指示器（ProgressIndication）是JFace以ProgressBar为基础编写的控件，克服了进度条控件的一些缺陷，如创建以后无法改变状态等，并重新包装了接口。

## 7.5 浏览器与OLE

SWT中使用浏览器较为简单，浏览器实现了OLE技术。OLE（Object Linking & Embedding，对象链接与嵌入）是微软制定的一种用于创建符合文档的协议，任何遵循该协议的程序所产生的对象都可以被别的对象包含，并在需要的时候调用原来的程序激活。如在一片word文档中嵌入了一个Excel表格，在双击该表格时，可以打开Excel程序编辑它。

# 8.SWT/JFace的事件处理

未完待续，具体说明见《Eclipse插件开发学习笔记》

## 8.1SWT的事件处理

SWT的事件监听采用了观察者的设计模式（Observer Pattern）。
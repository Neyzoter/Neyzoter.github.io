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

SWT 的API包括【布局类、组件类、事件类和图形类】（具体说明见[《Eclipse插件开发》](https://pan.baidu.com/s/1nKCw2EyOBFlNe3MDMpZyMw)  提取码：z8k3）。

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

Composite容器是SWT控件体系中最基础的容器类型，是其他所有容器类型的父类。Composite设计思想来自于设计模式中的[组合模式（Composite Pattern）](http://neyzoter.cn/wiki/DesignPattern/#226-%E7%BB%84%E5%90%88%E6%A8%A1%E5%BC%8Fcomposite--pattern)。一个Composite容器中可以包含任意多的基本控件或子容器控件，父容器像处理基本控件一样对子容器发送各种消息。

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

SWT的事件监听采用了[观察者的设计模式（Observer Pattern）](http://neyzoter.cn/wiki/DesignPattern/#232-观察者模式observe-pattern)。事件发送者声明监听器接口，对事件感兴趣的各方实现此接口并将监听器注册到事件的发送者上。

<img src="/images/wiki/EclipsePluginDev/Observe_Process.png" width="700" alt="Observer模式类图">

SWT中，Listerner接口扮演了观察者接口的角色，而所有窗口组件的父类——Widget类则是事件源。

## 8.2 常用事件

### 8.2.1 鼠标事件

当用户在某个控件的范围内操作鼠标（移动鼠标指针、单击按键等）时，就会产生鼠标事件，它的上下文是通过MouseEvent类传递到监听器的。

### 8.2.2 键盘事件

当用户按键盘时，处于活动状态的组件会接收到一个键盘事件。

### 8.2.3 Paint事件

当控件需要被重新绘制时，会送出该事件。

### 8.2.4 应用案例

## 8.3 JFace事件处理

### 8.3.1 操作（Action）与贡献（Contribution）

操作是JFace在SWT在事件监听框架基础上，对UI操作方法做出的更高一层的封装。使用操作，可以将一系列用户自定义的命令封装成一个对象。JFace将一系列用户自定义的命令封装成一个对象，开发者可以将操作关联到界面的一个或者多个组件上，当用户操作其中某个组件时，操作中所包含的命令就会被执行。

直接监听SWT事件和使用操作的对比：

<img src="/images/wiki/EclipsePluginDev/Direction_Listen_and_Point_Listen.png" width="700" alt="直接监听SWT事件和使用操作的对比">

操作中除了封装用户操作外，还包含它本身应该如何显示在界面上的信息，如图像、文字、工具提示等，贡献负责将操作和具体的SWT组件（ToolItem、MenuItem等）关联起来。

贡献分为两部分，贡献项目（ContributionItem）和贡献管理器（ContributionManager）。贡献项目关联着操作，而贡献管理器则包装了工具栏、菜单等可以放置操作的控件。当开发者讲一个贡献项目添加到贡献管理器上时，贡献管理器会从贡献项目中取出对应的操作的显示信息，并生成一个新的组件（工具栏按钮、菜单项等）显示在界面上。以下为贡献管理器、贡献项目和操作之间的互动：

<img src="/images/wiki/EclipsePluginDev/ContributionItemAndManager.png" width="700" alt="贡献项目和贡献管理器">

1.将操作关联到贡献项目；

2.将贡献项目添加到贡献管理器；

3.贡献管理器从贡献项目取得图标、文字等显示信息（贡献项目会从关联的操作上取得这些信息），然后创建新的组件来代表这个操作；

4.用户单击贡献项目做对应的组件时，贡献项目会负责执行相关联的操作。

### 8.3.2 创建操作

* **IAction**

  所有JFace操作都要实现`org.eclipse.jface.action.IAction`接口（**Artop使用**），这个接口规定了操作需要实现的一般方法，如运行用户操作、提供图片、文字信息等。

  <img src="/images/wiki/EclipsePluginDev/Action_Inherit.png" width="700" alt="操作的继承结构">

  上图的自上层时接口`org.eclipse.jface.action.IAction`，这是所有操作都必须实现的。在JFace其他部分使用到操作时，也会使用该接口。IAction中声明了getText、getImageDescription、getDescription等用于提供界面显示内容的方法，也声明了run、runWithEvent等**用于执行操作中包含的用户命令**的方法。

* **Action**

  上图另外一个比较重要的类是`org.eclipse.jface.action.Action`，这个抽象类是JFace提供的标准实现，其实现了IAction所有的方法。如果没有特殊需求，开发者可以直接继承Action并重载run方法来实现自己的操作。

  实例：

  ````java
  public class MyAction extends Action(){
      public static String ID = "MyAction";
      //构造函数
      public MyAction(){
          super();
          setId(ID);
          //下面3个函数设置各种用于显示的内容
          setText("My Action");
          setToolTipText("My Action Tooltip"); // 运行时控制台输出
          setImageDescriptor(ImageDescriptor.createFromFile(this.getClass(),"toolbar1.gif")); // 写字板的图标
      }
  }
  ````

  ### 8.3.3 使用贡献

  本节概述如何使用贡献框架完成一些常用的任务，如生成工具栏按钮、生成菜单项等。

  ```java
  ToolBarManager toolBarMgr = new ToolBarManager(toolBar);
  // 将MyAction操作添加到组件
  toolBarMgr.add(new MyAction());
  toolBarMgr.update(true); // 让刚添加的操作显示出来
  ```

  使用MenuManager管理窗口菜单见《Eclipse插件开发》。

# 9.Eclipse插件体系结构

## 9.1 Eclipse体系结构

Eclipse通过拓展点来拓展功能。

### 9.1.1 Eclipse平台架构

Eclipse围绕插件概念构建，见下图

<img src="/images/wiki/EclipsePluginDev/Eclipse_Framework.png" width="700" alt="Eclipse体系结构">

其中中间为Eclipse的平台部分，平台的子系统除了很小的核心外，都由插件构成，具体为：

* **运行时**（Runtime）——运行时定义了插件的结构，负责在Eclipse运行时发现和管理插件。

* **工作空间**（Workspace）——工作空间定义了Eclipse的工作区，用来分配和跟踪资源。

* **标准窗口小部件工具箱**（SWT）——一个UI窗口小部件通用库，能生成本地化风格的用户交互界面组件，但是拥有独立于操作系统的API。

* **JFace**——建立在SWT之上，提供对常用UI任务的支持。

* **工作台**（Workbench）——工作台定义了Eclipse的UI聚合体，提供包括编辑器、视图、透视图等界面组成部分。

* **小组**（Team）——“小组”插件为Eclipse中集成各种类型的源代码控制管理系统（如CVS、Subversion）

  > CVS是一个C/S系统，是一个常用的代码版本控制软件。主要在开源软件管理中使用。与它相类似的代码版本控制软件有subversion。多个开发人员通过一个中心版本控制系统来记录文件版本，从而达到保证文件同步的目的。CVS版本控制系统是一种GNU软件包，主要用于在多人开发环境下的源码的维护。但是由于之前CVS编码的问题，现在大多数软件开发公司都使用SVN替代了CVS。

* **帮助**——“帮助”插件为开发者编写帮助文档提供帮助。

* **Java开发工具**（JDT）——JDT提供对Java程序的编辑、编译、调试、调试功能，实现功能完整的Java开发环境。

* **插件开发环境**（PDE）——PDE提供自动创建、处理、调试和部署插件的工具。

  Eclipse 平台和JDT、PDE构成了Eclipse的三层结构，

  <img src="/images/wiki/EclipsePluginDev/Eclipse_JDT_PDE.png" width="700" alt="Eclipse的三层结构">

### 9.1.2 插件工作模式

Eclipse通过插件的依赖关系将不同的插件联系在一起。每个插件可以扮演双重角色，即其他插件服务的使用者和其他插件所需服务的提供者。以下是Eclipse UI插件的依赖关系，

<img src="/images/wiki/EclipsePluginDev/UI_Depandency.png" width="700" alt="UI插件的依赖关系">

Eclipse使用懒加载工作方式，只有运行时需要某依赖，才会将此依赖加入到内存。

### 9.1.3 工作层次结构

<img src="/images/wiki/EclipsePluginDev/Eclipse_Workbench.png" width="700" alt="Eclipse工作台层次结构及其对应界面元素">

## 9.2 插件加载过程

插件加载过程分为：插件安装、插件查找和插件启动。

### 9.2.1 插件安装

插件被Eclipse安装的条件：

（1）插件必须有一个唯一的标识符，Eclipse以此识别此插件；

（2）插件包含*.jar文件（有一个继承AbstractUIPlugin的插件类）、清单文件以及所需的资源

插件安装推荐方式：

* **方式1.通过文件系统手动安装插件**

  1）创建`location/new-extension`的位置来存储插件。

  <img src="/images/wiki/EclipsePluginDev/Plugin_Install_Dir.png" width="700" alt="Eclipse插件安装目录">

  在`.eclipseextension`文件中输入如下内容，（version为Eclipse的版本）

  ```
  id=org.eclipse.platform name=Eclipse Platform
  version=4.10.0
  ```

  2）Eclipse查找插件

  `Help -> Software Update -> Manage Configuration -> Product Configuration -> Eclipse SDK` （老版本，新版本有所不同）

* **方式2.采用链接的形式安装插件**

  如果在文件系统中已经有了产品拓展，例如已经使用上述方法创建了拓展，就可以在Eclipse程序目录中创建一些简单的文件，告知Eclipse需要检查这些目录以寻找相应的插件。

  在Eclipse安装文件夹中创建一个名为links的目录。在这个目录中，创建`*.link`文件（例如myPlugins.link）。每个链接文件都指向一个产品拓展位置。Eclipse会在启动时扫描这个文件夹，并在每个链接文件所指向的产品拓展中寻找插件。

  <img src="/images/wiki/EclipsePluginDev/plugin_link.png" width="500" alt="link方式安装目录布局">

  link内容实例：

  ```
  path=D:/location/new-plugins/ve
  ```

* **方式3.将插件（包括fetures和plugins）的内容拷贝至Eclipse安装目录下的features和plugins**

  重启Eclipse即可找到插件。

### 9.2.2 插件的发现和启动

自Eclipse3.1以后，支持插件的机制通过OSGi（Open Service Gateway Initiative）框架实现。当Eclipse第一次启动时，Eclipse**运行时**（Runtime）会遍历plugins文件夹中的目录，扫描每个插件的清单文件信息，并且建立一个内部模型来记录它所找到的每个插件的信息。此时未运行任何代码，因而插件未启动。只有当插件中的start()方法被调用后，插件才真正启动起来。

### 9.2.3 插件信息的获取

每个捆绑软件都有一个象征标识符（Symbolic Name），这个象征标识符便是插件的唯一标识。不论插件是否启动，都可以通过`Platform.getBundle(symbolicName)`来获取捆绑软件对象(`org.osgi.framework.Bundle`)。当插件启动后，插件的信息由内存中的捆绑软件上下文管理。如果安装了兼容软件，使当前Eclipse版本同先前版本兼容，便可以使用原来的`Platform.getPlugin(pluginID)`来获得插件实例(`org.eclipse.core.runtime.Plugin`)。

Bundle提供了获取插件的信息的方法：

具体见《Eclipse插件开发》

## 9.3 插件的拓展模式

**宿主插件**（host plug-in）：提供拓展点的插件；

**拓展者插件**（extender plug-in）：使用拓展点的插件；

**回调对象**（call-back object）：实现宿主插件和拓展者插件的通信。

### 9.3.1 拓展和拓展点

> 重点！对照artop例程的plugin.xml

下图中，拓展者插件`org.eclipse.search`在宿主插件`org.eclipse.ui`中拓展了一个动作集（actionSets）。

<img src="/images/wiki/EclipsePluginDev/host_plugin_extender_plugin.png" width="700" alt="link方式安装目录布局">

通过拓展UI插件声明的actionSets拓展点实现。运行Eclipse，选择“搜索”`->`“搜索”按钮之后，出现了下图效果。

<img src="/images/wiki/EclipsePluginDev/Search_Apparence.png" width="700" alt="搜索对话框">

拓展改变了宿主插件的某些行为，包括为宿主插件增加处理元素和为这些处理元素定制相应的动作。上例中，`org.eclipse.search`插件为`org.eclipse.ui`插件增加了两个菜单项，即“搜索”`->`“搜索”和“搜索”`->`“文件”，并且定制了相应的行为，`OpenFileSearchPageAction`和`OpenSearchDialogAction`。拓展者插件和宿主插件通过这两个菜单项通信。

Eclipse中，每个插件都有一个相应的`plugin.xml`清单文件与其相对应。它们在其中声明了该插件的所有拓展和拓展点。下面两段代码是与上面例子相对应的清单。

```xml
<plugin>
    <!--工作台拓展点-->
    <!--忽略一些代码-->
    
    <!--1.定义拓展点id：actionSets，不是完整标识，要拓展该拓展点，必须在前面加入其所在插件的ID   org.eclipse.ui.actionSets-->
    <extension-point id="actionSets" name="%ExtPoint.actionSets" schema="schema/actionSets.exsd"/>
    <!-- .....  -->
</plugin>
```

声明拓展清单中的每个XML元素和它们的属性都是在Schema中定义的，不同的拓展点这些元素和属性都可能不同。

```xml
<!-- 动作集 -->
<!--2.在声明拓展的时候使用了拓展的完整id-->
<extension point="org.eclipse.ui.actionSets">
    <actionSet 
               id="org.eclipse.search.searchActionSet"
               label="%search"
               visible="true">
        <!--搜索菜单-->
        <menu
              id="org.eclipse.search.menu"
              label="%searchMenu.label"
              path="navigate">
            <groupMarker name="internalDialogGroup"/>
            <separator name="fileSearchContextMenuActionGroup"/>
            <!--跳过一些代码-->
        </menu>
        <!--会话组-->
        <!--跳过一些代码-->
        <!--3.定义操作action，声明了OpenSearchDialogAction类（4），该类便是回调对象，回调对象类由拓展者插件定义，当用户第一次使用“搜索”->“搜索”菜单项时，由宿主插件创建实例-->
        <action id="org.eclipse.search.OpenSearchDialog"
                definitionId="org.eclipse.search.ui.openSearchDialog"
                toolbarPath="Normal/Search"
                menubarPath="org.eclipse.search.menu/internalDialogGroup"
                label="%openSearchDialogAction.label"
                tooltip="%openSearchDialogAction.tooltip"
                icon="%nl$/icons/full/etool16/search.gif"
                helpContextId="open_search_dialog_action_context"
                class="org.eclipse.search.internal.ui.OpenSearchDialogAction"/><!--4.声明了OpenSearchDialogAction类-->
    </actionSet>
</extension>
```

### 9.3.2 拓展加载过程

* 1.从Eclipse平台取得拓展点
* 2.取得已在此拓展点上注册的拓展
* 3.取出以XML方式声明的配置元素
* 4.根据每个配置元素的属性值创建回调对象
* 5.处理创建的对象

### 9.3.3 常用拓展点

[更多拓展点](https://help.eclipse.org/2018-12/index.jsp)通过输入`org.eclipse.ui.`搜索。

查看以下内容可参考如下图，

<img src="/images/wiki/EclipsePluginDev/Eclipse_Workbench.png" width="700" alt="Eclipse工作台层次结构及其对应界面元素">

**1.org.eclipse.ui.views**

拓展点`org.eclipse.ui.views`允许插件将**视图**添加到工作台中。添加视图的插件必须在plugin.xml中注册该视图，并提供有关该视图的配置信息，例如，它的实现类、它所属的视图的类别（或组）以及应该用来在菜单和标签中描述该视图的名称和图标。

**2.org.eclipse.ui.editors**

插件使用工作台拓展点`org.eclipse.ui.editors`将**编辑器**添加到工作台。添加编辑器的插件必须在他们的plugin.xml文件中注册编辑器拓展即编辑器的配置信息。

**3.org.eclipse.ui.popupMenus**

`org.eclipse.ui.popupMenus`（**弹出式菜单**）拓展点允许插件添加到其他视图和编辑器的上下文菜单。可以利用操作的标识将操作添加到特定上下文菜单（viewerContribution），或者通过将操作与特定对象类型进行关联来添加操作（objectContribution）。

**4.org.eclipse.ui.action.Sets**

插件可以使用`org.eclipse.ui.actionSets`（动作集）拓展点向工作台菜单和工具栏添加菜单、菜单项和工具栏项。为了减少同时显示每个插件的菜单添加项而导致的混乱，可将添加项分成多个**操作集**，通过用户首选项来使这些操作集可视。

**5.org.eclipse.ui.viewActions**

如果插件要**为工作台中已经存在的视图添加行为**，可以通过`org.eclipse.ui.viewActions`拓展点来完成。此拓展点允许插件为现有视图的本地下拉菜单和本地工具栏添加菜单项、紫菜当和工具栏条目。

**6.org.eclipse.ui.editorAcitons**

当编辑器活动时，`org.eclipse.ui.editorActions`拓展点允许向工作台菜单和工具栏做添加条目。

>Eclipse 提供了两种扩展点供用户添加菜单项到相应的位置。这两种扩展点为 org.eclipse.ui.commands（本文简称为 Commands 方式）和 org.eclipse.ui.actionSets（本文简称为 Actions 方式）。Actions 方式为界面上不同区域的表现方式提供了相应的扩展点，并且没有分离其界面表现和内在实现。恰恰相反，Commands 方式通过三步有效的达到界面表现和内部实现的分离：首先，通过 org.eclipse.ui.commands 扩展点创建命令和类别（Category），并且可以把某些命令放在一个类别（Category）中；然后，通过 org.eclipse.ui.menus 指定命令出现在界面的哪个区域（视图菜单 / 主菜单 / 上下文菜单）；最后通过 org.eclipse.ui.handlers 指定命令的实现。因此，Eclipse 推荐新开发的插件使用 Commands 来创建您的界面菜单。当然，由于 Actions 在现有的插件中用得比较多，如果我们需要扩展或基于之前的插件开发，也需要对其进行了解。除此之外，针对上下文菜单，虽然 Commands 和 Actions 方式均可以创建上下文菜单，但是 Eclipse 还提供了另外一种创建上下文菜单的扩展点 org.eclipse.ui.popupMenus（本文简称为 popupMenus 方式），本文将就这三种扩展点做详细的介绍。

# 10.开发第一个插件项目

## 10.1 创建插件工程

1.`File->New->Plug-in Project`

<img src="/images/wiki/EclipsePluginDev/createNewPluginProj.png" width="500" alt="创建新plugin工程">

2.输入项目名称——`com.nescar.examples.helloworld`，并设置Target Platform基于Eclipse还是OSGi框架。

<img src="/images/wiki/EclipsePluginDev/setProjName_setTargetPlatform.png" width="500" alt="设置项目名称和TargetPlatform">

Target Platform选项选择插件运行的框架——Eclipse、Equinox和standard。

Eclipse框架是指使用了Eclipse拓展注册表（IExtensionRegistry，本文第9章）的插件。IExtensionRegistry是在Eclipse平台的运行时层提供的，因而大部分的Eclipse插件都会使用此框架。如果不希望依赖Eclipse平台的运行时层，就要使用OSGi框架。

3.设置content

控制插件生命周期的插件类为激活器（Activator），该激活器会根据是否选择“此插件将对UI进行添加”复选框而继承自不同的类。如果选择`Generate an activator...`选框，则激活器类（插件类）将拓展`org.eclipse.ui.plugin.AbstractUIPlugin`类来对插件项目的生命周期进行管理。

* 如果该插件不对UI进行添加，则激活器类拓展`org.eclipse.ui.plugin.AbstractUIPlugin`类来对插件项目的生命周期进行管理。
* 如果“插件项目”*（第2步中的图）页OSGi框架，激活器则会实现`org.eclipse.core.runtime.Plugin`类对插件项目的生命周期进行管理。

`Rich Client Application`可以选择否，后期可以添加。

<img src="/images/wiki/EclipsePluginDev/setContent.png" width="800" alt="设置content">

4.选择模板

选择Hello World Command模板。

5.运行查看效果

点击打开文件`MENIFEST.MF`，点击`Launch an Eclipse application`运行。

<img src="/images/wiki/EclipsePluginDev/RunHelloworld.png" width="800" alt="运行">

运行效果如下：
1.菜单栏效果

<img src="/images/wiki/EclipsePluginDev/HelloWorld_Appearance.png" width="800" alt="运行查看效果">

2.工具栏效果

<img src="/images/wiki/EclipsePluginDev/HelloWorld_Appearance_toolbar.png" width="800" alt="运行查看效果">

[实例代码和解析地址](https://github.com/NESCAR/eclipse_plugin_dev_examples_song)

## 10.2 “插件开发”透视图

完成项目创建后，进入“插件开发”透视图（Perspective）。

### 10.2.1 PDE视图

`Windows->Open Pespective->Other..`，而后选择PDE类别，看到插件视图和插件依赖项视图两个视图。

<img src="/images/wiki/EclipsePluginDev/Perspective_Other.png" width="800" alt="打开透视图">

### 10.2.2 PDE运行时视图

### 10.2.3 清单编辑器

PDE提供了一个基于表单的多页插件清单编辑器。打开本插件的地址，可以看到清单编辑器包括概述页（Overview）、依赖性页（Dependencies）、运行时页（Runtime）、拓展页（Extensions）、拓展点页（Extension Point）、构建页（Build）、MANIFEST.MF、plugin.xml和build.properties，后面三个是特定的文本编辑器。

概述页是快速进入其他各个页面的通道。

<img src="/images/wiki/EclipsePluginDev/Overview_Intro.png" width="800" alt="Overview介绍">

## 10.3 插件工程结构

* **源代码部分**——Java源代码，包括动作（action）、操作（handler）
* **插件文件**
  * plugin.xml：插件清单文件，**在此处进行贡献和操作的关联**
  * MANIFEST.MF：OSGi捆绑软件清单文件
  * build.properties文件
  * 所依赖的系统库：JRE库和插件依赖项

* **其他资源**

## 10.4 插件文件

### 10.4.1 plugin.xml文件

plugin.xml用于记录插件的拓展点和拓展的。下图是plugin.xml的可视化编辑界面，

<img src="/images/wiki/EclipsePluginDev/plugin.xml_view.png" width="800" alt="plugin.xml介绍">

### 10.4.2 MANIFEST.MF文件

MANIFEST.MF文件用于提供关于捆绑软件的描述信息，对应于Overview页的信息，如General Information、Excution Environment等，其还通过变量`Require-Bundle`决定依赖插件，如

```yaml
Require-Bundle: org.eclipse.ui,
 org.eclipse.core.runtime
```

通过`Bundle-ActivationPolicy`来指定懒加载机制，如

```yaml
Bundle-ActivationPolicy: lazy
```



### 10.4.3 build.properties文件

 build.properties文件计略需要构建的元素列表，PDE可以通过这个文件来构建插件，并且在最终构建的插件中不需要再包含这个文件。

```properties
# 源目录
source.. = src/
# 输出目录
output.. = bin/
# bin文件夹所包含的目录
## 可以看到最终没有build.properties文件了
bin.includes = plugin.xml,\
               META-INF/,\
               .,\
               icons/
```

## 10.5 插件类

```java
// Activator
package com.nescar.examples.helloworld;

import org.eclipse.jface.resource.ImageDescriptor;
import org.eclipse.ui.plugin.AbstractUIPlugin;
import org.osgi.framework.BundleContext;

/**
 * The activator class controls the plug-in life cycle
 * @author Neyzoter Song
 * @date 2019/9/11
 */
public class Activator extends AbstractUIPlugin {

	// The plug-in ID
	/**
	 * 插件类声明一个静态字段，用于引用这个唯一的实例——插件标识
	 */
	public static final String PLUGIN_ID = "com.nescar.examples.helloworld"; //$NON-NLS-1$

	// The shared instance
	private static Activator plugin;
	
	/**
	 * The constructor
	 */
	public Activator() {
	}

	/**
	 * 启动插件时调用start
	 */
	@Override
	public void start(BundleContext context) throws Exception {
		super.start(context);
		plugin = this;
	}

	/**
	 * 卸载插件时调用stop
	 */
	@Override
	public void stop(BundleContext context) throws Exception {
		plugin = null;
		super.stop(context);
	}

	/**
	 * Returns the shared instance
	 * 获得该插件实例
	 *
	 * @return the shared instance
	 */
	public static Activator getDefault() {
		return plugin;
	}

	/**
	 * Returns an image descriptor for the image file at the given
	 * plug-in relative path
	 * 获得插件中图像的描述符，依据此标识符可以使用图像资源，例如在本地址插件
	 * 中使用此插件中icons目录下的sample.gif图标
	 * eg. AbstractUIPlugin.getImageDescriptor(icon.sample.gif).createImage();
	 * @param path the path
	 * @return the image descriptor
	 */
	public static ImageDescriptor getImageDescriptor(String path) {
		return imageDescriptorFromPlugin(PLUGIN_ID, path);
	}
}

```

## 10.6 运行插件程序

在工具栏单击“Run”菜单，选择“Run Configuration...”来进行“Create, manage, and run configurations”的设置Eclipse Application。

<img src="/images/wiki/EclipsePluginDev/Create_manage_run_config.png" width="800" alt="Create, manage, and run configurations设置">

## 10.7 调试插件

根据情况适当设置断点，设置断点只需在Java编辑器页面中需要调试的代码左侧双击鼠标。

在工具栏的虫子图标可以开启调试。

## 10.8 发布插件

使用PDE所提供的“Export”即可实现。

`File->Export`，然后选择“可部署的插件和段”。

<img src="/images/wiki/EclipsePluginDev/Plugin_Export.png" width="800" alt="插件导出">

然后设置目录，

<img src="/images/wiki/EclipsePluginDev/Export_Set.png" width="800" alt="导出目录">

将产生的.jar文件放入Eclipse程序的plugin文件夹中，重启Eclipse程序，地址本插件就包含在其中了。

## 10.9 发布RCP工程

### 10.9.1 创建工程时即设置为RCP

在创建工程时，可以设置为RCP工程

<img src="/images/wiki/EclipsePluginDev/export_product.png" width="800" alt="导出product">

设置，

<img src="/images/wiki/EclipsePluginDev/Export_RCP.png" width="800" alt="设置输出的product">

### 10.9.2 将插件改造成RCP

见《Eclipse插件开发》第20.4节。

# 11.操作（Actions）

## 11.1 Eclipse的操作概览

操作在Eclipse IDE出现的所有位置：

<img src="/images/wiki/EclipsePluginDev/Eclipse_IDE_Actions.png" width="800" alt="Eclipse IDE的Action位置">

（1）工具栏

（2）视图工具栏

（3）对象上下文菜单

（4）编辑器上下文菜单

（5）视图上下文菜单

（6）菜单栏

（7）视图下拉菜单

## 11.2 添加工作台窗口操作

### 11.2.1 使用模板创建拓展

[本项目连接](https://github.com/NESCAR/eclipse_plugin_dev_examples_song/tree/master/com.nescar.examples.actions)

打开“地址本”插件清单编辑器（plugin.xml文件），选择“拓展”页，在“拓展”选项卡中单击“新建”，在弹出的上下文菜单中选择“新建”`->`“拓展”命令来打开“新建拓展”向导，比如出创建一个`org.eclipse.ui.munus`的拓展点。

* 创建和设置command

  首先，通过 `org.eclipse.ui.commands` 扩展点创建命令和类别（Category），并且可以把某些命令放在一个类别（Category）中。

  <img src="/images/wiki/EclipsePluginDev/createCommand.png" width="800" alt="创建command">

  设置，name表示菜单项的名称。

  <img src="/images/wiki/EclipsePluginDev/setCommand.png" width="500" alt="创建command">

  **Command将菜单项添加到主菜单及其工具栏上。**

* 创建和设置Handler

  在`org.eclipse.ui.handlers`拓展点创建handler，然后在`Extention Element Details`中定义commandId和class，commandId是**要引用的**（即上面的）command的ID号，可以根据指向的类名取；class表示指向（使用）的一个类，此类（继承了抽象类AbstractHandler）中包含方法。

  <img src="/images/wiki/EclipsePluginDev/createAndSetHandler.png" width="800" alt="创建和设置Handler">

* 创建和设置key

  在`org.eclipse.ui.bindings`拓展点中创建`key`，

  <img src="/images/wiki/EclipsePluginDev/createAndSetKey.png" width="800" alt="创建和设置Key">

* 在`org.eclipse.ui.menus`这一拓展点下创建贡献（contribution）

  我们也可以把菜单项添加到已经存在的菜单当中，例如添加一个菜单项到 Eclipse 的 Search 主菜单当中，其 locationURI 为：

  `menu:org.eclipse.search.menu?dialogGroup`

  也可以设置一个新的菜单。

  <img src="/images/wiki/EclipsePluginDev/createMenuContribution.png" width="500" alt="MenuContribution创建">

* 创建和设置贡献内的menu

  此项对应Eclipse菜单栏的项目

  创建，

  <img src="/images/wiki/EclipsePluginDev/createMenu.png" width="800" alt="Menu创建">

  设置，其中label对应Eclipse菜单栏的项目名称，

  <img src="/images/wiki/EclipsePluginDev/NescInfo.png" width="800" alt="Menu设置">

* 创建和设置贡献内的command

  在menu中创建command。

  设置，其中commandId引用对应的command。

  <img src="/images/wiki/EclipsePluginDev/setContributionCommand.png" width="500" alt="设置贡献内的command">

* 效果图

  图中，Nesc Information菜单的名称为menu的label，Nesc Info Command菜单项（Nesc Information菜单的项目）的名称为command的name。

  <img src="/images/wiki/EclipsePluginDev/apperance.png" width="200" alt="效果图1">

  <img src="/images/wiki/EclipsePluginDev/apperance2.png" width="450" alt="效果图2">


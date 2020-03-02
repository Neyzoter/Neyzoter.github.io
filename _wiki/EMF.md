---
layout: wiki
title: EMF
categories: Eclipse
description: Eclipse Modeling Framework
keywords: Eclipse, EMF
---

# 1.EMF介绍

EMF是一种强大的架构和代码生成工具，可用于创建基于简单模型定义的Java应用程序。为了使建模对于主流Java编程人员实际有用，EMF统一了3种重要技术：Java、XML和UML。使用UML建模工具或者XML Schema定义模型，甚至在Java接口上指定简单的批注也能定义模型。开发人员只编写描述模型的抽象接口的子集，系统将自动生成并合并剩余代码。

*EMF和UML的区别？*

完整的UML支持更宽泛的建模范围，例如UML允许模仿应用程序的行为和它的类结构。

## 1.1 定义模型

* **元模型**

  用来表示模型的模型称为Ecore（元模型）。下面是一个元模型的简化子集：

  <img src="/images/wiki/EMF/ECore_Arch.png" width="600" alt="一个抽象的元模型简化子集">

  下面4个ECore类，都是元模型：

  *EClass*：用来表示建模类，有名称、0个或者多个属性、0个或者多个引用。EClass还可以作为下面的一些元模型的模型，比如EAttribute的模型是EClass，那么EClass就是元元模型。而EClass本身是也是一个元模型。

  *EAttribute*：用来表示模型属性

  *EReference*：用来表示类之间关联的一端

  *EDataType*：用来表示属性的类型

  下面是一个采购订单实例：

  <img src="/images/wiki/EMF/ecore_instance.png" width="600" alt="ecore实例">

  | 等级     | 实例                                                         | 备注                                    |
  | -------- | ------------------------------------------------------------ | --------------------------------------- |
  | 元元模型 | EClass                                                       | 生成了EAttribute、EReference、EDataType |
  | 元模型   | EClass（PurchaseOrder）、EAttribute（shipTo）、EAttribute（billTo）、EReference（items） |                                         |

* **创建和编辑模型**

  * 从Java接口开始

    EMF内省它们，并构建Ecore模型

  * 从XML Schema开始

    据其构建模型

  * 从UML开始

    （1）直接Ecore编辑：EMF简单的结构树的ECore样本编辑器；Ecore Tools项目提供基于UML符号的图形Ecore编辑器；第三方如Topcased（Ecore Editor）、Omondo（EclipseUML）、Soyatec（eUML）。

    （2）从UML导入

    （3）从UML导出

* **XMI串行化（Serialization）**

  将对象存储到介质（如文件、内存缓冲区等）中或是以二进制方式通过网络传输。Java代码、XML Schema和UML包含的附加信息超过了从Ecore模型中捕获的信息，在使用EMF的所有情况下都不需要这些形式。Ecore的直接串行化，**不会添加任何额外信息**。而XMI能够满足这种要求，简化了XML串行化元数据的标准。

* **Java标注**

  使用Java接口定义Ecore模型，通过使用`@model`注释显式标记，来将方法作为模型定义的一部分如：

  ```java
  /**
   * @model
   */
  public interface PurchaseOrder{
      /*
       * @model
       */
      String getShipTo();
      /*
       * @model
       */
      String getBilTo();
      /*
       * @model type="Item" containment="true"
       */
      List getItems();
  }
  ```

  PurchaseOrder包括两个属性、一个引用，引用是多重-多值引用（List），所以需要将引用的目标类型指定为`type="Item"`。并通过指定`containment="true"`来表示希望采购订单成为项目的容器。

* **小结**

  （1）Ecore及其XMI串行化是EMF的核心

  （2）至少可以从3个来源创建Ecore模型：UML、XML、**注释**Java接口。

  （3）Java实现代码或者模型的其他形式可以从Ecore模型生成。

# 2.技术


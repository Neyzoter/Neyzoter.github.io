---
layout: wiki
title: Design Pattern
categories: Design Pattern
description: 设计模式笔记
keywords: 设计模式
---

# 1、设计模式简介

# 2、设计模式类型

## 2.1 单例模式（Singleton Pattern）

确保某一个类只有一个实例，而且自行实例化并向整个系统提供这个实例。

```java
public class Singleton {
    private static final Singleton singleton = new Singleton(); //限制产生多个对象
    private Singleton(){
    }
    //通过该方法获得实例对象
    public static Singleton getSingleton(){
    	return singleton;
    }
    //类中其他方法，尽量是 static
    public static void doSomething(){
    }
}
```

**使用场景**

● 要求生成唯一序列号的环境；

● 在整个项目中需要一个共享访问点或共享数据，例如一个 Web 页面上的计数 器，可以不用把每次刷新都记录到数据库中，使用单例模式保持计数器的值，并确 保是线程安全的；

● 创建一个对象需要消耗的资源过多，如要访问 IO 和数据库等资源；

● 需要定义大量的静态常量和静态方法（如工具类）的环境，可以采用单例模式 （当然，也可以直接声明为 static 的方式）。

## 2.2 工厂模式

定义一个用于创建对象的接口，让子类决定实例化哪一个类。工厂方法使一个类 的实例化延迟到其子类。

具体的工厂模式代码如下，product 为抽象产品类负责定义产品的共性，实现对事物最抽象的定义； Creator 为抽象创建类，也就是抽象工厂，具体如何创建产品类是由具体的实现工 厂 ConcreteCreator 完成的。

```java
public class ConcreteCreator extends Creator {
    public T createProduct(Class c){
        Product product=null;
        try {
            //通过Class.forname产生一个新的对象
            product =(Product)Class.forName(c.getName()).newInstance();
        } catch (Exception e) {
            //异常处理
        }
        return (T)product;
    }
}
```

**简单工厂模式**

一个模块仅需要一个工厂类，没有必要把它产生出来，使用静态的方法

**多个工厂类**

每个人种（具体的产品类）都对应了一个创建者，每个创建者独立负责创建对应的 产品对象，非常符合单一职责原则

**代替单例模式**

单例模式的核心要求就是在内存中只有一个对象，通过工厂方法模式也可以只在内 存中生产一个对象

**延迟初始化**

ProductFactory 负责产品类对象的创建工作，并且通过prMap变量产生一个缓存，对需要再次被重用的对象保留

**使用场景**

jdbc 连接数据库，硬件访问，降低对象的产生和销毁

## 2.3 抽象工厂模式

为创建一组相关或相互依赖的对象提供一个接口，而且无须指定它们的具体类

```java
public abstract class AbstractCreator {
	//创建 A 产品家族
	public abstract AbstractProductA createProductA(); 
    //创建 B 产品家族
	public abstract AbstractProductB createProductB(); 
}
```

**使用场景**

一个对象族（或是一组没有任何关系的对象）都有相同的约束。 涉及不同操作系统的时候，都可以考虑使用抽象工厂模式

## 2.4 模板方法模式（Template Method Pattern）

定义一个操作中的算法的框架，而将一些步骤延迟到子类中。使得子类可以不改变一个算法的结构即可重定义 该算法的某些特定步骤

### 2.4.1 抽象模板

AbstractClass 叫做抽象模板，分为具体方法和模板方法，

**具体方法**

基本方法也叫做基本操作，是由子类实现的方法，并且在模板方法被调用。

**模板方法**

可以有一个或几个，一般是一个具体方法，也就是一个框架，实现对基本方法的调度，完成固定的逻辑。

*注意*：为了防止恶意的操作，一般模板方法都加上 final 关键字，不允许被覆写。

### 2.4.2 具体模板

ConcreteClass1 和ConcreteClass2 属于具体模板，实现父类所定义的 一个或多个抽象方法，也就是父类定义的基本方法在子类中得以实现

**使用场景**

● 多个子类有公有的方法，并且逻辑基本相同时。

● 重要、复杂的算法，可以把核心算法设计为模板方法，周边的相关细节功能则由 各个子类实现。

● 重构时，模板方法模式是一个经常使用的模式，把相同的代码抽取到父类中，然 后通过钩子函数（见“模板方法模式的扩展”）约束其行为

## 2.5 MVC模式

MVC：Model（模型）、View（视图）和Controller（控制）

1）最上面的一层，是直接面向最终用户的"视图层"（View）。它是提供给用户的操作界面，是程序的外壳。

2）最底下的一层，是核心的"数据层"（Model），也就是程序需要操作的数据或信息。

3）中间的一层，就是"控制层"（Controller），它负责根据用户从"视图层"输入的指令，选取"数据层"中的数据，然后对其进行相应的操作，产生最终结果。
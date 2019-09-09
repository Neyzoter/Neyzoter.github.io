---
layout: wiki
title: Design Pattern
categories: Design Pattern
description: 设计模式笔记
keywords: 设计模式
---

# 1、设计模式简介

```
Gang of Four
(
GoF
)
```

的分类将设计模式分类为 23 种经典的模式，根据用途我们又可以分为三大类，分别为创建型模式、结构型模式和行为型模式。

**重要的设计模式**

1.面向接口编程，而不是面向实现。这个很重要，也是优雅的、可扩展的代码的第一步，这就不需要多说了吧。

2.职责单一原则。每个类都应该只有一个单一的功能，并且该功能应该由这个类完全封装起来。

3.对修改关闭，对扩展开放。对修改关闭是说，我们辛辛苦苦加班写出来的代码，该实现的功能和该修复的 bug 都完成了，别人可不能说改就改；对扩展开放就比较好理解了，也就是说在我们写好的代码基础上，很容易实现扩展。

# 2、设计模式类型

## 2.1 创建者模式

### 2.1.1 简单工厂模式

### 2.1.2 工厂模式

### 2.1.3 抽象工厂模式

### 2.1.4 单例模式（Singleton Pattern）

**介绍**

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

### 2.1.5建造者模式

### 2.1.6 原型模式

### 2.1.7 创建型模式总结

## 2.2 结构性模式

### 2.2.1 代理模式

### 2.2.2 适配器模式

### 2.2.3 桥梁模式

### 2.2.4 装饰模式

### 2.2.5 门面模式

### 2.2.6 组合模式（Composite  Pattern）

**介绍**

组合模式用于表示具有层次结构的数据，使得我们对单个对象和组合对象的访问具有一致性。例如，

每个员工都有姓名、部门、薪水这些属性，同时还有下属员工集合（虽然可能集合为空），而下属员工和自己的结构是一样的，也有姓名、部门这些属性，同时也有他们的下属员工集合。

```java
public class Employee {
   private String name;
   private String dept;
   private int salary;
   private List<Employee> subordinates; // 下属，有可能是空的，即没有下属

   public Employee(String name,String dept, int sal) {
      this.name = name;
      this.dept = dept;
      this.salary = sal;
      subordinates = new ArrayList<Employee>();
   }

   public void add(Employee e) {
      subordinates.add(e);
   }

   public void remove(Employee e) {
      subordinates.remove(e);
   }

   public List<Employee> getSubordinates(){
     return subordinates;
   }

   public String toString(){
      return ("Employee :[ Name : " + name + ", dept : " + dept + ", salary :" + salary+" ]");
   }   
}
```

**应用场景**

●Eclipse界面开发SWT的容器父类，可以包含任意多的基本控件或者子容器控件。

### 2.2.7 享元模式

### 2.2.8 结构性模式总结

## 2.3 行为型模式

### 2.3.1 策略模式

### 2.3.2 观察者模式（Observe Pattern）

**介绍**

观察者模式包括两个操作

* 观察者订阅自己关心的主题
* 主题有数据变化后通知观察者

实现过程如下：

*1.定义主题，每个主题持有观察者列表的引用，用在数据变更的时候通知各个观察者*

```java
// 主题
public class Subject {
	// 观察者列表
    // Observer是一个接口，可以在此处存入多个Observer接口的应用类
   private List<Observer> observers = new ArrayList<Observer>();
   private int state;

   public int getState() {
      return state;
   }

   public void setState(int state) {
      this.state = state;
      // 数据已变更，通知观察者们
      notifyAllObservers();
   }

   public void attach(Observer observer){
      observers.add(observer);        
   }

   // 通知观察者们
   public void notifyAllObservers(){
      for (Observer observer : observers) {
         observer.update();
      }
   }     
}
```

*2.定义观察者接口*

```java
public abstract class Observer {
   protected Subject subject;
   public abstract void update();
}
```

其实如果只有一个观察者类的话，接口都不用定义了，不过，通常场景下，既然用到了观察者模式，我们就是希望一个事件出来了，会有多个不同的类需要处理相应的信息。比如，订单修改成功事件，我们希望发短信的类得到通知、发邮件的类得到通知、处理物流信息的类得到通知等。

*3.定义观察者类*

下面定义2个观察者

```java
// Binary观察者
public class BinaryObserver extends Observer {
      // 在构造方法中进行订阅主题
    public BinaryObserver(Subject subject) {
        this.subject = subject;
        // 通常在构造方法中将 this 发布出去的操作一定要小心
        this.subject.attach(this);
    }
      // 该方法由主题类在数据变更的时候进行调用
    @Override
    public void update() {
        String result = Integer.toBinaryString(subject.getState());
        System.out.println("订阅的数据发生变化，新的数据处理为二进制值为：" + result);
    }
}
// Hexa观察者
public class HexaObserver extends Observer {

    public HexaObserver(Subject subject) {
        this.subject = subject;
        this.subject.attach(this);
    }

    @Override
    public void update() {
          String result = Integer.toHexString(subject.getState()).toUpperCase();
        System.out.println("订阅的数据发生变化，新的数据处理为十六进制值为：" + result);
    }
}

```



### 2.3.3 责任链模式

### 2.3.4 模板方法模式

### 2.3.5 状态模式

### 2.3.6 行为型模式总结



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
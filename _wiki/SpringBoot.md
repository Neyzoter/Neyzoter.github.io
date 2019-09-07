---
layout: wiki
title: SpringBoot
categories: SpringBoot
description: SpringBoot使用方法
keywords: SpringBoot
---

# 1、SpringBoot介绍



# 2、Spring注解

## 2.1 概述

- @Component
- @Service
- @Scope
- @Repository
- @Controller
- @RestController
- @RequestMapping
- @PathVariable
- @ResponseBody
- @ComponentScan

## 2.2 声明Bean的注解

*如何吸引Spring容器的注意而“有幸”成为Spring 容器管理的Bean呢？* 
在Spring Boot中就依靠注解，Spring提供了多个注解来声明Bean为Spring容器管理的Bean，注解不同代表的含义不同，但是对Spring容器来说都是Spring管理的Bean

- @Component 没有明确角色的组件

- @Service 在业务逻辑层（Service层）使用

  Bean通过注解@Service声明为一个Spring容器管理的Bean,Spring容器会扫描classpath路径下的所有类，找到带有@Service注解的Impl类,并根据Spring注解对其进行初始化和增强

- @Repositpry 在数据访问层（dao层）使用

- @Controller 用于标注控制层组件

- @RestController

  

## 2.3 注册bean的方法

类：`@configuration`

方法：`@bean`

* 定义配置类

`@Configuration`注解类，`@bean`注解方法，等价于xml中配置beans

```java
package SpringStudy;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import SpringStudy.Model.Counter;
import SpringStudy.Model.Piano;
 
@Configuration
public class SpringConfig {
 
	@Bean
	public Piano piano(){
		return new Piano();
	}
	@Bean(name = "counter1") //name即xml中配置的id
	public Counter counter(){
		return  new Counter(12,"Shake it Off",piano());
	}
    @Bean(name = "counter2") //name即xml中配置的id
	public Counter counter(){
		return  new Counter(20,"Shake it Off",piano());
	}
}

```

* 基础类代码

```java
package SpringStudy.Model;
public class Counter {
	public  Counter() {
	}
	public  Counter(double multiplier, String song,Instrument instrument) {
		this.multiplier = multiplier;
		this.song = song;
		this.instrument=instrument;
	}
	private double multiplier;
	private String song;
	@Resource
	private Instrument instrument;
	public double getMultiplier() {
		return multiplier;
	}
	public void setMultiplier(double multiplier) {
		this.multiplier = multiplier;
	}
	public String getSong() {
		return song;
	}
	public void setSong(String song) {
		this.song = song;
	}
	public Instrument getInstrument() {
		return instrument;
	}
	public void setInstrument(Instrument instrument) {
		this.instrument = instrument;
	}
}
```

```java
package SpringStudy.Model;
public class Piano {
	private String name="Piano";
	private String sound;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getSound() {
		return sound;
	}
	public void setSound(String sound) {
		this.sound = sound;
	}
}
```

* 调用

```java
package webMyBatis;
 
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import SpringStudy.Model.Counter;
 
public class SpringTest {
	public static void main(String[] args) {
		//ApplicationContext ctx = new ClassPathXmlApplicationContext("spring/bean.xml");// 读取bean.xml中的内容
		ApplicationContext annotationContext = new AnnotationConfigApplicationContext("SpringStudy");
		Counter c = annotationContext.getBean("counter1", Counter.class);// 创建bean的引用对象counter1
		System.out.println(c.getMultiplier());
		System.out.println(c.isEquals());
		System.out.println(c.getSong());
	        System.out.println(c.getInstrument().getName());
	}
}
```

## 2.4 自动配置dataSource

以一个测试类为例

```java
@RunWith(SpringRunner.class)
//自动配置dataSource不然会出现运行错误
@EnableAutoConfiguration(exclude={DataSourceAutoConfiguration.class})
@SpringBootTest
public class RedisApplicationTest {
    @Test
    public void contextLoads() {
        System.out.println("hello web");
    }
}
```

## 2.5 @SpringBootApplication

等同于```@Configuration```, ```@EnableAutoConfiguration``` and ```@ComponentScan```，同时使用。

可以在后面定义一些参数，如

```java
//自动配置dataSource
@SpringBootApplication(exclude={DataSourceAutoConfiguration.class})
```



## 2.6 @Autowired



### 2.6.1 Setter方法中的@Autowired

@Autowired 注释可以在 setter 方法中被用于自动连接 bean

```java
//TextEditor.java 
package com.tutorialspoint;
import org.springframework.beans.factory.annotation.Autowired;
public class TextEditor {
   private SpellChecker spellChecker;
    //自动连接bean   SpellChecker
   @Autowired
   public void setSpellChecker( SpellChecker spellChecker ){
      this.spellChecker = spellChecker;
   }
   public SpellChecker getSpellChecker( ) {
      return spellChecker;
   }
   public void spellCheck() {
      spellChecker.checkSpelling();
   }
}
```

```java
//SpellChecker.java
package com.tutorialspoint;
public class SpellChecker {
   public SpellChecker(){
      System.out.println("Inside SpellChecker constructor." );
   }
   public void checkSpelling(){
      System.out.println("Inside checkSpelling." );
   }  
}
```

```java
// MainApp.java
package com.tutorialspoint;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
public class MainApp {
   public static void main(String[] args) {
      ApplicationContext context = new ClassPathXmlApplicationContext("Beans.xml");
      TextEditor te = (TextEditor) context.getBean("textEditor");
      te.spellCheck();
   }
}
```

```xml
<!--Bean.xml-->

<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
    http://www.springframework.org/schema/context
    http://www.springframework.org/schema/context/spring-context-3.0.xsd">

   <context:annotation-config/>

   <!-- Definition for textEditor bean without constructor-arg  -->
   <bean id="textEditor" class="com.tutorialspoint.TextEditor">
   </bean>

   <!-- Definition for spellChecker bean -->
   <bean id="spellChecker" class="com.tutorialspoint.SpellChecker">
   </bean>

</beans>
```

### 2.6.2 属性中的@Autowired

在属性中使用@Autowired来免除setter方法

```java
//TextEditor.java
package com.tutorialspoint;
import org.springframework.beans.factory.annotation.Autowired;
public class TextEditor {
    //直接给spellChecker一个bean
   @Autowired
   private SpellChecker spellChecker;
   public TextEditor() {
      System.out.println("Inside TextEditor constructor." );
   }  
   public SpellChecker getSpellChecker( ){
      return spellChecker;
   }  
   public void spellCheck(){
      spellChecker.checkSpelling();
   }
}
```

### 2.6.3 构造函数中的@Autowired

可以在构造函数中使用 @Autowired。一个构造函数 @Autowired 说明当创建 bean 时，即使在 XML 文件中没有使用 元素配置 bean ，构造函数也会被自动连接。

```java
// TextEditor.java
package com.tutorialspoint;
import org.springframework.beans.factory.annotation.Autowired;
public class TextEditor {
   private SpellChecker spellChecker;
   @Autowired
   public TextEditor(SpellChecker spellChecker){
      System.out.println("Inside TextEditor constructor." );
      this.spellChecker = spellChecker;
   }
   public void spellCheck(){
      spellChecker.checkSpelling();
   }
}
```

### 2.6.4 关于@Autowired的问题

* **如何处理多个符合的Bean**

  @Autowired默认是按照byType进行注入的，但是当byType方式找到了多个符合的bean，又是怎么处理的？Autowired默认先按byType，如果发现找到多个bean，则又按照byName方式比对。

## 2.7 @SpringBootApplication



## 2.8 @RestController

声明一个REST规则的controller。

## 2.9 @ComponentScan

对Application类添加@ComponentScan来指定扫描的包，但是一旦指定后，就不会再默认扫描Application类下的包

**补充**：Bean要放在Application类目录之下，不然无法扫描到，进而无法依赖注入

## 2.10 @Scheduled

Springboot可以通过@EnableScheduling（写在Application类前面），来使能Bean对象（可通过@Component实现）的周期性调度任务@Scheduled。

```java
@Component("taskJob")
public class Taskjobs {
    private final static Logger logger = LoggerFactory.getLogger(Taskjobs.class);
    @Scheduled(cron="10/5 * * * * ?")
    public void sendKafkaMsg(){
        try{
            logger.info("Starting send msg");
        }catch (Exception e){
            logger.error("",e);
        }
    }
}
```

https://docs.spring.io/spring-data/jpa/docs/current/reference/html/)

## 2.11 @RequestBody和@RequestParam

@RequestBody从http的body中获取数据；@RequestParam从http的参数中获取数据。
---
layout: wiki
title: SpringBoot
categories: SpringBoot
description: SpringBoot使用方法
keywords: SpringBoot
---

# 1、SpringBoot介绍



# 2、SpringBoot注解

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

## 2.2 声明Bean的注解

*如何吸引Spring容器的注意而“有幸”成为Spring 容器管理的Bean呢？* 
在Spring Boot中就依靠注解，Spring提供了多个注解来声明Bean为Spring容器管理的Bean，注解不同代表的含义不同，但是对Spring容器来说都是Spring管理的Bean

- @Component 没有明确角色的组件
- @Service 在业务逻辑层（Service层）使用
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


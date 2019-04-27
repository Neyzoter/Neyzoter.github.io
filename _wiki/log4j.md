---
layout: wiki
title: Log4j
categories: Log4j
description: Log4j学习笔记
keywords: Log4j,日志管理
---

# 1、Log4j安装
## 1.1 Log4j介绍

可以使用log4j将信息记录到各种目的地，例如发送电子邮件，数据库或文件。

有一个我们需要放到classpath的库的列表，以便log4j可以拿起它并使用它。

例如，当从log4j发出电子邮件时，我们需要电子邮件库jar文件。

库是可选的，并且取决于我们将要与log4j框架一起使用的功能。

- **JavaMail API(mail.jar):** 从https://glassfish.dev.java.net/javaee5/mail/用于基于电子邮件的日志记录。
- **JavaBeans Activation Framework(activation.jar):** 来自http://java.sun.com/products/javabeans/jaf/index.jsp。
- **Java Message Service:** 用于JMS和JNDI。
- **XML Parser(Xerces.jar):** 来自http://xerces.apache.org/xerces-j/install.html。

## 1.2 Log4j安装

建立一个Maven项目，然后在`pom.xml`添加依赖

```xml
<dependency>
    <groupId>log4j</groupId>
    <artifactId>log4j</artifactId>
    <version>1.2.17</version>
</dependency>
```

~~对于Java Web应用程序，将`log4j.properties`文件存储在`WEB-INF/classes`目录下；~~其他项目`resources`文件夹下创建的`log4j.properties`，下面是`log4j.properties`的位置。

```
MyTest
 |
 +-src
    |
    +-main
       |
       +-java
       |  |
       |  +-com
       |    |
       |    +-w3cschool
       |       |
       |       +-ide
       |
       +-resources
       |  |
       |  +- log4j.properties  
       |
       +-webapp
          |
          +- WEN-INF
             |
             +- classes
```

具体`log4j.properties`内容：

```properties
# Root logger option
log4j.rootLogger=DEBUG, stdout, file
 
# 将log信息指向控制台
log4j.appender.stdout=org.apache.log4j.ConsoleAppender
log4j.appender.stdout.Target=System.out
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss} %-5p %c{1}:%L - %m%n
 
# 将log信息指向一个文件
log4j.appender.file=org.apache.log4j.RollingFileAppender
## 具体的文件及其地址
log4j.appender.file.File=./log4j.log  
log4j.appender.file.MaxFileSize=5MB
log4j.appender.file.MaxBackupIndex=10
log4j.appender.file.layout=org.apache.log4j.PatternLayout
log4j.appender.file.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss} %-5p %c{1}:%L - %m%n
```

最后一个`%m%n `配置`log4j`以添加换行符。

`％L`设置从记录请求的行号。

`％c{1}`引用通过` getLogger()`设置的日志记录名称。

`％-5p`设置日志记录优先级，如DEBUG或ERROR。

## 1.3 使用实例

```java
package com.w3cschool.ide;
import org.apache.log4j.Logger;
public class App{
  final static Logger logger = Logger.getLogger(App.class);
  public static void main(String[] args) {
    App obj = new App();
    obj.runMe("w3cschool");
  }
  private void runMe(String parameter){
    if(logger.isDebugEnabled()){
      logger.debug("This is debug : " + parameter);
    }
    if(logger.isInfoEnabled()){
      logger.info("This is info : " + parameter);
    }
    logger.warn("This is warn : " + parameter);
    logger.error("This is error : " + parameter);
    logger.fatal("This is fatal : " + parameter);
  }
}
```

>**ERROR** 为严重错误 主要是程序的错误
>**WARN** 为一般警告，比如session丢失
>**INFO** 为一般要显示的信息，比如登录登出
>**DEBUG** 为程序的调试信息

**代码显示如何记录异常**

```java
import org.apache.log4j.Logger;
public class App {
  final static Logger logger = Logger.getLogger(App.class);
  public static void main(String[] args) {
    App obj = new App();
    try {
      obj.divide();
    } catch (ArithmeticException ex) {
      logger.error("Sorry, something wrong!", ex);
    }
  }
  private void divide() {
    int i = 10 / 0;
  }
}
```

**`Logger.getLogger(App.class)`需要输入一个类，用于跟踪输出该日志的对象**

# 2、Log4j配置

## 2.1 log4j.properties语法

X是一个appender的名称，配置语法如下，

```properties
# 根记录器的级别设置为DEBUG，并将名称为X的附加器附加到它
log4j.rootLogger = DEBUG, X

# 将log信息指向一个文件
log4j.appender.X=org.apache.log4j.FileAppender
# log4j支持UNIX风格的变量替换，如${variableName}
log4j.appender.X.File=${log}/log.out

# Define the layout for X appender
log4j.appender.X.layout=org.apache.log4j.PatternLayout
log4j.appender.X.layout.conversionPattern=%m%n
```

# X、日志级别

| 级别  | 描述                                         |
| ----- | -------------------------------------------- |
| ALL   | 所有级别包括自定义级别。                     |
| DEBUG | 调试消息日志。                               |
| ERROR | 错误消息日志，**应用程序可以继续运行**。     |
| FATAL | 严重错误消息日志，必须**中止运行应用程序**。 |
| INFO  | 信息消息。                                   |
| OFF   | 最高可能的排名，旨在关闭日志记录。           |
| TRACE | 高于DEBUG。                                  |
| WARN  | 用于警告消息。                               |




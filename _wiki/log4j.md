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

# 3、Log4j日志级别

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

**级别顺序**

`ALL < DEBUG < INFO < WARN < ERROR < FATAL < OFF`

**可以通过设置控制级别来控制是否输出优先级低的日志**

**例子（使用java代码设置控制级别）**

```java
import org.apache.log4j.*;

public class Main {
   private static org.apache.log4j.Logger log = Logger
                                    .getLogger(Main.class);
   public static void main(String[] args) {
       //设置控制机别
      log.setLevel(Level.WARN);

      log.trace("Trace Message!");
      log.debug("Debug Message!");
      log.info("Info Message!");
      log.warn("Warn Message!");
      log.error("Error Message!");
      log.fatal("Fatal Message!");
   }
}
```

**输出**

```
Warn Message!
Error Message!
Fatal Message!
```

**例子2（使用log4j的properties设置控制级别）**

通过配置文件执行log.setLevel（Level.WARN），具体设置代码为`log4j.rootLogger = WARN, FILE`。

```properties
# Define the root logger with appender file
log = c:/log4j
log4j.rootLogger = WARN, FILE

# Define the file appender
log4j.appender.FILE=org.apache.log4j.FileAppender
log4j.appender.FILE.File=${log}/log.out

# Define the layout for file appender
log4j.appender.FILE.layout=org.apache.log4j.PatternLayout
log4j.appender.FILE.layout.conversionPattern=%m%n
```

# 4、Log4j日志格式

布局类层次结构中的顶级类是抽象类org.apache.log4j.Layout，包括子类DateLayout、HTMLLayout、PatternLayout、SimpleLayout、XMLLayout。

**布局类的方法**

| 方法                                              | 描述                         |
| ------------------------------------------------- | ---------------------------- |
| public abstract boolean ignoresThrowable()        | 如果忽略Throwable对象。      |
| public abstract String format(LoggingEvent event) | 实现此方法以进行格式化布局。 |
| public String getContentType()                    | 返回布局对象使用的内容类型。 |
| public String getFooter()                         | 记录消息的页脚信息。         |
| public String getHeader()                         | 日志消息的头信息。           |

# 5、Log4j日志到文件

| 属性           | 描述                                               |
| -------------- | -------------------------------------------------- |
| immediateFlush | 默认值为true。刷新每个追加操作的消息。             |
| encoding       | 更改字符编码。默认为平台特定的编码方案。           |
| threshold      | 此附加器的阈值级别。                               |
| Filename       | 日志文件的名称。                                   |
| fileAppend     | 默认为true。将日志记录信息附加到同一文件的结尾。   |
| bufferedIO     | 是否缓冲写入。默认为false。                        |
| bufferSize     | 如果启用了缓冲I/O，请设置缓冲区大小。默认值为8kb。 |

**例子**

```properties
# Define the root logger with appender file
## 级别低于DEBUG的日志不会打印
log4j.rootLogger = DEBUG, FILE

# Define the file appender
log4j.appender.FILE=org.apache.log4j.FileAppender
# file name
log4j.appender.FILE.File=${log}/log.out 

# Set the flush to true
log4j.appender.FILE.ImmediateFlush=true

# Set the threshold to debug mode
log4j.appender.FILE.Threshold=debug

# Set the append to true, overwrite
log4j.appender.FILE.Append=true

# Define the layout for file appender
log4j.appender.FILE.layout=org.apache.log4j.PatternLayout
log4j.appender.FILE.layout.conversionPattern=%m%n
```

**登录多个文件**

我们可能希望将消息记录到多个文件中，例如，如果文件大小达到某个阈值，我们希望将消息记录到一个新文件。

要将信息记录到多个文件中，请使用org.apache.log4j.RollingFileAppender类，该类扩展了FileAppender类并继承其所有属性。

| 描述           | 描述                                      |
| -------------- | ----------------------------------------- |
| maxFileSize    | 将滚动文件的文件的最大大小。 默认值为10MB |
| maxBackupIndex | 设置要创建的备份文件数。默认值为1。       |

```properties
# Define the root logger with appender file
log4j.rootLogger = DEBUG, FILE

# Define the file appender
log4j.appender.FILE=org.apache.log4j.RollingFileAppender
# file name
log4j.appender.FILE.File=${log}/log.out

# Set the maximum file size before rollover
log4j.appender.FILE.MaxFileSize=5KB

# Set the the backup index
log4j.appender.FILE.MaxBackupIndex=2

log4j.appender.FILE.layout=org.apache.log4j.PatternLayout
log4j.appender.FILE.layout.ConversionPattern = %d{yyyy-MM-dd HH:mm:ss} %-5p %c{1}:%L - %m%n
```

**每日日志文件**

要每天生成日志文件，请使用org.apache.log4j.DailyRollingFileAppender类扩展FileAppender类。

| 描述        | 描述                                                         |
| ----------- | ------------------------------------------------------------ |
| DatePattern | 指示何时滚动文件，以及要遵循的命名约定。默认情况下每天午夜滚动。 |

DatePattern支持的模式

| DatePattern          | 描述                             |
| -------------------- | -------------------------------- |
| '.' yyyy-MM          | 每月结束时滚动。                 |
| '.' yyyy-MM-dd       | 在每天的中午和午夜滚动。         |
| '.' yyyy-MM-dd-a     | 默认值。每天午夜滚动。           |
| '.' yyyy-MM-dd-HH    | 滚动在每个小时的顶部。           |
| '.' yyyy-MM-dd-HH-mm | 每分钟滚动一次。                 |
| '.' yyyy-ww          | 根据区域设置，每周的第一天滚动。 |

每天的中午和午夜翻转的例子：

```properties
# Define the root logger with appender file
log4j.rootLogger = DEBUG, FILE

# Define the file appender
log4j.appender.FILE=org.apache.log4j.DailyRollingFileAppender
# Set the name of the file
log4j.appender.FILE.File=${log}/log.out

# Set the DatePattern
log4j.appender.FILE.DatePattern="." yyyy-MM-dd-a

log4j.appender.FILE.layout=org.apache.log4j.PatternLayout
log4j.appender.FILE.layout.ConversionPattern = %d{yyyy-MM-dd HH:mm:ss} %-5p %c{1}:%L - %m%n
```

# 6、Log4j日志到数据库

使用log4j API通过使用org.apache.log4j.jdbc.JDBCAppender对象将信息记录到数据库中。

| 属性       | 描述                                                 |
| ---------- | ---------------------------------------------------- |
| bufferSize | 设置缓冲区大小。默认大小为1。                        |
| driver     | JDBC驱动程序类。默认为sun.jdbc.odbc.JdbcOdbcDriver。 |
| layout     | 设置布局。默认是org.apache.log4j.PatternLayout。     |
| password   | 设置数据库密码。                                     |
| sql        | 指定用于每个日志记录请求的SQL语句。                  |
| URL        | 设置JDBC URL                                         |
| user       | 设置数据库用户名                                     |

**例子**

首先，创建一个表来存储日志信息。

```sql
CREATE TABLE LOGS
   (USER_ID VARCHAR(20) NOT NULL,
    DATED   DATE NOT NULL,
    LOGGER  VARCHAR(50) NOT NULL,
    LEVEL   VARCHAR(10) NOT NULL,
    MESSAGE VARCHAR(1000) NOT NULL
   );
```

然后，为JDBCAppender创建配置文件log4j.properties，该文件控制如何连接到数据库以及如何将日志消息存储到LOGS表。

```properties
# Define the root logger with appender file
log4j.rootLogger = DEBUG, DB

# Define the DB appender
log4j.appender.DB=org.apache.log4j.jdbc.JDBCAppender

# Set JDBC URL
log4j.appender.DB.URL=jdbc:mysql://localhost/Your_Database_Name

# Set Database Driver
log4j.appender.DB.driver=com.mysql.jdbc.Driver

# Set database user name and password
log4j.appender.DB.user=your_user_name
log4j.appender.DB.password=your_password

# Set the SQL statement to be executed.
log4j.appender.DB.sql=INSERT INTO LOGS 
                      VALUES("%x","%d","%C","%p","%m")

# Define the layout for file appender
log4j.appender.DB.layout=org.apache.log4j.PatternLayout
```

java代码

```java
import org.apache.log4j.Logger;
import java.sql.*;
import java.io.*;
import java.util.*;

public class Main{
  static Logger log = Logger.getLogger(Main.class.getName());
  public static void main(String[] args)
                throws IOException,SQLException{
     log.debug("Debug");
     log.info("Info");
  }
}
```


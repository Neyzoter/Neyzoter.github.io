---
layout: wiki
title: Book
categories: Book
description: 读书笔记
keywords: Book, Note
---

> 本笔记只记录重点，完整内容见原书。

# 1.卓有成效的程序员

本书提出方法，提高程序员的工作效率。

## 1.1 自动化法则

* **建立本地缓存**

  ```bash
  wget --mirror -w 2 --html-extension --convert-links -P /home/scc/example/
  ```

  | 参数               | 作用                           |
  | ------------------ | ------------------------------ |
  | `--mirror`(`-m`)   | 给网站建立本地镜像             |
  | `-w`(`--wait`)     | 重新尝试的间隔秒               |
  | `--html-extension` | 把文件拓展名改为html           |
  | `--convert-links`  | 把页面上所有的链接转为本地链接 |
  | `-P`               | 保存网站镜像的本地目录         |

* **自动访问网站**

  ```bash
  curl "www.neyzoter.cn/app/query?date=2020&num=10"
  # 通过POST来和资源交互
  curl -d "date=2020&num=10" www.neyzoter.cn/app/query
  ```

  | 参数           | 作用           |
  | -------------- | -------------- |
  | `-d`(`--data`) | HTTP POST data |

* **在构建之外使用Ant**

  Ant可以实现打包前，将无关文件清理掉。

  ```xml
  <!--clean-all 方法-->
  <target name="clean-all" depends="init">
  	<delete verbose="true" includeEmptyDirs="true">
      	<fileset dir="${clean.dir}">
          	<include name ="**/*.war" />
              <include name ="**/*.ear" />
              <include name ="**/*.jar" />
              <containsregexp expression=".*~$"/>
          </fileset>
      </delete>
      <delete verbose="true" includeEmptyDirs="true">
          <fileset dir="${clean.dir}" defaultexcludes="no">
          	<patternset refid="generated-dirs" />
          </fileset>
      </delete>
  </target>
  ```

  打包

  ```xml
  <!--打包样例，需要依赖clean-all-->
  <target name="zip-samples" depends="clean-all">
  	<delete file="${class-zip-name}" />
      <echo message="You file name is ${class-zip-name}" />
      <zip destfile="${class-zip-name}.zip" basedir="." compress="true"
           excludes="*.xml,*.zip,*.cmd" />
  </target>
  ```

* **用Rake执行常见任务**

  Rake是Ruby的make工具，能够与操作系统轻松交互，比如可以使用Rake快速打开几个文件。

* **使用Selenium浏览网页**

  Selenium是一个开源的测试工具，用于Web应用程序的用户验收测试。Selenium借助JS自动化了浏览器操作，从而可以模拟用户的行为。Selenium IDE是一个FireFox的插件，可以记录浏览器操作，不需要测试人员每次都要进行重复的操作。

* **使用bash统计异常数**

  ```bash
  #!/bin/bash
  # 遍历所有ERROR，排序，消除重复
  for X in $(egrep -o "[A-Z]\w*Exception" log.txt | sort | uniq);
  do
  	# 异常输出到控制台上
  	echo -n -e "$X "
  	# 统计个数
  	grep -c "$X" log.txt
  done
  ```

* **别给牦牛剪毛**

  别让自动化的努力变成剪牦牛毛——指的是如果在写自动化脚本的时候，发现了很多其他无关的问题，比如版本不兼容、驱动有问题等，需要尽快抽身，而不是不停解决以上无关的问题。

## 1.2 哲学

* **事物本质性质和附属性质（亚力士多德）**

  本质复杂性是指要解决问题的核心，而附属复杂性是值在解决核心问题时，可能需要附属解决的问题。比如为了分析某个数据库数据，需要连接数据库并导出数据，导出数据的过程即为附属性质而分析数据库才是本质性质。很多组织会在附属性质上花费比本质性质更多的时间和精力。

  所以，**去除本质复杂性，也要去除附属复杂性。**

* **奥卡姆剃刀原理**

  如果对于一个现象有多种解释，那么最简单的往往是最正确的。

  “80-10-10”准则（Dietzler定律）是指80%的客户需求可以很快完成，下一个10%需要花很大努力完成，而最后10%几乎不可能完成，因为不想将所有工具和框架都“招致麾下”。

  一些语言的诞生是为了让程序员摆脱一些麻烦，但随着时间推移，可能语言的功能越来越多，然而使得解决方案变得不正确（不符合奥卡姆剃刀原理）。

  所以，**适合的才是最好的，不要总是追求样样精通**。

* **笛米特法则**

  任何对象都不需要知道与之交互的那个对象的任何内部细节。

  比如，下面的方法是不合适的，

  ```java
  Job job = new Job("Safety Engineer", 5000.00);
  Person homer = new person("Homer", job);
  // 通过Person来获取Job，直接操作Job对象是不合适的
  homer.getJob().setPosition("Janitor");
  ```

  正确的做法应该是在Person类中定义可以更改Position的方法

  ```java
  // 正确的做法应该是在Person类中定义可以更改Position的方法
  homer.changeJobPositionTo("Janitor");
  ```

  

# 2. TCP-IP详解卷1：协议

## 第17章 TCP：传输控制协议

```
+------------------------+-------------------------------+-----------------------------+
|       IP首部            |              TCP首部           |        TCP数据              |
+------------------------+-------------------------------+-----------------------------+
       20 bytes                       20 bytes                                 
```

<img src="/images/wiki/Book/TCP_Head.png" width="500" alt="TCP首部">

* **TCP首部的6个标志比特**

  URG：紧急指针有效

  ACK：确认序号有效

  PSH：接收方应该尽快将这个报文段交给应用层

  RST：重建连接

  SYN：同步序号用来发起一个连接

  FIN：发端完成发送任务

## 第18章 TCP连接的建立与终止

以下是TCP的三次握手和四次挥手过程：

<img src="/images/wiki/Book/TCP_3Connect_4Disconnect.png" width="500" alt="TCP3次握手和4次挥手">

* **连接终止协议**

  终止连接需要4次握手，有TCP的半关闭（Half-Close）造成的。一个TCP连接是全双工（两个方向上同时传递），因此每个方向必须单独进行关闭。这一原则就是当一方完成它的数据发送任务后就能发送一个FIN来终止该方向的连接。当一端接受到一个FIN，它必须通知应用层另一端已经终止了那个方向的数据传输（也就是FIN的ack）。

  
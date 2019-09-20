---
layout: post
title: Springboot实现多个配置文件
categories: [Softwares, Backend]
description: 在IDEA编辑器上实现Springboot的web应用有选择性的使用别的配置文件
keywords: IDEA, Springboot, properties, modules
---

# 1.问题描述

在我们使用Springboot的时候，有时想：

* 在开发阶段和部署阶段使用不同的配置
* 一个底层module（如dal层）的配置被多个上层应用重复使用

如何实现呢？

# 2.实现

* 创建文件

  在顶层应用（一般为web，下图中为uop子模块），定义application.properties这一配置文件；在dal层定义application-NAME.properties这一配置文件，其中NAME后面需要使用，如取名为userMysql（文件名变为application-userMysql.properties），其中放MyBatis相关的配置信息。如，

  ```properties
  # MyBatis
  # mysql
  spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
  spring.datasource.url=jdbc:mysql://localhost:3306/User?useUnicode=true&characterEncoding=utf8
  spring.datasource.username=root
  spring.datasource.password=song
  
  mybatis.typeAliasesPackage=cn.neyzoter.aiot.dal.domain.user
  mybatis.mapperLocations=classpath:mapper/*.xml
  ```

  另外可以把mapper配置文件，放到mapper文件中。

  <img src="/images/posts/2019-9-20-IDEA-Spring-Application-With-Several-Properties/idea_modules.png" width="600" alt="idea工程" />

* 配置application.properties

  在application.properties中配置激活dal中的application-userMysql.properties，

  ```properties
  spring.profiles.active=userMysql
  ```

  **可以输入多个配置文件名，用逗号隔开，另外userMysql即application-userMysql.properties中的userMysql（NAME）**

此后，可以实现运行顶层应用（上图中的uop子模块），application.properties会激活dal模块中的application-userMysql.properties。




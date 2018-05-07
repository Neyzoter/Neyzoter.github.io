---
layout: wiki
title: MAVEN
categories: MAVEN
description: MAVEN的介绍和使用
keywords: MAVEN, Java
---


## pom.xml
POM 代表工程对象模型。它是使用 Maven 工作时的基本组建，是一个 xml 文件。它被放在工程根目录下，文件命名为 pom.xml。

## 生命周期

阶段|处理|描述
prepare-resources|资源拷贝|本阶段可以自定义需要拷贝的资源
compile|编译|本阶段完成源代码编译
package|打包|本阶段根据 pom.xml 中描述的打包配置创建 JAR / WAR 包
install|安装|本阶段在本地 / 远程仓库中安装工程包


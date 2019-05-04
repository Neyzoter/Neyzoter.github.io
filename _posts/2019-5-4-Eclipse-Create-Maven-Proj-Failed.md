---
layout: post
title: Eclipse创建Maven项目出现错误
categories: Softwares
description: Eclipse创建Maven项目出现错误
keywords: Java Web, Eclipse, Maven
---

> 原创

# 1、问题描述

在Eclipse下创建Maven项目时，出现了`Could not resolve archetype org.apache.maven.archetypes:maven-archetype-webapp:1.0 from any of the configured repositories.`的情况。

# 2、问题解决

## 2.1 网上的解决方法（对我的Eclipse没有用）

添加远程的Maven配置。

Window \-\> Preferences \-\> Maven \-\> Archetypes \-\> Add Remote Catalog

在`Catalog File`这一栏加入地址`http://repo1.maven.org/maven2/archetype-catalog.xml`，`Description`这一栏加入描述，用于和其他的配置区分，可以随便取，如"`Maven Catalogs`"。

然后，点击`Description`下面的`Verify`进行验证下载。

最后，在建立Maven项目时，选择'Archetype'时，选择Catalog为你所下载的配置，我这里是"`Maven Catalogs`"。

## 2.2 我的解决方法

Maven的镜像设置——需要给maven建立一个xml设置文件来设置一些参数，指向ali镜像。

```xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
            http://maven.apache.org/xsd/settings-1.0.0.xsd">
    
    <!-- 这个是配置阿里Maven镜像 -->
    <mirrors>
        <mirror>
          <id>aliyun</id>
          <name>aliyun</name>
          <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
          <mirrorOf>central</mirrorOf>
        </mirror>
    </mirrors>
    
    <profiles>
        <profile>
            <id>nexus</id>
            <repositories>
                <repository>
                    <id>central</id>
                    <url>http://repo.maven.apache.org/maven2</url>
                    <snapshots>
                        <enabled>false</enabled>
                    </snapshots>
                </repository>
                <repository>
                    <id>ansj-repo</id>
                    <name>ansj Repository</name>
                    <url>http://maven.nlpcn.org/</url>
                    <snapshots>
                        <enabled>false</enabled>
                    </snapshots>
                </repository>
            </repositories>
        </profile>
    </profiles>
 
    <activeProfiles>
        <activeProfile>nexus</activeProfile>
    </activeProfiles>
</settings>
```

**具体步骤：**

1、Window \-\> Preferences \-\> Maven \-\> User Setting

<img src="/images/posts/2019-5-4-Eclipse-Create-Maven-Proj-Failed/usersettings.png" width="600" alt="User Settings" />

2、创建`settings.xml`

在第一步的目录下，创建一个`setting.xml`。具体内容为本小姐的“Maven的镜像设置“。

3、`Update Settings`

在第一步的User Settings界面进行设置更新"`Update Settings`"。

4、正常进行Maven工程创建即可。

**问题分析**

上次电脑主板烧坏后，没有重新配置Maven，所以导致Maven的Archetype一直失败。
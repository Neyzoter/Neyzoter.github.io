---
layout: wiki
title: MAVEN
categories: MAVEN
description: MAVEN的介绍和使用
keywords: MAVEN, Java
---

# 1、Maven介绍
## pom.xml
POM 代表工程对象模型。它是使用 Maven 工作时的基本组建，是一个 xml 文件。它被放在工程根目录下，文件命名为 pom.xml。

## 生命周期
一个典型MAVEN工程的生命周期序列。

阶段|处理|描述
prepare-resources|资源拷贝|本阶段可以自定义需要拷贝的资源
compile|编译|本阶段完成源代码编译
package|打包|本阶段根据 pom.xml 中描述的打包配置创建 JAR / WAR 包
install|安装|本阶段在本地 / 远程仓库中安装工程包

# 2、Maven配置
## 安装本地jar包
1、安装

```
mvn install:install-file -Dfile=jar包的位置(参数一) -DgroupId=groupId(参数二) -DartifactId=artifactId(参数三) -Dversion=version(参数四) -Dpackaging=jar
```

eg.


```
mvn install:install-file -Dfile="/home/songchaochao/Dev/repository/mongo-java-drive-3.8.1.jar" -DgroupId=org.mongodb -DartifactId=mongo-java-drive -Dversion=3.8.1 -Dpackaging=jar
```

2、查看默认仓库中是否安装了MongoDB

如默认在/home/songchaochao/Dev/repository/，则是否有org/mongodb/...目录。

**设置默认仓库的方法**

maven安装包的setting.xml中加入

<localRepository>/home/songchaochao/Dev/repository</localRepository>

3、导入

如果本地没有的话，也可以通过这个pom.xml中的语句来安装jar包。

```xml
<dependencies>
    <dependency>
        <groupId>org.mongodb</groupId>
        <artifactId>mongodb-driver-sync</artifactId>
        <version>3.8.1</version>
    </dependency>
</dependencies>
```




## maven配置默认jdk

setting.xml中添加

```xml
<profile>    
    <id>jdk-1.8</id>    
     <activation>    
          <activeByDefault>true</activeByDefault>    
          <jdk>1.8</jdk>    
      </activation>    
<properties>    
<maven.compiler.source>1.8</maven.compiler.source>    
<maven.compiler.target>1.8</maven.compiler.target>    
<maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>    
</properties>    
</profile>
```

# 3、Maven使用
## Maven编译

到项目根目录下运行命令

```
mvn clean compile
```

## 添加jar库

在pom.xml中加入jar的信息

```xml
  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>3.8.1</version>
      <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>io.netty</groupId>
        <artifactId>netty-all</artifactId>
        <version>4.1.29.Final</version>
    </dependency>
  </dependencies>
```

## 打包和运行

* 打包

生成jar（target目录中），但是这个包只能被引用，不能运行。这个jar没有带有main方法的类信息。

```xml
mvn clean package  
```

1.如果想要运行还需要在pom.xml中配置maven-shade-plugin，添加main方法的类信息。

```xml
  <build>
  <plugins>
  <plugin>  
<groupId>org.apache.maven.plugins</groupId>  
  <artifactId>maven-shade-plugin</artifactId>  
  <version>1.2.1</version>  
  <executions>  
    <execution>  
      <phase>package</phase>  
      <goals>  
        <goal>shade</goal>  
      </goals>  
      <configuration>  
        <transformers>  
          <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">            <mainClass>com.nesc.NettyServer.App</mainClass>  
         </transformer>  
       </transformers>  
     </configuration>  
     </execution>  
  </executions>  
</plugin> 
</plugins>
</build>
```

"com.nesc.NettyServer.App"需要改成当前项目的住类索引。

2.`spring-boot`工程打包可运行`jar`，在需要操作的工程`pom.xml`中加入，

```xml
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <configuration>
                    <!-- 指定该Main Class为全局的唯一入口 -->
                    <mainClass>com.neyzoter.aiot.web.BootApplication</mainClass>
                    <layout>ZIP</layout>
                </configuration>
                <executions>
                    <execution>
                        <goals>
                            <goal>repackage</goal><!--可以把依赖的包都打包到生成的Jar包中-->
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
```

"com.neyzoter.aiot.web.BootApplication"需要改成当前项目的住类索引。

再次生成包，可以得到origin（jar包名字中有origin）和非origin（jar包名字中没有origin）的包。其中非origin的包已经包含了main，可以运行。

* 运行


```
java -jar jar的文件名
```

## 其他的Maven项目直接引用这个jar

```
mvn clean install
```
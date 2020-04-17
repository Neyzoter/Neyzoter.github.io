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


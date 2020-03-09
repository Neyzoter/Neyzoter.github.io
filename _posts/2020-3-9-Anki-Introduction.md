---
layout: post
title: 安利Anki
categories: Softwares
description: 安利Anki
keywords: Anki
---



> Anki是一个卡片记忆工具

# 1.Anki介绍

[Anki](https://apps.ankiweb.net/)是一款基于“间隔记忆”的卡片记忆工具，可以用来记忆任何东西，能大大提高记忆效率。Anki具有以下特点：

* **同步性**

  使用Ankiweb的服务器，你可以在多台不同系统的设备之间同步你的卡片.

* **灵活性**

  从卡片的布局，到卡片的复习时间安排，anki提供了多种有价值的选项供你自定义.

* **富媒体性**

  你可以将音频，视频，文字，图片，以及科学符号放置在你的卡片中.

* **优化性**

  Anki可以同时处理10万张卡片，因此不必担心卡片太多造成的麻烦.

* **可扩展性**

  Anki还提供了各种插件，通过它你可以扩展你需要的功能.

* **开源**

  Anki是个开源的软件，因此你的数据会更安全，其次，它也将会发展的更智能 .

# 2.Anki使用

* **主要功能：卡片记忆**

  1. Deck是Anki的卡片目录，比如我有三个Deck——English（英语单词和翻译）、algorithm（算法，包括在Leetcode、剑指Offer等遇到的算法题目或者算法问题）、backend-interviewer（后端面试问题，包括后端技术问题、面试一般问题等）。

     <img src="/images/posts/2020-3-9-Anki-Introduction/First-page.png" width="400" alt="首页">

  2. 比如我们要学习English

     <img src="/images/posts/2020-3-9-Anki-Introduction/Deck-English.png" width="400" alt="English">

  3. 自动跳出English的某个卡片的正面问题

     翻译中文至英文，点击Show Answer 可以查看卡片反面的答案。

     <img src="/images/posts/2020-3-9-Anki-Introduction/Front.png" width="400" alt="English-Front">

  4. 查看答案

     点击Show Answer 可以查看卡片反面的答案，可以看到下方有Again、Good、Easy等按钮，表示对于该问题的掌握程度。掌握程度越差，下次复习的时间越短。其中按钮上方的`<1m`、`<10m`、`4d`表示下次卡片可以再次学习的时间。

     <img src="/images/posts/2020-3-9-Anki-Introduction/Front-Back.png" width="400" alt="English-Front-Back">

* **远程同步**

  Anki官网提供免费的远程同步保存功能，如果想要手动同步只需要点击Sync按钮或者快捷键Y。同步包括下行和上行两个方面，也就是下载本地没有的远程数据，上传远程没有的本地数据。不过在这之前需要注册Anki用户，这样才能同步到对应的账户下。用户还可以在[Anki Web](https://ankiweb.net/decks/)上，通过浏览器查看自己的卡片。有了同步功能，用户就可以在不同设备上进行在多设备上进行卡片记忆啦。

  <img src="/images/posts/2020-3-9-Anki-Introduction/AnkiWeb.png" width="800" alt="Anki Web">

* **导出卡片**

  也许我们想要在本地保存卡片，并拷贝给别人。而Anki可以实现方便的卡片导出还可以选择是否导出学习记录。Anki支持以下几种导出格式，

  1. `Anki Collection Package(*.colpkg)`

     Anki集合包是后缀为`*.colpkg`的数据包。使用该功能时，会把所有信息包括卡片、记忆记录等都导出。如果Anki导入该包，会把原来的包都覆盖掉。

     <img src="/images/posts/2020-3-9-Anki-Introduction/colpkg.png" width="400" alt="Anki colpkg">

  2. `Anki Deck Package(*.apkg)`

     Anki Deck包是后缀为`*.apkg`的数据包。使用该功能时，会导出某一个或者所有（All Deck）Deck的卡片，而且可以选择是否导出记忆记录。

     <img src="/images/posts/2020-3-9-Anki-Introduction/apkg.png" width="400" alt="Anki apkg">

  3. `Notes in Plain Text(*.txt)`

     具体见[Anki中文文档](http://www.ankichina.net/anki20.html)

  4. `Cards in Plain Text(*.txt)`

     具体见[Anki中文文档](http://www.ankichina.net/anki20.html)

# 3.卡片推荐

我维护了一个存放自己笔记的[Anki卡片的Github仓库](https://github.com/Neyzoter/Anki-Backup)，里面包含了英语短语翻译、算法题、后端面试问题等内容的卡片，欢迎Star和Fork。

# 4. 参考

1. [Anki中文文档](http://www.ankichina.net/anki20.html)
2. [Anki英文文档](https://docs.ankiweb.net)
3. [Anki中国](http://ankichina.net/)
4. [Anki官网](https://apps.ankiweb.net/)


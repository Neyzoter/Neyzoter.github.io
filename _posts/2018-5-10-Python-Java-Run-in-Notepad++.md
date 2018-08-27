---
layout: post
title: Notepad++运行Python、Java和CPP
categories: Softwares
description: 在Notepad上实现Python、Java和CPP程序的运行
keywords: Notepad++, Python, Java
---

> 原创
> 
> 转载请注明出处，侵权必究


# Python的运行
1、安装Python

安装了Python，并把路径加入到Path。

2、运行

打开Notepad++后，按下F5或者点开“运行”，见下图。

<img src="/images/posts/2018-5-10-Python-Java-Run-in-Notepad++/run.png" width="600" alt="运行" />

3、加入Python路径

```

cmd /k 你的python.exe（比如我的是F:\Program\Anaconda\python.exe） "$(FULL_CURRENT_PATH)" & PAUSE & EXIT

```

栗子：

```

cmd /k F:\Program\Anaconda\python.exe "$(FULL_CURRENT_PATH)" & PAUSE & EXIT

```

<img src="/images/posts/2018-5-10-Python-Java-Run-in-Notepad++/run_path.png" width="300" alt="运行程序" />

4、保存为快捷键

<img src="/images/posts/2018-5-10-Python-Java-Run-in-Notepad++/shortcut.png" width="300" alt="快捷键" />

5、使用

# Java的运行
1、安装Java

2、安装NppExec

<img src="/images/posts/2018-5-10-Python-Java-Run-in-Notepad++/showPluginManager.png" width="500" alt="显示插件" />

找到NppExec，并安装。

<img src="/images/posts/2018-5-10-Python-Java-Run-in-Notepad++/installNppExec.png" width="500" alt="显示插件" />

如果出现无法安装的问题，那么可以直接网上下载好NppExec插件。解压后，放到Notepad++的插件文件夹里。

比如我的安装地址是：C:\Program Files\Notepad++\plugins。

<img src="/images/posts/2018-5-10-Python-Java-Run-in-Notepad++/files.png" width="500" alt="文件夹" />

红色的是NppExec压缩包解压后的文件。

3、运行NppExec

<img src="/images/posts/2018-5-10-Python-Java-Run-in-Notepad++/executeNppExec.png" width="500" alt="执行NppExec" />

4、粘贴代码

<img src="/images/posts/2018-5-10-Python-Java-Run-in-Notepad++/copyPaste.png" width="400" alt="执行NppExec" />

```
javac "$(FULL_CURRENT_PATH)"
echo
echo ===========编译成功后开始运行===========
echo 若不使用 -cp ，则需使用cd切换到当前目录，或勾选Follow CURRENT_DIRECTORY菜单项
java -cp "$(CURRENT_DIRECTORY)" "$(NAME_PART)"

```

然后保存Java编译javac和执行java。

<img src="/images/posts/2018-5-10-Python-Java-Run-in-Notepad++/saveJava.png" width="700" alt="保存Java编译和执行" />

5、设置快捷键

<img src="/images/posts/2018-5-10-Python-Java-Run-in-Notepad++/Java_shortcut.png" width="450" alt="保存Java编译和执行快捷键" />

6、运行

按下快捷键(我的是ctrl+F6)，编译和执行。

helloworld程序的执行结果如下。

<img src="/images/posts/2018-5-10-Python-Java-Run-in-Notepad++/runOut.png" width="800" alt="执行NppExec" />

# CPP的运行
## 1 notepad运行cpp
1、安装MinGW

2、将MinGW的bin路径加入到环境变量中

比如我的是

C:\Program Files\mingw-w64\x86_64-5.3.0-posix-seh-rt_v4-rev0\mingw64\bin

3、验证g++有用

win+r调出cmd窗口，输入“g++ -v”，查看g++的版本。我的是5.3.0。

<img src="/images/posts/2018-5-10-Python-Java-Run-in-Notepad++/gpp.png" width="500" alt="查看g++的版本" />

4、配置notepad++

按下F5或者菜单栏-》运行-》运行

将

```
cmd /k cd /d "$(CURRENT_DIRECTORY)" & g++ "$(FILE_NAME)" -o "$(NAME_PART)" & "$(NAME_PART).exe"
```

复制进去，并保存，设置快捷键。

如果想要支持C++11，以上输入的代码需要加上“-std=c++11”，即

```
cmd /k cd /d "$(CURRENT_DIRECTORY)" & g++ -std=c++11 "$(FILE_NAME)" -o "$(NAME_PART)" & "$(NAME_PART).exe"
```

5、快捷键运行即可

## 2 如何用命令行运行cpp？

1、打开cmd命令行

2、进入包含cpp的文件夹

3、编译

生成一个默认的a.exe执行文件

```
$ g++ 文件名.cpp  
```

或者指定exe文件名

```
$ g++ 文件名.cpp  -o 文件名（可以任意取）
```

4.运行

如果是默认的a.exe，则在cmd窗口输入“a.exe”或者“a”

如果是指定了文件名，则在cmd窗口输入“文件名.exe”或者“文件名”


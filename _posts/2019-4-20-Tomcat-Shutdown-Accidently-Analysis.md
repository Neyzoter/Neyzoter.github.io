---
layout: post
title: Tomcat意外停止的问题分析
categories: Java
description: Tomcat意外停止的问题分析
keywords: Tomcat, ssh
---

## 1、问题描述
测试时发现Tomcat会在后台运行时意外停止。后来查阅了[相关资料和类似问题](<http://hongjiang.info/why-kill-2-cannot-stop-tomcat/>)，找到了原因。

日志输出：

```
org.apache.coyote.AbstractProtocol pause
Pausing ProtocolHandler
org.apache.catalina.core.StandardService stopInternal
Stopping service Catalina
org.apache.coyote.AbstractProtocol stop
Stopping ProtocolHandler
org.apache.coyote.AbstractProtocol destroy
Destroying ProtocolHandler
....
```

## 2、问题分析
### 2.1 Tomcat不是通过脚本正常关闭(viaport: 即通过8005端口发送shutdown指令)
因为正常关闭(viaport)的话会在 pause 之前有这样的一句warn日志：

```
org.apache.catalina.core.StandardServer await
A valid shutdown command was received via the shutdown port. Stopping the Server instance.
然后才是 pause -> stop -> destroy 
```

### 2.2 Tomcat的shutdownhook被触发，执行了销毁逻辑

而这又有两种情况：

第一，应用代码里有地方用`System.exit`来退出jvm，第二，系统发的信号(`kill -9`除外，SIGKILL信号JVM不会有机会执行shutdownhook)

对于第一种情况，我的代码中并没有推出jvm的内容。

那就只有第二种情况了，而且发现了一个问题：**发现每次tomcat意外退出的时间与ssh会话结束的时间正好吻合**。

查看运行Tomcat的脚本`runtc.sh`：

```bash
#!/bin/bash

# 运行tomcat
sudo /opt/tomcat/apache-tomcat-8.0.53/bin/startup.sh
tail -f /opt/tomcat/apache-tomcat-8.0.53/logs/catalina.out
```

**Tomcat启动为后，当前shell进程并没有退出，而是挂住在tail进程，往终端输出日志内容。这种情况下，如果用户直接关闭ssh终端的窗口(用鼠标或快捷键)，则java进程也会退出。而如果先ctrl-c终止`runtc.sh`进程，然后再关闭ssh终端的话，则java进程不会退出。**

## 3.深入理解

> Tomcat启动为后，当前shell进程并没有退出，而是挂住在tail进程，往终端输出日志内容。这种情况下，如果用户直接关闭ssh终端的窗口(用鼠标或快捷键)，则java进程也会退出。而如果先ctrl-c终止test.sh进程，然后再关闭ssh终端的话，则java进程不会退出。

这是一个有趣的现象，`catalina.sh start`方式启动的Tomcat会把java进程挂到`init`(进程id为1)的父进程下，已经与当前`runtc.sh`进程脱离了父子关系，也与ssh进程没有关系，为什么关闭ssh终端窗口会导致java进程退出？

以下来自[hongjiang.info](http://hongjiang.info/why-kill-2-cannot-stop-tomcat/)

注释：

>ID  标志      作用
>01 SIGHUP 挂起（hangup）
>
>本信号在用户终端连接(正常或非正常)结束时发出, 通常是在终端的控制进程结束时, 通知同一session内的各个作业, 这时它们与控制终端不再关联。
>登录Linux时，系统会分配给登录用户一个终端(Session)。在这个终端运行的所有程序，包括前台进程组和后台进程组，一般都属于这个Session。当用户退出Linux登录时，前台进程组和后台有对终端输出的进程将会收到SIGHUP信号。这个信号的默认操作为终止进程，因此前台进程组和后台有终端输出的进程就会中止。不过可以捕获这个信号，比如wget能捕获SIGHUP信号，并忽略它，这样就算退出了Linux登录，wget也能继续下载。
>
>02 SIGINT 中断，当用户从键盘按```^c```或者```^break```时，用于通知前台进程组终止进程
>
>03 SIGQUIT 退出，当用户从键盘按quit键时
>
>04 SIGILL 非法指令
>
>05 SIGTRAP 跟踪陷阱（trace trap），启动进程，跟踪代码的执行
>
>06 SIGIOT IOT指令
>
>07 SIGEMT EMT指令
>
>08 SIGFPE 浮点运算溢出
>
>09 SIGKILL 杀死、终止进程 
>
>10 SIGBUS 总线错误
>
>11 SIGSEGV 段违例（segmentation  violation），进程试图去访问其虚地址空间以外的位置
>
>12 SIGSYS 系统调用中参数错，如系统调用号非法
>
>13 SIGPIPE 向某个非读管道中写入数据
>
>14 SIGALRM 闹钟。当某进程希望在某时间后接收信号时发此信号
>
>15 SIGTERM 软件终止（software  termination）
>
>16 SIGUSR1 用户自定义信号1
>
>17 SIGUSR2 用户自定义信号2
>
>18 SIGCLD 某个子进程死
>
>19 SIGPWR 电源故障

**(1)用 ctrl-c 终止当前test.sh进程时，系统events进程向 java 和 tail 两个进程发送了`SIGINT`(kill -2) 信号**

```
SIGINT [ 0 11  ] -> [ 0 20629 tail ] 
SIGINT [ 0 11  ] -> [ 0 20628 java ] 
SIGINT [ 0 11  ] -> [ 0 20615 test.sh ] 

注pid 11是events进程
```

hongjiang的`test.sh`主要内容如下

```bash
#!/bin/bash
cd /data/server/tomcat/bin/
./catalina.sh start
tail -f /data/server/tomcat/logs/catalina.out
```

**(2)关闭ssh终端窗口时，sshd向下游进程发送`SIGHUP`(kill -1), 为何java进程也会收到？**

```
SIGHUP [ 0 11681 sshd: hongjiang.wanghj [priv] ] -> [ 57316 11700 bash ] 
SIGHUP [ 57316 11700 -bash ] -> [ 57316 11700 bash ]
SIGHUP [ 57316 11700 ] -> [ 0 13299 tail ] 
SIGHUP [ 57316 11700 ] -> [ 0 13298 java ] 
SIGHUP [ 57316 11700 ] -> [ 0 13285 test.sh ] 
```

**(3)`SIGINT` (kill -2) 不会让后台java进程退出的原因**

**shell在非交互模式下对后台进程处理`SIGINT`信号时设置的是`IGNORE`**

为什么在交互模式下shell不会对后台进程处理`SIGINT`信号设置为忽略，而非交互模式下会设置为忽略呢？还是比较好理解的，举例来说，我们先某个前台进程运行时间太长，可以`ctrl-z`中止一下，然后通过`bg %n`把这个进程放入后台，同样也可以把一个`cmd &`方式启动的后台进程，通过`fg %n`放回前台，然后在`ctrl-c`停止它，当然不能忽略`SIGINT`。

为何交互模式下的后台进程会设置一个自己的进程组ID呢？因为默认如果采用父进程的进程组ID，父进程会把收到的键盘事件比如`ctrl-c`之类的`SIGINT`传播给进程组中的每个成员，假设后台进程也是父进程组的成员，因为作业控制的需要不能忽略`SIGINT`，你在终端随意`ctrl-c`就可能导致所有的后台进程退出，显然这样是不合理的；所以为了避免这种干扰后台进程设置为自己的pgid。

而非交互模式下，通常是不需要作业控制的，所以作业控制在非交互模式下默认也是关闭的（当然也可以在脚本里通过选项`set -m`打开作业控制选项）。不开启作业控制的话，脚本里的后台进程可以通过设置忽略`SIGINT`信号来避免父进程对组中成员的传播，因为对它来说这个信号已经没有意义。

**回到tomcat的例子，catalina.sh脚本通过start参数启动的时候，就是以非交互方式后台启动，java进程也被shell设置了忽略`SIGINT`信号（也就是`ctrl+c`，关闭了catalina.out输出显示），因此在`ctrl-c`结束test.sh进程时，系统发送的`SIGINT`对java没有影响。**

**(4)`SIGHUP` (kill -1) 让tomcat进程退出的原因**

在交互模式下，shell对java进程设置了`SIGINT`，`SIGQUIT`信号设置了忽略，但并没有对`SIGHUP`信号设为忽略。

sshd把`SIGHUP`传递给bash进程后，bash会把`SIGHUP`传递给它的子进程，并且对于其子进程test.sh，bash还会对test.sh的进程组里的成员都传播一遍`SIGHUP`。因为java后台进程从父进程catalina.sh(又是从其父进程test.sh)继承的pgid，所以java进程仍属于test.sh进程组里的成员，收到`SIGHUP`后退出。

**通过关闭交互模式下的catalina.out输出显示后，java后台进程继承父进程catalina.sh的pgid，而catalina.sh不再使用test.sh的进程组，而是自己的pid作为pgid，catalina.sh进程在执行完退出后，java进程挂到了init下，java与test.sh进程就完全脱离关系了，bash也不会再向它发送信号。**

## 4.参考文献

1.[tomcat进程意外退出的问题分析](<http://hongjiang.info/why-kill-2-cannot-stop-tomcat/>)


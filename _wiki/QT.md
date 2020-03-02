---
layout: wiki
title: QT
categories: QT
description: QT小笔记
keywords: QT, GUI
---

# 1、HelloWorld
```CPP
#include <QApplication>
#include <QLabel>

int main(int argc, char *argv[])
{
    //GUI 程序是 QApplication，非 GUI 程序是 QCoreApplication。QApplication 实际上是 QCoreApplication 的子类。
    QApplication app(argc, argv);//后面才是实际业务代码

    QLabel label("Hello, world");//QLabel对象
    label.show();//QLabel兑现显示

    return app.exec();//执行循环
}
```

# 2、自定义信号槽

eg

```CPP

//newspaper.h
#ifndef NEWSPAPER_H
#define NEWSPAPER_H

#include <QObject>

class Newspaper : public QObject
{
    //为我们的类提供信号槽机制、国际化机制以及 Qt 提供的不基于 C++ RTTI 的反射能力
    Q_OBJECT   //如果继承了QObject，则需要加这个宏

public:
    //类构造函数的初始化列表，const类型只能在初始化时赋值，这里就是给const类型初始化
    Newspaper(const QString &name): m_name(name){}
    
    void send()
    {
        emit newPaper(m_name);//发出信号
    }
signals:
    void newPaper(const QString & name);//其中的参数是传送的信号
private:
    QString m_name;
};
#endif // NEWSPAPER_H

```

```CPP

// reader.h
#ifndef READER_H
#define READER_H

#include <QObject>
#include <QDebug>

class Reader : public QObject
{
    Q_OBJECT

public:
    Reader(){}

    void DispMsg(const QString & str)
    {
        qDebug()<<"receive:"<<str<<endl;
    }
};
#endif // READER_H

```

```
//main.c
#include <QCoreApplication>

#include <QDebug>
#include <QObject>
#include "newspaper.h"
#include "reader.h"

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);

    Newspaper newspaper("create newspaper");
    Reader reader;

    QObject::connect(&newspaper,&Newspaper::newPaper,&reader,&Reader::DispMsg);

    newspaper.send();
}

```

# 3、QT Widgets Application工程
## 3.1 pro文件
工程文件，放置工程的说明。
```
QT       += core gui  # 需要的模块，这里用到core和gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets  # 如果QT版本大于4，则要添加widgets模块

TARGET = 2_mainwindow  # 生成的程序的名字
TEMPLATE = app     # 生成makefile所使用的的模板，app：编译成一个可执行程序；lib：编译成一个链接库（默认是动态链接库）


SOURCES += main.cpp\
        mainwindow.cpp    # 源代码文件

HEADERS  += mainwindow.h    # 头文件

FORMS    += mainwindow.ui  # 指定项目中的UI文件，这些文件在编译前被uic处理
```
## 3.2 ui文件
包括很多属性（property）：geometry、windowTitle、text等，用于设置UI界面。可采用GUI界面设计，代码自动更新。

# 4、QT资源文件
如何创建资源呢？

1、工程上右键“添加新文件”

2、QT分类下找到“QT资源文件”

输入资源文件的名字和路径

3、选择下一步

4、选择所需要的版本控制系统，然后直接选择完成

# 5、对象模型

## 5.1 moc = Meta Object Compiler

moc:元对象编译器，会对C++代码进行一次预处理（不同于C++编译器的预处理），生成标准的C++源代码，然后再用标准C++编译器进行编译。

moc为C++添加的特性：

* 信号槽机制，用于解决对象之间的通讯，这个我们已经了解过了，可以认为是 Qt 最明显的特性之一；
* 可查询，并且可设计的对象属性；
* 强大的事件机制以及事件过滤器；
* 基于上下文的字符串翻译机制（国际化），也就是 tr() 函数，我们简单地介绍过；
* 复杂的定时器实现，用于在事件驱动的 GUI 中嵌入能够精确控制的任务集成；
* 层次化的可查询的对象树，提供一种自然的方式管理对象关系。
* 智能指针（QPointer），在对象析构之后自动设为 0，防止野指针；
* 能够跨越库边界的动态转换机制。

## 5.2 对象树
QObject是以对象树的形式组织起来的。创建一个QObject对象时，会看到 QObject 的构造函数接收一个 QObject 指针作为参数，这个参数就是 parent，也就是父对象指针。这里的父对象不是继承意义上的父类。

一个按钮有一个 QShortcut（快捷键）对象作为其子对象。当我们删除按钮的时候，这个快捷键理应被删除。

见以下例子

```
class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    //这里提供了一个父对象，自动添加到父对象的children()列表，当父对象析构时，这个列表的所有对象都会被析构
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

private:
    void open();

    QAction * openAction;//生命了一个QAction，可以用new QAction来定义
};
```

Qt 引入对象树的概念，在一定程度上解决了内存问题。


# 6、布局管理器
## 6.1 QSpinBox和QSlider
QSpinBox：只能输入数字的输入框，带有上下箭头的步进按钮。

QSlider：带有滑块的滑竿

数值改变有两个信号函数，valueChanged(int)和valueChanged(const QString &)。在连接connect的时候，需要明确是哪一个。

```
//这样不行，这里没有指明是哪个和valueChanged
QObject::connect(spinBox, &QSpinBox::valueChanged, slider, &QSlider::setValue);
```

解决方法如下：

```
void (QSpinBox:: *spinBoxSignal)(int) = &QSpinBox::valueChanged;
QObject::connect(spinBox, spinBoxSignal, slider, &QSlider::setValue);
```

## 6.2 布局方式

QHBoxLayout：按照水平方向从左到右布局；

QVBoxLayout：按照竖直方向从上到下布局；

QGridLayout：在一个网格中进行布局，类似于 HTML 的 table；

QFormLayout：按照表格布局，每一行前面是一段文本，文本后面跟随一个组件（通常是输入框），类似 HTML 的 form；

QStackedLayout：层叠的布局，允许我们将几个组件按照 Z 轴方向堆叠，可以形成向导那种一页一页的效果。

# 7、对话框
在QT中对话框的类叫QDialog。其parent指针有额外的解释：如果parent为NULL，则对话框作为一个顶层窗口（任务栏会另外开一个窗口），否则作为其父组件的子对话框（默认出现的位置是parent的中心）。顶层窗口在任务栏（一般是电脑的桌面下方一条）有自己的位置，非顶层窗口和共享父组件的位置。

## 7.1 模态和非模态
对话框分为模态对话框和非模态对话框。所谓模态对话框，就是会阻塞同一应用程序中其它窗口的输入。模态对话框很常见，比如“打开文件”功能。你可以尝试一下记事本的打开文件，当打开文件对话框出现时，我们是不能对除此对话框之外的窗口部分进行操作的。与此相反的是非模态对话框，例如查找对话框，我们可以在显示着查找对话框的同时，继续对记事本的内容进行编辑。

```
void MainWindow::open()
{

//    //**以下在栈上建立，所以如果用dialog.show()会闪退，而exec为循环执行，所以不会闪退***//
//    //创建一个QDialog对象
//    //QDialog dialog;//作为一个单独的顶层窗口，开一个任务栏
//    QDialog dialog(this);//作为父组件的子对话框，和父组件是同一个任务
//    dialog.setWindowTitle(tr("Hello,dialog!"));
//    dialog.exec();//实现了窗口级别的模态对话框：仅仅阻塞与对话框关联的窗口，但是依然允许用户与程序中其它窗口交互

    //***以下在堆上建立，show虽然不会阻塞当前进程，但是堆不会析构***//
    //QDialog * dialog = new QDialog(this);//作为父组件的子对话框，和父组件是同一个任务。父类关闭时，自动销毁dialog。这样不用加dialog->setAttribute(Qt::WA_DeleteOnClose);
    QDialog * dialog = new QDialog;
    dialog->setAttribute(Qt::WA_DeleteOnClose);//如果对话框和父类不在一个界面类中出现，那么用这个函数，在关闭对话框后，自动销毁对话框
    dialog->setWindowTitle(tr("Hello,dialog!"));
    dialog->show();//实现非模态对话框

}
```

## 7.2 对话框数据传递

采用信号槽机制实现数据传递，不要担心关掉Dialog后，是否还能传递数据。因为信号槽机制保证了sender函数获取到signal的发出者。

```
//开启Dialog   ->   关闭Dialog时，自动调用reject()函数（已重写）    ->   
//重写的reject()函数抛出信号userAgeChanged(newAge)   ->
//和该信号连接的槽函数setUserAge()调用，更改userAge    ->
//打印出年龄
```






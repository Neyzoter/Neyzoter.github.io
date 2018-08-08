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
---
layout: wiki
title: Java
categories: Java
description: Java语法
keywords: Java
---


# 1、java规范
## 1.1 基本数据类型
### 1.1.1 内置数据类型

数据类型的取值范围都以常量的形式存储在了对应的包装类中。

数据类型.SIZE：二进制位数；数据类型.MIN_VALUE/MAX_VALUE。

如Integer.SIZE

* byte、Byte类

8bits，有符号，以二进制补码表示的整数

-128到127

默认0

* short、Short类

16bits,有符号，二进制补码表示

-2^15到2^15-1

默认0

* int、Integer类

32bits，有符号，二进制补码表示

默认0

* long、Long类

64bits，有符号，二进制补码表示

默认0L

**要在数值后面加上L，否则会作为整形解析，导致溢出**

* float、Float类

32bits，浮点数存储

默认0.0f

不能用来表示精确的值，如货币

* double、Double类

64bits，浮点数存储

默认0.0d

不能用来表示精确的值，如货币

* boolean

1bit

true或着false

默认false

* char、Character类

**16bits**unicode字符

最小\u0000，最大\uffff，**16进制**表示。

char数据类型可以存储任何字符。

eg.  char letter = "A"; 

### 1.1.2 引用类型

对象和数组都是引用数据类型，默认null。

eg.  Site site = new Site("Runoob");

### 1.1.3 常量
final修饰，声明后无法更改。

```Java
final double PI = 3.1415926
```

字符串常量和字符常量都可以包含任何Unicode字符。

eg.   

```Java
char a = '\u0001'; // 16进制Unicode字符
String a = "\u0001";
```

## 1.2 变量类型
### 1.2.1 类变量（静态变量）

独立于方法之外的变量，用static修饰。如 static int allClicks = 0

无论一个类创建了多少个对象，类只拥有类变量的一份拷贝。（和CPP相同）

静态变量属于类，在第一次被访问时创建，在程序结束时销毁。

### 1.2.2 实例变量

独立于方法之外的变量，没有static修饰。如String str = "hello world"

实例变量属于类的对象，在对象创建时创建，在对象销毁时销毁。

### 1.2.3 局部变量

类的方法中的变量，在栈上分配。

方法进入时创建，方法结束时销毁。

## 1.3 修饰符
### 1.3.1 访问控制修饰符

|修饰符|当前类|同一包内|子孙类(同一包)|子孙类(不同包)|其他包|
|-|-|-|-|-|-|
|public|Y|Y|Y|Y|Y|
|-|-|-|-|-|-|
|protected|Y|Y|Y|Y/N|N|
|-|-|-|-|-|-|
|default|Y|Y|Y|N|N|
|-|-|-|-|-|-|
|private|Y|N|N|N|N|

说明：关于protected的Y/N，子类与基类不在同一个包内时，子类实例可以访问其从基类继承而来的protected方法，但是不能访问基类实例的protected方法。
### 1.3.2 abstract修饰符
抽象类，不能用来实例化对象， 声明抽象类的唯一目的时为了将来堆该类进行扩充,具体实现由子类提供。**任何继承抽象类的子类必须实现父类的所有抽象方法，除非该子类也是抽象类。**

如果一个类包含抽象方法，那么一定要声明为抽象类。

```Java
public abstract class Caravan{
  private double price;
  private String model;
  private String year;
  public abstract void goFast();//抽象方法
  public abstract void changeColor();
}

class C extends Caravan{
  public void goFast();
  public abstract void changeColor();
} 
```

### 1.3.3 synchronized修饰符
synchronized关键字声明的方法同一时间只能被**同一个线程**访问。

```
public synchronized void showDetails(){

}
```

### 1.3.4 transient修饰符
序列化的对象包含被transient修饰的实例变量时，java虚拟机（JVM）跳过该特定的变量。

### 1.3.5 volatile修饰符
每次线程访问时，都强制从共享内存中重新读取改成员变量的值。当成员变量发生变化时，会强制线程将变化值写回共享内存。

## 1.4 运算符

### 1.4.1 >>>和>>

\>>：表示有符号右移，正数右移高位补0,负数右移高位补1。

\>>>：表示无符号右移，负数和正数，高位通通补0。

### 1.4.2 条件运算符

?:和C一样。

### 1.4.3 instanceof

检查对象是否是一个特定类型（类类型和接口类型）

```Java
String name = "James";
boolean result = name instanceof String;//检查name是否时String类型
```

说明：如果Car继承了Vehicle，用Car建立一个对象car，则car既是Car又是Vehicle。

## 1.5 循环
* while(){}

* do{}while()

* for(;;)

* 增强for(声明语句:表达式){}

主要用于数组遍历。

```Java
String names[] = {"James","Larry","Tom","Lacy"};
for(String name:names)[
  System.out.print("name");
  System.out.print(",");
}
```

* continue

直接进行下一次循环。

## 1.6 分支结构
* if ... else if ... else...

和CPP相同。

* switch() case value :...break;default...break;

和CPP相同。

支持String类型。

## 1.7 Number、Char、String和Math类
### 1.7.1 Number类
Integer、Long、Byte、Double、Float、Short

xxxValue()：将Number对象转化为xxx数据类型并返回。

compareTo()：将Number对象与参数比较。

equals()：判断number对象是否与参数相等。

valueOf()：返回一个Number对象指定的内置数据类型。

```
Integer X = Integer.valueOf(9);

Integer a = Integer.valueOf("444",16);//使用16进制,返回1092( = 0x444)
```

toString()：以字符串形式返回值。

parseInt()：将字符串解析为int类型。

>Integer i1 = 128;//装箱，相当于Integer.valueof(128);
>int i = i1;//拆箱，相当于i1.intValue()

### 1.7.2 Character类

isLetter()：是否是一个字母

isDigital()：是否是一个数字字符

isWhitespace()：是否是一个空格

isUpperCase()：是否是大写字母

isLowerCase()：是否是小谢字母

toUpperCase()：指定字母的大写形式

toLowerCase()：指定字母的小写形式

toString()：返回字符的字符串类型，长度1

### 1.7.3 String类
**不可改变**，如果需要对字符串做多次修改，选择使用StringBuffer和StringBuilder类。

charAt(int index)：返回指定索引出的char值

compareTo(Object o 或者 String anotherString)：把这个字符串和另一个对象比较，等于返回0,大于返回小于0,小于返回大于0。

compareTo(String anotherString)：按字典顺序比较两个字符串。

...

### 1.7.4 StringBuffer和StringBuilder类
和String不同，可以被修改，并且不产生新的未使用对象。

StringBuilder：相比于StringBuffer，不是线程安全的，不能同步访问。但是StringBuilder具有速度优势。

StringBuffer append(String s)：将指定的字符串追加到字符序列。

StringBuffer reverse()：此字符序列用其反转形式取代。

delete(int start,int end)：移除此序列的子字符串中的字符。

insert(int offset,int i)：int参数的字符串表示形式插入此序列

replace(int start,int end,String str)：替换。

### 1.7.5 Math类
Math.sin()

Math.cos()

Math.tan()

Math.atan()

Math.toDegree()

Math.ceil()：返回大于等于给定参数的最小整数

Math.floor()：返回小于等于给定采纳数的最大整数

Math.rint()：返回与参数最接近的整数。返回类型为doule

Math.round()：四舍五入

Math.random()：返回随机数0.0到1.0

## 1.8 数组
* 创建
```
dataType[] arrayRefVar;//首选方法
dataType arrayRefVar[];//效果相同，但不是首选方法

dataType[] arrayRefVar = new dataType[arraySize];//第一步，使用dataType[arraySize]创建一个数组；第二步，把新创建的数组的引用复制给变量arrayRefVar
```

* foreach循环

```
for(dataType element : arrayRefVar){}
```

* 多维数组

```
int a[][] = new int[2][3];
```

多维数组的动态初始化

```
String s[][] = new String[2][];
s[0] = new String[2];//这里确定每一行的元素个数
s[1] = new String[3];
s[0][0] = new String("Good");
s[0][1] = new String("Luck");
s[1][0] = new String("to");
s[1][1] = new String("you");
s[1][2] = new String("!");
```

* Array类

java.util.Arrays类能方便地操作数组，提供的方法都是static静态的。

binarySearch(Object[] a,Object key)：二分查找法在给定数组中搜索给定值的对象。数组在调用前，必须排序好。如果查找值包含在数组中，则返回搜索键的索引，否则返回-1或者-“插入点”，插入点表示第一个大于该键key的元素索引。

equal(Object[] a,Object[] b)：是否相等

fill(Object[] a,int fromIndex,int toIndex,Object val,)：将val插入到指定范围中。

sort(Object[] a)：升序排列。

## 1.9 时间

### 1.9.1 Date时间创建

```Java
Date(int year,int month,int date);//以int型表示年月日

Date(int year,int month,int date,int hour,int min);

Date(int year,int month,int date,int hour,int min,int sec);

```

### 1.9.2 方法

* get时间

```Java
//格林尼治时间
Date(long date);//date:距离格林尼治标准时间1970年1月1日0时0分0秒的毫秒数

.getYear()、.getHour()、.getMonth()、.getMinutes()、.getSecond()


getTime()：返回子格林尼治时间
```

* 比较时间

三个方法：

1、getTime后比较

2、before()、after()、equals()来比较

3、compareTo()：由Comparable接口定义，Date类实现了这个接口。

* 格式化时间

SimpleDateFormat ft = new SimpleDateFormat("E yyyy.MM.dd 'at' hh:mm:ss a zzz");

E：星期；y：四位年份；M：月份；d：一个月的日期； 'at'：显示at；h：小时；m：分钟；s：秒；a：AM；z：时区。

S：毫秒。

可以格式化输出，通过System.out.printf("%tc%n")。以%t开头。c：全部日期和时间信息，F：年-月-日...

* 解析字符串

```Java

import java.util.*;
import java.text.*;
  
public class DateDemo {
 
   public static void main(String args[]) {
      SimpleDateFormat ft = new SimpleDateFormat ("yyyy-MM-dd"); 
 
      String input = args.length == 0 ? "1818-11-11" : args[0]; 
 
      System.out.print(input + " Parses as "); 
 
      Date t; 
 
      try { 
          t = ft.parse(input); //解析字符串
          System.out.println(t); 
      } catch (ParseException e) { 
          System.out.println("Unparseable using " + ft); 
      }
   }
}
```

### 1.9.3 休眠sleep
```Java
import java.util.*;
  
public class SleepDemo {
   public static void main(String args[]) {
      try { 
         System.out.println(new Date( ) + "\n"); 
         Thread.sleep(1000*3);   // 休眠3秒
         System.out.println(new Date( ) + "\n"); 
      } catch (Exception e) { 
          System.out.println("Got an exception!"); 
      }
   }
}
```

### 1.9.4 测量时间
```Java
import java.util.*;
  
public class DiffDemo {
 
   public static void main(String args[]) {
      try {
         long start = System.currentTimeMillis( );
         System.out.println(new Date( ) + "\n");
         Thread.sleep(5*60*10);
         System.out.println(new Date( ) + "\n");
         long end = System.currentTimeMillis( );
         long diff = end - start;
         System.out.println("Difference is : " + diff);
      } catch (Exception e) {
         System.out.println("Got an exception!");
      }
   }
}
```

### 1.9.5 Calender 类
设置和获取日期数据的特定部分，比如小时、日、分钟，或者在日期的这些部分加上或者减去值。

具体见菜鸟教程。

## 1.10 正则表达式
### 1.10.1 类和方法
java.util.regex包主要包括三个类：

* Pattern类

Pattern对象是一个正则表达式的编译表示。没有公共构造方法，要创建一个Pattern对象，必须首先调用其公共静态编译方法。

* Matcher类

Matcher对象是对输入字符串进行解释和匹配操作的引擎。没有公共构造方法，要调用Pattern对象的matcher方法来获得一个Matcher对象。

* PatternSyntaxException

表示一个正则表达式模式中的语法错误。

使用方法：

```Java
import java.util.regex.Matcher;
import java.util.regex.Pattern;
 
public class RegexMatches
{
    public static void main( String args[] ){
 
      // 按指定模式在字符串查找
      String line = "This order was placed for QT3000! OK?";
      String pattern = "(\\D*)(\\d+)(.*)";
 
      // 创建 Pattern 对象
      Pattern r = Pattern.compile(pattern);
 
      // 现在创建 matcher 对象
      Matcher m = r.matcher(line);
      if (m.find( )) {
         System.out.println("Found value: " + m.group(0) );
         System.out.println("Found value: " + m.group(1) );
         System.out.println("Found value: " + m.group(2) );
         System.out.println("Found value: " + m.group(3) ); 
      } else {
         System.out.println("NO MATCH");
      }
   }
}
```
### 1.10.2 正则表达式语法

\\：插入一个正则表达式的反斜线，其后的字符具有特殊意义。即\\d表示\d。

具体将菜鸟教程。

## 1.11 可变参数

```
public static void printMax(double... numbers){  //可输入多个参数
  if(numbers.length == 0){   
    System.out.println("No argument passed");
    return;
  }

  double result = numbers[0];
  
  for(int i = 1;i<numbers.length;i++){
    if(numbers[i] > result){
      result = numbers[i];
    }
  }
  System.out.println("The max value is "+result);
}
```

## 1.12 finalize()方法
清除回收对象。

```Java
public class FinalizationDemo {
  public static void main(String[] args) {
    Cake c1 = new Cake(1);
    Cake c2 = new Cake(2);
    Cake c3 = new Cake(3);
      
    c2 = c3 = null;
    System.gc(); //调用Java垃圾收集器
  }
}
 
class Cake extends Object {
  private int id;
  public Cake(int id) {
    this.id = id;
    System.out.println("Cake Object " + id + "is created");
  }
    
  protected void finalize() throws java.lang.Throwable {
    super.finalize();//调用父类的finalize
    System.out.println("Cake Object " + id + "is disposed");
  }
}
```

## 1.13 Java流(Stream)、文件(File)和IO
### 1.13.1 读取控制台输入
**BufferReader**
为获得一个绑定到控制台的字符流，将System.in包装在一个BufferedReader对象中来创建一个字符流。

```Java
BufferReader br = new BufferReader(new InputStreamReader(System.in));
```

后面用read()方法从控制台读取一个字符，用readLine()方法读取一个字符串。

* 读取字符

```Java
import java.io.*;
 
public class BRRead {
    public static void main(String args[]) throws IOException {
        char c;
        // 使用 System.in 创建 BufferedReader
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        System.out.println("输入字符, 按下 'q' 键退出。");
        // 读取字符
        do {
            c = (char) br.read();
            System.out.println(c);
        } while (c != 'q');
    }
}
```

输出：

>输入字符, 按下 'q' 键退出。
runoob
r
u
n
o
o
b


q
q

* 读字符串

```Java
//使用 BufferedReader 在控制台读取字符
import java.io.*;
 
public class BRReadLines {
    public static void main(String args[]) throws IOException {   //抛出IOException
        // 使用 System.in 创建 BufferedReader
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String str;
        System.out.println("Enter lines of text.");
        System.out.println("Enter 'end' to quit.");
        do {
            str = br.readLine();
            System.out.println(str);
        } while (!str.equals("end"));
    }
}
```

输出：
>Enter lines of text.
Enter 'end' to quit.
This is line one
This is line one
This is line two
This is line two
end
end


**Scanner**
hasNext()和hasNextLine()来判断是否还有输入数据

next()和nextLine()方法获取输入的字符串。

```
Scanner s = new Scanner(System.in);
```

* next和nextLine的区别

1、next一定要读取到有效字符后才可以结束输入

2、对输入有效字符之前遇到的空白，next会自动将其去掉

3、只有有效字符后才将后面输入的空白作为分隔符或者结束符

4、next不能得到带有空格的字符串

5、nextLine以Enter为结束符，返回输入回车之前的所有字符

* 输入int或者float等

先hasNextXxx()方法进行验证，在使用nextXxx()来读取（Xxx表示Int或者Float）。

```Java
import java.util.Scanner;
 
class ScannerDemo {
    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);
 
        double sum = 0;
        int m = 0;
 
        while (scan.hasNextDouble()) {
            double x = scan.nextDouble();
            m = m + 1;
            sum = sum + x;
        }
 
        System.out.println(m + "个数的和为" + sum);
        System.out.println(m + "个数的平均值是" + (sum / m));
        scan.close();
    }
}
```

输入输出：

>12
23
15
21.4
end
4个数的和为71.4
4个数的平均值是17.85

**Console**

输入的时候字符都是可见的，所以Scanner类不适合从控制台读取密码。从Java SE 6开始特别引入了Console类来实现这个目的。若要读取一个密码，可以采用下面这段代码:

```Java
Console cons = System.console();
String username = cons.readline("User name: ");
char[] passwd = cons.readPassword("Password: ");
```
### 1.13.2 读写文件
* FileInputStream

该流从文件读取数据，可以用new来创建。

```Java
FileInputStream f = new FileInputStream("C:/java/hello");
或者
File file = new File("C:/java/hello");//使用文件对象来创建一个输入流对象
FileInputStream f = new FileInputStream(file);
```

* FileOutputStream
该流从文件读取数据，可以用new来创建。

```
import java.io.*;
 
public class fileStreamTest {
    public static void main(String args[]) {
        try {
            byte bWrite[] = { 11, 21, 3, 40, 5 };
            OutputStream os = new FileOutputStream("test.txt");
            for (int x = 0; x < bWrite.length; x++) {
                os.write(bWrite[x]); // writes the bytes
            }
            os.close();
 
            InputStream is = new FileInputStream("test.txt");
            int size = is.available();
 
            for (int i = 0; i < size; i++) {
                System.out.print((char) is.read() + "  ");
            }
            is.close();
        } catch (IOException e) {
            System.out.print("Exception");
        }
    }
}

```

```
import java.io.*;
 
public class fileStreamTest2 {
    public static void main(String[] args) throws IOException {
 
        File f = new File("a.txt");
        FileOutputStream fop = new FileOutputStream(f);
        // 构建FileOutputStream对象,文件不存在会自动新建
 
        OutputStreamWriter writer = new OutputStreamWriter(fop, "UTF-8");
        // 构建OutputStreamWriter对象,参数可以指定编码,默认为操作系统默认编码,windows上是gbk
 
        writer.append("中文输入");
        // 写入到缓冲区
 
        writer.append("\r\n");
        // 换行
 
        writer.append("English");
        // 刷新缓存冲,写入到文件,如果下面已经没有写入的内容了,直接close也会写入
 
        writer.close();
        // 关闭写入流,同时会把缓冲区内容写入文件,所以上面的注释掉
 
        fop.close();
        // 关闭输出流,释放系统资源
 
        FileInputStream fip = new FileInputStream(f);
        // 构建FileInputStream对象
 
        InputStreamReader reader = new InputStreamReader(fip, "UTF-8");
        // 构建InputStreamReader对象,编码与写入相同
 
        StringBuffer sb = new StringBuffer();
        while (reader.ready()) {
            sb.append((char) reader.read());
            // 转成char加到StringBuffer对象中
        }
        System.out.println(sb.toString());
        reader.close();
        // 关闭读取流
 
        fip.close();
        // 关闭输入流,释放系统资源
 
    }
}
```

## 1.14 异常处理

## 1.X 注释

```
/**
* Copyright (C), 2006-2010, ChengDu Lovo info. Co., Ltd.
* FileName: Test.java
* 类的详细说明
*
* @author 类创建者姓名
* @Date    创建日期
* @version 1.00
*/
```

```
/**
* 类方法的详细使用说明
*
* @param 参数1 参数1的使用说明
* @return 返回结果的说明
* @throws 异常类型.错误代码 注明从此类方法中抛出异常的说明
*/
```

```
/**
* 构造方法的详细使用说明
*
* @param 参数1 参数1的使用说明
* @throws 异常类型.错误代码 注明从此类方法中抛出异常的说明
*/
```


# java备忘

## 方法的型参和实参

java中只能实现值传递，不能引用传递，和CPP不同。

所以无法通过方法直接改变，可以通过return来返回改变后的值。

注意：如果是基本类型或者String，实参不会改变，传的是值。如果是对象集合或者数组，则实参会改变，传的是引用。

## 构造方法
构造方法和他所在类的名字相同，当构造方法没有返回值。

所有类都有构造方法，Java自动提供了一个默认构造方法，它把所有成员初始化为0。

一旦定义了自己的构造方法，默认构造方法失效。

## 数组
存储在*堆*上的对象

## 继承
超类（super class）：被继承的类

子类（subclass）：派生类

## 命名
package：全部小谢，eg.com.runoob。

class和interface：大写字母开头，多个单词时，第二个单词开始开头大写。。

class变量：小写字母开头，多个单词时，第二个单词开始开头大写。

## 源文件声明规则
1、源文件中只能有一个public类，可以有多个非public类

2、源文件名和public类名相同

3、如果一个类定义在某个包中，package语句应该在源文件的首行。

4、源文件的import语句在package语句和类定义之间。

5、import语句和package语句堆源文件中定义的所有类都有效。在同一个源文件中，不能给不同的类不同的包声明。





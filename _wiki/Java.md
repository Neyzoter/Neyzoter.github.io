---
layout: wiki
title: Java
categories: Java
description: Java语法
keywords: Java
---


# 1、java基础
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

```java
final double PI = 3.1415926
```

字符串常量和字符常量都可以包含任何Unicode字符。

eg.   

```java
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

* 抽象类

抽象类，不能用来实例化对象， 声明抽象类的唯一目的时为了将来对该类进行扩充,具体实现由子类提供。**任何继承抽象类的子类必须实现父类的所有抽象方法，除非该子类也是抽象类。**

如果一个类包含抽象方法，那么一定要声明为抽象类。

```java
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

|参数|  抽象类| 接口|
|-|-|-|
|默认的方法实现| 它可以有默认的方法实现 |接口完全是抽象的。它根本不存在方法的实现|
|实现  |子类使用extends关键字来继承抽象类。如果子类不是抽象类的话，它需要提供抽象类中所有声明的方法的实现。 |  子类使用关键字implements来实现接口。它需要提供接口中所有声明的方法的实现|
|构造器| 抽象类可以有构造器 |  接口不能有构造器|
|与正常Java类的区别 |除了你不能实例化抽象类之外，它和普通Java类没有任何区别  | 接口是完全不同的类型|
|访问修饰符 |  抽象方法可以有public、protected和default这些修饰符 |   接口方法默认修饰符是public。你不可以使用其它修饰符。|
|main方法 | 抽象方法可以有main方法并且我们可以运行它 | 接口没有main方法，因此我们不能运行它。|
|多继承 抽象方法可以继承一个类和实现多个接口|  接口只可以继承一个或多个其它接口||
|速度 | 它比接口速度要快    |接口是稍微有点慢的，因为它需要时间去寻找在类中实现的方法。|
|添加新方法|   如果你往抽象类中添加新的方法，你可以给它提供默认的实现。因此你不需要改变你现在的代码。| 如果你往接口中添加方法，那么你必须改变实现该接口的类。|

* 抽象方法

抽象方法具体实现在子类中。在父类中，抽象方法只包含一个方法名，没有方法体。

子类必须重写父类的抽象方法，或者声明自身为**抽象类**。


### 1.3.3 synchronized修饰符
synchronized关键字声明的方法同一时间只能被**同一个线程**访问。

```java
public synchronized void showDetails(){

}
```

### 1.3.4 transient修饰符
序列化的对象包含被transient修饰的实例变量时，java虚拟机（JVM）跳过该特定的变量。

作用：在序列化时，有的属性需要序列化，有的不需要序列化。比如一个用户的敏感信息（密码、银行卡号等），不希望在网络操作中被传输，则可以加上transient。这个字段的生命周期仅存于调用者的内存中而不会写到磁盘中持久化。

### 1.3.5 volatile修饰符
每次线程访问时，都强制从共享内存中重新读取改成员变量的值。当成员变量发生变化时，会强制线程将变化值写回共享内存。

## 1.4 运算符

### 1.4.1 >>>和>>

\>\>：表示有符号右移，正数右移高位补0,负数右移高位补1。

\>\>\>：表示无符号右移，负数和正数，高位通通补0。

### 1.4.2 条件运算符

?:和C一样。

### 1.4.3 instanceof

检查对象是否是一个特定类型（类类型和接口类型）

```java
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

```java
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

```java
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

```java
dataType[] arrayRefVar;//首选方法
dataType arrayRefVar[];//效果相同，但不是首选方法

dataType[] arrayRefVar = new dataType[arraySize];//第一步，使用dataType[arraySize]创建一个数组；第二步，把新创建的数组的引用复制给变量arrayRefVar
```

* foreach循环

```java
for(dataType element : arrayRefVar){}
```

* 多维数组

```java
int a[][] = new int[2][3];
```

多维数组的动态初始化

```java
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

```java
Date(int year,int month,int date);//以int型表示年月日

Date(int year,int month,int date,int hour,int min);

Date(int year,int month,int date,int hour,int min,int sec);

```

### 1.9.2 方法

* get时间

```java
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

```java

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

```java
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

```java
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

```java
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

\\\\：插入一个正则表达式的反斜线，其后的字符具有特殊意义。即\\\\d表示\\d。

具体将菜鸟教程。

## 1.11 可变参数

```java
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

```java
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

```java
BufferReader br = new BufferReader(new InputStreamReader(System.in));
```

后面用read()方法从控制台读取一个字符，用readLine()方法读取一个字符串。

* 读取字符

```java
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

```
输入字符, 按下 'q' 键退出。
runoob
r
u
n
o
o
b


q
q
```

* 读字符串

```java
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

```
Enter lines of text.
Enter 'end' to quit.
This is line one
This is line one
This is line two
This is line two
end
end
```

**Scanner**
hasNext()和hasNextLine()来判断是否还有输入数据

next()和nextLine()方法获取输入的字符串。

```java
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

```java
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

```
12
23
15
21.4
end
4个数的和为71.4
4个数的平均值是17.85
```

**Console**

输入的时候字符都是可见的，所以Scanner类不适合从控制台读取密码。从Java SE 6开始特别引入了Console类来实现这个目的。若要读取一个密码，可以采用下面这段代码:

```java
Console cons = System.console();
String username = cons.readline("User name: ");
char[] passwd = cons.readPassword("Password: ");
```
### 1.13.2 读写文件
* FileInputStream

该流从文件读取数据，可以用new来创建。

```java
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

```java
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

### 1.14.1 异常发生原因分类
1、用户输入非法数据

2、要打开的文件不存在

3、网络通信时连接中断，或者JVM内存溢出

### 1.14.2 Exception类的层次
异常类都是java.lang.Exception类继承的子类。

Exception是Throwable类的子类，Throwable类还有子类Error。

Throwable

|

|-----Error

|

|-----Exception


Exception

|

|-----IOException

|

|-----RuntimeException

* 内置异常类

java定义了异常类在java.lang标准包中

**非检查性异常**

运行时出现的异常。比如溢出等。

```
ArithmeticException 当出现异常的运算条件时，抛出此异常。例如，一个整数"除以零"时，抛出此类的一个实例。
ArrayIndexOutOfBoundsException  用非法索引访问数组时抛出的异常。如果索引为负或大于等于数组大小，则该索引为非法索引。
ArrayStoreException 试图将错误类型的对象存储到一个对象数组时抛出的异常。
ClassCastException  当试图将对象强制转换为不是实例的子类时，抛出该异常。
IllegalArgumentException    抛出的异常表明向方法传递了一个不合法或不正确的参数。
IllegalMonitorStateException    抛出的异常表明某一线程已经试图等待对象的监视器，或者试图通知其他正在等待对象的监视器而本身没有指定监视器的线程。
IllegalStateException   在非法或不适当的时间调用方法时产生的信号。换句话说，即 Java 环境或 Java 应用程序没有处于请求操作所要求的适当状态下。
IllegalThreadStateException 线程没有处于请求操作所要求的适当状态时抛出的异常。
IndexOutOfBoundsException   指示某排序索引（例如对数组、字符串或向量的排序）超出范围时抛出。
NegativeArraySizeException  如果应用程序试图创建大小为负的数组，则抛出该异常。
NullPointerException    当应用程序试图在需要对象的地方使用 null 时，抛出该异常
NumberFormatException   当应用程序试图将字符串转换成一种数值类型，但该字符串不能转换为适当格式时，抛出该异常。
SecurityException   由安全管理器抛出的异常，指示存在安全侵犯。
StringIndexOutOfBoundsException 此异常由 String 方法抛出，指示索引或者为负，或者超出字符串的大小。
UnsupportedOperationException   当不支持请求的操作时，抛出该异常。
```

**检查性异常**

编译的时候的异常。例如打开一个不存在的文件，一个异常发生。

```
ClassNotFoundException  应用程序试图加载类时，找不到相应的类，抛出该异常。
CloneNotSupportedException  当调用 Object 类中的 clone 方法克隆对象，但该对象的类无法实现 Cloneable 接口时，抛出该异常。
IllegalAccessException  拒绝访问一个类的时候，抛出该异常。
InstantiationException  当试图使用 Class 类中的 newInstance 创建一个类的实例，而指定的类对象因为是一个接口或是一个抽象类而无法实例化时，抛出该异常。
InterruptedException    一个线程被另一个线程中断，抛出该异常。
NoSuchFieldException    请求的变量不存在
NoSuchMethodException   请求的方法不存在
```

**异常方法**

```
public String getMessage()    返回关于发生的异常的详细信息。这个消息在Throwable 类的构造函数中初始化了。
public Throwable getCause()    返回一个Throwable 对象代表异常原因。
public String toString()     使用getMessage()的结果返回类的串级名字。
public void printStackTrace()    打印toString()结果和栈层次到System.err，即错误输出流。
public StackTraceElement [] getStackTrace()   返回一个包含堆栈层次的数组。下标为0的元素代表栈顶，最后一个元素代表方法调用堆栈的栈底。
public Throwable fillInStackTrace()     用当前的调用栈层次填充Throwable 对象栈层次，添加到栈层次任何先前信息中。
```

实例：

```java
import java.io.*;
public class ExcepTest{
 
   public static void main(String args[]){
      try{
         int a[] = new int[2];
         System.out.println("Access element three :" + a[3]);
      }catch(ArrayIndexOutOfBoundsException e){    //这里是定义一个要捕获的异常名，这里是ArrayIndexOutOfBoundsException
         System.out.println("Exception thrown  :" + e);
      }
      System.out.println("Out of the block");
   }
}
```

多重捕获块：

```java
try{
   // 程序代码
}catch(异常类型1 异常的变量名1){   //如果异常，先抛给这个。如果不匹配，则抛给下一个。
  // 程序代码
}catch(异常类型2 异常的变量名2){
  // 程序代码
}catch(异常类型2 异常的变量名2){
  // 程序代码
}
```

### 1.14.3 throws/throw关键字

如果一个方法不处理检查性异常，而交给方法调用处进行处理，则该方法必须使用throws关键字来声明。可以抛出多个异常，用逗号隔开。throws表示这个方法有可能抛出的异常。

也可以用throw关键字抛出异常，无论它是新实例化的还是刚捕获到的。

区别：throws表示一个方法声明可能抛出一个异常，throw表示此处抛出一个自定义的异常（可以自定义，需要继承Exception，也可以是java自身给出的异常类）

```java
import java.io.*;
public class className
{
  public void deposit(double amount) throws RemoteException,InsufficientFundsException    //异常交给
  {
    // Method implementation
    throw new RemoteException();//抛出异常
  }
  //Remainder of class definition
}
```

### 1.14.4 finally关键字

finally代码块中，可以运行清理类型等收尾善后性质的语句。

* 使用案例
```java
try{
  // 程序代码
}catch(异常类型1 异常的变量名1){
  // 程序代码
}catch(异常类型2 异常的变量名2){
  // 程序代码
}finally{
  // 程序代码
}
```

* 特殊情况

**这里会返回2,而不是1。因为finally总是比catch的return先执行。**

 **catch 块中有退出系统的语句 System.exit(-1); finally就不会被执行**

```java

try{
   //待捕获代码    
}catch（Exception e）{
    System.out.println("catch is begin");
    return 1 ；
}finally{
     System.out.println("finally is begin");
     return 2 ;
}
```


### 1.14.5 声明自定义异常
* 所有异常都是必须时Trowable的子类
* 如果希望写一个检查性异常类，则需要继承Exception类。
* 如果希望写一个运行时异常类，需要继承RuntimeException

* 自定义一个异常类

CheckingAccount类中包含一个withdraw方法抛出一个insufficientFundsException

```java
// 文件名称 CheckingAccount.java
import java.io.*;
 
//此类模拟银行账户
public class CheckingAccount
{
  //balance为余额，number为卡号
   private double balance;
   private int number;
   public CheckingAccount(int number)
   {
      this.number = number;
   }
  //方法：存钱
   public void deposit(double amount)
   {
      balance += amount;
   }
  //方法：取钱
   public void withdraw(double amount) throws
                              InsufficientFundsException
   {
      if(amount <= balance)
      {
         balance -= amount;
      }
      else
      {
         double needs = amount - balance;
         throw new InsufficientFundsException(needs);
      }
   }
  //方法：返回余额
   public double getBalance()
   {
      return balance;
   }
  //方法：返回卡号
   public int getNumber()
   {
      return number;
   }
}
```

```java
//文件名称 BankDemo.java
public class BankDemo
{
   public static void main(String [] args)
   {
      CheckingAccount c = new CheckingAccount(101);
      System.out.println("Depositing $500...");
      c.deposit(500.00);
      try
      {
         System.out.println("\nWithdrawing $100...");
         c.withdraw(100.00);
         System.out.println("\nWithdrawing $600...");
         c.withdraw(600.00);
      }catch(InsufficientFundsException e)
      {
         System.out.println("Sorry, but you are short $"
                                  + e.getAmount());
         e.printStackTrace();
      }
    }
}

```

* 实用案例

```java
/**
 * 异常:
 * finally不一定被执行，，例如 catch 块中有退出系统的语句 System.exit(-1); finally就不会被执行
 *
 */
import java.io.*;
public class Demo {

    /**
     * @param args
     */
    public static void main(String[] args) {
        
        //检查异常1.打开文件
        FileReader fr=null;
        try {
            fr=new FileReader("d:\\aa.text");
            // 在出现异常的地方，下面的代码的就不执行
            System.out.println("aaa");
        } catch (Exception e) {
            System.out.println("进入catch");
            // 文档读取异常
            // System.exit(-1);
            System.out.println("message="+e.getLocalizedMessage());  //没有报哪一行出错
            e.printStackTrace();   // 打印出错异常还出现可以报出错先异常的行
        }
        // 这个语句块不管发生没有发生异常，都会执行
        // 一般来说，把需要关闭的资源，文件，连接，内存等
        finally
        {
            System.out.println("进入finally");
            if(fr!=null);
            {
                try {
                    fr.close();
                } catch (Exception e) {
                    // TODO: handle exception
                    e.printStackTrace();
                }
            }
        }
        System.out.println("OK");
    }
}
```

## 1.X 注释

```java
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

```java
/**
* 类方法的详细使用说明
*
* @param 参数1 参数1的使用说明
* @return 返回结果的说明
* @throws 异常类型.错误代码 注明从此类方法中抛出异常的说明
*/
```

```java
/**
* 构造方法的详细使用说明
*
* @param 参数1 参数1的使用说明
* @throws 异常类型.错误代码 注明从此类方法中抛出异常的说明
*/
```

# 2、Java面向对象
## 2.1 简单使用
注：Java不支持多继承，即一个子类不能继承多个父类。但是可以支持多重继承，即A类继承B，B类继承C。

使用：

```java
//公共父类
public class Animal { 
    private String name;  
    private int id; 
    public Animal(String myName, int myid) { 
        name = myName; 
        id = myid;
    } 
    public void eat(){ 
        System.out.println(name+"正在吃"); 
    }
    public void sleep(){
        System.out.println(name+"正在睡");
    }
    public void introduction() { 
        System.out.println("大家好！我是"         + id + "号" + name + "."); 
    } 
}
```

```java
//企鹅类
public class Penguin extends Animal {   //extends继承
    public Penguin(String myName, int myid) { 
        super(myName, myid); //通过super来调用父类的方法来初始化
    } 
}
```

## 2.2 关键字
### 2.2.1 extends关键字
只能继承一个父类。


### 2.2.2 implements关键字
implements关键字可以变相使java具有多继承的特性，适用范围为类继承接口的情况，可以同时继承多个接口。

```java
public interface A {
    public void eat();
    public void sleep();
}
 
public interface B {
    public void show();
}
 
public class C implements A,B {
}
```

### 2.2.3 final关键字
在实例变量中也出现过final，表示该变量不能被修改。

在继承中，final修饰的class（类）不能被继承,同时类内的方法自动声明为final，但是类内的实例变量不是final。

```java
//final声明类名
final class 类名{}
```

```java
//final声明方法
修饰符(public/private/default/protected) final 返回值类型 方法名(){}
```

final的总结：

final修饰属性或变量：不管是基本类型还是引用，其中的值不能变。引用类型变量里买内存放的是一个地址，所以用final修饰引用类型变量指的是它的地址不变，而地址中的数值可以改变。

final修饰类中的方法：方法可以被继承，但是无法重写。

final修饰类：类不可以被继承。

## 2.3 构造器

调用父类的构造方法的唯一途径是使用super关键字。

子类不能继承父类的构造器，如果父类的构造器**带有参数**，则**必须**在子类的构造其中显式通过super关键字调用父类的构造器并配以适当的参数列表。

如果没有参数并且子类的构造函数没有显式调用父类的含参构造方法，在编译的时候，会自动给子类的第一个语句放上super()。

```java

class SuperClass {
  private int n;
  SuperClass(){
    System.out.println("SuperClass()");
  }
  SuperClass(int n) {
    System.out.println("SuperClass(int n)");
    this.n = n;
  }
}
class SubClass extends SuperClass{
  private int n;
  
  SubClass(){
    super(300);
    System.out.println("SubClass");
  }  
  
  public SubClass(int n){
    System.out.println("SubClass(int n):"+n);
    this.n = n;
  }
}
public class TestSuperSub{
  public static void main (String args[]){
    SubClass sc = new SubClass();
    SubClass sc2 = new SubClass(200); 
  }
}
```

注意：

java文件被编译成class文件时，在子类的所有构造函数中的第一行（第一个语句）默认自动添加super()语句，在执行子类的构造函数之前，总是会先执行父类中的构造函数。

1、如果父类中不包含默认构造函数，那么子类中的super()语句 就会执行失败，系统就会报错。一般默认构造函数编译时会自动添加，但如果类中已经有了一个构造函数，就不会添加。

2、执行父类构造函数的语句只能放在函数内语句的首句，不然会报错。

在继承关系中，在调用函数（方法）或者类中的成员变量时，JVM（Java虚拟机）会先检测 当前类（子类）是否含有该函数或者成员变量，如果有就执行子类中的，如果咩有才会执行父类的。

## 2.4 Java转型问题
1、父类引用指向子类对象，而子类引用不能指向父类对象。

```java
Father f1 = new Son();//向上转型，父类引用可以指向子类对象
Son s1 = (Son)f1;//向下转型，f1指向子类对象，s1指向f1即指向子类对象
```

但是f1不能调用Son中Father没有的方法。

```java
Father f2 = new Father();
Son s2 = (Son)f2;//错误，子类引用不能指向父类对象，
```

## 2.5 Java重写(Override)和重载(Overload)
### 2.5.1 重写
1、子类对父类的允许访问的方法实现过程进行重新编写，返回值和形参都不能改变。即外壳不变，核心重写。

2、重写方法不能抛出新的检查异常或者比被重写方法更加宽泛的异常。

例如，父类抛出检查异常IOException，重写的时候不能Exception异常（因为Exception是IOException的父类，只能抛出IOException的子类异常）。

**重写规则**

>参数列表必须完全与被重写方法的相同；
>返回类型必须完全与被重写方法的返回类型相同；
>访问权限不能比父类中被重写的方法的访问权限更低。例如：如果父类的一个方法被声明为public，那么在子类中重写该方法就不能声明为protected。
>父类的成员方法只能被它的子类重写。
>声明为final的方法不能被重写。
>声明为static的方法不能被重写，但是能够被再次声明。
>子类和父类在同一个包中，那么子类可以重写父类所有方法，除了声明为private和final的方法。
>子类和父类不在同一个包中，那么子类只能够重写父类的声明为public和protected的非final方法。
>重写的方法能够抛出任何非强制异常，无论被重写的方法是否抛出异常。但是，重写的方法不能抛出新的强制性异常，或者比被重写方法声明的更广泛的强制性异常，反之则可以。
>构造方法不能被重写。
>如果不能继承一个方法，则不能重写这个方法。

可以使用super来调用父类被重写的方法。

### 2.5.2 重载
在同一个类中，方法名字相同，但是参数不同。

**重载规则**

>被重载的方法必须改变参数列表(参数个数或类型不一样)；
>被重载的方法可以改变返回类型；
>被重载的方法可以改变访问修饰符；
>被重载的方法可以声明新的或更广的检查异常；
>方法能够在同一个类中或者在一个子类中被重载。
>无法以返回值类型作为重载函数的区分标准。

### 2.5.3 重写与重载的区别

|区别点 |重载方法|    重写方法|
|-|-|-|
|参数列表|    必须修改 |   一定不能修改|
|-|-|-|
|返回类型|    可以修改|    一定不能修改|
|-|-|-|
|异常|  可以修改|    可以减少或删除，一定不能抛出新的或者更广的异常|
|-|-|-|
|访问 | 可以修改   | 一定不能做更严格的限制（可以降低限制）|
|-|-|-|

## 2.6 多态
### 2.6.1 介绍
同一个行为具有多个不同表现形式或者形态的能力。

下面使用instanceof实现了识别不通的类，进行不同的操作（多态）。
```java
public class Test {
    public static void main(String[] args) {
      show(new Cat());  // 以 Cat 对象调用 show 方法
      show(new Dog());  // 以 Dog 对象调用 show 方法
                
      Animal a = new Cat();  // 向上转型  
      a.eat();               // 调用的是 Cat 的 eat
      Cat c = (Cat)a;        // 向下转型  
      c.work();        // 调用的是 Cat 的 work
  }  
            
    public static void show(Animal a)  {
      a.eat();  
        // 类型判断
        if (a instanceof Cat)  {  // 猫做的事情 
            Cat c = (Cat)a;  
            c.work();  
        } else if (a instanceof Dog) { // 狗做的事情 
            Dog c = (Dog)a;  
            c.work();  
        }  
    }  
}
 
abstract class Animal {  
    abstract void eat();  
}  
  
class Cat extends Animal {  
    public void eat() {  
        System.out.println("吃鱼");  
    }  
    public void work() {  
        System.out.println("抓老鼠");  
    }  
}  
  
class Dog extends Animal {  
    public void eat() {  
        System.out.println("吃骨头");  
    }  
    public void work() {  
        System.out.println("看家");  
    }  
}
```

* Java对比C++(多态)

C++的多态通过定义虚函数来实现，即用virtual来声明方法，子类可以重新定义该方法。如果在父类中没有声明virtual则子类对象实际调用的是父类的方法。

Java中，当子类对象调用重写的方法时，调用的是子类的方法，而不是父类中被重写的方法。

>C++的虚函数可以在子类中重写，调用是根据实际的对象来判别的，而不是通过指针类型(普通函数的调用是根据当前指针类型来判断的)。纯虚函数是一种在父函数中只定义而不实现的一种函数，不能用来声明对象，也可以被称为抽象类。纯虚函数的实现也可以在类声明外进行定义。C++中的抽象类abstract class是指至少有一个纯虚函数的类，如果一个类全部由纯虚函数组成，不包括任何的实现，被称为纯虚类。

>Java中的普通函数自带虚函数功能，调用是根据指针所指向的对象的类型进行判断的。Java中没有virtual这个关键字，java管虚函数叫abstract function，管抽象类叫做abstract class，没有pure这个概念，而是发明了一种叫接口interface的东西来代替纯虚类。interface和abstract class的区别就类似于C++中一般抽象类和纯虚类的区别。

>抽象类只能作为基类来使用，不能被定义对象，其纯虚函数的实现在派生类中，如果派生类也没有给出实现，则该派生类还是一个抽象类，只有给出了纯虚函数实现的派生类才能建立对象。由此看出抽象类是注孤生的节奏啊，永远没有对象。

### 2.6.2 多态的实现方法

1、重写

Java函数自带重写功能，不需要像C++一样声明virtual。（C++父类声明virtual方法，才能在子类中重写）

2、接口

Java用interface声明接口，用implement继承接口。

3、抽象类和抽象方法

抽象类不能实例化对象，必须被继承后才能使用。

抽象方法即在父类中声明该方法为抽象方法，具体实现由子类决定。

## 2.7 Java封装
比如把属性和变量设为pirvate，并只能通过方法名来获取或者重新赋值。

## 2.8 Java接口
[可见度] interface 接口名称[extends 其他接口]

注：这里的extends没有错误，接口和接口通过extends继承，并且可以**多继承**。

只能够有静态的不能被修改的数据成员，即public static final。不过在interface中一般不定义数据成员。

接口中的方法都必须时抽象方法，不能包含除了static和final的变量。**接口是需要被类实现的，接口的方法没有具体的实现。**

**接口的意义**

可以理解成统一的协议，实现类和接口分离。

## 2.9 标记接口
没有包含任何方法和属性的接口。

作用：

1、建立一个公共的父接口

比如EventListener接口，由几十个其他接口拓展的Java API，可以用一个标记接口建立一组接口的父接口。

如果继承了EventListener接口，JVM就知道该接口将要备用与一个事件的代理方案。

**可以用if(obj instanceof ...)进行类型查询。**

2、向一个类添加数据类型

## 2.10 Java包

### 2.10.1 包的作用

1、把功能相似或相关的类或接口组织在同一个包中，方便类的查找和使用。

2、如同文件夹一样，包也采用了树形目录的存储方式。同一个包中的类名字是不同的，不同的包中的类的名字是可以相同的，当同时调用两个不同包中相同类名的类时，应该加上包名加以区别。因此，包可以避免名字冲突。

3、包也限定了访问权限，拥有包访问权限的类才能访问某个包中的类。

### 2.10.2 包的使用

package pkg1[.pkg2[.pkg3...]]

* package创建包

创建一个目录，包放置其中，并用"package 目录名"来声明。

```java
/* 文件名: Animal.java */
//如果一个源文件中没有使用包声明，则其中的类、函数、枚举、注释等将放在一个无名的包中
package animals;  //包声明应该在源文件的第一行，每个源文件只能包含一个包声明
 
interface Animal {
   public void eat();
   public void travel();
}
```

* import导入包

```java
import pkg1[.pkg2..].(classname|\*);
```

* package的目录结构

通常一个公司使用它互联网域名的颠倒形式来作为它的包名。

例如....\com\runoob\test\Runoob.java

# 3、Java高级编程
## 3.1 数据结构
### 3.1.1 枚举(Enumeration)
枚举接口定义了一种从数据结构中取回连续元素的方式。

方法：（传统的接口已经被迭代器取代）

|boolean hasMoreElements( ) |测试此枚举是否包含更多的元素。|
|-|-|
|Object nextElement( )|如果此枚举对象至少还有一个可提供的元素，则返回此枚举的下一个元素。|

```java
import java.util.Vector;
import java.util.Enumeration;
 
public class EnumerationTester {
 
   public static void main(String args[]) {
      Enumeration<String> days;//定义一个枚举
      Vector<String> dayNames = new Vector<String>();
      dayNames.add("Sunday");
      dayNames.add("Monday");
      dayNames.add("Tuesday");
      dayNames.add("Wednesday");
      dayNames.add("Thursday");
      dayNames.add("Friday");
      dayNames.add("Saturday");
      days = dayNames.elements();
      while (days.hasMoreElements()){  //测试此枚举是否包含更多的元素
         System.out.println(days.nextElement()); //返回枚举的下一个元素
      }
   }
}
```

### 3.1.2 位集合(BitSet)
位集合类实现了一组可以单独设置和清除的位和标志。

```java
import java.util.BitSet;
 
public class BitSetDemo {
 
  public static void main(String args[]) {
     BitSet bits1 = new BitSet(16);//指定16位，初始化为0
     BitSet bits2 = new BitSet(16);
      
     // set some bits
     for(int i=0; i<16; i++) {
        if((i%2) == 0) bits1.set(i);
        if((i%5) != 0) bits2.set(i);
     }
     System.out.println("Initial pattern in bits1: ");
     System.out.println(bits1);
     System.out.println("\nInitial pattern in bits2: ");
     System.out.println(bits2);
 
     // AND bits，逻辑与
     bits2.and(bits1);//这里bits2变成了逻辑与后的值
     System.out.println("\nbits2 AND bits1: ");
     System.out.println(bits2);
 
     // OR bits
     bits2.or(bits1);
     System.out.println("\nbits2 OR bits1: ");
     System.out.println(bits2);
 
     // XOR bits
     bits2.xor(bits1);
     System.out.println("\nbits2 XOR bits1: ");
     System.out.println(bits2);
  }
}
```

输出：

```
Initial pattern in bits1:
{0, 2, 4, 6, 8, 10, 12, 14}

Initial pattern in bits2:
{1, 2, 3, 4, 6, 7, 8, 9, 11, 12, 13, 14}

bits2 AND bits1:   
{2, 4, 6, 8, 12, 14}

bits2 OR bits1:   // bits2 = {2, 4, 6, 8, 12, 14} 
{0, 2, 4, 6, 8, 10, 12, 14}

bits2 XOR bits1:   // bits2 = {0, 2, 4, 6, 8, 10, 12, 14}
{}
```

### 3.1.3 向量(Vector)
```java
Vector();//建立一个默认的向量，长度10
Vector(int size);//指定大小
Vector(int size,int incr);//指定大小，并增量用incr指定
Vector(Collection c);//创建一个包含集合c元素的向量
```

具体方法见菜鸟。

### 3.1.4 栈(Stack)

方法

```java
Stack();//  创建一个默认的栈
boolean empty();//测试栈是否为空
Object peek( );//查看栈顶，但不弹出
Object pop( );//移除堆栈顶部的对象，并作为此函数的值返回该对象。
Object push(Object element);//把项压入堆栈顶部。
int search(Object element);//返回对象在堆栈中的位置，以 1 为基数。
```

### 3.1.5 字典Dictionary
* 字典类

字典**类**是一个抽象类，定义了键映射到值的数据结构。

字典已经过时，实际开发中，可以实现Map接口来获取键/值的存储关系。

* Map**接口**

map已经代替了字典dictionary。

```java
import java.util.*;

public class CollectionsDemo {

   public static void main(String[] args) {
      Map m1 = new HashMap(); //hashmap
      m1.put("Zara", "8");
      m1.put("Mahnaz", "31");
      m1.put("Ayan", "12");
      m1.put("Daisy", "14");
      System.out.println();
      System.out.println(" Map Elements");
      System.out.print("\t" + m1);
   }
}
```

* 使用规则

>给定一个键和一个值，你可以将该值存储在一个Map对象. 之后，你可以通过键来访问对应的值。
>当访问的值不存在的时候，方法就会抛出一个NoSuchElementException异常.
>当对象的类型和Map里元素类型不兼容的时候，就会抛出一个 ClassCastException异常。
>当在不允许使用Null对象的Map中使用Null对象，会抛出一个NullPointerException 异常。
>当尝试修改一个只读的Map时，会抛出一个UnsupportedOperationException异常。

```
void clear( )
 从此映射中移除所有映射关系（可选操作）。
boolean containsKey(Object k)
如果此映射包含指定键的映射关系，则返回 true。
boolean containsValue(Object v)
如果此映射将一个或多个键映射到指定值，则返回 true。
Set entrySet( )
返回此映射中包含的映射关系的 Set 视图。
boolean equals(Object obj)
比较指定的对象与此映射是否相等。
Object get(Object k)
返回指定键所映射的值；如果此映射不包含该键的映射关系，则返回 null。
int hashCode( )
返回此映射的哈希码值。
boolean isEmpty( )
如果此映射未包含键-值映射关系，则返回 true。
Set keySet( )
返回此映射中包含的键的 Set 视图。
Object put(Object k, Object v)
将指定的值与此映射中的指定键关联（可选操作）。
void putAll(Map m)
从指定映射中将所有映射关系复制到此映射中（可选操作）。
Object remove(Object k)
如果存在一个键的映射关系，则将其从此映射中移除（可选操作）。
int size( )
返回此映射中的键-值映射关系数。
Collection values( )
返回此映射中包含的值的 Collection 视图。
```

### 3.1.6 哈希表(Hashtable)
哈希表是java.util的一部分，是Dictionary具体的实现，提供了一种在用户定义键结构的基础上组织数据的手段。Hashtable类和HashMap类很相似，但是Hashtable支持同步。

Hashtable也存储键/值对。

例如，在地址列表的哈希表中，可以根据邮政编码作为键来存储和排序数据，而不是通过人名。

* 构造方法

```java
Hashtable();
Hashtable(int size );
Hashtable(int size,float fillRatio);//通过fillRatio指定填充比例，介于0.0至1.0之间，决定了哈希表在重新调整大小之前的充满程度
Hashtable(Map m);//构建一个以m中元素为初始化元素的哈希表，哈希表容量设置为m的两倍
```

**Hashtable包括Map接口中定义的方法**，还定义了：

```java
void clear( )
 将此哈希表清空，使其不包含任何键。
Object clone( )
创建此哈希表的浅表副本。
boolean contains(Object value)
 测试此映射表中是否存在与指定值关联的键。
boolean containsKey(Object key)
测试指定对象是否为此哈希表中的键。
boolean containsValue(Object value)
如果此 Hashtable 将一个或多个键映射到此值，则返回 true。
Enumeration elements( )
返回此哈希表中的值的枚举。
Object get(Object key)
 返回指定键所映射到的值，如果此映射不包含此键的映射，则返回 null. 更确切地讲，如果此映射包含满足 (key.equals(k)) 的从键 k 到值 v 的映射，则此方法返回 v；否则，返回 null。
boolean isEmpty( )
测试此哈希表是否没有键映射到值。
Enumeration keys( )
 返回此哈希表中的键的枚举。
Object put(Object key, Object value)
将指定 key 映射到此哈希表中的指定 value。
void rehash( )
增加此哈希表的容量并在内部对其进行重组，以便更有效地容纳和访问其元素。
Object remove(Object key)
从哈希表中移除该键及其相应的值。
int size( )
 返回此哈希表中的键的数量。
String toString( )
返回此 Hashtable 对象的字符串表示形式，其形式为 ASCII 字符 ", " （逗号加空格）分隔开的、括在括号中的一组条目。
```

### 3.1.7 属性(Properties)
**Properties继承于Hashtable**,表示一个持久的属性集。属性列表中每个键和其对因值都是一个字符串。

* 构造函数

```java
Properties();
Properties(Properties propDefault);//使用propDefault作为默认值

```

```java
String getProperty(String key)
 用指定的键在此属性列表中搜索属性。
String getProperty(String key, String defaultProperty)
用指定的键在属性列表中搜索属性。
void list(PrintStream streamOut)
 将属性列表输出到指定的输出流。
void list(PrintWriter streamOut)
将属性列表输出到指定的输出流。
void load(InputStream streamIn) throws IOException
 从输入流中读取属性列表（键和元素对）。
Enumeration propertyNames( )
按简单的面向行的格式从输入字符流中读取属性列表（键和元素对）。
Object setProperty(String key, String value)
 调用 Hashtable 的方法 put。
void store(OutputStream streamOut, String description)
 以适合使用  load(InputStream)方法加载到 Properties 表中的格式，将此 Properties 表中的属性列表（键和元素对）写入输出流。
```

实例：

```java
import java.util.*;
 
public class PropDemo {
 
   public static void main(String args[]) {
      Properties capitals = new Properties();
      Set states;
      String str;
      
      capitals.put("Illinois", "Springfield");//加入属性
      capitals.put("Missouri", "Jefferson City");
      capitals.put("Washington", "Olympia");
      capitals.put("California", "Sacramento");
      capitals.put("Indiana", "Indianapolis");
 
      // Show all states and capitals in hashtable.
      states = capitals.keySet(); // key的set视图
      Iterator itr = states.iterator();//生成一个迭代器
      while(itr.hasNext()) {
         str = (String) itr.next();
         System.out.println("The capital of " +
            str + " is " + capitals.getProperty(str) + ".");
      }
      System.out.println();
 
      // look for state not in list -- specify default
      str = capitals.getProperty("Florida", "Not Found");
      System.out.println("The capital of Florida is "
          + str + ".");
   }
}

```

* 迭代器


> (1) 使用方法 iterator() 要求容器返回一个 Iterator。第一次调用 Iterator 的 next() 方法时，它返回序列的第一个元素。注意：iterator() 方法是 java.lang.Iterable 接口,被 Collection 继承。
 >(2) 使用 next() 获得序列中的下一个元素。
 >(3) 使用 hasNext() 检查序列中是否还有元素。
 >(4) 使用 remove() 将迭代器新返回的元素删除。

## 3.2 Java集合框架
集合框架包括：

**接口**：代表集合的抽象数据类型，例如Collection、List、Set、Map。之所以定义多个接口，是为了以不同的方式操作集合对象。

**实现(类)**：集合接口的具体体现。它们是可重复使用的数据结构，如ArrayList、LinkedList、HashSet、HashMap等

**算法**：实现集合接口的对象里的方法执行的一些有用的计算，如搜索和排序。这些算法被称为多态，因为相同的方法可以在相似的接口上有着不同的实现。



```
Collection 接口
Collection 是最基本的集合接口，一个 Collection 代表一组 Object，即 Collection 的元素, Java不提供直接继承自Collection的类，只提供继承于的子接口(如List和set)。
Collection 接口存储一组不唯一，无序的对象。

List 接口
List接口是一个有序的 Collection，使用此接口能够精确的控制每个元素插入的位置，能够通过索引(元素在List中位置，类似于数组的下标)来访问List中的元素，第一个元素的索引为 0，而且允许有相同的元素。

List 接口存储一组不唯一，有序（插入顺序）的对象。

Set
Set 具有与 Collection 完全一样的接口，只是行为上不同，Set 不保存重复的元素。

Set 接口存储一组唯一，无序的对象。

SortedSet 
继承于Set保存有序的集合。

Map
Map 接口存储一组键值对象，提供key（键）到value（值）的映射。

Map.Entry 
描述在一个Map中的一个元素（键/值对）。是一个Map的内部类。

SortedMap
继承于 Map，使 Key 保持在升序排列。

Enumeration
这是一个传统的接口和定义的方法，通过它可以枚举（一次获得一个）对象集合中的元素。这个传统接口已被迭代器取代。
```

<img src="/images/wiki/Java/JavaSets1.gif" width="400" alt="JavaSets1" />

<img src="/images/wiki/Java/JavaSets12.png" width="400" alt="JavaSets2" />

**List和Set的区别**

1. Set 接口实例存储的是无序的，无法保证每个元素的存储顺序，不重复的数据。List 接口实例存储的是有序的，保持了每个元素的插入顺序，输出的顺序就是插入的顺序，可以重复的元素。

2. Set检索效率低下，删除和插入效率高，插入和删除不会引起元素位置改变 <实现类有HashSet,TreeSet>。

3. List和数组类似，可以动态增长，根据实际存储的数据的长度自动增长List的长度。查找元素效率高，插入删除效率低，因为会引起其他元素位置改变 <实现类有ArrayList,LinkedList,Vector> 。

* 集合实现类

```
AbstractCollection 
实现了大部分的集合接口。

AbstractList 
继承于AbstractCollection 并且实现了大部分List接口。

AbstractSequentialList 
继承于 AbstractList ，提供了对数据元素的链式访问而不是随机访问。

LinkedList
该类实现了List接口，允许有null（空）元素。主要用于创建链表数据结构，该类没有同步方法，如果多个线程同时访问一个List，则必须自己实现访问同步，解决方法就是在创建List时候构造一个同步的List。例如：
Listlist=Collections.synchronizedList(newLinkedList(...));
LinkedList 查找效率低。

ArrayList
该类也是实现了List的接口，实现了可变大小的数组，随机访问和遍历元素时，提供更好的性能。该类也是非同步的,在多线程的情况下不要使用。ArrayList 增长当前长度的50%，插入删除效率低。

AbstractSet 
继承于AbstractCollection 并且实现了大部分Set接口。

HashSet
该类实现了Set接口，不允许出现重复元素，不保证集合中元素的顺序，允许包含值为null的元素，但最多只能一个。

LinkedHashSet
具有可预知迭代顺序的 Set 接口的哈希表和链接列表实现。

TreeSet
该类实现了Set接口，可以实现排序等功能。

AbstractMap 
实现了大部分的Map接口。

HashMap 
HashMap 是一个散列表，它存储的内容是键值对(key-value)映射。
该类实现了Map接口，根据键的HashCode值存储数据，具有很快的访问速度，最多允许一条记录的键为null，不支持线程同步。

TreeMap 
继承了AbstractMap，并且使用一颗树。

WeakHashMap 
继承AbstractMap类，使用弱密钥的哈希表。

LinkedHashMap 
继承于HashMap，使用元素的自然顺序对元素进行排序.

IdentityHashMap 
继承AbstractMap类，比较文档时使用引用相等。

```

* 迭代器使用

```java
import java.util.*;
 
public class Test{
 public static void main(String[] args) {
     List<String> list=new ArrayList<String>();
     list.add("Hello");
     list.add("World");
     list.add("HAHAHAHA");
     //第一种遍历方法使用foreach遍历List
     for (String str : list) {            //也可以改写for(int i=0;i<list.size();i++)这种形式
        System.out.println(str);
     }
 
     //第二种遍历，把链表变为数组相关的内容进行遍历
     String[] strArray=new String[list.size()];
     list.toArray(strArray);
     for(int i=0;i<strArray.length;i++) //这里也可以改写为  foreach(String str:strArray)这种形式
     {
        System.out.println(strArray[i]);
     }
     
    //第三种遍历 使用迭代器进行相关遍历
     
     Iterator<String> ite=list.iterator();
     while(ite.hasNext())//判断下一个元素之后有值
     {
         System.out.println(ite.next());
     }
 }
}
```

## 3.3 Java泛型
泛型提供编译时类型安全检测机制，该机制允许程序员在编译时检测到非法的类型。

需求：写一个排序方法，能够对整数数组、字符串数组甚至其他任何类型的数组进行排序，该如何实现?

泛型方法在调用时可以接受到不同类型的参数。根据传递给泛型方法的参数类型，编译器适当的处理每一个方法调用。

### 3.3.1 泛型方法

* 案例

**如何使用泛型方法打印不同字符串的元素**

下面案例，将int、float和char类型泛化，这样就不会出现写三个函数的问题。System.out.printf( "%s ", element )三者都可以输出，而E[] inputArray也可以是以上三种类型。


```java
public class GenericMethodTest
{
   // 泛型方法 printArray                         
   public static < E > void printArray( E[] inputArray )
   {
      // 输出数组元素            
         for ( E element : inputArray ){        //除了字符型，%s还能输出整型、float型。这里的E用于泛这三种类型
            System.out.printf( "%s ", element );
         }
         System.out.println();
    }
 
    public static void main( String args[] )
    {
        // 创建不同类型数组： Integer, Double 和 Character
        Integer[] intArray = { 1, 2, 3, 4, 5 };
        Double[] doubleArray = { 1.1, 2.2, 3.3, 4.4 };
        Character[] charArray = { 'H', 'E', 'L', 'L', 'O' };
 
        System.out.println( "整型数组元素为:" );
        printArray( intArray  ); // 传递一个整型数组
 
        System.out.println( "\n双精度型数组元素为:" );
        printArray( doubleArray ); // 传递一个双精度型数组
 
        System.out.println( "\n字符型数组元素为:" );
        printArray( charArray ); // 传递一个字符型数组
    } 
}

```

输出：

```
整型数组元素为:
1 2 3 4 5 

双精度型数组元素为:
1.1 2.2 3.3 4.4 

字符型数组元素为:
H E L L O   
```

**"extends"如何使用在一般意义上的意思"extends"（类）或者"implements"（接口）**

```java
public class MaximumTest
{
   // 比较三个值并返回最大值
   public static <T extends Comparable<T>> T maximum(T x, T y, T z)
   {                     
      T max = x; // 假设x是初始最大值
      if ( y.compareTo( max ) > 0 ){
         max = y; //y 更大
      }
      if ( z.compareTo( max ) > 0 ){
         max = z; // 现在 z 更大           
      }
      return max; // 返回最大对象
   }
   public static void main( String args[] )
   {
      System.out.printf( "%d, %d 和 %d 中最大的数为 %d\n\n",
                   3, 4, 5, maximum( 3, 4, 5 ) );
 
      System.out.printf( "%.1f, %.1f 和 %.1f 中最大的数为 %.1f\n\n",
                   6.6, 8.8, 7.7, maximum( 6.6, 8.8, 7.7 ) );
 
      System.out.printf( "%s, %s 和 %s 中最大的数为 %s\n","pear",
         "apple", "orange", maximum( "pear", "apple", "orange" ) );
   }
}
```

输出：

```
3, 4 和 5 中最大的数为 5

6.6, 8.8 和 7.7 中最大的数为 8.8

pear, apple 和 orange 中最大的数为 pear
```

### 3.2.2 泛型方法


```java
public class Box<T> {
   
  private T t;
 
  public void add(T t) {
    this.t = t;
  }
 
  public T get() {
    return t;
  }
 
  public static void main(String[] args) {
    Box<Integer> integerBox = new Box<Integer>();//这里指定了Integer类型
    Box<String> stringBox = new Box<String>();
 
    integerBox.add(new Integer(10));
    stringBox.add(new String("菜鸟教程"));
 
    System.out.printf("整型值为 :%d\n\n", integerBox.get());
    System.out.printf("字符串为 :%s\n", stringBox.get());
  }
}
```

### 3.2.3 类型通配符
类型通配符一般使用?代替具体的类型参数。例如，List<?>在逻辑上是List<String> ,List<Integer>等所有List<具体类型实参>的父类。

1、案例1

```java
import java.util.*;
 
public class GenericTest {
     
    public static void main(String[] args) {
        List<String> name = new ArrayList<String>();
        List<Integer> age = new ArrayList<Integer>();
        List<Number> number = new ArrayList<Number>();
        
        name.add("icon");
        age.add(18);
        number.add(314);
 
        getData(name);
        getData(age);
        getData(number);
       
   }
 
   public static void getData(List<?> data) {
      System.out.println("data :" + data.get(0));
   }
}

```

输出：

```
data :icon
data :18
data :314
```

2、案例2（通配符上限）

类型通配符上限通过形如List来定义，如此定义就是通配符泛型值接受Number及其下层子类类型。

```java
import java.util.*;
 
public class GenericTest {
     
    public static void main(String[] args) {
        List<String> name = new ArrayList<String>();
        List<Integer> age = new ArrayList<Integer>();
        List<Number> number = new ArrayList<Number>();
        
        name.add("icon");
        age.add(18);
        number.add(314);
 
        //getUperNumber(name);//1，由于getUperNumber定义时，extendsNumber，限制了参数泛型的上限为Number，所以String不在这个范围内 
        getUperNumber(age);//2
        getUperNumber(number);//3
       
   }
 
   public static void getData(List<?> data) {
      System.out.println("data :" + data.get(0));
   }
   
   public static void getUperNumber(List<? extends Number> data) {    //这里extends表示通配符所代表的类型是T类型的子类。如果想要代表父类，换成super。
          System.out.println("data :" + data.get(0));
       }
}
```


* 通配符的extends和super区别

<? extends T>表示该通配符所代表的类型是T类型的子类。

<? super T>表示该通配符所代表的类型是T类型的父类。

类型通配符下限通过形如 List<? super Number>来定义，表示类型只能接受Number及其三层父类类型，如Objec类型的实例。

## 3.3 Java序列化
序列化机制：一个对象可以被表示为一个字节序列，该字节序列包括对象的数据、有关对象的类型的信息和存储在对象中数据的类型。

将序列化对象写入文件后，可以从文件中读取出来，并且对它进行反序列化，即对象的类型信息、对象的数据和对象中的数据类型可以在内存中新建对象。

类ObjectInputStream和ObjectOutputStream是高层次的数据流，包括反序列化和序列化对象的方法。

ObjectOutputStream 类包含很多写方法来写各种数据类型，但是一个特别的方法例外：

```java
public final void writeObject(Object x) throws IOException;//序列化一个对象，并将它发送到输出流。
public final Object readObject() throws IOException, ClassNotFoundException;//从流中取出下一个对象，并将对象反序列化。

```

### 3.3.1 序列化对象
序列化的两个条件：

1、该类必须实现java.io.Serializable对象

2、该类的所有属性必须是可序列化的。如果有一个属性不可序列化，则该属性必须注明是短暂的。

Java标准类是否可序列化，可查看该类的文档。确定该类有没有实现java.io.Serializable接口。



```java
//首先定义一个要序列化的对象
public class Employee implements java.io.Serializable
{
   public String name;
   public String address;
   public transient int SSN;//transient表示序列化的时候，不会序列化到指定的目的地中。
   public int number;
   public void mailCheck()
   {
      System.out.println("Mailing a check to " + name
                           + " " + address);
   }
}
```


```java

//序列化
import java.io.*;
 
public class SerializeDemo
{
   public static void main(String [] args)
   {
      Employee e = new Employee();
      e.name = "Reyan Ali";
      e.address = "Phokka Kuan, Ambehta Peer";
      e.SSN = 11122333;
      e.number = 101;
      try
      {
         FileOutputStream fileOut =
         new FileOutputStream("/tmp/employee.ser");//文件输出流
         ObjectOutputStream out = new ObjectOutputStream(fileOut);//对象输出流，输出到fileOut文件
         out.writeObject(e);
         out.close();
         fileOut.close();
         System.out.printf("Serialized data is saved in /tmp/employee.ser");
      }catch(IOException i)
      {
          i.printStackTrace();
      }
   }
}
```

### 3.3.2 反序列化对象

```java
//反序列化
import java.io.*;
 
public class DeserializeDemo
{
   public static void main(String [] args)
   {
      Employee e = null;
      try
      {
         FileInputStream fileIn = new FileInputStream("/tmp/employee.ser");//文件输入流
         ObjectInputStream in = new ObjectInputStream(fileIn);//对象输入流，输入fileIn这个流
         e = (Employee) in.readObject();//这里需要将反序列化后，进行Object指定
         in.close();
         fileIn.close();
      }catch(IOException i)
      {
         i.printStackTrace();
         return;
      }catch(ClassNotFoundException c)//如果JVM反序列化对象的过程中找不到该类，就会抛出该异常
      {
         System.out.println("Employee class not found");
         c.printStackTrace();
         return;
      }
      System.out.println("Deserialized Employee...");
      System.out.println("Name: " + e.name);
      System.out.println("Address: " + e.address);
      System.out.println("SSN: " + e.SSN);//SSN是transient，所以没有序列化，在反序列化后，SSN属性为0
      System.out.println("Number: " + e.number);
    }
}
```

输出：

```
Deserialized Employee...
Name: Reyan Ali
Address:Phokka Kuan, Ambehta Peer
SSN: 0
Number:101
```

## 3.4 多线程

### 3.4.1 线程的优先级

Java 线程的优先级是一个整数，其取值范围是 1 （Thread.MIN_PRIORITY ） - 10 （Thread.MAX_PRIORITY ）。

默认情况下，每一个线程都会分配一个优先级 NORM_PRIORITY（5）。

具有较高优先级的线程对程序更重要，并且应该在低优先级的线程之前分配处理器资源。

### 3.4.2 创建线程的方法

1、通过实现 Runnable 接口；

2、通过继承 Thread 类本身；

3、通过 Callable 和 Future 创建线程。

### 3.4.3 Runnable接口

构造方法有多个

```java
Thread(Runnable threadOb,String threadName);
```

一个类只需要执行一个方法调用 run()

```java
public void run()
```

新线程创建之后，你调用它的 start() 方法它才会运行。

```java
void start();
```

实例：

```java
class RunnableDemo implements Runnable {
   private Thread t;
   private String threadName;
   
   RunnableDemo( String name) {
      threadName = name;
      System.out.println("Creating " +  threadName );
   }
   
   public void run() {
      System.out.println("Running " +  threadName );
      try {
         for(int i = 4; i > 0; i--) {
            System.out.println("Thread: " + threadName + ", " + i);
            // 让线程睡眠一会
            Thread.sleep(50);
         }
      }catch (InterruptedException e) {
         System.out.println("Thread " +  threadName + " interrupted.");
      }
      System.out.println("Thread " +  threadName + " exiting.");
   }
   
   public void start () {
      System.out.println("Starting " +  threadName );
      if (t == null) {
         t = new Thread (this, threadName);
         t.start ();
      }
   }
}
 
public class TestThread {
 
   public static void main(String args[]) {
      RunnableDemo R1 = new RunnableDemo( "Thread-1");
      R1.start();
      
      RunnableDemo R2 = new RunnableDemo( "Thread-2");
      R2.start();
   }   
}

```

### 3.4.4 继承Tread类

本质上Tread是实现了接口Runnable的实例。

```java
class ThreadDemo extends Thread {
   private Thread t;
   private String threadName;
   
   ThreadDemo( String name) {
      threadName = name;
      System.out.println("Creating " +  threadName );
   }
   
   public void run() {
      System.out.println("Running " +  threadName );
      try {
         for(int i = 4; i > 0; i--) {
            System.out.println("Thread: " + threadName + ", " + i);
            // 让线程睡眠一会
            Thread.sleep(50);
         }
      }catch (InterruptedException e) {
         System.out.println("Thread " +  threadName + " interrupted.");
      }
      System.out.println("Thread " +  threadName + " exiting.");
   }
   
   public void start () {
      System.out.println("Starting " +  threadName );
      if (t == null) {
         t = new Thread (this, threadName);
         t.start ();
      }
   }
}
 
public class TestThread {
 
   public static void main(String args[]) {
      ThreadDemo T1 = new ThreadDemo( "Thread-1");
      T1.start();
      
      ThreadDemo T2 = new ThreadDemo( "Thread-2");
      T2.start();
   }   
}
```

Thread类对象的方法

|1 | public void start()
使该线程开始执行；Java 虚拟机调用该线程的 run 方法。|
|-|-|
|2 | public void run()
如果该线程是使用独立的 Runnable 运行对象构造的，则调用该 Runnable 对象的 run 方法；否则，该方法不执行任何操作并返回。|
|-|-|
|3 | public final void setName(String name)
改变线程名称，使之与参数 name 相同。|
|-|-|
|4 | public final void setPriority(int priority)
 更改线程的优先级。|
|-|-|
|5 | public final void setDaemon(boolean on)
将该线程标记为守护线程或用户线程。|
|-|-|
|6 | public final void join(long millisec)
等待该线程终止的时间最长为 millis 毫秒。|
|-|-|
|7 | public void interrupt()
中断线程。|
|-|-|
|8 | public final boolean isAlive()
测试线程是否处于活动状态。|

Thread类的静态fangfa

|1 | public static void yield()
暂停当前正在执行的线程对象，并执行其他线程。|
|-|-|
|2 | public static void sleep(long millisec)
在指定的毫秒数内让当前正在执行的线程休眠（暂停执行），此操作受到系统计时器和调度程序精度和准确性的影响。|
|-|-|
|3 | public static boolean holdsLock(Object x)
当且仅当当前线程在指定的对象上保持监视器锁时，才返回 true。|
|-|-|
|4 | public static Thread currentThread()
返回对当前正在执行的线程对象的引用。|
|-|-|
|5 |public static void dumpStack()
将当前线程的堆栈跟踪打印至标准错误流。|

### 3.4.5 Callable和Future创建线程

1. 创建 Callable 接口的实现类，并实现 call() 方法，该 call() 方法将作为线程执行体，并且有返回值。

2. 创建 Callable 实现类的实例，使用 FutureTask 类来包装 Callable 对象，该 FutureTask 对象封装了该 Callable 对象的 call() 方法的返回值。

3. 使用 FutureTask 对象作为 Thread 对象的 target 创建并启动新线程。

4. 调用 FutureTask 对象的 get() 方法来获得子线程执行结束后的返回值。

```java
public class CallableThreadTest implements Callable<Integer> {
    public static void main(String[] args)  
    {  
        CallableThreadTest ctt = new CallableThreadTest();  
        FutureTask<Integer> ft = new FutureTask<>(ctt);  
        for(int i = 0;i < 100;i++)  
        {  
            System.out.println(Thread.currentThread().getName()+" 的循环变量i的值"+i);  
            if(i==20)  
            {  
                new Thread(ft,"有返回值的线程").start();  
            }  
        }  
        try  
        {  
            System.out.println("子线程的返回值："+ft.get());  
        } catch (InterruptedException e)  
        {  
            e.printStackTrace();  
        } catch (ExecutionException e)  
        {  
            e.printStackTrace();  
        }  
  
    }
    @Override  
    public Integer call() throws Exception  
    {  
        int i = 0;  
        for(;i<100;i++)  
        {  
            System.out.println(Thread.currentThread().getName()+" "+i);  
        }  
        return i;  
    }  
}
```

### 3.4.6 线程池
容纳多个线程的容器，其中的线程可以反复使用，省去了频繁创建线程对象的操作，无需反复创建线程而消耗过多资源

在java中，如果每个请求到达就创建一个新线程，开销是相当大的。在实际使用中，创建和销毁线程花费的时间和消耗的系统资源都相当大，甚至可能要比在处理实际的用户请求的时间和资源要多的多。除了创建和销毁线程的开销之外，活动的线程也需要消耗系统资源。如果在一个jvm里创建太多的线程，可能会使系统由于过度消耗内存或“切换过度”而导致系统资源不足。为了防止资源不足，需要采取一些办法来限制任何给定时刻处理的请求数目，尽可能减少创建和销毁线程的次数，特别是一些资源耗费比较大的线程的创建和销毁，尽量利用已有对象来进行服务。（为什么）

线程池主要用来解决线程生命周期开销问题和资源不足问题。通过对多个任务重复使用线程，线程创建的开销就被分摊到了多个任务上了，而且由于在请求到达时线程已经存在，所以消除了线程创建所带来的延迟。这样，就可以立即为请求服务，使用应用程序响应更快；另外，通过适当的调整线程中的线程数目可以防止出现资源不足的情况。

* 方法

```
 Executors：线程池创建工厂类
 public static ExecutorServicenewFixedThreadPool(int nThreads)：返回线程池对象
 ExecutorService：线程池类
 Future<?> submit(Runnable task)：获取线程池中的某一个线程对象，并执行
 Future 接口：用来记录线程任务执行完毕后产生的结果。线程池创建与使用
```

* 使用Runnable创建线程池

1、创建线程池对象

2、创建 Runnable 接口子类对象

3、提交 Runnable 接口子类对象

4、关闭线程池

```java
//Test.java
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class Test {
    public static void main(String[] args) {
        //创建线程池对象  参数5，代表有5个线程的线程池
        ExecutorService service = Executors.newFixedThreadPool(5);
        //创建Runnable线程任务对象
        TaskRunnable task = new TaskRunnable();
        //从线程池中获取线程对象
        service.submit(task);
        System.out.println("----------------------");
        //再获取一个线程对象
        service.submit(task);
        //关闭线程池
        service.shutdown();
    }
}
```

```java
public class TaskRunnable implements Runnable{
    @Override
    public void run() {
        for (int i = 0; i < 1000; i++) {
            System.out.println("自定义线程任务在执行"+i);
        }
    }
}
```

# 4、网络编程
## 4.1 TCP连接过程

服务器实例化一个 ServerSocket 对象，表示通过服务器上的端口通信。

服务器调用 ServerSocket 类的 accept() 方法，该方法将一直等待，直到客户端连接到服务器上给定的端口。

服务器正在等待时，一个客户端实例化一个 Socket 对象，指定服务器名称和端口号来请求连接。

Socket 类的构造函数试图将客户端连接到指定的服务器和端口号。如果通信被建立，则在客户端创建一个 Socket 对象能够与服务器进行通信。

在服务器端，accept() 方法返回服务器上一个新的 socket 引用，该 socket 连接到客户端的 socket。

## 4.2 方法
### 4.2.1 ServerSocket类
服务器应用程序通过使用 java.net.ServerSocket 类以获取一个端口,并且侦听客户端请求。

* 构造方法

|1 |**public ServerSocket(int port) throws IOException**
创建**绑定**到特定端口的服务器套接字。|
|-|-|
|2 | **public ServerSocket(int port, int backlog) throws IOException**
利用指定的 backlog 创建服务器套接字并将其绑定到指定的本地端口号。|
|-|-|
|3 | **public ServerSocket(int port, int backlog, InetAddress address) throws IOException**
使用指定的端口、侦听 backlog 和要绑定到的本地 IP 地址创建服务器。|
|-|-|
|4| **public ServerSocket() throws IOException**
创建非绑定服务器套接字。|

说明：创建非绑定服务器套接字。 如果 ServerSocket 构造方法没有抛出异常，就意味着你的应用程序已经成功绑定到指定的端口，并且侦听客户端请求。

* 常用方法

|1 |**public int getLocalPort()**
  返回此套接字在其上侦听的端口。|
|-|-|
|2 |**public Socket accept() throws IOException**
侦听并接受到此套接字的连接。|
|-|-|
|3 |**public void setSoTimeout(int timeout)**
 通过指定超时值启用/禁用 SO_TIMEOUT，以毫秒为单位。|
 |-|-|
|4 |**public void bind(SocketAddress host, int backlog)**
将 ServerSocket 绑定到特定地址（IP 地址和端口号）。|

### 4.2.2 Socket类
java.net.Socket 类代表客户端和服务器都用来互相沟通的套接字。客户端要获取一个 Socket 对象通过实例化 ，而 服务器获得一个 Socket 对象则通过 accept() 方法的返回值。

* 构造方法

|1 |**public Socket(String host, int port) throws UnknownHostException, IOException.**
创建一个流套接字并将其连接到指定主机上的指定端口号。|
|-|-|
|2 |**public Socket(InetAddress host, int port) throws IOException**
创建一个流套接字并将其连接到指定 IP 地址的指定端口号。|
|-|-|
|3 |**public Socket(String host, int port, InetAddress localAddress, int localPort) throws IOException.**
创建一个套接字并将其连接到指定远程主机上的指定远程端口。|
|-|-|
|4 |**public Socket(InetAddress host, int port, InetAddress localAddress, int localPort) throws IOException.**
创建一个套接字并将其连接到指定远程地址上的指定远程端口。|
|-|-|
|5 |**public Socket()**
通过系统默认类型的 SocketImpl 创建未连接套接字|

* 常用方法

|1 |**public void connect(SocketAddress host, int timeout) throws IOException**
将此套接字连接到服务器，并指定一个超时值。|
|-|-|
|2 |**public InetAddress getInetAddress()**
 返回套接字连接的地址。|
 |-|-|
|3 |**public int getPort()**
返回此套接字连接到的远程端口。|
|-|-|
|4 |**public int getLocalPort()**
返回此套接字绑定到的本地端口。|
|-|-|
|5 |**public SocketAddress getRemoteSocketAddress()**
返回此套接字连接的端点的地址，如果未连接则返回 null。|
|-|-|
|6 |**public InputStream getInputStream() throws IOException**
返回此套接字的输入流。|
|-|-|
|7 |**public OutputStream getOutputStream() throws IOException**
返回此套接字的输出流。|
|-|-|
|8 |**public void close() throws IOException**
关闭此套接字。|

### 4.2.3 InetAddress类

这个类表示互联网协议(IP)地址。

|1 |**static InetAddress getByAddress(byte[] addr)**
在给定原始 IP 地址的情况下，返回 InetAddress 对象。|
|-|-|
|2 |**static InetAddress getByAddress(String host, byte[] addr)**
根据提供的主机名和 IP 地址创建 InetAddress。|
|-|-|
|3 |**static InetAddress getByName(String host)**
在给定主机名的情况下确定主机的 IP 地址。|
|-|-|
|4 |**String getHostAddress()**
返回 IP 地址字符串（以文本表现形式）。|
|-|-|
|5 |**String getHostName()**
 获取此 IP 地址的主机名。|
 |-|-|
|6 |**static InetAddress getLocalHost()**
返回本地主机。|
|-|-|
|7 |**String toString()**
将此 IP 地址转换为 String。|

## 4.3 实例

```java
//客户端
// 文件名 GreetingClient.java
 
import java.net.*;
import java.io.*;
 
public class GreetingClient
{
   public static void main(String [] args)
   {
      String serverName = args[0];
      int port = Integer.parseInt(args[1]);//将字符串转成int
      try
      {
         System.out.println("连接到主机：" + serverName + " ，端口号：" + port);
         Socket client = new Socket(serverName, port);//创建一个socket
         System.out.println("远程主机地址：" + client.getRemoteSocketAddress());//获取远程socket的地址
         OutputStream outToServer = client.getOutputStream();//
         DataOutputStream out = new DataOutputStream(outToServer);
 
         out.writeUTF("Hello from " + client.getLocalSocketAddress());
         InputStream inFromServer = client.getInputStream();//返回此套接字的输入流
         DataInputStream in = new DataInputStream(inFromServer);//数据流
         System.out.println("服务器响应： " + in.readUTF());
         client.close();
      }catch(IOException e)
      {
         e.printStackTrace();
      }
   }
}
```

```java
//服务器
// 文件名 GreetingServer.java
 
import java.net.*;
import java.io.*;
 
public class GreetingServer extends Thread
{
   private ServerSocket serverSocket;
   
   public GreetingServer(int port) throws IOException
   {
      serverSocket = new ServerSocket(port);//创建socket并绑定到特定的端口
      serverSocket.setSoTimeout(10000);
   }
 
   public void run()
   {
      while(true)
      {
         try
         {
            System.out.println("等待远程连接，端口号为：" + serverSocket.getLocalPort() + "...");
            Socket server = serverSocket.accept();
            System.out.println("远程主机地址：" + server.getRemoteSocketAddress());
            DataInputStream in = new DataInputStream(server.getInputStream());
            System.out.println(in.readUTF());//如果接受纯数据的话，这里不能用readUTF
            DataOutputStream out = new DataOutputStream(server.getOutputStream());
            out.writeUTF("谢谢连接我：" + server.getLocalSocketAddress() + "\nGoodbye!");
            server.close();
         }catch(SocketTimeoutException s)
         {
            System.out.println("Socket timed out!");
            break;
         }catch(IOException e)
         {
            e.printStackTrace();
            break;
         }
      }
   }
   public static void main(String [] args)
   {
      int port = Integer.parseInt(args[0]);
      try
      {
         Thread t = new GreetingServer(port);
         t.run();
      }catch(IOException e)
      {
         e.printStackTrace();
      }
   }
}
```

## 4.4 名词
* 同步和异步

同步指的是用户进程触发IO 操作并等待或者轮询的去查看IO 操作是否就绪

异步是指用户进程触发IO 操作以后便开始做自己的事情，而当IO 操作已经完成的时候会得到IO 完成的通知。

* 阻塞与非阻塞

阻塞和非阻塞是针对于进程在访问数据的时候，根据IO操作的就绪状态来采取的不同方式

阻塞方式下读取或者写入函数将一直等待

非阻塞方式下，读取或者写入方法会立即返回一个状态值

* BIO 编程

Blocking IO： 同步阻塞的编程方式。

JDK1.4版本之前常用的编程方式。首先在服务端启动一个ServerSocket来监听网络请求，客户端启动Socket发起网络请求，默认情况下ServerSocket回建立一个线程来处理此请求，如果服务端没有线程可用，客户端则会阻塞等待或遭到拒绝。

同步并阻塞，服务器实现模式为一个连接一个线程，即客户端有连接请求时服务器端就需要启动一个线程进行处理，如果这个连接不做任何事情会造成不必要的线程开销，当然可以通过线程池机制改善。

* NIO 编程

Unblocking IO（New IO）： 同步非阻塞的编程方式

NIO本身是基于事件驱动思想来完成的，其主要想解决的是BIO的大并发问题，NIO基于Reactor，当socket有流可读或可写入socket时，操作系统会相应的通知引用程序进行处理，应用再将流读取到缓冲区或写入操作系统。

NIO的最重要的地方是当一个连接创建后，不需要对应一个线程，这个连接会被注册到多路复用器上面，所以所有的连接只需要一个线程就可以搞定，当这个线程中的多路复用器进行轮询的时候，**发现连接上有请求的话，才开启一个线程进行处理**，也就是一个请求一个线程模式。

* AIO编程

Asynchronous IO： 异步非阻塞的编程方式。

对于读操作而言，当有流可读取时，操作系统会将可读的流传入read方法的缓冲区，并通知应用程序；对于写操作而言，当操作系统将write方法传递的流写入完毕时，操作系统主动通知应用程序。


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

## 堆和栈
### 概述

JVM内存的划分：

1.   寄存器；

2.   本地方法区；

3.   方法区；

4.   栈内存；

5.   堆内存。

* 栈内存

栈内存首先是一片内存区域，存储的都是局部变量，凡是定义在方法中的都是局部变量（方法外的是全局变量），for循环内部定义的也是局部变量，是先加载函数才能进行局部变量的定义，所以方法先进栈，然后再定义变量，变量有自己的作用域，一旦离开作用域，变量就会被释放。栈内存的更新速度很快，因为局部变量的生命周期都很短。

* 堆内存

存储的是数组和对象（其实数组就是对象），凡是new建立的都是在堆中，堆中存放的都是实体（对象），实体用于封装数据，而且是封装多个（实体的多个属性），如果一个数据消失，这个实体也没有消失，还可以用，所以堆是不会随时释放的，但是栈不一样，栈里存放的都是单个变量，变量被释放了，那就没有了。堆里的实体虽然不会被释放，但是会被当成垃圾，Java有垃圾回收机制不定时的收取。

### 解析

主函数先进栈，在栈中定义一个变量arr,接下来为arr赋值，但是右边不是一个具体值，是一个实体。实体创建在堆里，在堆里首先通过new关键字开辟一个空间，内存在存储数据的时候都是通过地址来体现的，地址是一块连续的二进制，然后给这个实体分配一个内存地址。数组都是有一个索引，数组这个实体在堆内存中产生之后每一个空间都会进行默认的初始化（这是堆内存的特点，未初始化的数据是不能用的，但在堆里是可以用的，因为初始化过了，但是在栈里没有），不同的类型初始化的值不一样。所以堆和栈里就创建了变量和实体：

<img src="/images/wiki/Netty/DuiZhanyingshe.jpg" width="700" alt="堆栈的关联" />

当一个实体，没有引用数据类型指向的时候，它在堆内存中不会被释放，而被当做一个垃圾，在不定时的时间内自动回收，因为Java有一个自动回收机制，（而c++没有，需要程序员手动回收，如果不回收就越堆越多，直到撑满内存溢出，所以Java在内存管理上优于c++）。自动回收机制（程序）自动监测堆里是否有垃圾，如果有，就会自动的做垃圾回收的动作，但是什么时候收不一定。

* 区别总结

1.栈内存存储的是局部变量而堆内存存储的是实体；

2.栈内存的更新速度要快于堆内存，因为局部变量的生命周期很短；

3.栈内存存放的变量生命周期一旦结束就会被释放，而堆内存存放的实体会被垃圾回收机制不定时的回收。

### 线程安全

* 多线程的三个概念

1、原子性

一个操作（有可能包含有多个子操作）要么全部执行（生效），要么全部都不执行（都不生效）。

关于原子性，一个非常经典的例子就是银行转账问题：比如A和B同时向C转账10万元。如果转账操作不具有原子性，A在向C转账时，读取了C的余额为20万，然后加上转账的10万，计算出此时应该有30万，但还未来及将30万写回C的账户，此时B的转账请求过来了，B发现C的余额为20万，然后将其加10万并写回。然后A的转账操作继续——将30万写回C的余额。这种情况下C的最终余额为30万，而非预期的40万。

2、可见性

当多个线程并发访问共享变量时，一个线程对共享变量的修改，其它线程能够立即看到。可见性问题是好多人忽略或者理解错误的一点。

CPU从主内存中读数据的效率相对来说不高，现在主流的计算机中，都有几级缓存。每个线程读取共享变量时，都会将该变量加载进其对应CPU的高速缓存里，修改该变量后，CPU会立即更新该缓存，但并不一定会立即将其写回主内存（实际上写回主内存的时间不可预期）。此时其它线程（尤其是不在同一个CPU上执行的线程）访问该变量时，从主内存中读到的就是旧的数据，而非第一个线程更新后的数据。

3、顺序性

顺序性指的是，程序执行的顺序按照代码的先后顺序执行。

```java
boolean started = false; // 语句1
long counter = 0L; // 语句2
counter = 1; // 语句3
started = true; // 语句4
```

从代码顺序上看，上面四条语句应该依次执行，但实际上JVM真正在执行这段代码时，并不保证它们一定完全按照此顺序执行。CPU虽然并不保证完全按照代码顺序执行，但它会保证程序最终的执行结果和代码顺序执行时的结果一致。

编译器和处理器对指令进行重新排序时，会保证重新排序后的执行结果和代码顺序执行的结果一致，所以重新排序过程并不会影响单线程程序的执行，却可能影响多线程程序并发执行的正确性。

* 如何解决多线程并发问题

1、保证原子性

**锁**

常用的保证Java操作原子性的工具是锁和同步方法（或者同步代码块）。使用锁，可以保证同一时间只有一个线程能拿到锁，也就保证了同一时间只有一个线程能执行申请锁和释放锁之间的代码。

```java
public void testLock () {
  lock.lock();
  try{
    int j = i;
    i = j + 1;
  } finally {
    lock.unlock();
  }
}
```

**同步**
与锁类似的是同步方法或者同步代码块。使用非静态同步方法时，锁住的是当前实例；使用静态同步方法时，锁住的是该类的Class对象；使用静态代码块时，锁住的是synchronized关键字后面括号内的对象。

```java
public void testLock () {
  synchronized (anyObject){
    int j = i;
    i = j + 1;
  }
}
```

**CAS(compare and swap)**

基础类型变量自增（i++）是一种常被新手误以为是原子操作而实际不是的操作。Java中提供了对应的原子操作类来实现该操作，并保证原子性，其本质是利用了CPU级别的CAS指令。由于是CPU级别的指令，其开销比需要操作系统参与的锁的开销小。

原子操作补充：所谓原子操作是指不会被线程调度机制打断的操作；这种操作一旦开始，就一直运行到结束，中间不会有任何 context switch （切换到另一个线程）。

```java
AtomicInteger atomicInteger = new AtomicInteger();
for(int b = 0; b < numThreads; b++) {
  new Thread(() -> {
    for(int a = 0; a < iteration; a++) {
      atomicInteger.incrementAndGet();
    }
  }).start();
}
```

2、保证可见性

Java提供了volatile关键字来保证可见性。当使用volatile修饰某个变量时，它会保证对该变量的修改会立即被更新到内存中，并且将其它缓存中对该变量的缓存设置成无效，因此其它线程需要读取该值时必须从主内存中读取，从而得到最新的值。

3、保证顺序性

**volatile**

volatile适用于不需要保证原子性，但却需要保证可见性的场景。一种典型的使用场景是用它修饰用于停止线程的状态标记。如下所示

**synchronized和锁**

**happens-before原则**

两个操作的执行顺序只要可以通过happens-before推导出来，则JVM会保证其顺序性，反之JVM对其顺序性不作任何保证，可对其进行任意必要的重新排序以获取高效率。

>传递规则：如果操作1在操作2前面，而操作2在操作3前面，则操作1肯定会在操作3前发生。该规则说明了happens-before原则具有传递性
>锁定规则：一个unlock操作肯定会在后面对同一个锁的lock操作前发生。这个很好理解，锁只有被释放了才会被再次获取
>volatile变量规则：对一个被volatile修饰的写操作先发生于后面对该变量的读操作
>程序次序规则：一个线程内，按照代码顺序执行
>线程启动规则：Thread对象的start()方法先发生于此线程的其它动作
>线程终结原则：线程的终止检测后发生于线程中其它的所有操作
>线程中断规则： 对线程interrupt()方法的调用先发生于对该中断异常的获取
>对象终结规则：一个对象构造先于它的finalize发生

* 线程问题

问：平时项目中使用锁和synchronized比较多，而很少使用volatile，难道就没有保证可见性？
答：锁和synchronized即可以保证原子性，也可以保证可见性。都是通过保证同一时间只有一个线程执行目标代码段来实现的。


问：锁和synchronized为何能保证可见性？
答：根据JDK 7的Java doc中对concurrent包的说明，一个线程的写结果保证对另外线程的读操作可见，只要该写操作可以由happen-before原则推断出在读操作之前发生。

>The results of a write by one thread are guaranteed to be visible to a read by another thread only if the write operation happens-before the read operation. The synchronized and volatile constructs, as well as the Thread.start() and Thread.join() methods, can form happens-before relationships.

问：既然锁和synchronized即可保证原子性也可保证可见性，为何还需要volatile？
答：synchronized和锁需要通过操作系统来仲裁谁获得锁，开销比较高，而volatile开销小很多。因此在只需要保证可见性的条件下，使用volatile的性能要比使用锁和synchronized高得多。

问：既然锁和synchronized可以保证原子性，为什么还需要AtomicInteger这种的类来保证原子操作？
答：锁和synchronized需要通过操作系统来仲裁谁获得锁，开销比较高，而AtomicInteger是通过CPU级的CAS操作来保证原子性，开销比较小。所以使用AtomicInteger的目的还是为了提高性能。

问：还有没有别的办法保证线程安全
答：有。尽可能避免引起非线程安全的条件——共享变量。如果能从设计上避免共享变量的使用，即可避免非线程安全的发生，也就无须通过锁或者synchronized以及volatile解决原子性、可见性和顺序性的问题。

问：synchronized即可修饰非静态方式，也可修饰静态方法，还可修饰代码块，有何区别
答：synchronized修饰非静态同步方法时，锁住的是当前实例；synchronized修饰静态同步方法时，锁住的是该类的Class对象；synchronized修饰静态代码块时，锁住的是synchronized关键字后面括号内的对象。

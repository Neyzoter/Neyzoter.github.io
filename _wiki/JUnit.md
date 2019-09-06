---
layout: wiki
title: JUnit
categories: JUnit
description: JUnit学习笔记
keywords: Java, JUnit
---

# 1.JUnit介绍

JUnit 是一个 Java 编程语言的单元测试框架。JUnit 在测试驱动的开发方面有很重要的发展，是起源于 JUnit 的一个统称为 xUnit 的单元测试框架之一。

JUnit 促进了“先测试后编码”的理念，强调建立测试数据的一段代码，可以先测试，然后再应用。这个方法就好比“测试一点，编码一点，测试一点，编码一点……”，增加了程序员的产量和程序的稳定性，可以减少程序员的压力和花费在排错上的时间。

## 1.1 JUnit介绍

- JUnit 是一个开放的资源框架，用于编写和运行测试。
- 提供注释来识别测试方法。
- 提供断言来测试预期结果。
- 提供测试运行来运行测试。
- JUnit 测试允许你编写代码更快，并能提高质量。
- JUnit 优雅简洁。没那么复杂，花费时间较少。
- JUnit 测试可以自动运行并且检查自身结果并提供即时反馈。所以也没有必要人工梳理测试结果的报告。
- JUnit 测试可以被组织为测试套件，包含测试用例，甚至其他的测试套件。
- JUnit 在一个条中显示进度。如果运行良好则是绿色；如果运行失败，则变成红色。

## 1.2 测试JUnit建立

```java
//TestJunit.java
import org.junit.Test;
import static org.junit.Assert.assertEquals;
public class TestJunit {
   @Test
   public void testAdd() {
      String str= "Junit is working fine";
      assertEquals("Junit is working fine",str);
   }
}
```

```java
//TestRunner.java
import org.junit.runner.JUnitCore;
import org.junit.runner.Result;
import org.junit.runner.notification.Failure;

public class TestRunner {
   public static void main(String[] args) {
      Result result = JUnitCore.runClasses(TestJunit.class);
      for (Failure failure : result.getFailures()) {
         System.out.println(failure.toString());
      }
      System.out.println(result.wasSuccessful());
   }
}   
```

编译、运行TestRunner.java查看结果。

```
true
```

# 2.JUnit使用

## 2.1 测试框架

JUnit测试框架具有以下重要特性：测试工具、测试套件、测试运行器和测试分类。

* **测试工具**

  测试工具是一整套固定的工具用于基线测试。测试工具的目的是为了确保测试能够在共享且固定的环境中运行，因此保证测试结果的可重复性。包括：

  - 在所有测试调用指令发起前的 setUp() 方法。
  - 在测试方法运行后的 tearDown() 方法。

  例子：

  ```java
  import junit.framework.*;
  
  public class JavaTest extends TestCase {
     protected int value1, value2;
  
     // 给value1和value2在测试之前设置初始值
     protected void setUp(){
        value1=3;
        value2=3;
     }
  
     // 测试两个数相加
     public void testAdd(){
        double result= value1 + value2;
        assertTrue(result == 6);
     }
  }
  ```

* **测试套件**

  测试套件意味*捆绑几个测试案例并且同时运行*。在 JUnit 中，@RunWith 和 @Suite 都被用作运行测试套件。以下为使用 TestJunit1 和 TestJunit2 的测试分类：

  ```java
  import org.junit.runner.RunWith;
  import org.junit.runners.Suite;
  
  //JUnit Suite Test
  @RunWith(Suite.class)
  @Suite.SuiteClasses({   //捆绑几个测试案例并同时运行
     TestJunit1.class ,TestJunit2.class
  })
  public class JunitTestSuite {
  }
  import org.junit.Test;
  import org.junit.Ignore;
  import static org.junit.Assert.assertEquals;
  
  public class TestJunit1 {
  
     String message = "Robert";   
     MessageUtil messageUtil = new MessageUtil(message);
  
     @Test
     public void testPrintMessage() { 
        System.out.println("Inside testPrintMessage()");    
        assertEquals(message, messageUtil.printMessage());     
     }
  }
  import org.junit.Test;
  import org.junit.Ignore;
  import static org.junit.Assert.assertEquals;
  
  public class TestJunit2 {
  
     String message = "Robert";   
     MessageUtil messageUtil = new MessageUtil(message);
  
     @Test
     public void testSalutationMessage() {
        System.out.println("Inside testSalutationMessage()");
        message = "Hi!" + "Robert";
        assertEquals(message,messageUtil.salutationMessage());
     }
  }
  ```

* **测试运行器**

  测试运行器 用于执行测试案例。以下为假定测试分类成立的情况下的例子：

  ```java
  import org.junit.runner.JUnitCore;
  import org.junit.runner.Result;
  import org.junit.runner.notification.Failure;
  
  public class TestRunner {
     public static void main(String[] args) {
         //测试运行TestJunit
        Result result = JUnitCore.runClasses(TestJunit.class);
        for (Failure failure : result.getFailures()) {
           System.out.println(failure.toString());
        }
        System.out.println(result.wasSuccessful());
     }
  }
  ```

* **JUnit测试分类**

  测试分类是在编写和测试 JUnit 的重要分类。几种重要的分类如下：

  - 包含一套断言方法的测试断言
  - 包含规定运行多重测试工具的测试用例
  - 包含收集执行测试用例结果的方法的测试结果

## 2.2 基本用法

**创建一个需要测试的类**

```java
/*
* This class prints the given message on console.
*/
public class MessageUtil {

   private String message;

   //Constructor
   //@param message to be printed
   public MessageUtil(String message){
      this.message = message;
   }

   // prints the message
   public String printMessage(){
      System.out.println(message);
      return message;
   }   
}  
```

**创建Test Case类**

- 创建一个名为 TestJunit.java 的测试类。
- 向测试类中添加名为 testPrintMessage() 的方法。
- 向方法中添加 Annotaion @Test。
- 执行测试条件并且应用 Junit 的 assertEquals API 来检查。

```java
import org.junit.Test;
import static org.junit.Assert.assertEquals;
public class TestJunit {

   String message = "Hello World";  
   MessageUtil messageUtil = new MessageUtil(message);

   @Test
   public void testPrintMessage() {
      assertEquals(message,messageUtil.printMessage());
   }
}
```

**创建Test Runner类**

- 创建一个 TestRunner 类
- 运用 JUnit 的 JUnitCore 类的 runClasses 方法来运行上述测试类的测试案例
- 获取在 Result Object 中运行的测试案例的结果
- 获取 Result Object 的 getFailures() 方法中的失败结果
- 获取 Result object 的 wasSuccessful() 方法中的成功结果

```java
import org.junit.runner.JUnitCore;
import org.junit.runner.Result;
import org.junit.runner.notification.Failure;

public class TestRunner {
   public static void main(String[] args) {
       // 运行上述测试类的测试案例
      Result result = JUnitCore.runClasses(TestJunit.class);
      for (Failure failure : result.getFailures()) {  //查看测试案例结果
         System.out.println(failure.toString());
      }
      System.out.println(result.wasSuccessful());
   }
} 
```

## 2.3 JUnit API

一些重要的类列示如下：

| 序号 | 类的名称   | 类的功能                                |
| :--- | :--------- | :-------------------------------------- |
| 1    | Assert     | assert 方法的集合                       |
| 2    | TestCase   | 一个定义了运行多重测试的固定装置        |
| 3    | TestResult | TestResult 集合了执行测试样例的所有结果 |
| 4    | TestSuite  | TestSuite 是测试的集合                  |

### 2.3.1 Assert类

```java
public class Assert extends java.lang.Object
```

这个类提供了一系列的编写测试的有用的声明方法。只有失败的声明方法才会被记录。**Assert** 类的重要方法列式如下：

| 序号 | 方法和描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | **void assertEquals(boolean expected, boolean actual)** 检查两个变量或者等式是否平衡 |
| 2    | **void assertFalse(boolean condition)** 检查条件是假的       |
| 3    | **void assertNotNull(Object object)** 检查对象不是空的       |
| 4    | **void assertNull(Object object)** 检查对象是空的            |
| 5    | **void assertTrue(boolean condition)** 检查条件为真          |
| 6    | **void fail()** 在没有报告的情况下使测试不通过               |

使用案例：

```java
import org.junit.Test;
import static org.junit.Assert.*;
public class TestJunit1 {
   @Test
   public void testAdd() {
      //test data
      int num= 5;
      String temp= null;
      String str= "Junit is working fine";

      //check for equality
      assertEquals("Junit is working fine", str);

      //check for false condition
      assertFalse(num > 6);

      //check for not null value
      assertNotNull(str);
   }
}
```

```java
import org.junit.runner.JUnitCore;
import org.junit.runner.Result;
import org.junit.runner.notification.Failure;

public class TestRunner1 {
   public static void main(String[] args) {
      Result result = JUnitCore.runClasses(TestJunit1.class);
      for (Failure failure : result.getFailures()) {
         System.out.println(failure.toString());
      }
      System.out.println(result.wasSuccessful());
   }
} 
```

### 2.3.2 TestCase类

```java
public abstract class TestCase extends Assert implements Test
```

一个定义了运行多重测试的固定装置，一些 重要的方法和描述如下：

| 序号 | 方法和描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | **int countTestCases()** 为被run(TestResult result) 执行的测试案例计数 |
| 2    | **TestResult createResult()** 创建一个默认的 TestResult 对象 |
| 3    | **String getName()** 获取 TestCase 的名称                    |
| 4    | **TestResult run()** 一个运行这个测试的方便的方法，收集由TestResult 对象产生的结果 |
| 5    | **void run(TestResult result)** 在 TestResult 中运行测试案例并收集结果 |
| 6    | **void setName(String name)** 设置 TestCase 的名称           |
| 7    | **void setUp()** 创建固定装置，例如，打开一个网络连接        |
| 8    | **void tearDown()** 拆除固定装置，例如，关闭一个网络连接     |
| 9    | **String toString()** 返回测试案例的一个字符串表示           |

使用案例：

```java
import junit.framework.TestCase;
import org.junit.Before;
import org.junit.Test;
public class TestJunit2 extends TestCase  {
   protected double fValue1;
   protected double fValue2;

   @Before 
   public void setUp() {
      fValue1= 2.0;
      fValue2= 3.0;
   }

   @Test
   public void testAdd() {
      //count the number of test cases
      System.out.println("No of Test Case = "+ this.countTestCases());

      //test getName 
      String name= this.getName();
      System.out.println("Test Case Name = "+ name);

      //test setName
      this.setName("testNewAdd");
      String newName= this.getName();
      System.out.println("Updated Test Case Name = "+ newName);
   }
   //tearDown used to close the connection or clean up activities
   public void tearDown(  ) {
   }
}
```

```java
import org.junit.runner.JUnitCore;
import org.junit.runner.Result;
import org.junit.runner.notification.Failure;

public class TestRunner2 {
   public static void main(String[] args) {
      Result result = JUnitCore.runClasses(TestJunit2.class);
      for (Failure failure : result.getFailures()) {
         System.out.println(failure.toString());
      }
      System.out.println(result.wasSuccessful());
   }
}
```

输出

```
No of Test Case = 1
Test Case Name = testAdd
Updated Test Case Name = testNewAdd
true
```

### 2.3.3 TestResult类

```java
public class TestResult extends Object
```

TestResult 类收集所有执行测试案例的结果。它是收集参数层面的一个实例。这个实验框架区分失败和错误。失败是可以预料的并且可以通过假设来检查。错误是不可预料的问题就像 ArrayIndexOutOfBoundsException。TestResult 类的一些重要方法列式如下：

| 序号 | 方法和描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | **void addError(Test test, Throwable t)** 在错误列表中加入一个错误 |
| 2    | **void addFailure(Test test, AssertionFailedError t)** 在失败列表中加入一个失败 |
| 3    | **void endTest(Test test)** 显示测试被编译的这个结果         |
| 4    | **int errorCount()** 获取被检测出错误的数量                  |
| 5    | **Enumeration errors()** 返回错误的详细信息                  |
| 6    | **int failureCount()** 获取被检测出的失败的数量              |
| 7    | **void run(TestCase test)** 运行 TestCase                    |
| 8    | **int int runCount()** 获得运行测试的数量                    |
| 9    | **void startTest(Test test)** 声明一个测试即将开始           |
| 10   | **void stop()** 标明测试必须停止                             |

使用案例：

```java
import org.junit.Test;
import junit.framework.AssertionFailedError;
import junit.framework.TestResult;

// TestResult是一个抽象类，TestJunit3不是抽象类的话，必须实现抽象方法
public class TestJunit3 extends TestResult {
   // 在错误列表中加入一个错误
    //定义了父类的抽象函数
   public synchronized void addError(Test test, Throwable t) {
      super.addError((junit.framework.Test) test, t);
   }

   // 在失败列表中加入一个失败
    //定义了父类的抽象函数
   public synchronized void addFailure(Test test, AssertionFailedError t) {
      super.addFailure((junit.framework.Test) test, t);
   }
   @Test
   public void testAdd() {
   // add any test
   }

   // Marks that the test run should stop.
   public synchronized void stop() {
   //stop the test here
   }
}
```

```java
import org.junit.runner.JUnitCore;
import org.junit.runner.Result;
import org.junit.runner.notification.Failure;

public class TestRunner3 {
   public static void main(String[] args) {
      Result result = JUnitCore.runClasses(TestJunit3.class);
      for (Failure failure : result.getFailures()) {
         System.out.println(failure.toString());
      }
      System.out.println(result.wasSuccessful());
   }
}  
```

### 2.3.4 TestSuite类

```java
public class TestSuite extends Object implements Test
```

| 序号 | 方法和描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | **void addTest(Test test)** 在套中加入测试。                 |
| 2    | **void addTestSuite(Class<? extends TestCase> testClass)** 将已经给定的类中的测试加到套中。 |
| 3    | **int countTestCases()** 对这个测试即将运行的测试案例进行计数。 |
| 4    | **String getName()** 返回套的名称。                          |
| 5    | **void run(TestResult result)** 在 TestResult 中运行测试并收集结果。 |
| 6    | **void setName(String name)** 设置套的名称。                 |
| 7    | **Test testAt(int index)** 在给定的目录中返回测试。          |
| 8    | **int testCount()** 返回套中测试的数量。                     |
| 9    | **static Test warning(String message)** 返回会失败的测试并且记录警告信息。 |

使用案例：

```java
import junit.framework.*;
public class JunitTestSuite {
   public static void main(String[] a) {
      // add the test's in the suite
      TestSuite suite = new TestSuite(TestJunit1.class, TestJunit2.class, TestJunit3.class );
      TestResult result = new TestResult();
      suite.run(result);
      System.out.println("Number of test cases = " + result.runCount());//得到套中测试的数量
    }
}
```

输出

```
No of Test Case = 1
Test Case Name = testAdd
Updated Test Case Name = testNewAdd
Number of test cases = 3
```

## 2.4 编写测试

一个应用 POJO 类，Business logic 类和在 test runner 中运行的 test 类的 JUnit 测试的例子。

**POJO类**

- 取得或者设置雇员的姓名的值
- 取得或者设置雇员的每月薪水的值
- 取得或者设置雇员的年龄的值

```java
// EmployeeDetails.java
public class EmployeeDetails {

   private String name;
   private double monthlySalary;
   private int age;

   /**
   * @return the name
   */
   public String getName() {
      return name;
   }
   /**
   * @param name the name to set
   */
   public void setName(String name) {
      this.name = name;
   }
   /**
   * @return the monthlySalary
   */
   public double getMonthlySalary() {
      return monthlySalary;
   }
   /**
   * @param monthlySalary the monthlySalary to set
   */
   public void setMonthlySalary(double monthlySalary) {
      this.monthlySalary = monthlySalary;
   }
   /**
   * @return the age
   */
   public int getAge() {
      return age;
   }
   /**
   * @param age the age to set
   */
   public void setAge(int age) {
   this.age = age;
   }
}
```

**Business Logic类**

- 计算雇员每年的薪水
- 计算雇员的评估金额

```java
public class EmpBusinessLogic {
   // Calculate the yearly salary of employee
   public double calculateYearlySalary(EmployeeDetails employeeDetails){
      double yearlySalary=0;
      yearlySalary = employeeDetails.getMonthlySalary() * 12;
      return yearlySalary;
   }

   // Calculate the appraisal amount of employee
   public double calculateAppraisal(EmployeeDetails employeeDetails){
      double appraisal=0;
      if(employeeDetails.getMonthlySalary() < 10000){
         appraisal = 500;
      }else{
         appraisal = 1000;
      }
      return appraisal;
   }
}
```

**测试类**

- 测试雇员的每年的薪水
- 测试雇员的评估金额

```java
import org.junit.Test;
import static org.junit.Assert.assertEquals;

public class TestEmployeeDetails {
   EmpBusinessLogic empBusinessLogic =new EmpBusinessLogic();
    // 1.要测试的类创建一个新的对象
   EmployeeDetails employee = new EmployeeDetails();

   //test to check appraisal
   @Test
   public void testCalculateAppriasal() {
       //2.运行要测试的类的对象的方法
      employee.setName("Rajeev");
      employee.setAge(25);
      employee.setMonthlySalary(8000);
      double appraisal= empBusinessLogic.calculateAppraisal(employee);
       //3.Assert查看是否正确
      assertEquals(500, appraisal, 0.0);
   }

   // test to check yearly salary
   @Test
   public void testCalculateYearlySalary() {
      employee.setName("Rajeev");
      employee.setAge(25);
      employee.setMonthlySalary(8000);
      double salary= empBusinessLogic.calculateYearlySalary(employee);
      assertEquals(96000, salary, 0.0);
   }
}
```

```java
import org.junit.runner.JUnitCore;
import org.junit.runner.Result;
import org.junit.runner.notification.Failure;

public class TestRunner {
   public static void main(String[] args) {
      Result result = JUnitCore.runClasses(TestEmployeeDetails.class);
      for (Failure failure : result.getFailures()) {
         System.out.println(failure.toString());
      }
      System.out.println(result.wasSuccessful());
   }
} 
```







## 2.5 注解

### 2.5.1 @RunWith



### 2.5.2 @Suite

用作运行测试套件

```java
@RunWith(Suite.class)
@Suite.SuiteClasses({   //捆绑几个测试案例并同时运行
   TestJunit1.class ,TestJunit2.class
})
```

### 2.5.3 @Test

@Test注解告诉Junit为要做测试的public权限的方法创建一个测试实例。为了运行这个方法，Junit首先会创建一个该类实例，用于调用被@Test注解了的方法。遇到任何异常抛出时，Junit都会执行失败。如果没有异常抛出，Junit测试必然会成功

### 2.5.4 @Before

有些测试在运行前需要创造几个相似的对象。在 public void 方法加该注释是因为该方法需要在**test 方法前**运行。

```java
@Before 
public void setUp() {
    fValue1= 2.0;
    fValue2= 3.0;
}
```

### 2.5.5 @After

如果你将外部资源在 Before 方法中分配，那么你需要在测试运行后释放他们。在 public void 方法加该注释是因为该方法需要在 test 方法后运行。

### 2.5.6 @BeforeClass

在 public void 方法加该注释是因为该方法需要在类中**所有方法前**运行。

### 2.5.7 @AfterClass

它将会使方法在**该类所有测试结束后**执行，可以用来进行清理活动。

### 2.5.8 @Ignore

忽略有关不需要执行的测试。

## 2.6 执行过程

```java
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

public class ExecutionProcedureJunit {

   //execute only once, in the starting 
   @BeforeClass
   public static void beforeClass() {
      System.out.println("in before class");
   }

   //execute only once, in the end
   @AfterClass
   public static void  afterClass() {
      System.out.println("in after class");
   }

   //execute for each test, before executing test
   @Before
   public void before() {
      System.out.println("in before");
   }

   //execute for each test, after executing test
   @After
   public void after() {
      System.out.println("in after");
   }

   //test case 1
   @Test
   public void testCase1() {
      System.out.println("in test case 1");
   }

   //test case 2
   @Test
   public void testCase2() {
      System.out.println("in test case 2");
   }
}
```

```java
import org.junit.runner.JUnitCore;
import org.junit.runner.Result;
import org.junit.runner.notification.Failure;

public class TestRunner {
   public static void main(String[] args) {
      Result result = JUnitCore.runClasses(ExecutionProcedureJunit.class);
      for (Failure failure : result.getFailures()) {
         System.out.println(failure.toString());
      }
      System.out.println(result.wasSuccessful());
   }
} 
```

输出

```
in before class
in before
in test case 1
in after
in before
in test case 2
in after
in after class
```


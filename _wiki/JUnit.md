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

## 2.7 套件测试

测试套件意味着捆绑几个单元测试用例并且一起执行他们。在 JUnit 中，@RunWith 和 @Suite 注释用来运行套件测试。

**创建一个类**

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

   // add "Hi!" to the message
   public String salutationMessage(){
      message = "Hi!" + message;
      System.out.println(message);
      return message;
   }   
}  
```

**Test Case类**

```java
//第一个测试类
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
```

```java
//第二个测试类
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

**使用Test Suite类**

- 创建一个 java 类。
- 在类中附上 @RunWith(Suite.class) 注释。
- 使用 @Suite.SuiteClasses 注释给 JUnit 测试类加上引用。

```java
import org.junit.runner.RunWith;
import org.junit.runners.Suite;
@RunWith(Suite.class)
@Suite.SuiteClasses({
   TestJunit1.class,
   TestJunit2.class
})
public class JunitTestSuite {   
}  
```

**创建TestRunner类**

```java
import org.junit.runner.JUnitCore;
import org.junit.runner.Result;
import org.junit.runner.notification.Failure;

public class TestRunner {
   public static void main(String[] args) {
      Result result = JUnitCore.runClasses(JunitTestSuite.class);
      for (Failure failure : result.getFailures()) {
         System.out.println(failure.toString());
      }
      System.out.println(result.wasSuccessful());
   }
}
```

输出

```
Inside testPrintMessage()
Robert
Inside testSalutationMessage()
Hi Robert
true
```

## 2.8 忽略测试

* 一个含有 @Ignore 注释的测试方法将不会被执行。
* 如果一个测试类有 @Ignore 注释，则它的测试方法将不会执行。

## 2.9 时间测试

Junit 提供了一个暂停的方便选项。如果一个测试用例比起指定的毫秒数花费了更多的时间，那么 Junit 将自动将它标记为失败。timeout 参数和 @Test 注释一起使用。

**创建一个类**

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
    // while循环，用于测试是否超时
   public void printMessage(){
      System.out.println(message);
      while(true);
   }   

   // add "Hi!" to the message
   public String salutationMessage(){
      message = "Hi!" + message;
      System.out.println(message);
      return message;
   }   
} 
```

**Test Case类**

- 创建一个叫做 TestJunit.java 的 java 测试类。
- 给 testPrintMessage() 测试用例添加 1000 的暂停时间。

```java
import org.junit.Test;
import org.junit.Ignore;
import static org.junit.Assert.assertEquals;

public class TestJunit {

   String message = "Robert";   
   MessageUtil messageUtil = new MessageUtil(message);

    //测试超时
   @Test(timeout=1000)
   public void testPrintMessage() { 
      System.out.println("Inside testPrintMessage()");     
      messageUtil.printMessage();     
   }

   @Test
   public void testSalutationMessage() {
      System.out.println("Inside testSalutationMessage()");
      message = "Hi!" + "Robert";
      assertEquals(message,messageUtil.salutationMessage());
   }
}
```

**Test Runner类**

```java
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

输出

```
Inside testPrintMessage()
Robert
Inside testSalutationMessage()
Hi!Robert
testPrintMessage(TestJunit): test timed out after 1000 milliseconds
false
```

## 2.10 异常测试

Junit 用代码处理提供了一个追踪异常的选项。你可以测试代码是否它抛出了想要得到的异常。expected 参数和 @Test 注释一起使用。

**创建一个类**

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
    // 1/0出错，用于测试
   public void printMessage(){
      System.out.println(message);
      int a =0;
      int b = 1/a;
   }   

   // add "Hi!" to the message
   public String salutationMessage(){
      message = "Hi!" + message;
      System.out.println(message);
      return message;
   }   
}  
```

**创建Test Case类**

- 创建一个叫做 TestJunit.java 的 java 测试类。
- 给 testPrintMessage() 测试用例添加需要的异常 ArithmeticException。

```java
import org.junit.Test;
import org.junit.Ignore;
import static org.junit.Assert.assertEquals;

public class TestJunit {

   String message = "Robert";   
   MessageUtil messageUtil = new MessageUtil(message);

    //测试有异常ArithmeticException？
    //期望有该异常抛出
   @Test(expected = ArithmeticException.class)
   public void testPrintMessage() { 
      System.out.println("Inside testPrintMessage()");     
      messageUtil.printMessage();     
   }

   @Test
   public void testSalutationMessage() {
      System.out.println("Inside testSalutationMessage()");
      message = "Hi!" + "Robert";
      assertEquals(message,messageUtil.salutationMessage());
   }
}
```

**Test Runner类**

```java
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

## 2.11 参数化测试

Junit 4 引入了一个新的功能参数化测试。参数化测试允许开发人员使用不同的值反复运行同一个测试。你将遵循 5 个步骤来创建参数化测试。

- 用 @RunWith(Parameterized.class) 来注释 test 类。
- 创建一个由 @Parameters 注释的公共的静态方法，它返回一个对象的集合(数组)来作为测试数据集合。
- 创建一个公共的构造函数，它接受和一行测试数据相等同的东西。
- 为每一列测试数据创建一个实例变量。
- 用实例变量作为测试数据的来源来创建你的测试用例。

**创建一个类**

```java
public class PrimeNumberChecker {
   public Boolean validate(final Integer primeNumber) {
      for (int i = 2; i < (primeNumber / 2); i++) {
         if (primeNumber % i == 0) {
            return false;
         }
      }
      return true;
   }
}
```

**创建 Parameterized Test Case 类**

```java
import java.util.Arrays;
import java.util.Collection;

import org.junit.Test;
import org.junit.Before;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;
import org.junit.runner.RunWith;
import static org.junit.Assert.assertEquals;

// 需要以 @RunWith(Parameterized.class) 来注释 test 类
@RunWith(Parameterized.class)
public class PrimeNumberCheckerTest {
   private Integer inputNumber;
   private Boolean expectedResult;
   private PrimeNumberChecker primeNumberChecker;

    //要测试的对象
   @Before
   public void initialize() {
      primeNumberChecker = new PrimeNumberChecker();
   }

   // Each parameter should be placed as an argument here
   // Every time runner triggers, it will pass the arguments
   // from parameters we defined in primeNumbers() method
   public PrimeNumberCheckerTest(Integer inputNumber, 
      Boolean expectedResult) {
      this.inputNumber = inputNumber;
      this.expectedResult = expectedResult;
   }
	
    // 为测试提供数多个数值
   @Parameterized.Parameters
   public static Collection primeNumbers() {
      return Arrays.asList(new Object[][] {
         { 2, true },
         { 6, false },
         { 19, true },
         { 22, false },
         { 23, true }
      });
   }

   // This test will run 4 times since we have 5 parameters defined
   @Test
   public void testPrimeNumberChecker() {
      System.out.println("Parameterized Number is : " + inputNumber);
      assertEquals(expectedResult, 
      primeNumberChecker.validate(inputNumber));
   }
}
```

**TestRunner类**

```java
import org.junit.runner.JUnitCore;
import org.junit.runner.Result;
import org.junit.runner.notification.Failure;

public class TestRunner {
   public static void main(String[] args) {
      Result result = JUnitCore.runClasses(PrimeNumberCheckerTest.class);
      for (Failure failure : result.getFailures()) {
         System.out.println(failure.toString());
      }
      System.out.println(result.wasSuccessful());
   }
}
```

输出

```
Parameterized Number is : 2
Parameterized Number is : 6
Parameterized Number is : 19
Parameterized Number is : 22
Parameterized Number is : 23
true
```

### 2.12 ANT插件运行JUnit

https://www.w3cschool.cn/junit/mkvf1hvg.html

## 2.13 框架拓展

JUnit拓展包括：

- Cactus
- JWebUnit
- XMLUnit
- MockObject

### 2.13.1 Cactus

Cactus 是一个简单框架用来测试服务器端的 Java 代码（Servlets, EJBs, Tag Libs, Filters）。Cactus 的设计意图是用来减小为服务器端代码写测试样例的成本。它使用 JUnit 并且在此基础上进行扩展。Cactus 实现了 in-container 的策略，意味着可以在容器内部执行测试。

Cactus 系统由以下几个部分组成：

- **Cactus Framework（Cactus 框架）** 是 Cactus 的核心。它是提供 API 写 Cactus 测试代码的引擎。
- **Cactus Integration Modules（Cactus 集成模块）** 它是提供使用 Cactus Framework（Ant scripts, Eclipse plugin, Maven plugin）的前端和框架。

这是使用 cactus 的样例代码。

```java
import org.apache.cactus.*;
import junit.framework.*;

public class TestSampleServlet extends ServletTestCase {
   @Test
   public void testServlet() {
      // Initialize class to test
      SampleServlet servlet = new SampleServlet();

      // Set a variable in session as the doSomething()
      // method that we are testing 
      session.setAttribute("name", "value");

      // Call the method to test, passing an 
      // HttpServletRequest object (for example)
      String result = servlet.doSomething(request);

      // Perform verification that test was successful
      assertEquals("something", result);
      assertEquals("otherValue", session.getAttribute("otherName"));
   }
}
```

### 2.13.2 JWebUnit

JWebUnit 是一个基于 Java 的用于 web 应用的测试框架。它以一种统一、简单测试接口的方式包装了如 HtmlUnit 和 Selenium 这些已经存在的框架来允许你快速地测试 web 应用程序的正确性。

JWebUnit 提供了一种高级别的 Java API 用来处理结合了一系列验证程序正确性的断言的 web 应用程序。这包括通过链接，表单的填写和提交，表格内容的验证和其他 web 应用程序典型的业务特征。

这个简单的导航方法和随时可用的断言允许建立更多的快速测试而不是仅仅使用 JUnit 和 HtmlUnit。另外如果你想从 HtmlUnit 切换到其它的插件，例如 Selenium(很快可以使用)，那么不用重写你的测试样例代码。

以下是样例代码。

```java
import junit.framework.TestCase;
import net.sourceforge.jwebunit.WebTester;

public class ExampleWebTestCase extends TestCase {
   private WebTester tester;

   public ExampleWebTestCase(String name) {
        super(name);
        tester = new WebTester();
   }
   //set base url
   public void setUp() throws Exception {
       getTestContext().setBaseUrl("http://myserver:8080/myapp");
   }
   // test base info
   @Test
   public void testInfoPage() {
       beginAt("/info.html");
   }
}
```

### 2.13.3 XMLUnit

XMLUnit 提供了一个单一的 JUnit 扩展类，即 XMLTestCase，还有一些允许断言的支持类：

- 比较两个 XML 文件的不同（通过使用 Diff 和 DetailedDiff 类）
- 一个 XML 文件的验证（通过使用 Validator 类）
- 使用 XSLT 转换一个 XML 文件的结果（通过使用 Transform 类）
- 对一个 XML 文件 XPath 表达式的评估（通过实现 XpathEngine 接口）
- 一个 XML 文件进行 DOM Traversal 后的独立结点（通过使用 NodeTest 类）

我们假设有两个我们想要比较和断言它们相同的 XML 文件，我们可以写一个如下的简单测试类：

```java
import org.custommonkey.xmlunit.XMLTestCase;

public class MyXMLTestCase extends XMLTestCase {

   // this test method compare two pieces of the XML
   @Test
   public void testForXMLEquality() throws Exception {
      String myControlXML = "<msg><uuid>0x00435A8C</uuid></msg>";
      String myTestXML = "<msg><localId>2376</localId></msg>";
      assertXMLEqual("Comparing test xml to control xml",
      myControlXML, myTestXML);
   }
}
```

### 2.13.4 MockObject

在一个单元测试中，虚拟对象可以模拟复杂的，真实的（非虚拟）对象的行为，因此当一个真实对象不现实或不可能包含进一个单元测试的时候非常有用。

用虚拟对象进行测试时一般的编程风格包括：

- 创建虚拟对象的实例
- 在虚拟对象中设置状态和描述
- 结合虚拟对象调用域代码作为参数
- 在虚拟对象中验证一致性

以下是使用 Jmock 的 MockObject 例子。

```java
import org.jmock.Mockery;
import org.jmock.Expectations;

class PubTest extends TestCase {
   Mockery context = new Mockery();
   public void testSubReceivesMessage() {
      // set up
      final Sub sub = context.mock(Sub.class);

      Pub pub = new Pub();
      pub.add(sub);

      final String message = "message";

      // expectations
      context.checking(new Expectations() {
         oneOf (sub).receive(message);
      });

      // execute
      pub.publish(message);

      // verify
      context.assertIsSatisfied();
   }
}
```


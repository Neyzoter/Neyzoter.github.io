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

* **使用bash统计异常数**

  ```bash
  #!/bin/bash
  # 遍历所有ERROR，排序，消除重复
  for X in $(egrep -o "[A-Z]\w*Exception" log.txt | sort | uniq);
  do
  	# 异常输出到控制台上
  	echo -n -e "$X "
  	# 统计个数
  	grep -c "$X" log.txt
  done
  ```

* **别给牦牛剪毛**

  别让自动化的努力变成剪牦牛毛——指的是如果在写自动化脚本的时候，发现了很多其他无关的问题，比如版本不兼容、驱动有问题等，需要尽快抽身，而不是不停解决以上无关的问题。

## 1.2 哲学

* **事物本质性质和附属性质（亚力士多德）**

  本质复杂性是指要解决问题的核心，而附属复杂性是值在解决核心问题时，可能需要附属解决的问题。比如为了分析某个数据库数据，需要连接数据库并导出数据，导出数据的过程即为附属性质而分析数据库才是本质性质。很多组织会在附属性质上花费比本质性质更多的时间和精力。

  所以，**去除本质复杂性，也要去除附属复杂性。**

* **奥卡姆剃刀原理**

  如果对于一个现象有多种解释，那么最简单的往往是最正确的。

  “80-10-10”准则（Dietzler定律）是指80%的客户需求可以很快完成，下一个10%需要花很大努力完成，而最后10%几乎不可能完成，因为不想将所有工具和框架都“招致麾下”。

  一些语言的诞生是为了让程序员摆脱一些麻烦，但随着时间推移，可能语言的功能越来越多，然而使得解决方案变得不正确（不符合奥卡姆剃刀原理）。

  所以，**适合的才是最好的，不要总是追求样样精通**。

* **笛米特法则**

  任何对象都不需要知道与之交互的那个对象的任何内部细节。

  比如，下面的方法是不合适的，

  ```java
  Job job = new Job("Safety Engineer", 5000.00);
  Person homer = new person("Homer", job);
  // 通过Person来获取Job，直接操作Job对象是不合适的
  homer.getJob().setPosition("Janitor");
  ```

  正确的做法应该是在Person类中定义可以更改Position的方法

  ```java
  // 正确的做法应该是在Person类中定义可以更改Position的方法
  homer.changeJobPositionTo("Janitor");
  ```

## 1.3 多语言编程

计算机语言会越来越细分领域，追求通用性的语言会被抛弃。

# 2. TCP-IP详解卷1：协议

## 第17章 TCP：传输控制协议

```
+------------------------+-------------------------------+-----------------------------+
|       IP首部            |              TCP首部           |        TCP数据              |
+------------------------+-------------------------------+-----------------------------+
       20 bytes                       20 bytes                                 
```

<img src="/images/wiki/Book/TCP_Head.png" width="500" alt="TCP首部">

* **TCP首部的6个标志比特**

  URG：紧急指针有效

  ACK：确认序号有效

  PSH：接收方应该尽快将这个报文段交给应用层

  RST：重建连接

  SYN：同步序号用来发起一个连接

  FIN：发端完成发送任务

## 第18章 TCP连接的建立与终止

以下是TCP的三次握手和四次挥手过程：

<img src="/images/wiki/Book/TCP_3Connect_4Disconnect.png" width="500" alt="TCP3次握手和4次挥手">

* **连接终止协议**

  终止连接需要4次握手，有TCP的半关闭（Half-Close）造成的。一个TCP连接是全双工（两个方向上同时传递），因此每个方向必须单独进行关闭。这一原则就是当一方完成它的数据发送任务后就能发送一个FIN来终止该方向的连接。当一端接受到一个FIN，它必须通知应用层另一端已经终止了那个方向的数据传输（也就是FIN的ack）。

# 3. 大型分布式网站架构设计与实践

通过服务（SOA系统）的方式进行交互，保证交互的标准性；

采用可水平伸缩的集群方式来支撑巨大的访问量，设计到负载均衡问题；

通过分布式缓存解决大量的数据缓存问题；

通过监控、恢复措施提高系统的稳定性；

## 3.1 面向服务的体系架构（SOA）

### 3.1.1 基于TCP协议的RPC

RPC：远程过程调用。

* **对象的序列化**

  数据需要转化为二进制流在网络上传输，涉及到对象的序列化和反序列化问题。解决方案包括Google的Protocal Buffer、Java自带的序列化方式、Hessian、JSON、XML、Spark的Kryo。下面是一个Java序列化的例子，

  ```java
  public class SerializationUtil implements Serializable {
      private static final long serialVersionUID = 1065846828160869484L;
      public static byte[] serialize(Object obj) throws Exception{
          ByteArrayOutputStream baos = null;
          ObjectOutputStream oos = null;
          try{
              // create byte array output stream
              baos = new ByteArrayOutputStream();
              // create obj output stream, write into baos
              oos = new ObjectOutputStream(baos);
              // write obj into baos
              oos.writeObject(obj);
              // trans to byte[]
              byte[] bytes = baos.toByteArray();
              oos.close();
              return bytes;
          }catch (Exception e){
              throw e;
          }
      }
      public static Object deserialize(byte[] bytes){
          ByteArrayInputStream bais = null;
          Object tmpObject = null;
          try {
              // trans to ByteArrayInputStream
              bais = new ByteArrayInputStream(bytes);
              // trans to obj InputStream
              ObjectInputStream ois = new ObjectInputStream(bais);
              // trans to obj
              tmpObject = (Object)ois.readObject();
              ois.close();
              return tmpObject;
          } catch (Exception e) {
              e.printStackTrace();
          }
          return null;
      }
  }
  ```

* **基于TCP的RPC简单实现**

  1. 服务（接口）和实现类

  ```java
  /**
   * RPC 服务接口
   * @author Charles Song
   * @date 2020-4-19
   */
  public interface RpcService {
      String printString (String str) ;
  }
  
  /**
   * RPC服务实现
   */
  public class RpcServiceImpl implements RpcService{
      @Override
      public String printString (String str) {
          System.out.println(str);
          return str;
      }
  }
  
  ```

  2. 服务提供者

  ```java
  /**
   * RPC 服务提供者
   * @author Charles Song
   * @date 2020-4-19
   */
  public class RpcProvider {
      public static final int PORT = 5000;
      public static void main (String[] args) {
          // 创建保存服务实现类的对象
          HashMap<String, Object> servicesImpl = new HashMap<>(10);
          // 加入RpcService接口实现RpcServiceImpl
          servicesImpl.put(RpcService.class.getName(), new RpcServiceImpl());
  
          try{
              ServerSocket serverSocket = new ServerSocket(PORT);
              System.out.println("Waiting for RPC...");
              while (true) {
                  Socket socket = serverSocket.accept();
  
                  ObjectInputStream objectInputStream = new ObjectInputStream(socket.getInputStream());
                  // 获取接口名称
                  String ifName = objectInputStream.readUTF();
                  System.out.println("Interface Name : " + ifName);
                  // 获取方法名称
                  String methodName = objectInputStream.readUTF();
                  System.out.println("Method Name : " + methodName);
                  // 获取方法参数类型
                  Class<?>[] methodArgClass = (Class<?>[]) objectInputStream.readObject();
                  // 获取方法的参数
                  Object[] arguments = (Object[]) objectInputStream.readObject();
  
                  // 获取接口
                  Class serviceIfClass = Class.forName(ifName);
                  // 获取接口的实现
                  Object serviceImpl = servicesImpl.get(ifName);
                  // 获取方法
                  Method method = serviceIfClass.getMethod(methodName, methodArgClass);
                  // 调用函数methodArgClass
                  Object result = method.invoke(serviceImpl, arguments);
                  // 将结果发送给消费者
                  ObjectOutputStream objectOutputStream = new ObjectOutputStream(socket.getOutputStream());
                  objectOutputStream.writeObject(result);
              }
          } catch (Exception e) {
              System.err.println(e);
          }
  
      }
  }
  ```

  3. 服务消费者

  ```java
  /**
   * RPC 服务使用者
   * @author Charles Song
   * @date 2020-4-19
   */
  public class RpcConsumer {
      public static void main (String[] args) {
          try {
              String ifName = RpcService.class.getName();
              Method method = RpcService.class.getMethod("printString", String.class);
              String methodName = method.getName();
              Class[] methodArgClass = method.getParameterTypes();
              Object[] arguments = {"Msg Received..."};
  
              Socket socket = new Socket("127.0.0.1", RpcProvider.PORT);
  
              ObjectOutputStream objectOutputStream = new ObjectOutputStream(socket.getOutputStream());
              // 接口名称
              objectOutputStream.writeUTF(ifName);
              // 方法名称
              objectOutputStream.writeUTF(methodName);
              // 方法参数类型
              objectOutputStream.writeObject(methodArgClass);
              // 方法参数
              objectOutputStream.writeObject(arguments);
  
              ObjectInputStream objectInputStream = new ObjectInputStream(socket.getInputStream());
              Object result = objectInputStream.readObject();
              System.out.println("result = " + (String)result);
          } catch (Exception e) {
              System.out.println(e);
          }
      }
  }
  ```

  运行结果：

  ```
  ## 服务提供者
  Waiting for RPC...
  Interface Name : cn.neyzoter.oj.test.rpc.RpcService
  Method Name : printString
  Msg Received...
  
  ## 服务消费者
  result = Msg Received...
  ```

  
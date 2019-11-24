---
layout: wiki
title: Spark
categories: Spark
description: Spark框架使用
keywords: Spark, Java, Big Data, Machine Learning
---

# 1、Spark介绍

## 1.1 链接

[Spark 编程指南](https://endymecy.gitbooks.io/spark-programming-guide-zh-cn/content/)

[Spark例程](http://spark.apache.org/examples.html)

[configuration](https://spark.apache.org/docs/latest/configuration.html)

[tuning](https://spark.apache.org/docs/latest/tuning.html)

## 1.2 介绍

Spark是个通用的集群计算框架，通过将大量数据集计算任务分配到多台计算机上，提供高效内存计算。如果你熟悉Hadoop，那么你知道分布式计算框架要解决两个问题：如何分发数据和如何分发计算。Hadoop使用HDFS来解决分布式数据问题，MapReduce计算范式提供有效的分布式计算。类似的，Spark拥有多种语言的函数式编程API，提供了除map和reduce之外更多的运算符，这些操作是通过一个称作弹性分布式数据集(resilient distributed datasets, RDDs)的分布式数据框架进行的。

**核心组建**

- **Spark Core**：包含Spark的基本功能；尤其是定义RDD的API、操作以及这两者上的动作。其他Spark的库都是构建在RDD和Spark Core之上的。
- **Spark SQL**：提供通过Apache Hive的SQL变体Hive查询语言（HiveQL）与Spark进行交互的API。每个数据库表被当做一个RDD，Spark SQL查询被转换为Spark操作。对熟悉Hive和HiveQL的人，Spark可以拿来就用。
- **Spark Streaming**：允许对实时数据流进行处理和控制。很多实时数据库（如Apache Store）可以处理实时数据。Spark Streaming允许程序能够像普通RDD一样处理实时数据。
- **MLlib**：一个常用机器学习算法库，算法被实现为对RDD的Spark操作。这个库包含可扩展的学习算法，比如分类、回归等需要对大量数据集进行迭代的操作。之前可选的大数据机器学习库Mahout，将会转到Spark，并在未来实现。
- **GraphX**：控制图、并行图操作和计算的一组算法和工具的集合。GraphX扩展了RDD API，包含控制图、创建子图、访问路径上所有顶点的操作。

# 2、Spark使用

## 2.1 基础

### 2.1.1 基础操作

* 运行例子

  ```bash
  ./bin/run-example SparkPi 10
  ```

* 启动shell

  ```ba
  ./bin/spark-shell
  ```

* 为文件系统中的md文件创建一个新的RDD

  ```bash
  scala> val textFile = sc.textFile("README.md")
  ```

* 操作actions，从RDD返回值

  ```bash
  scala> textFile.count() # RDD 的数据条数
  res0: Long = 126
  
  scala> textFile.first() # RDD 的第一行数据
  res1: String = # Apache Spark
  ```

* 转换transformations，变成一个新的RDD并返回它的引用

  使用filter来查找包含Spark文本的新的RDD，返回引用

  ```bash
  scala> val linesWithSpark = textFile.filter(line => line.contains("Spark")) # 返回一个新的RDD保存了所有含有Spark文本
  linesWithSpark: spark.RDD[String] = spark.FilteredRDD@7dd4af09
  
  scala> linesWithSpark.count()  # 计算个数
  res2: Long = 20
  ```

* 映射map，将得到的结果映射到一个新的RDD

  ```bash
  scala> var wordNum = textFile.map(line => line.split(" ").size)  # 计算每一行的单词数目，用空格隔开
  wordNum: org.apache.spark.rdd.RDD[Int] = MapPartitionsRDD[3] at map at <console>:25
  ```

* reduce，找到单词数目最多的

  ```bash
  scala> wordNum.reduce((a,b) => if (a > b) a else b)
  res3: Int = 22
  ```

  **`map` 和 `reduce` 的参数是 Scala 的函数串(闭包)，并且可以使用任何语言特性或者 Scala/Java 类库。**

* scala调用Java函数库

  ```bash
  scala> import java.lang.Math
  import java.lang.Math
  
  scala> wordNum.reduce((a,b) => Math.max(a,b))
  res4: Int = 22
  ```

* 统计每个单词数量

  ```bash
  # 每个单词都是以看看k-v格式：(word, 1)
  # 统计每个word的数目
  scala> val wordCounts = textFile.flatMap(line => line.split(" ")).map(word => (word, 1)).reduceByKey((a, b) => a + b) # reduceByKey表示对同一种Key进行该操作
  wordCounts: org.apache.spark.rdd.RDD[(String, Int)] = ShuffledRDD[5] at reduceByKey at <console>:26
  
  # 显示收集单词的数量
  wordCounts.collect()
  res7: Array[(String, Int)] = Array((package,1), (this,1), (integration,1), (Python,2), (page](http://spark.apache.org/documentation.html).,1), (cluster.,1), (its,1), ([run,1), (There,1), (general,3), (have,1), (pre-built,1), (Because,1), (YARN,,1), (locally,2), (changed,1), (locally.,1), (sc.parallelize(1,1), (only,1), (several,1), (This,2), (basic,1), (Configuration,1), (learning,,1), (documentation,3), (first,1), (graph,1), (Hive,2), (info,1), (["Specifying,1), ("yarn",1), ([params]`.,1), ([project,1), (prefer,1), (SparkPi,2), (<http://spark.apache.org/>,1), (engine,1), (version,1), (file,1), (documentation,,1), (MASTER,1), (example,3), (["Parallel,1), (are,1), (params,1), (scala>,1), (DataFrames,,1), (provides,1), (refer,2), (configure,1), (Interactive,2), (R,,1), (can,7), (build,4),...
  ```

* 将数据集拉到集群内的内存缓存，重复访问时，提高访问速率

  ```bash
  scala> linesWithSpark.cache()
  res8: linesWithSpark.type = MapPartitionsRDD[6] at filter at <console>:26
  
  scala> linesWithSpark.count()
  res9: Long = 20
  ```


### 2.1.2 初始化Spark

```scala
// 设置Spark Context的信息
val conf = new SparkConf().setAppName(appName).setMaster(master)
new SparkContext(conf)
```

**使用shell**

在 Spark shell 中，有一个专有的 SparkContext 已经为你创建好。在变量中叫做 sc。可以用 `--master` 参数来设置 SparkContext 要连接的集群，用 `--jars` 来设置需要添加到 classpath 中的 JAR 包，如果有多个 JAR 包使用**逗号**分割符连接它们。

```bash
# 在一个拥有4核的环境运行spark-shell
$ ./bin/spark-shell --master local[4]
```

```bash
# 将jar加入到classpath
$ ./bin/spark-shell --master local[4] --jars code.jar
```

### 2.1.3 弹性分布式数据集RDD

* **并行集合**

  ```scala
  var data = Array(1,2,3,4,5)
  var distData = sc.parallelize(data) // 并行集合
  ```

  并行集合一个很重要的参数是切片数(*slices*)，表示一个数据集切分的份数。Spark 会在集群上为每一个切片运行一个任务。你可以在集群上为每个 CPU 设置 2-4 个切片(slices)。正常情况下，Spark 会试着基于你的集群状况自动地设置切片的数目。然而，你也可以通过 `parallelize` 的第二个参数手动地设置(例如：`sc.parallelize(data, 10)`)。

* **外部数据集**

  * 读取文件

    所有spark基于文件的方式，包括textFile，能很好支持文件目录，压缩过的文件和通配符。`textFile("/my/文件目录")`，`textFile("/my/文件目录/*.txt")` 和 `textFile("/my/文件目录/*.gz")`

    `textFile`第二个可选参数来控制切片(*slices*)的数目。默认情况下，Spark 为每一个文件块(HDFS 默认文件块大小是 64M)创建一个切片(*slice*)。但是你也可以通过一个更大的值来设置一个更高的切片数目。注意，你不能设置一个小于文件块数目的切片值。

  * 其他数据格式

    `SparkContext.wholeTextFiles` 让你读取一个包含多个小文本文件的文件目录并且返回每一个(filename, content)对。与 `textFile` 的差异是：它记录的是每个文件中的每一行。

    对于 [SequenceFiles](http://hadoop.apache.org/docs/current/api/org/apache/hadoop/mapred/SequenceFileInputFormat.html)，可以使用 SparkContext 的 `sequenceFile[K, V]` 方法创建，K 和 V 分别对应的是 key 和 values 的类型。像 [IntWritable](http://hadoop.apache.org/docs/current/api/org/apache/hadoop/io/IntWritable.html) 与 [Text](http://hadoop.apache.org/docs/current/api/org/apache/hadoop/io/Text.html) 一样，它们必须是 Hadoop 的 [Writable](http://hadoop.apache.org/docs/current/api/org/apache/hadoop/io/Writable.html) 接口的子类。另外，对于几种通用的 Writables，Spark 允许你指定原声类型来替代。例如： `sequenceFile[Int, String]` 将会自动读取 IntWritables 和 Text。

    `RDD.saveAsObjectFile` 和 `SparkContext.objectFile` 支持保存一个RDD，保存格式是一个简单的 Java 对象序列化格式。这是一种效率不高的专有格式，如 Avro，它提供了简单的方法来保存任何一个 RDD。

* **RDD操作**

  * 基本

      RDD支持2中类型操作：transformations和actions，transformation表示从一个数据源创建一个新的RDD，actions表示计算操作，并返回数值。map就是一个transformation，reduce是一个action。**transformation是惰性的，只有action运行的时候才会进行计算。也就是说每次对一个RDD计算，都是需要先transformation，再进行action。如果为了提高action效率，可以将transformation后的RDD持久化到内存中。**

      ```scala
      // 创建一个RDD，因为惰性模式，没有立即计算，lines只是一个指向文件的指针
      val lines = sc.textFile("data.txt")
      // map是一个transformation，因为惰性模式，没有立即计算
      val lineLengths = lines.map(s => s.length)
      // reduce是一个action，spark将计算分成多个任务，并让他们运行在多个机器上
      // 每台机器都运行自己的 map 部分和本地 reduce 部分。然后仅仅将结果返回给驱动程序。
      val totalLength = lineLengths.reduce((a, b) => a + b)
      ```

      如果想要再次使用lineLengths，可以将其持久化到内存中，

      ```scala
      val lines = sc.textFile("data.txt")
      val lineLengths = lines.map(s => s.length)
      lineLengths.persist()// 后面action时，会持久化到内存中
      val totalLength = lineLengths.reduce((a, b) => a + b)
      ```

  * 传递函数到spark
  
    ```scala
    object MyFunctions {
      def func1(s: String): String = { ... }
    }
    
    myRdd.map(MyFunctions.func1)
    ```
  
    如果要传递某一个对象中的方法，需要传递整个对象到集群。比如，
  
    ```scala
    class MyClass {
      val field = "Hello"
        // 调用MyClass对象的doStuff方法时，需要将外部对象"Hello"引入
      def doStuff(rdd: RDD[String]): RDD[String] = { rdd.map(x => field + x) }
    }
    ```
  
    为了避免这个问题，
    
    ```scala
    class MyClass {
      val field = "Hello"
        // 调用MyClass对象的doStuff方法时，需要将外部对象"Hello"引入
      def doStuff(rdd: RDD[String]): RDD[String] = { 
          var field_ = this.field;//复制 field 到一个本地变量而不是从外部访问它
          rdd.map(x => field + x) 
      }
    }
    ```
    
  * 使用键值对
  
      有一些操作（称为shuffle）只针对键值对
  
      `reduceByKey`操作对每一种Key单独进行操作，最典型的是统计文本的个数。
  
      `sortByKey`操作将键值对按照字母排序。
  
  * 一些transformation
  
      [部分中文总结](https://endymecy.gitbooks.io/spark-programming-guide-zh-cn/content/programming-guide/rdds/transformations.html)
  
      [RDD Scala](https://spark.apache.org/docs/latest/api/scala/index.html#org.apache.spark.rdd.RDD) [PairRDDFunctions Scala](https://spark.apache.org/docs/latest/api/scala/index.html#org.apache.spark.rdd.PairRDDFunctions)
  
      [RDD Java](https://spark.apache.org/docs/latest/api/java/index.html?org/apache/spark/api/java/JavaRDD.html) [PairRDDFunctions Java](https://spark.apache.org/docs/latest/api/java/index.html?org/apache/spark/api/java/JavaPairRDD.html)
  
  * 一些Action
  
      [RDD Scala](https://spark.apache.org/docs/latest/api/scala/index.html#org.apache.spark.rdd.RDD) [PairRDDFunctions Scala](https://spark.apache.org/docs/latest/api/scala/index.html#org.apache.spark.rdd.PairRDDFunctions)
  
      [RDD Java](https://spark.apache.org/docs/latest/api/java/index.html?org/apache/spark/api/java/JavaRDD.html) [PairRDDFunctions Java](https://spark.apache.org/docs/latest/api/java/index.html?org/apache/spark/api/java/JavaPairRDD.html)
  
* **RDD持久化**

  可以利用不同的存储级别存储每一个被持久化的RDD。使用方法是通过给`persist()`设置存储级别。

  | Storage Level                              | Meaning                                                      |
  | ------------------------------------------ | ------------------------------------------------------------ |
  | `MEMORY_ONLY`                              | 将RDD作为非序列化的Java对象存储在jvm中。如果RDD不适合存在内存中，一些分区将不会被缓存，从而在每次需要这些分区时都需重新计算它们。这是系统默认的存储级别。 |
  | `MEMORY_AND_DISK`                          | 将RDD作为非序列化的Java对象存储在jvm中。如果RDD不适合存在内存中，将这些不适合存在内存中的分区存储在磁盘中，每次需要时读出它们。 |
  | `MEMORY_ONLY_SER`                          | 将RDD作为序列化的Java对象存储（每个分区一个byte数组）。这种方式比非序列化方式更节省空间，特别是用到快速的序列化工具时，但是会更耗费cpu资源—密集的读操作。 |
  | `MEMORY_AND_DISK_SER`                      | 和MEMORY_ONLY_SER类似，但不是在每次需要时重复计算这些不适合存储到内存中的分区，而是将这些分区存储到磁盘中。 |
  | `DISK_ONLY`                                | 仅仅将RDD分区存储到磁盘中                                    |
  | `MEMORY_ONLY_2`, `MEMORY_AND_DISK_2`, etc. | 和上面的存储级别类似，但是复制每个分区到集群的两个节点上面   |
  | `OFF_HEAP `(experimental)                  | 以序列化的格式存储RDD到[Tachyon](http://tachyon-project.org/)中。相对`于MEMORY_ONLY_SER`，`OFF_HEAP`减少了垃圾回收的花费，允许更小的执行者共享内存池。这使其在拥有大量内存的环境下或者多并发应用程序的环境中具有更强的吸引力。 |

  *删除内存中的数据*

  `RDD.unpersist()`方法

  *如何选择存储级别？*

  - 如果你的RDD适合默认的存储级别（`MEMORY_ONLY`），就选择默认的存储级别。因为这是cpu利用率最高的选项，会使RDD上的操作尽可能的快。
  - 如果不适合用默认的级别，选择`MEMORY_ONLY_SER`。选择一个更快的序列化库提高对象的空间使用率，但是仍能够相当快的访问。
  - 除非函数计算RDD的花费较大或者它们需要过滤大量的数据，不要将RDD存储到磁盘上，否则，重复计算一个分区就会和重磁盘上读取数据一样慢。
  - 如果你希望更快的错误恢复，可以利用重复(replicated)存储级别。所有的存储级别都可以通过重复计算丢失的数据来支持完整的容错，但是重复的数据能够使你在RDD上继续运行任务，而不需要重复计算丢失的数据。
  - 在拥有大量内存的环境中或者多应用程序的环境中，`OFF_HEAP`具有如下优势：
    - 它运行多个执行者共享Tachyon中相同的内存池
    - 它显著地减少垃圾回收的花费
    - 如果单个的执行者崩溃，缓存的数据不会丢失

### 2.1.4 共享变量

#### 2.1.4.1 广播变量

广播变量允许程序员缓存一个只读的变量在每台机器上面，而不是每个任务保存一份拷贝。利用广播变量，我们能够以一种更有效率的方式将一个大数据量输入集合的副本分配给每个节点。

```scala
// SparkContext.broadcast(v)方法从一个初始变量v中创建
scala> val broadcastVar = sc.broadcast(Array(1, 2, 3))
broadcastVar: spark.Broadcast[Array[Int]] = spark.Broadcast(b5c40191-a864-4c7d-b9bf-d87e1a4e787c)
// 广播变量是v的一个包装变量，它的值可以通过value方法访问
scala> broadcastVar.value
res0: Array[Int] = Array(1, 2, 3)
```

**广播变量创建以后，我们就能够在集群的任何函数中使用它来代替变量v，这样我们就不需要再次传递变量v到每个节点上。另外，为了保证所有的节点得到广播变量具有相同的值，对象v不能在广播之后被修改。**

#### 2.1.4.2 累加器

累加器是一种只能通过关联操作进行“加”操作的变量，因此它能够高效的应用于并行操作中。

```scala
// 通过accumulator创建一个累加器
scala> val accum = sc.accumulator(0, "My Accumulator")
accum: spark.Accumulator[Int] = 0
// 并行计算
scala> sc.parallelize(Array(1, 2, 3, 4)).foreach(x => accum += x)
...
10/09/29 18:41:08 INFO SparkContext: Tasks finished in 0.317106 s
scala> accum.value
res2: Int = 10
```

## 2.2 SQL

## 2.3 Spark Stream

Spark streaming是Spark核心API的一个扩展，它对实时流式数据的处理具有可扩展性、高吞吐量、可容错性等特点。

<img src="/images/wiki/Spark/streaming-flow.png" width="700" alt="Stream效果" />

Spark Streaming支持一个高层的抽象，叫做离散流(`discretized stream`)或者`DStream`，它代表连续的数据流。DStream既可以利用从Kafka, Flume和Kinesis等源获取的输入数据流创建，也可以 在其他DStream的基础上通过高阶函数获得。在内部，DStream是由一系列RDDs组成。

Spark Stream可以输出到[机器学习算法](https://spark.apache.org/docs/latest/mllib-guide.html)

### 2.3.1 快速例子

程序从监听TCP套接字的数据服务器获取文本数据，然后计算文本中包含的单词数。

```scala
import org.apache.spark._
import org.apache.spark.streaming._
import org.apache.spark.streaming.StreamingContext._
// Create a local StreamingContext with two working thread and batch interval of 1 second
val conf = new SparkConf().setMaster("local[2]").setAppName("NetworkWordCount")
val ssc = new StreamingContext(conf, Seconds(1)) // 每1秒钟处理一次
// 创建一个DStream
// 可以通过KafkaUtils.createDirectStream创建来自kafka的数据流
val lines = ssc.socketTextStream("localhost", 9999)
```





## 2.4 MLib

## 2.5 GraphX



# 3、Spark技术

## 3.1 Checkpoint机制

Checkpoint 是用来容错的，当错误发生的时候，可以迅速恢复的一种机制。

在SparkContext中需要调用setCheckpointDir方法，设置一个容错的文件系统的目录，比如HDFS。然后对RDD调用checkpoint方法，之后在RDD所处的job运行结束之后，会启动一个单独的job来将checkpoint过的RDD的数据写入之前设置的文件系统中。进行持久化操作。那么此时，即使在后面使用RDD的时候，他的持久化数据不小心丢失了，但是还是可以从它的checkpoint文件中读取出该数据，而无需重新计算。

## 3.2 弹性分布式数据集

RDD 是指能横跨集群所有节点进行并行计算的分区元素集合（Resilient Distributed Dataset，弹性分布式集合）。RDDs 从 Hadoop 的文件系统中的一个文件中创建而来(或其他 Hadoop 支持的文件系统)，或者从一个已有的 Scala 集合转换得到。用户可以要求 Spark 将 RDD *持久化(persist)*到内存中，来让它在并行计算中高效地重用。最后，RDDs 能在节点失败中自动地恢复过来。

*RDD和持久化RDD的区别？*

在 Spark 中，所有的转换(transformations)都是惰性(lazy)的，它们不会马上计算它们的结果。相反的，它们仅仅记录转换操作是应用到哪些基础数据集(例如一个文件)上的。转换仅仅在这个时候计算：当动作(action) 需要一个结果返回给驱动程序的时候。这个设计能够让 Spark 运行得更加高效。例如，我们可以实现：通过 `map` 创建一个新数据集在 `reduce` 中使用，并且仅仅返回 `reduce` 的结果给 driver，而不是整个大的映射过的数据集。默认情况下，每一个转换过的 RDD 会在每次执行动作(action)的时候重新计算一次。然而，你也可以使用 `persist` (或 `cache`)方法持久化(`persist`)一个 RDD 到内存中。在这个情况下，Spark 会在集群上保存相关的元素，在你下次查询的时候会变得更快。

## 3.3 共享变量

共享变量能被运行在并行计算中。默认情况下，当 Spark 运行一个并行函数时，这个并行函数会作为一个任务集在不同的节点上运行，它会把函数里使用的每个变量都复制搬运到每个任务中。有时，一个变量需要被共享到交叉任务中或驱动程序和任务之间。Spark支持两种共享变量：1.广播变量，用来所有节点的内存中缓存一个值；2.累加器(accumulators)，仅仅只能执行“添加(added)”操作，例如：记数器(counters)和求和(sums)。

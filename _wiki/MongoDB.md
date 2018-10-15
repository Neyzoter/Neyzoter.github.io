---
layout: wiki
title: MongoDB
categories: MongoDB
description: MongoDB的用法
keywords: MongoDB
---

# 1、命令
## 1.1 数据库
### 创建数据库
如果数据库不存在，则创建数据库

```
use DATABASE_NAME
```
### 删除数据库
删除**当前**数据库

```
db.dropDatabase()
```

### 显示所有数据库列表
```
show dbs
```

### 显示当前数据库对象或者集合
```
db
```

## 1.2 集合
### 创建集合
```
db.createCollection(name, options)
```

option格式：  [option名称:参数]

|字段 |	类型 |	描述|
|-|-|-|
|capped	|布尔	|（可选）如果为 true，则创建固定集合。固定集合是指有着固定大小的集合，当达到最大值时，它会自动覆盖最早的文档。
**当该值为 true 时，必须指定 size 参数。**|
|-|-|-|
|autoIndexId	|布尔	|（可选）如为 true，自动在 _id 字段创建索引。默认为 false。|
|-|-|-|
|size	|数值	|（可选）为固定集合指定一个最大值（以字节计）。
**如果 capped 为 true，也需要指定该字段。**|
|-|-|-|
|max |	数值	|（可选）指定固定集合中包含文档的最大数量。|

eg.

```
db.createCollection("mycol", { capped : true, autoIndexId : true, size : 
   6142800, max : 10000 } )
```

**创建capped collections**

固定大小的colletion

```
db.createCollection("mycoll", {capped:true, size:100000})
```

### 删除集合

```
db.collection.drop()
```

返回：true：删除成功；false：删除失败。

### 查看集合

```
show collections
```

## 1.3 文档document
相当于SQL中的行row。

文档数据结构和json基本一样。所有存储在集合中的数据都是BSON格式。BSON是一种类json的二进制形式的存储格式，简称Binary Json。

### 插入文档
* insert

```
db.COLLECTION_NAME.insert(document)
```

eg.col为一个集合名。如果col不在数据库中，则自动创建。

```
db.col.insert({title: 'MongoDB 教程', 
    description: 'MongoDB 是一个 Nosql 数据库',
    by: '菜鸟教程',
    url: 'http://www.runoob.com',
    tags: ['mongodb', 'database', 'NoSQL'],
    likes: 100
})
```

* insertMany

插入多条文档

```
db.col.insertMany([{"b":3},{"c":4}])
```

### 更新文档
* update

```
db.collection.update(
   <query>,
   <update>,
   {
     upsert: <boolean>,
     multi: <boolean>,
     writeConcern: <document>
   }
)
```

**query** : update的查询条件，类似sql update查询内where后面的。

**update** : update的对象和一些更新的操作符（如$,$inc...）等，也可以理解为sql update查询内set后面的

**upsert** : 可选，这个参数的意思是，如果不存在update的记录，是否插入objNew,true为插入，默认是false，不插入。

**multi** : 可选，mongodb 默认是false,只更新找到的第一条记录，如果这个参数为true,就把按条件查出来多条记录全部更新。

**writeConcern** :可选，抛出异常的级别。

```
WriteConcern.NONE:没有异常抛出
WriteConcern.NORMAL:仅抛出网络错误异常，没有服务器错误异常
WriteConcern.SAFE:抛出网络错误异常、服务器错误异常；并等待服务器完成写操作。
WriteConcern.MAJORITY: 抛出网络错误异常、服务器错误异常；并等待一个主服务器完成写操作。
WriteConcern.FSYNC_SAFE: 抛出网络错误异常、服务器错误异常；写操作等待服务器将数据刷新到磁盘。
WriteConcern.JOURNAL_SAFE:抛出网络错误异常、服务器错误异常；写操作等待服务器提交到磁盘的日志文件。
WriteConcern.REPLICAS_SAFE:抛出网络错误异常、服务器错误异常；等待至少2台服务器完成写操作。
```

```
db.col.update({'title':'MongoDB 教程'},{$set:{'title':'MongoDB'}},{multi:true})
```

以上{'title':'MongoDB 教程'}是query（查询部分）；{$set:{'title':'MongoDB'}}为update部分；{multi:true}为可以找到多个匹配的记录。

其他，

db.collection.updateOne() 向指定集合更新单个文档

db.collection.updateMany() 向指定集合更新多个文档

* save

通过传入的文档来替换已有文档。

```
db.collection.save(
   <document>,
   {
     writeConcern: <document>
   }
)
```

**document** : 文档数据。

**writeConcern** :可选，抛出异常的级别。

在document中指定_id字段，则可以更新该_id的数据。

```
db.col.save(document)
```

如果不提供_id字段，则save和insert一样新生成一个文档。

### 删除文档
官方推荐delete

* delete

删除集合下的所有文档


```
db.col.deleteMany({})
```

删除 status 等于 A 的全部文档

db.col.deleteMany({ status : "A" })

删除 status 等于 D 的一个文档

db.col.deleteOne( { status: "D" } )

* remove
 
已经过时。

```
db.collection.remove(
   <query>,
   {
     justOne: <boolean>,
     writeConcern: <document>
   }
)
```

**query** :（可选）删除的文档的条件。

**justOne **: （可选）如果设为 true 或 1，则只删除一个文档。

**writeConcern** :（可选）抛出异常的级别。

### 查询文档
* DBQuery.shellBatchSize

```
DBQuery.shellBatchSize
```
设置查询到的doc个数。

* find

```
db.collection.find(query, projection)
```

**query** ：可选，使用查询操作符指定查询条件

**projection** ：可选，使用投影操作符指定返回的键。查询时返回文档中所有键值， 只需省略该参数即可（默认省略）。

protection的使用：

```
db.collection.find(query, {title: 1, by: 1}) // inclusion模式 指定返回的键（title和by），不返回其他键
db.collection.find(query, {title: 0, by: 0}) // exclusion模式 指定不返回的键（title和by）,返回其他键
```

* fineOne

findOne()：只返回一个文档

* pretty

以易读的方式查询，pretty()

```
db.col.find().pretty()
```

* 查询语句

**和RDBMS的where比较**

|操作|格式|范例|RDBMS中的类似语句|
|-|-|-|-|
|等于|{<key>:<value>}|db.col.find({"by":"菜鸟教程"}).pretty()|where by = '菜鸟教程'|
|-|-|-|-|
|小于|{<key>:{$lt:<value>}}|db.col.find({"likes":{$lt:50}}).pretty()|where likes < 50
|-|-|-|-|
|小于或等于|{<key>:{$lte:<value>}}|db.col.find({"likes":{$lte:50}}).pretty()|where likes <= 50|
|-|-|-|-|
|大于|{<key>:{$gt:<value>}}|db.col.find({"likes":{$gt:50}}).pretty()|where likes > 50|
|-|-|-|-|
|大于或等于|{<key>:{$gte:<value>}}|db.col.find({"likes":{$gte:50}}).pretty()|where likes >= 50|
|-|-|-|-|
|不等于|{<key>:{$ne:<value>}}|db.col.find({"likes":{$ne:50}}).pretty()|where likes != 50|

**操作符简写**

```
$gt -------- greater than  >

$gte --------- gt equal  >=

$lt -------- less than  <

$lte --------- lt equal  <=

$ne ----------- not equal  !=

$eq  --------  equal  =
```

**模糊查询**

```
查询 title 包含"教"字的文档：
db.col.find({title:/教/})

查询 title 字段以"教"字开头的文档：
db.col.find({title:/^教/})

查询 titl e字段以"教"字结尾的文档：
db.col.find({title:/教$/})
```

**AND条件用逗号**

db.col.find({key1:value1, key2:value2}).pretty()

**OR条件用$or**

```
db.col.find(
   {
      $or: [
         {key1: value1}, {key2:value2}
      ]
   }
).pretty()
```

**OR和AND连用**

```
db.col.find({"likes": {$gt:50}, $or: [{"by": "菜鸟教程"},{"title": "MongoDB 教程"}]}).pretty()
```

* $type

$type操作符是基于BSON类型来检索集合中匹配的数据类型，并返回结果
```
db.col.find({"title" : {$type : 2}})
或
db.col.find({"title" : {$type : 'string'}})
```

```
Double	                1	 
String	                2	 
Object	                3	 
Array	                4	 
Binary data         	5	 
Undefined	            6	已废弃。
Object id	            7	 
Boolean	                8	 
Date	                9	 
Null	                10	 
Regular Expression	    11	 
JavaScript	            13	 
Symbol	                14	 
JavaScript (with scope)	15	 
32-bit integer	        16	 
Timestamp	            17	 
64-bit integer	        18	 
Min key	                255	Query with -1.
Max key	                127	 
```

* limit和skip

limit:在MongoDB中读取指定数量的数据记录

skip：在MongoDB中跳过指定数量的数据

1、读取前NUMBER个数据

```
db.COLLECTION_NAME.find().limit(NUMBER)
```

2、读取第NUMBER1条数据后的NUMBER1条

```
db.COLLECTION_NAME.find().skip(NUMBER1).limit(NUMBER1)
```

说明：**当查询时同时使用sort,skip,limit，无论位置先后，最先执行顺序 sort再skip再limit**

## 1.5 数据处理
### 插入数据
db是一个目录，用于存放所有数据库。


```
db.DATABASE_NAME.insert({x:10})
```

### 格林尼治时间
```
var mydate1 = new Date()
或者
var mydate1 = ISODate()
```

### 排序

```
db.COLLECTION_NAME.find().sort({KEY:1})
```

其中，KEY是某一个字段，1：升序；-1：降序。

### 索引
索引通常能够极大的提高查询的效率，如果没有索引，MongoDB在读取数据时必须扫描集合中的每个文件并选取那些符合查询条件的记录。

索引是特殊的数据结构，索引存储在一个易于遍历读取的数据集合中，索引是对数据库表中一列或多列的值进行排序的一种结构

```
db.collection.createIndex(keys:val, options)
```

eg.

```
db.values.createIndex({open: 1, close: 1}, {background: true})
```

keys为要创建的索引字段，val为1：按照升序创建索引；val为-1：按照降序来创建索引。可以设置使用多个字段创建索引。

|Parameter	| Type |	Description|
|-|-|-|
|background	| Boolean	| 建索引过程会阻塞其它数据库操作，background可指定以后台方式创建索引，即增加 "background" 可选参数。 "background" 默认值为false。|
|-|-|-|
|unique	| Boolean	|建立的索引是否唯一。指定为true创建唯一索引。默认值为false.|
|-|-|-|
|name	| string	| 索引的名称。如果未指定，MongoDB的通过连接索引的字段名和排序顺序生成一个索引名称。|
|-|-|-|
|dropDups	 | Boolean	| 3.0+版本已废弃。在建立唯一索引时是否删除重复记录,指定 true 创建唯一索引。默认值为 false.|
|-|-|-|
| sparse	| Boolean	| 对文档中不存在的字段数据不启用索引；这个参数需要特别注意，如果设置为true的话，在索引字段中不会查询出不包含对应字段的文档.。默认值为 false.|
|-|-|-|
| expireAfterSeconds	| integer	| 指定一个以秒为单位的数值，完成 TTL设定，设定集合的生存时间。|
|-|-|-|
|v	| index version	| 索引的版本号。默认的索引版本取决于mongod创建索引时运行的版本。|
|-|-|-|
|weights	| document	|索引权重值，数值在 1 到 99,999 之间，表示该索引相对于其他索引字段的得分权重。|
|-|-|-|
|default_language	| string	| 对于文本索引，该参数决定了停用词及词干和词器的规则的列表。 默认为英语|
|-|-|-|
| language_override	| string	| 对于文本索引，该参数指定了包含在文档中的字段名，语言覆盖默认的language，默认值为 language.|

### 聚合
MongoDB中聚合(aggregate)主要用于处理数据(诸如统计平均值,求和等)，并返回计算后的数据结果。类似于SQL中的count(*)

```
db.COLLECTION_NAME.aggregate(AGGREGATE_OPERATION)
```

eg.

```
db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$sum : 1}}}])
```

其中$group是管道，$sum是聚合的表达式。

* 管道

管道在Unix和Linux中一般用于将当前命令的输出结果作为下一个命令的参数。

MongoDB的聚合管道将MongoDB文档在一个管道处理完毕后将结果传递给下一个管道处理。管道操作是可以重复的。

**表达式：处理输入文档并输出。表达式是无状态的，只能用于计算当前聚合管道的文档，不能处理其它的文档。**

**$project**：修改输入文档的结构。可以用来重命名、增加或删除域，也可以用于创建计算结果以及嵌套文档。

**$match**：用于过滤数据，只输出符合条件的文档。$match使用MongoDB的标准查询操作。

**$limit**：用来限制MongoDB聚合管道返回的文档数。

**$skip**：在聚合管道中跳过指定数量的文档，并返回余下的文档。

**$unwind**：将文档中的某一个数组类型字段拆分成多条，每条包含数组中的一个值。

**$group**：将集合中的文档分组，可用于统计结果。

**$sort**：将输入文档排序后输出。

**$geoNear**：输出接近某一地理位置的有序文档。

管道实例:

$project只留下_id、title和author：

```
db.article.aggregate(
    { $project : {
        title : 1 ,
        author : 1 ,
    }}
 );
```

$match过滤数据：

获取分数大于70小于或等于90记录，然后**将符合条件的记录送到下一阶段$group管道操作符进行处理**

```
db.articles.aggregate( [
                        { $match : { score : { $gt : 70, $lte : 90 } } },
                        { $group: { _id: null, count: { $sum: 1 } } }
                       ] );
```

$skip跳过文档

跳过前五个。

```
db.article.aggregate(
    { $skip : 5 });
```

* 聚合表达式

|表达式|	描述|	实例|
|-|-|-|
|$sum	| 计算总和。	|db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$sum : "$likes"}}}])|
|-|-|-|
|$avg	| 计算平均值| 	db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$avg : "$likes"}}}])|
|-|-|-|
|$min|	获取集合中所有文档对应值得最小值。|	db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$min : "$likes"}}}])|
|-|-|-|
|$max	| 获取集合中所有文档对应值得最大值。	db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$max : "$likes"}}}])|
|-|-|-|
|$push	|在结果文档中插入值到一个数组中。|	db.mycol.aggregate([{$group : {_id : "$by_user", url : {$push: "$url"}}}])|
|-|-|-|
|$addToSet	| 在结果文档中插入值到一个数组中，但不创建副本。|	db.mycol.aggregate([{$group : {_id : "$by_user", url : {$addToSet : "$url"}}}])|
|-|-|-|
|$first	| 根据资源文档的排序获取第一个文档数据。|	db.mycol.aggregate([{$group : {_id : "$by_user", first_url : {$first : "$url"}}}])|
|-|-|-|
|$last |	根据资源文档的排序获取最后一个文档数据|	db.mycol.aggregate([{$group : {_id : "$by_user", last_url : {$last : "$url"}}}])|

## 1.6 MongoDB复制
MongoDB复制是将数据同步在多个服务器的过程。

1、关闭正在运行的MongoDB服务器

2、启动MongoDB
```
mongod --port "PORT" --dbpath "YOUR_DB_DATA_PATH" --replSet "REPLICA_SET_INSTANCE_NAME"
```

eg.会启动一个名为rs0的MongoDB实例，其端口号为27017。

```
mongod --port 27017 --dbpath "\data\db" --replSet rs0
```

3、打开命令提示框并连接上mongoDB服务。

```
mongo
```

4、使用命令rs.initiate()来启动一个新的副本集

```
rs.initiate()
```

查看配置：

```
rs.conf()
```

查看副本集状态：

```
rs.status() 
```

5、副本集添加成员

需要多台服务器启动MongoDB服务。进入Mongo客户端，使用rs.add()方法来添加副本集的成员。

```
rs.add(HOST_NAME:PORT)
```

eg.

```
rs.add("mongod1.net:27017")
```

MongoDB的副本集于常见的主从有所不同，主从在主机死掉后所有服务停止，而副本集在主机死后，副本会接管主节点成为主节点。

# 2、分片技术
分片技术,可以满足MongoDB数据量大量增长的需求。

当MongoDB存储海量的数据时，一台机器可能不足以存储数据，也可能不足以提供可接受的读写吞吐量。这时，我们就可以通过在多台机器上分割数据，使得数据库系统能存储和处理更多的数据。

# 3、备份与恢复

## 3.1 备份
```
mongodump -h dbhost -d dbname -o dbdirectory
```

**-h**：

MongDB所在服务器地址，例如：127.0.0.1，当然也可以指定端口号：127.0.0.1:27017

**-d**：

需要备份的数据库实例，例如：test

**-o**：

备份的数据存放位置，例如：c:\data\dump，当然该目录需要提前建立，在备份完成后，系统自动在dump目录下建立一个test目录，这个目录里面存放该数据库实例的备份数据。

## 3.2 数据恢复
```
mongorestore -h <hostname><:port> -d dbname <path>
```

**\-\-host \<:port\>, \-h \<:port\>**：

MongoDB所在服务器地址，默认为： localhost:27017

**\-\-db,\-d**：

需要恢复的数据库实例，例如：test，当然这个名称也可以和备份时候的不一样，比如test2

**\-\-drop**：

恢复的时候，先删除当前数据，然后恢复备份的数据。就是说，恢复后，备份后添加修改的数据都会被删除，慎用哦！

**\<path\>**：

mongorestore 最后的一个参数，设置备份数据所在位置，例如：c:\data\dump\test。

你不能同时指定 <path> 和 --dir 选项，--dir也可以设置备份目录。

**\-\-dir**：

指定备份的目录

你不能同时指定 <path> 和 --dir 选项。

# 4、监控
## 4.1 mongostat 
mongostat是mongodb自带的状态检测工具，在命令行下使用。

它会间隔固定时间获取mongodb的当前运行状态，并输出。如果你发现数据库突然变慢或者有其他问题的话，你第一手的操作就考虑采用mongostat来查看mongo的状态。

启动方法：

1、启动你的Mongod服务

2、进入到你安装的MongoDB目录下的bin目录， 然后输入mongostat命令

## 4.2 mongotop 
mongotop提供了一个方法，用来跟踪一个MongoDB的实例，查看哪些大量的时间花费在读取和写入数据。

启动方法：

1、启动你的Mongod服务

2、进入到你安装的MongoDB目录下的bin目录， 然后输入mongotop命令

```
mongotop --locks
```

使用mongotop - 锁，这将产生以下输出

**ns**：
包含数据库命名空间，后者结合了数据库名称和集合。

**db**：

包含数据库的名称。名为 . 的数据库针对全局锁定，而非特定数据库。

**total**：

mongod花费的时间工作在这个命名空间提供总额。

**read**：

提供了大量的时间，这mongod花费在执行读操作，在此命名空间。

write：

提供这个命名空间进行写操作，这mongod花了大量的时间。

# 5、设置
### 启动服务

```
目录/mongod**
```

### 开始shell

```
目录/mongo
```

### 元数据

```
<dbname>.system.*
```

是包含多种系统信息的特殊集合

```
dbname.system.namespaces	列出所有名字空间。
dbname.system.indexes	列出所有索引。
dbname.system.profile	包含数据库概要(profile)信息。
dbname.system.users	列出所有可访问数据库的用户。
dbname.local.sources	包含复制对端（slave）的服务器信息和状态。
```

### MongoDB连接
#### 启动MongoDB服务

```
mongodb://[username:password@]host1[:port1][,host2[:port2],...[,hostN[:portN]]][/[database][?options]]mongodb://[username:password@]host1[:port1][,host2[:port2],...[,hostN[:portN]]][/[database][?options]]
```

**mongodb://** 这是固定的格式，必须要指定。

**username:password@** 可选项，如果设置，在连接数据库服务器之后，驱动都会尝试登陆这个数据库

**host1** 必须的指定至少一个host, host1 是这个URI唯一要填写的。它指定了要连接服务器的地址。如果要连接复制集，请指定多个主机地址。

**portX** 可选的指定端口，如果不填，默认为27017

**/database** 如果指定username:password@，连接并验证登陆指定数据库。若不指定，默认打开 test 数据库。

**?options** 是连接选项。如果不使用/database，则前面需要加上/。所有连接选项都是键值对name=value，键值对之间通过&或;（分号）隔开

#### MongoDB连接命令

使用用户名和密码连接到 MongoDB 服务器，你必须使用 'username:password@hostname/dbname' 格式，'username'为用户名，'password' 为密码。

1、使用用户名和密码连接登陆到默认数据库

```
./mongo
```

2、使用用户admin和密码123456连接到本地MongoDB服务

```
 mongodb://admin:123456@localhost/
```

3、使用用户名和密码连接登陆到指定数据库

```
mongodb://admin:123456@localhost/test
```

4、连接 replica pair, 服务器1为example1.com服务器2为example2

```
mongodb://example1.com:27017,example2.com:27017
```

# 6、概念
### SQL和MongoDB

|SQL术语/概念 | MongoDB术语/概念 | 解释/说明|
|-|-|-|
|database | database | 数据库|
|-|-|-|
|table | collection | 数据库表/集合|
|-|-|-|
|row | document | 数据记录行/文档|
|-|-|-|
|column |  field | 数据字段/域|
|-|-|-|
|index | index | 索引|
|-|-|-|
|table joins |-| 表连接,MongoDB不支持|
|-|-|-|
|primary key	| primary key | 主键,MongoDB自动将_id字段设置为主键|

### MongoDB的格式

|id|user_name|email|age|city|
|-|-|-|-|-|
|1|Mark Hanks|mark@abc.com|25|Los Angles|

```
{
"_id":ObjectId("5146bb52d8524270060001f3"),
"age":25,
"city":"Los Angeles",
"email":"mark@abc.com",
"user_name":"Mark Hanks"
}
```

注：ObjectId数据类型包括12bytes，前4个时间戳（格林尼治时间UTC），下面3个字节是机器识别码，下面2个字节是进程id组成PID，最后3个字节是随机数。

### 数据库命名

1、不能是空字符串（"")。

2、不得含有' '（空格)、.、$、/、\和\0 (空字符)。

3、应全部小写。

4、最多64字节。

### MongoDB保留的数据库

**admin**： 从权限的角度来看，这是"root"数据库。要是将一个用户添加到这个数据库，这个用户自动继承所有数据库的权限。一些特定的服务器端命令也只能从这个数据库运行，比如列出所有的数据库或者关闭服务器。

**local**: 这个数据永远不会被复制，可以用来存储限于本地单台服务器的任意集合

**config**: 当Mongo用于分片设置时，config数据库在内部使用，用于保存分片的相关信息。

### 文档
文档是一组键值(key-value)对(即BSON)。


 | RDBMS | MongoDB | 
 |-  |    -  |
 | 数据库 | 数据库 | 
 |-  |    -  |
 | 表格 | 集合 |
 |-  |    -  | 
 | 行 | 文档 | 
 |-  |    -  |
 | 列 | 字段 | 
 |-  |    -  |
 | 表联合 | 嵌入文档 | 
 |-  |    -  |
 | 主键 | 主键 (MongoDB 提供了 key 为 _id ) | 

### MongoDB的数据类型


|数据类型 | 描述 |
|-|-|
|String | 字符串。存储数据常用的数据类型。在 MongoDB 中，UTF-8 编码的字符串才是合法的。|
|-|-|
|Integer | 整型数值。用于存储数值。根据你所采用的服务器，可分为 32 位或 64 位。|
|-|-|
|Boolean | 布尔值。用于存储布尔值（真/假）。|
|-|-|
|Double | 双精度浮点值。用于存储浮点值。|
|-|-|
| Min/Max keys | 将一个值与 BSON（二进制的 JSON）元素的最低值和最高值相对比。|
|-|-|
|Array | 用于将数组或列表或多个值存储为一个键。|
|-|-|
|Timestamp | 时间戳。记录文档修改或添加的具体时间。|
|-|-|
|Object | 用于内嵌文档。|
|-|-|
|Null | 用于创建空值。|
|-|-|
|Symbol | 符号。该数据类型基本上等同于字符串类型，但不同的是，它一般用于采用特殊符号类型的语言。|
|-|-|
|Date|日期时间。用 UNIX 时间格式来存储当前日期或时间。你可以指定自己的日期时间：创建 Date 对象，传入年月日信息。|
|-|-|
|Object ID | 对象 ID。用于创建文档的 ID。|
|-|-|
| Binary Data | 二进制数据。用于存储二进制数据。|
|-|-|
|Code  | 代码类型。用于在文档中存储 JavaScript 代码。|
|-|-|
|Regular expression|正则表达式类型。用于存储正则表达式。|

* ObjectId

前 4 个字节表示创建 unix 时间戳,格林尼治时间 UTC 时间，比北京时间晚了 8 个小时

接下来的 3 个字节是机器标识码

紧接的两个字节由进程 id 组成 PID

最后三个字节是随机数

<img src="/images/wiki/MongoDB/MongoDB_ObjectId.jpeg" width="400" alt="ObjectId" />

```
var newObject = ObjectId()
newObject.getTimestamp()
newObject.str
```

* 时间戳

BSON有一个特殊的时间戳类型用于 MongoDB 内部使用，与普通的 日期 类型不相关。

64bits：[0:31]，time_t，与Unix新纪元相差的秒数;[32:63],某秒中操作的一个递增的序数。






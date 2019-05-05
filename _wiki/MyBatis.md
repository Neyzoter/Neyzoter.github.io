---
layout: wiki
title: MyBatis
categories: MyBatis
description: MyBatis笔记
keywords: ORM, MyBatis
---

# 1、介绍

MyBatis是一个简单，小巧但功能非常强大的ORM(Object-Relational Mapping，对象-关系映射)开源框架，它的功能强大也体现在它的缓存机制上。MyBatis提供了一级缓存、二级缓存这两个缓存机制，能够很好地处理和维护缓存，以提高系统的性能。

## 1.1 一级缓存

对于会话（Session）级别的数据缓存，我们称之为一级数据缓存，简称一级缓存。

每当我们使用MyBatis开启一次和数据库的会话，MyBatis会创建出一个SqlSession对象表示一次数据库会话。

在对数据库的一次会话中，我们有可能会反复地执行完全相同的查询语句，如果不采取一些措施的话，每一次查询都会查询一次数据库,而我们在极短的时间内做了完全相同的查询，那么它们的结果极有可能完全相同，由于查询一次数据库的代价很大，这有可能造成很大的资源浪费。

为了解决这一问题，减少资源的浪费，MyBatis会在表示会话的SqlSession对象中建立一个简单的缓存，将每次查询到的结果结果缓存起来，当下次查询的时候，如果判断先前有个完全一样的查询，会直接从缓存中直接将结果取出，返回给用户，不需要再进行一次数据库查询了。

MyBatis会在一次会话的表示（一个SqlSession对象）中创建一个本地缓存(local cache)，对于每一次查询，都会尝试根据查询的条件去本地缓存中查找是否在缓存中，如果在缓存中，就直接从缓存中取出，然后返回给用户；否则，从数据库读取数据，将查询结果存入缓存并返回给用户。

<img src="/images/wiki/MyBatis/1cache.jpg" width="700" alt="MyBatis一级缓存机制" />

## 1.2 一级缓存实现原理

MyBatis只是一个MyBatis对外的接口，SqlSession将它的工作交给了Executor执行器这个角色来完成，负责完成对数据库的各种操作。当创建了一个SqlSession对象时，MyBatis会为这个SqlSession对象创建一个新的Executor执行器，而缓存信息就被维护在这个Executor执行器中，MyBatis将缓存和对缓存相关的操作封装成了Cache接口中。SqlSession、Executor、Cache之间的关系如下列类图所示：

<img src="/images/wiki/MyBatis/SqlSession2Executor2Cache.jpg" width="700" alt="SqlSession、Executor、Cache之间的关系" />

Executor接口的实现类BaseExecutor中拥有一个Cache接口的实现类PerpetualCache，则对于BaseExecutor对象而言，它将使用PerpetualCache对象维护缓存。

由于Session级别的一级缓存实际上就是使用PerpetualCache维护的，那么PerpetualCache是怎样实现的呢？

PerpetualCache实现原理其实很简单，其内部就是通过一个简单的HashMap<k,v> 来实现的，没有其他的任何限制。如下是PerpetualCache的实现代码：

```java
public class PerpetualCache implements Cache {
	private String id;
	private Map<Object, Object> cache = new HashMap<Object, Object>();
	public PerpetualCache(String id) {
 		this.id = id;
 	}
	public String getId() {
 		return id;
 	}
 	public int getSize() {
 		return cache.size();
 	}
 	public void putObject(Object key, Object value) {
 		cache.put(key, value);
 	}
 	public Object getObject(Object key) {
 		return cache.get(key);
 	}
 	public Object removeObject(Object key) {
 		return cache.remove(key);
 	}
 	public void clear() {
 		cache.clear();
 	}
 	public ReadWriteLock getReadWriteLock() {
 		return null;
 	}
 	public boolean equals(Object o) {
 		if (getId() == null) throw new CacheException("Cache instances require an ID.");
 		if (this == o) return true;
 		if (!(o instanceof Cache)) return false;
 
 		Cache otherCache = (Cache) o;
 		return getId().equals(otherCache.getId());
	}
 	public int hashCode() {
 		if (getId() == null) throw new CacheException("Cache instances require an ID.");
 		return getId().hashCode();
 	}
 
}
```

## 1.3 一级缓存的生命周期

a. MyBatis在开启一个数据库会话时，会创建一个新的SqlSession对象，SqlSession对象中会有一个新的Executor对象，Executor对象中持有一个新的PerpetualCache对象；当会话结束时，SqlSession对象及其内部的Executor对象还有PerpetualCache对象也一并释放掉。

b. 如果SqlSession调用了close()方法，会释放掉一级缓存PerpetualCache对象，一级缓存将不可用；

c. 如果SqlSession调用了clearCache()，会清空PerpetualCache对象中的数据，但是该对象仍可使用；

d.SqlSession中执行了任何一个update操作(update()、delete()、insert()) ，都会清空PerpetualCache对象的数据，但是该对象可以继续使用；

<img src="/images/wiki/MyBatis/SqlQueryProcess.jpg" width="700" alt="Sql查询工作时序" />

# 2、MyBatis








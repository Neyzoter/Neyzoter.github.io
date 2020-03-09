---
layout: post
title: Java中的拷贝方法
categories: Java
description: Java中的拷贝方法，应对深拷贝和浅拷贝问题
keywords: Java, 深拷贝, 浅拷贝
---

> Java中的深拷贝和浅拷贝

# 1.Java中的深拷贝和浅拷贝

Java的深拷贝是指将对象完全复制到另外一个地址空间；浅拷贝是指一个对象被另外一个变量应用，此时可以有多个变量指向该对象地址空间。

# 2.Java拷贝实例

## 2.1 List拷贝

### 2.1.1 深拷贝

```java
// l_old是一个已经存在的List，用于创建新的List
// 深拷贝
List<Integer> l_new = new LinkedList<>(l_old);
// 深拷贝
List<Integer> l_new = new ArrayList<>(l_old);
```

### 2.1.2 浅拷贝

```java
// 浅拷贝，如果list2改变，list1也会同样改变
List<Integer> list1 = new LinkedList<>();
list1.add(1);list1.add(2);list1.add(3);
List<Integer> list2 = list1;
```



 ## 2.2 数组拷贝

### 2.2.1 深拷贝

* **方案1 for循环**

  ```java
  // nums_old是一个int数组
  int[] nums_new = new int[nums_old.length]
  int i = 0
  for num : nums_old
  	nums_new[i] = num;
      i ++;
  ```

* **方案2 **

### 2.2.2 浅拷贝

```java
// 浅拷贝，arrays1和arrays2的地址相同
int[] arrays1 = new int[5];
for (int i = 0; i < arrays.length ; i ++) {
    arrays[i] = i + 2 + i / 2;
}
int[] arrays2 = arrays;
```


---
layout: post
title: 清华ucore操作系统的内存管理解析
categories: OS
description: 清华ucore操作系统的内存管理解析
keywords: OS, 清华, ucore
---

> 原创
>

# 1.ucore操作系统

ucore操作系统是清华大学计算机系为了课程需求而维护的一个简单的操作系统。ucore的[Github仓库地址](https://github.com/chyyuu/ucore_os_lab)，另外我维(学)护（习）的ucore [Github仓库地址](https://github.com/Neyzoter/ucore_os_lab)。不同于清华的ucore仓库，我的ucore仓库添加了许多中文注释，甚至修复了小的问题。

不过，不得不说的是，清华大学的计算机课程真的很硬核！国内其他高校，甚至一些985高校都还需要进一步在教学上提高。

# 2.ucore操作系统内存管理

## 2.1 虚拟内存管理结构体

ucore操作系统的每个进程都会拥有一个`mm_struct`，具体如下，

```c
struct mm_struct {
    list_entry_t mmap_list;        // linear list link which sorted by start addr of vma
    struct vma_struct *mmap_cache; // current accessed vma, used for speed purpose
    pde_t *pgdir;                  // vma虚拟内存区域的PDT页目录表，用于索引表
    int map_count;                 // vma的个数
    void *sm_priv;                 // the private data for swap manager
    int mm_count;                  // the number ofprocess which shared the mm
    semaphore_t mm_sem;            // mutex for using dup_mmap fun to duplicat the mm 
    int locked_by;                 // the lock owner process's pid
};
```


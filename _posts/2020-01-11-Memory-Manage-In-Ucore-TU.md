---
layout: post
title: 清华ucore操作系统的内存管理解析
categories: OS
description: 清华ucore操作系统的内存管理解析
keywords: OS, 清华, ucore
---

> 原创
>
> 未完待续

# 1.ucore操作系统

ucore操作系统是清华大学计算机系为了课程需求而维护的一个简单的操作系统。ucore的[Github仓库地址](https://github.com/chyyuu/ucore_os_lab)，另外我维(学)护（习）的ucore [Github仓库地址](https://github.com/Neyzoter/ucore_os_lab)。不同于清华的ucore仓库，我的ucore仓库添加了许多中文注释，甚至修复了小的问题。

不过，不得不说的是，清华大学的计算机课程真的很硬核！国内其他高校，甚至一些985高校都还需要进一步在教学上提高。

# 2.ucore操作系统内存管理

## 2.1 虚拟内存管理结构体

### 2.1.1 空闲区域管理

在ucore初始化pmm（Physical Memory Manage）的时候（`pmm_init @ /kern/mm/pmm.c`）：

1. 初始化物理内存页管理器框架`pmm_manager`，包括给pmm设置一些默认的处理函数

   ```c
   const struct pmm_manager default_pmm_manager = {
       .name = "default_pmm_manager",
       .init = default_init,        // 初始化free_area_t结构体对应结构体变量
       .init_memmap = default_init_memmap,  // 初始化物理页，即将可利用的物理内存空间（页）加入到free_area_t管理的空闲页管理链表中，在此之前会进行物理地址探测，找出可以使用的区域
       .alloc_pages = default_alloc_pages, // 
       .free_pages = default_free_pages,
       .nr_free_pages = default_nr_free_pages,
       .check = default_check,
   };
   ```

2. 初始化页

   也就是将可使用的**页对应的页表**加入到`free_area_t`管理的链表中，即有一个`free_area_t`结构体变量，多个`list_entry_t`。

    ```c
    // 该结构体用于管理没有被使用的内存空间
    typedef struct {
        list_entry_t free_list;         // 未被使用的内存列表头
        unsigned int nr_free;           // 未被使用的页数目
    } free_area_t;
    struct list_entry {
        struct list_entry *prev, *next;
    };
    typedef struct list_entry list_entry_t;
    ```



### 2.1.1 虚拟连续内存空间

ucore通过`vma_struct`数据结构来管理一个虚拟**连续**内存空间（空间大小必须是一个页的整数倍），下面是其具体定义：

```c
// the virtual continuous memory area(vma)
struct vma_struct {
    struct mm_struct *vm_mm; // 使用同一个PDT（页目录表，可以看作一级页表）的vma集合
    uintptr_t vm_start;      // 一个连续地址的虚拟内存空间（vma）的开始地址
    uintptr_t vm_end;        // 一个连续地址的虚拟内存空间的结束地址
    uint32_t vm_flags;       // flags of vma
    list_entry_t list_link;  // 一个双向链表,按照从小到大的顺序把一系列用vma_struct表示的虚拟内存空间链接起来
};
```

如果我们定义两个`vma_struct`对应的结构体变量，则这两个结构体变量分别管理两段虚拟连续内存空间。如下图所示，`vma_struct 1`定义了长度为2 Page的虚拟连续内存空间，`vma_struct 2`定义了长度为3 Page的虚拟连续内存空间。而`mmap_struct`是一个`mm_struct`类型的结构体变量，对于一个PDT有一个`mmap_struct`。下图中的虚拟内存空间就是用PDT组织起来的。

<img src="/images/posts/2020-01-11-Memory-Manage-In-Ucore-TU/VmaMM.png" width="700" alt="vma、mm管理虚拟内空间">

### 2.1.2 PDT管理结构体

ucore操作系统的每个进程都会拥有一个`mm_struct`，用于管理使用同一个PDT的vma集合，具体如下，

```c
struct mm_struct {
    list_entry_t mmap_list;        // 双向链表头,链接了所有属于同一页目录表的虚拟内存空间
    struct vma_struct *mmap_cache; // current accessed vma, used for speed purpose
    pde_t *pgdir;                  // vma虚拟内存空间的PDT页目录表，用于索引页表
    int map_count;                 // vma的个数
    void *sm_priv;                 // the private data for swap manager
    int mm_count;                  // the number ofprocess which shared the mm
    semaphore_t mm_sem;            // mutex for using dup_mmap fun to duplicat the mm 
    int locked_by;                 // the lock owner process's pid
};
```

`mm_struct`定义了页表目录（可以找到页目录）、vma（虚拟内存空间）、vma数目等，是一个进程管理其内存空间的总体结构。

其中，`mm_struct.mmap_list`是一个双向链表头,链接了所有属于同一页目录表的虚拟内存空间。

在ucore中可以使用`mm_create() @ /kern/mm/vmm.c`来创建`mm_struct`，主要是对结构体变量的初始化。不过，`pgdir`还没有分配。

### 2.1.3 页目录初始化

在ucore中使用`setup_pgdir(struct proc_struct *proc) @ proc.c`来进行`mm_struct`中的`pde_t pgdir`初始化。

`pgdir`是页目录表的基地址，通过`pgdir`可以找到一个页表，进而映射到物理空间（具体说明见下方补充）。**`pgdir`需要分配一个页来保存页目录表。**

```
/**
* PDE2和PDE3...指向的PT省略
* 
* |   PTE    |            |    PT1   |
* |---PDE1---|  ---.      |---PTE1---|
* |---PDE2---|     |      |---PTE2---|
* |---PDE3---|     |      |---PTE3---|
* |----------|     '----->|----------|
* */
```



*补充：PDE（Page Directory Entry）、PTE（Page Table Entry）找到的内存空间是一个**4KB连续物理空间的基址**。*

<img src="/images/wiki/OS/Page_Mechanism.png" width="500" alt="页机制">


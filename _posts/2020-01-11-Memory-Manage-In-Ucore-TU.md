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

ucore操作系统是清华大学计算机系为了课程需求而维护的一个简单的操作系统。ucore的[Github仓库地址](https://github.com/chyyuu/ucore_os_lab)，另外我维(学)护（习）的ucore [Github仓库地址](https://github.com/Neyzoter/ucore_os_lab)。不同于清华的ucore仓库，我的ucore仓库添加了许多中文注释，甚至修复了小的问题。不过，不得不说的是，清华大学的计算机课程真的很硬核！国内其他高校，甚至一些985高校都还需要进一步在教学上提高。

本文章从ucore操作系统的角度来解析操作系统是如何管理内存的。

# 2.ucore操作系统内存管理

## 2.1 ucore虚拟内存

ucore将虚拟内存映射到如下物理内存中，具体的链接情况见ld文件。

```
/* *
 * Virtual memory map:                                          Permissions
 *                                                              kernel/user
 *
 *     4G ------------------> +---------------------------------+
 *                            |                                 |
 *                            |         Empty Memory (*)        |
 *                            |                                 |
 *                            +---------------------------------+ 0xFB000000
 *                            |   Cur. Page Table (Kern, RW)    | RW/-- PTSIZE
 *     VPT -----------------> +---------------------------------+ 0xFAC00000
 *                            |        Invalid Memory (*)       | --/--
 *     KERNTOP -------------> +---------------------------------+ 0xF8000000
 *                            |                                 |
 *                            |    Remapped Physical Memory     | RW/-- KMEMSIZE
 *                            |                                 |
 *     KERNBASE ------------> +---------------------------------+ 0xC0000000
 *                            |        Invalid Memory (*)       | --/--
 *     USERTOP -------------> +---------------------------------+ 0xB0000000
 *                            |           User stack            |
 *                            +---------------------------------+
 *                            |                                 |
 *                            :                                 :
 *                            |         ~~~~~~~~~~~~~~~~        |
 *                            :                                 :
 *                            |                                 |
 *                            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *                            |       User Program & Heap       |
 *     UTEXT ---------------> +---------------------------------+ 0x00800000
 *                            |        Invalid Memory (*)       | --/--
 *                            |  - - - - - - - - - - - - - - -  |
 *                            |    User STAB Data (optional)    |
 *     USERBASE, USTAB------> +---------------------------------+ 0x00200000
 *                            |        Invalid Memory (*)       | --/--
 *     0 -------------------> +---------------------------------+ 0x00000000
 * (*) Note: The kernel ensures that "Invalid Memory" is *never* mapped.
 *     "Empty Memory" is normally unmapped, but user programs may map pages
 *     there if desired.
 *
 * */
```

## 2.2 虚拟内存管理

### 2.2.1 物理内存管理结构体

在ucore初始化pmm（Physical Memory Manage）的时候，首先会初始化物理内存页管理器框架`pmm_manager`，包括给pmm设置一些默认的处理函数，`pmm_manager = &default_pmm_manager`，其中`default_pmm_manager`如下（当然也可以自己实现该`pmm_manager`）。

```c
const struct pmm_manager default_pmm_manager = {
    .name = "default_pmm_manager",
    .init = default_init,        // 初始化free_area_t结构体对应结构体变量，此时只有一个结构体，自己指向自己
    .init_memmap = default_init_memmap,  // 初始化物理页，即将可利用的物理内存空间（页）加入到free_area_t管理的空闲页管理链表中，在此之前会进行物理地址探测，找出可以使用的区域
    .alloc_pages = default_alloc_pages, // 
    .free_pages = default_free_pages,
    .nr_free_pages = default_nr_free_pages,
    .check = default_check,
};
```

* `init`函数

  初始化free_area_t结构体对应结构体变量，此时只有一个结构体，自己指向自己（`(&free_list)->prev = (&free_list)->next = (&free_list);`，elm为），free的页个数为0（`nr_free = 0`，也是`free_list`的成员，只在链表头`free_list`有效）。

* `default_init_memmap`函数

  初始化一块连续内存空间块（具体解释见下方的物理页管理结构体），连续内存空间块中每个物理页都会对应1个Page结构体，第1个Page会保存该连续内存空间块的总页数信息。

* `default_alloc_pages`

* `default_free_pages`

* `default_nr_free_pages`

* `default_check`

### 2.2.2 物理页管理结构体

本节内容都在`page_init @ /kern/mm/pmm.c`函数中进行。

1个物理页对应1个Page结构体来管理（也就是需要`npage = maxpa / PGSIZE`个Page结构体来管理，其中maxpa是最大的物理地址空间，PGSIZE是1个页的大小），下面是一个简单的结构体，实际上为了实现页面置换等算法，还会有额外的成员变量。

```c
struct Page {
    int ref;                        // 被引用的次数
    uint32_t flags;                 // 页属性，bit0用于表示是否可用(0可用)，bit1用于表示property成员是否可用
    unsigned int property; // 该成员可以用来记录某连续内存空间块的大小（地址连续空闲页的个数），只有连续内存空间的头一页Head Page使用
    list_entry_t page_link;         // 将多个连续内存空闲块（有多个页）链接在一起，也是只有连续内存空间的头一页Head Page使用
};
```

***那么Page结构体存放在什么地方呢？***在ucore中，使用bootloader加载ucore内核后的空间（ld文件将该空间起始地址设置为0xC0100000，和**2.1 ucore虚拟内存**的0xC0000000有偏差是因为，还有1MB的空间给了Bootloader）作为保存Page结构体的地方。

```
                         ...........................
KERNTOP -------------> +---------------------------------+ 0xF8000000
                       |                                 |
                       |                                 | RW/-- KMEMSIZE
                       |                                 |
Page结构体结束的地方--> +---------------------------------+
                       |              Pages              | 
Page结构体开始的地方--> +---------------------------------+ 
                       |       ~~~ ucore kernel ~~~      |
KERNBASE ------------> +---------------------------------+ 0xC0000000
                         ...........................
```

在初始化所有Page的时候，`flag[bit0]`都设置为不可用，在后面`pmm_struct.init_memmap`中针对可使用的空间设置为0（可被使用的）。

***具体如何对物理页的管理结构体Page进行初始化？***在ucore操作系统中，实现了针对多个连续内存空间块的初始化。在初始化之前，汇编代码会通过INT 15h中断来探测内存空间，比如以下是一个简单的结果：

```
         size       start       end    1:可用; 2:不可用（和Page的flags成员不同）
memory: 0009fc00, [00000000, 0009fbff], type = 1.
memory: 00000400, [0009fc00, 0009ffff], type = 2.
memory: 00010000, [000f0000, 000fffff], type = 2.
memory: 07ee0000, [00100000, 07fdffff], type = 1.
memory: 00020000, [07fe0000, 07ffffff], type = 2.
memory: 00040000, [fffc0000, ffffffff], type = 2.
```

可以看到有两块区域可用，即type = 1的区域。`page_init`会**依次**对**每个可用的**（type=1）连续内存空间内存映射`pmm_struct.init_memmap`（`pmm_struct.init_memmap`可以指定为不同的函数）。默认的内存映射函数：

1. 设置连续内存空间块每个物理页（都是可被使用的）对应的Page结构体的flags成员（之前初始化Page结构体的时候，初始化为了1，也就是不可使用）设置为0（即可以使用）、property成员设置为0
2. 给第1个Page（Head Page）的property成员设置为连续内存空间块包含的物理页大小，并使能Head Page的property成员（`flags[bit1] = 1`）
3. 将`base->page_link`加入到`free_list`，`free_list`说明见下方。

总结下来，每个Page结构体都会对应一个物理页（比如大小为4KB），在一块连续的内存空闲块中，Page结构体放在最底下，如下所示的Page1到Page3是存储在内存空闲块的最下方，而实际可用的空间在上方。

```
                             
+---------------------------------+ ---------------------------
|                                 |
:                                 :
|        ~~~~~ 12KB ~~~~~~        |
:         3 Physical Pages        :
|                                 |
+---------------------------------+
|             Page3               |           Free Mem 1 
+---------------------------------+
|             Page2               |
+---------------------------------+
|             Page1               | ----.
+---------------------------------+ ----|------------------------
|        ~~~~~~~~~~~~~~~~~        |     |
:        ~~~~~~~~~~~~~~~~~        :     |                  
|        ~~~~~~~~~~~~~~~~~        |     |                        
+---------------------------------+ ----|------------------------
|                                 |     |
:                                 :     |
|        ~~~~~ 12KB ~~~~~~        |     |
:         3 Physical Pages        :     |
|                                 |     |
+---------------------------------+     |
|             Page3               |     |     Free Mem 2
+---------------------------------+     |
|             Page2               |     |
+---------------------------------+     |
|             Page1               | <---'
+---------------------------------+ -----------------------------
```



### 2.1.1 空闲区域管理

在也就是将可使用的**页对应的页表**加入到`free_area_t`管理的链表中，即有一个`free_area_t`结构体变量，多个`list_entry_t`，。

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

ucore通过`vma_struct`结构体来管理一个虚拟**连续**内存空间（空间大小必须是一个页的整数倍），下面是其具体定义：

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


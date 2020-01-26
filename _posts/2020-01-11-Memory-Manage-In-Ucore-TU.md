---
layout: post
title: 清华ucore操作系统的内存管理解析
categories: OS
description: 清华ucore操作系统的内存管理解析
keywords: OS, 清华, ucore
---

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

## 2.2 物理内存管理

**本节2.2.1 - 3主要讲述的是物理内存管理的基本结构体，而2.2.4则是ppm在初始化时，默认会将内核的页表建立起来。**

### 2.2.1 物理内存管理pmm结构体

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

* `init_memmap`函数

  初始化一块连续内存空间块（具体解释见下方的物理页管理结构体），连续内存空间块中每个物理页都会对应1个Page结构体，第1个Page会保存该连续内存空间块的总页数信息。

* `alloc_pages`

  分配页的功能，具体见下方`free_area_t`的解释

* `free_pages`

* `nr_free_pages`

* `check`

### 2.2.2 物理页管理page结构体

本节内容都在`page_init @ /kern/mm/pmm.c`函数中进行。

1个物理页对应1个Page结构体来管理（也就是需要`npage = maxpa / PGSIZE`个Page结构体来管理，其中maxpa是最大的物理地址空间，PGSIZE是1个页的大小），下面是一个简单的结构体，实际上为了实现页面置换等算法，还会有额外的成员变量。

```c
struct Page {
    int ref;                        // 被引用的次数
    uint32_t flags;  // 页属性，bit0用于表示是否可用(0可用)，bit1用于表示property成员是否可用
    unsigned int property; // 该成员可以用来记录某连续内存空间块的大小（地址连续空闲页的个数），只有连续内存空间的头一页Head Page使用
    list_entry_t page_link;// 将多个连续内存空闲块（有多个页）链接在一起，也是只有连续内存空间的头一页Head Page使用
};
```

***那么Page结构体存放在什么地方呢？***在ucore中，使用bootloader加载ucore内核后的空间（ld文件将该空间起始地址设置为0xC0100000，和**2.1 ucore虚拟内存**的0xC0000000有偏差是因为，还有1MB的空间给了Bootloader）作为保存Page结构体的地方。

```
                         ...........................
KERNTOP -------------> +---------------------------------+ 0xF8000000
                       |                                 |
                       |                                 | RW/-- KMEMSIZE
                       |                                 |
Page结构体结束的地方----> +---------------------------------+
                       |              Pages              | 
Page结构体开始的地方----> +---------------------------------+ 
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

### 2.2.3 空闲区域 free_area_t 管理

在也就是将可使用的一块连续内存空间块的Head Page的`list_entry_t page_link`加入到`free_area_t`管理的链表中。

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

一个`free_area_t`结构体变量带有多个`list_entry_t`，每个`list_entry_t`都是一块连续内存空间块的Head Page，也就是说`list_entry_t`后面带有一串page，而且是地址连续的。

```
.-> +------------------+  ->  +------------------+  ->  +------------------+  ---------.
|   |   free_area_t    |      |   list_entry_t1  |      |   list_entry_t2  |           |
|   +------------------+  <-  +------------------+  <-  +------------------+  <-.      |
|   |                                                                           |      |
|   |                                                                           |      |
|   |                                                                           |      |
|   '------------------>  +------------------+  ->  +------------------+  ------'      |
|                         |   list_entry_t4  |      |   list_entry_t3  |               |
'-----------------------  +------------------+  <-  +------------------+  <------------'

```

`pmm_manager`的`alloc_pages`函数可以使用特定的算法实现从上述链表选取n个page，返回pages的Head Page信息，具体见`default_alloc_pages`函数举例。

### 2.2.4 内核内存空间的段页式管理实现

**本小节应用到2.2.1 -3 的结构体，实现内核内存空间的页表建立和初始化。**

x86体系结构将内存地址分成三种:逻辑地址(也称虚地址)、线性地址和物理地址。逻辑地址即是程序指令中使用的地址,物理地址是实际访问内存的地址。逻辑地址通过段式管理的地址映射可以得到线性地址,线性地址通过页式管理的地址映射得到物理地址。

<img src="/images/posts/2020-01-11-Memory-Manage-In-Ucore-TU/Segment_Page_Mem_Manage.png" width="700" alt="段页式管理">

**（1）如何实现在建立页表的过程中维护全局段描述符表(GDT)和页表的关系**

* **Bootloader阶段**

  在Bootloader阶段（bootloader的`start @ boot/bootasm.S`），虚拟地址、线性地址、物理地址是一样的：

  `virt addr = linear addr = phy addr`

  并占用了`0x100000`，也就是1MB的空间

* **进入内核阶段**

  在进入内核的阶段（`kern_entry`到`enable_page @ kern/mm/pmm.c`），再次更新段映射，但是还没有启动页机制。此时ucore被bootloader放置从物理地址`0x100000`开始的物理内存中，而虚拟地址是`0xC0100000`。

  `virt addr - 0xC0000000 = linear addr = phy addr`

* **启动页映射阶段**

  启动页映射阶段（`enable_page`到`gdt_init`）

  ```
  virt addr - 0xC0000000 = linear addr = phy addr   # 物理内存在0-4MB之内
  virt addr - 0xC0000000 = linear addr = phy addr + 0xC0000000 # 物理内存在0-4MB之外
  ```

* **最终阶段**

  最终阶段（从`gdt_Init`），第三次更新了段映射，形成新的段页式映射机制，并且取消了临时映射关系。

  `virt addr = linear addr = phy addr + 0xC0000000`

**（2）如何建立虚拟页和物理页帧的地址映射关系？**

二级页表结构，页目录表占用4KB空间（即使页目录项很少，也是1个Page单元），同理页表也是。在ucore中，可以通过`alloc_page`函数获得一个空闲物理页作为页目录表或者页表。

页目录表和页表项计算举例：比如有16MB的物理内存空间，每个物理页大小为4KB，则共需要`16MB / 4KB = 4096`个页表项。而每个页表项占用4B空间，也就是说最少需要`4096 * 4B = 16KB`的页表项空间，即4个物理页。在加上页目录表的4KB空间，共需要5KB空间，即5个物理页。

具体而言，在ucore中，通过函数`boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);`来实现将内核内存空间的所有物理页都通过页表的形式管理起来，见下图，

<img src="/images/posts/2020-01-11-Memory-Manage-In-Ucore-TU/LinearAddr2PhyAddr.png" width="700" alt="二级页表管理">

> 说明：线性地址`[22:31]`共10个字节，1024个数字，用于表示页目录表PDT（Page Dir Table）的偏移。页目录表共1个物理页4KB，每个页目录表项PDE（Page Dir Entry）占用4B，所以线性地址`[22:31]`可以完全索引到所有的页目录表项。某一个PDE可以指向一个页表PT（Page Table），和PDT一样，用线性地址的10个字节（`[21:12]`）来索引某一个页表项PTE（Page Table Entry）。最后通过PTE找到某个4KB物理页后，可以通过线性地址`[11:0]`来索引到对应物理页的某一个字节。

**内核内存空间的映射（也就是内核内存空间的页表的建立）**具体代码如下：

```c
pmm_init(void) {
    // .....
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
    // ......
}
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    // [LAB2 SCC] PGOFF 表示线性地址的物理页偏移，也就是la的低12位，共4KB空间
    assert(PGOFF(la) == PGOFF(pa));
    // [LAB2 SCC] ROUNDUP向上取"整"（第二个参数的倍数）
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
        // [LAB2 SCC] 通过pmm_manager获取一个4KB空间，并作为PTE
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL); // [LAB2 SCC] 分配失败
        // [LAB2 SCC] 给这个pte指向要管理的物理页
        *ptep = pa | PTE_P | perm;
    }
}
```

*说明*：

1. `PGOFF(la)`可以获取线性地址的低12位，也就是对应物理页内的偏移；

2. for循环内实现了将内核所有`KMEMSIZE`大小的内存空间分配给PTE管理（至于PTE和PDE存放在哪里，见上方***那么Page结构体存放在什么地方呢？***）

   1. `get_pte`通过`pmm_manager`会判断PT是否已经分配，如果没有分配就会先分配1个PT，再从中获取1个PTE；如果之前已经分配过PT，则直接获取PTE。具体而言，通过标志位实现`*pdep = pa | PTE_U | PTE_W | PTE_P`。

      *`PTE_U`*:位3,表示用户态的软件可以读取对应地址的物理内存页内容

      *`PTE_W`*:位2,表示物理内存页内容可写

      *`PTE_P`*:位1,表示物理内存页存在，通过这一标志位来实现决定是否需要分配给这个PT一个Page

   2. 而后会给PTE赋值，`*ptep = pa | PTE_P | perm`

## 2.3 虚拟内存管理

通过内存地址虚拟化,可以使得软件在没有访问某虚拟内存地址时不分配具体的物理内存，而只有在实际访问某虚拟内存地址时，操作系统再动态地分配物理内存，建立虚拟内存到物理内存的页映射关系，这种技术称为按需分页(demand paging)。这样就可以做到虚拟内存可能比实际物理内存大，实现虚拟内存需要实现内存和外存数据的换入换出操作（将内存中可能暂时用不到的数据存入到外存，将目前需要使用的存在外存中的数据拷贝到内存）、页面替换算法等。

ucore通过vma和mm结构体来实现描述应用程序运行所需的合法内存空间。当访问内存产生page fault异常时，可获得访
问的内存的方式(读或写)以及具体的虚拟内存地址，这样ucore就可以查询此地址，看是否属于`vma_struct`数据结构中描述的合法地址范围中，如果在，则可根据具体情况进行请求调页/页换入换出处理；如果不在，则报错。

*虚拟内存的意义*

1. 通过设置页表项来限定软件运行时的访问空间，确保软件运行不越界，完成内存访问保护的功能。
2. 使得软件在没有访问某虚拟内存地址时不分配具体的物理内存，实现比物理内存更大的内存空间

### 2.3.1 虚拟连续内存空间vma管理

ucore通过`vma_struct`结构体来管理一个虚拟**连续**内存空间（空间大小必须是一个页的整数倍），**是描述应用程序对虚拟内存需求的数据结构**，下面是其具体定义：

```c
// the virtual continuous memory area(vma)
struct vma_struct {
    struct mm_struct *vm_mm; // 使用同一个PDT（页目录表，可以看作一级页表）的vma集合
    uintptr_t vm_start;      // 一个连续地址的虚拟内存空间（vma）的开始地址
    uintptr_t vm_end;        // 一个连续地址的虚拟内存空间的结束地址
    uint32_t vm_flags;       // 虚拟内存空间的属性, 比如只读、可读写、可执行
    list_entry_t list_link;  // 一个双向链表,按照从小到大的顺序把一系列用vma_struct表示的虚拟内存空间链接起来
};
```

如果我们定义两个`vma_struct`对应的结构体变量，则这两个结构体变量分别管理两段虚拟连续内存空间。如下图所示，`vma_struct 1`定义了长度为2 Page的虚拟连续内存空间，`vma_struct 2`定义了长度为3 Page的虚拟连续内存空间。而`mmap_struct`是一个`mm_struct`类型的结构体变量，对于一个PDT有一个`mmap_struct`。下图中的虚拟内存空间就是用PDT组织起来的。

<img src="/images/posts/2020-01-11-Memory-Manage-In-Ucore-TU/VmaMM.png" width="700" alt="vma、mm管理虚拟内空间">

图中的二级页表结构就是**2.2 物理内存管理**小节中提到的段页式管理实现的页表。

### 2.3.2 页目录管理结构体

ucore操作系统的每个进程都会拥有一个`mm_struct`，用于管理使用同一个PDT的vma集合，具体如下，

```c
struct mm_struct {
    list_entry_t mmap_list;        // 双向链表头,链接了所有属于同一页目录表的虚拟内存空间
    struct vma_struct *mmap_cache; // current accessed vma, used for speed purpose
    pde_t *pgdir;                  // vma虚拟内存空间的PDT页目录表，用于索引页表
    int map_count;                 // vma的个数	
    void *sm_priv;                 // 指向用来链接记录页访问情况的链表头，建立mm_struct和后续要讲到的swap_manager之间的联系
    int mm_count;                  // the number ofprocess which shared the mm
    semaphore_t mm_sem;            // mutex for using dup_mmap fun to duplicat the mm 
    int locked_by;                 // the lock owner process's pid
};
```

`mm_struct`定义了页表目录（可以找到页目录）、vma（虚拟内存空间）、vma数目等，是一个进程管理其内存空间的总体结构。

其中，`mm_struct.mmap_list`是一个双向链表头,链接了所有属于同一页目录表的虚拟内存空间。

在ucore中可以使用`mm_create() @ /kern/mm/vmm.c`来创建`mm_struct`，主要是对结构体变量的初始化。不过，`pgdir`还没有分配。

### 2.3.3 页目录初始化

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

### 2.3.4 虚拟内存管理的实现


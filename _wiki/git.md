---
layout: wiki
title: Git
categories: Git
description: Git 常用操作记录。
keywords: Git, 版本控制
---

# 1.Git基础

## 1.1 Git技术

* **Git直接记录快照，而非差异比较**

  Git区别于其他版本控制系统，每次提交更新，或者在Git中保存状态时，主要对当时的全部文件制作一个快照并保存快照。如果文件没有修改，Git不再重新存储该文件，而是只保留一个链接指向之前存储的文件。

* **Git保证完整性**

  Git中所有数据在存储前都计算校验和，然后以校验和来引用，不可能在Git不知情时更改任何文件内容或者目录内容。计算机制为SHA-1散列，由40个十六进制组成的字符串。

* **Git管理文件的三种状态**

  1. 已提交（committed）

     数据已经安全地保存在本地数据库中

  2. 已修改（modified）

     修改了文件，但还没保存到数据库中。

  3. 已暂存（staged）

     对一个已修改文件的当前版本做了标记，使之包含在下次提交的快照中。

## 1.2 Git配置

### 1.2.1 **Git配置文件**

1. `/etc/gitconfig`

   包含系统上每个用户及他们仓库的通用配置

2. `~/.gitconfig`或者`~/.config/git/config`

   当前用户的配置，通过 传递`--global`选项来让Git读写该文件

3. Git仓库目录中的`config`文件（`.git/config`）

   针对Git仓库（代码）的配置

**每一级别覆盖上一级别的配置，即`.git/config`会覆盖`/etc/gitconfig`。**

### 1.2.2 **用户信息**

每个Git提交都会使用此信息，并且写入到每一次提交，不可更改。

```bash
# --global表示该命令只需要运行一次，之后所有操作都会使用此信息
$ git config --global user.name "John Doe"
$ git config --global user.email johndoe@example.com
```

### 1.2.3 **检查配置信息**

```bash
$ git config --list
user.name=Neyzoter
user.email=sonechaochao@gmail.com
push.default=matching
```

### 1.2.4 **获取帮助**

**[ATTENTION]**

```bash
# 获取帮助的3种方式
$ git help <verb>
$ git <verb> --help
$ man git-<verb>
```

## 1.3 简单操作

### 1.3.1 **现有目录初始化仓库**

该命令创建一个名为`.git`的子目录，包含初始化仓库中所有的必须文件。

```bash
# 初始化仓库
$ git init
# 跟踪文件
$ git add *.c
$ git LICENSE
# 提交文件，-m表示message
$ git commit -m "update"
```

### 1.3.2 **克隆现有仓库**

**git clone默认配置下远程Git仓库中的每个文件的每个版本都被拉取下来。**

```bash
# 克隆远程仓库
$ git clone [url]
# 克隆远程仓库并自定义仓库名为DIR_NAME
$ git clone [url] [DIR_NAME]
```

### 1.3.3 **更新仓库**

**已跟踪文件指被纳入了版本控制的文件。上一次快照中有文件的记录，工作一段时间后，文件状态处于未修改、已修改或者已放入暂存区。初次克隆某个仓库的时候,工作目录中的所有文件都属于已跟踪文件,并处于未修改状态。**文件变化周期如下图所示，

<img src="/images/wiki/Git/Git_Periods.png" width="700" alt="Git仓库文件变化周期" />

1. **检查当前文件状态**

    **[ATTENTION]**
    
    ```bash
    # git status会输出当前所在分支、更改的文件、未跟踪的文件
    $ git status
    On branch master
    Your branch is up-to-date with 'origin/master'.
    Changes not staged for commit:
(use "git add <file>..." to update what will be committed)
      (use "git checkout -- <file>..." to discard changes in working directory)

      modified:   _wiki/git.md
    Untracked files:
            (use "git add <file>..." to include in what will be committed)
          
      images/wiki/Git/
    ```

    git add 既可以将未跟踪文件暂存，也可以将修改的文件暂存，也就是上图中的`Add the file`和`Stage the file`。** 如果一个文件处于Staged暂存，还未Committed提交，再次修改后，该文件会处于两种状态，即未修改和暂存。如果再次add，则Git会存储当前一次修改。

2. **状态简览**

    **[ATTENTION]**

    ```bash
    $ git status -s
     M README          # M在右侧，在工作区修改了，但是未暂存
    MM Rakefile        # 暂存过，但是又被修改了
    A lib/git.rb       # A表示未被跟踪的文件添加到了暂存区
    M lib/simplegit.rb # M在左侧，已经暂存
    ?? LICENSE.txt     # ??表示未被跟踪的文件
    ```

3. **忽略文件**

    `.gitignore`文件中存放文件忽略规则。

4. **查看已暂存和未暂存的修改**

    **[ATTENTION]**

    ```bash
    # 工作目录下当前文件和暂存区域快照之间的差异，即修改后未暂存的变化内容
    $ git diff
    # 已暂存的将要添加到下次提交的内容
    $ git diff --cached
    $ git diff --staged   # Git 1.6.1及更高版本，和--cached效果相同
    ```

    **git diff 本身只显示尚未暂存的改动,而不是自上次提交以来所做的所有改动。 所以有时候你一下子暂
    存了所有更新过的文件后,运行 git diff 后却什么也没有,就是这个原因。**

5. **提交更新**

   ```bash
   # 使用默认的文本编辑器输入提交的说明
   $ git commit
   # 修改默认编辑器，一般是vim或者emacs
   $ git config --global core.editor
   # 直接在命令行添加说明
   $ git commit -m "update"
   ```

6. **跳过暂存，即add**

   **[ATTENTION]**可以通过commit来直接提交修改的**已经跟踪的**文件。

   ```bash
   # 把所有已经跟踪过的文件暂存起来一并提交
   $ git commit -a
   ```

7. **移除文件**

   ```bash
   # 首先删除文件
   $ rm PROJECTS.md
   # 然后从暂存区移除已跟踪文件
   $ git rm PROJECTS.md
   # 如果删除之前修改过并且已经放到暂存区（还未提交）的文件
   # git为了防止误删还没有添加到快照的数据，这样的数据不会被Git恢复
   $ git rm -f PROJECTS.md
   # 移除暂存区文件，但仍然将文件保留在目录中
   $ git rm --cached PROJECTS.md
   ```

8. **移动文件**

   Git不显示跟踪文件移动操作，如果在Git中重命名了某个文件，仓库中存储的元数据不会体现这是一次改名操作（体现为删除文件和跟踪一个未被跟踪的文件）。

   ```bash
   $ git mv file_from file_lo*
   ```

### 1.3.4 **查看提交历史**

**[ATTENTION] 查看提交历史、查看每次提交内容的差异。**

> 什么是作者和提交者？作者：实际作出修改的人，提交者：最后将工作成果提交给仓库的人。比如甲为项目发布补丁，然后乙将甲的补丁并入项目，在甲是作者，乙是提交者。具体见分布式Git。

```bash
# 查看提交历史
$ git log
# 查看每次提交的内容差异
$ git log -p
# 仅显示最近两次提交
$ git log -p -2
# 每次提交的简略统计信息，比如修改的文件、添加还是删除等
$ git log --stat
# 更加漂亮的log
$ git log --pretty=oneline # 在一行内显示提交
49e7e6bb20dc668891f778e2c38dd5443e06b3ee update
95e89b97f323916342543d557513fd5f2b314db4 update os
$ git log --pretty=short # 简短
commit 49e7e6bb20dc668891f778e2c38dd5443e06b3ee
Author: Neyzoter <sonechaochao@gmail.com>

update

commit 95e89b97f323916342543d557513fd5f2b314db4
Author: Neyzoter <sonechaochao@gmail.com>

update os
$ git log --pretty=full # 所有信息，不包括时间
commit 49e7e6bb20dc668891f778e2c38dd5443e06b3ee
Author: Neyzoter <sonechaochao@gmail.com>
Commit: Neyzoter <sonechaochao@gmail.com>

update

commit 95e89b97f323916342543d557513fd5f2b314db4
Author: Neyzoter <sonechaochao@gmail.com>
Commit: Neyzoter <sonechaochao@gmail.com>

update os
$ git log --pretty=fuller # 所有信息，包括时间
commit 49e7e6bb20dc668891f778e2c38dd5443e06b3ee
Author:     Neyzoter <sonechaochao@gmail.com>
AuthorDate: Mon Dec 23 22:11:17 2019 +0800
Commit:     Neyzoter <sonechaochao@gmail.com>
CommitDate: Mon Dec 23 22:11:17 2019 +0800

update

commit 95e89b97f323916342543d557513fd5f2b314db4
Author:     Neyzoter <sonechaochao@gmail.com>
AuthorDate: Sun Dec 22 20:03:06 2019 +0800
Commit:     Neyzoter <sonechaochao@gmail.com>
CommitDate: Sun Dec 22 20:03:06 2019 +0800

update os
```

### 1.3.5 **撤销操作**

**[ATTENTION]**

* **取消提交**

    ```bash
    # 尝试重新提交，上一次删除
    $ git commit --amend
    ```
    
    举例
    
    ```bash
    $ git commit -m 'initial commit'
    $ git add forgotten_file
    $ git commit --amend -m "amend commit"
    # 最后只有第二次提交amend commit有效
    ```
    
* **取消暂存的文件**

    ```bash
    # 将文件恢复到未暂存的状态，只修改暂存区
    $ git reset HEAD <file>
    ```

* **取消对文件的修改**

    **[ATTENTION]**
    
    ```bash
    # 将文件恢复到上次提交的状态
$ git checkout -- <file>
    ```
    

### 1.3.6 远程仓库的使用

* **查看远程仓库**

  ```bash
  # 列出指定的每个远程服务器简写
  $ git remote
  origin
  
  # 显示需要读写远程仓库使用的 Git 保存的简写与其对应的 URL
  $ git remote -v
  origin	git@github.com:Neyzoter/Neyzoter.github.io.git (fetch)
  origin	git@github.com:Neyzoter/Neyzoter.github.io.git (push)
  # 如果有多个远程仓库，则会显示如下
  bakkdoor https://github.com/bakkdoor/grit (fetch)
  bakkdoor https://github.com/bakkdoor/grit (push)
  cho45    https://github.com/cho45/grit (fetch)
  cho45    https://github.com/cho45/grit (push)
  defunkt  https://github.com/defunkt/grit (fetch)
  defunkt  https://github.com/defunkt/grit (push)
  koke     git://github.com/koke/grit.git (fetch)
  koke     git://github.com/koke/grit.git (push)
  origin   git@github.com:mojombo/grit.git (fetch)
  origin   git@github.com:mojombo/grit.git (push)
  ```

* **添加远程仓库**

  `git remote add <shortname> <url>`添加一个新的远程Git仓库

  ```bash
  # 添加远程仓库
  $ git remote add pb https://github.com/paulboone/ticgit
  $ git remote -v
  origin https://github.com/schacon/ticgit (fetch)
  origin https://github.com/schacon/ticgit (push)
  pb https://github.com/paulboone/ticgit (fetch)
  pb https://github.com/paulboone/ticgit (push)
  ```

* **从远程仓库抓取**

  ```bash
  # schacon可以拉取paulboone中有，而schacon没有的内容
  # paulboone可以在本地通过pb/master访问到，可以合并到自己的某个分支中
  $ git fetch pb
  # 从远程仓库抓取
  $ git fetch [remote-name]
  # 抓取克隆（或者上一次抓取）后新推送的所有工作
  $ git fetch origin
  # 自动抓取然后合并到当前分支
  $ git pull
  ```

* **推送到远程仓库**

  ```bash
  # 推送到上游
  $ git push [remote-name] [branch-name]
  $ git push origin master
  ```

### 1.3.7 打标签

**[ATTENTION]**

* **列出标签**

  ```bash
  # 列出所有标签
  $ git tag
  # 列出匹配标签
  $ git tag -l 'v	.8.5*'
  v1.8.5
  v1.8.5-rc0
  v1.8.5-rc1
  v1.8.5-rc2
  v1.8.5-rc3
  v1.8.5.1
  v1.8.5.2
  v1.8.5.3
  v1.8.5.4
  v1.8.5.5
  ```

* **创建标签**

  标签分为两种类型：附注标签（存储在Git数据库中的一个完整对象）和轻量标签（特定提交的引用）

  * 附注标签

    ```bash
    # 创建辅助标签
    $ git tag -a v1.4 -m "my version 1.4"
    # 查看标签
    $ git tag
    v0.1
    v1.3
    v1.4
    # 查看标签细节
    $ git show v1.4
    tag v1.4
    Tagger: Ben Straub <ben@straub.cc>
    Date:
    Sat May 3 20:19:12 2014 -0700
    my version 1.4
    commit ca82a6dff817ec66f44342007202690a93763949
    Author: Scott Chacon <schacon@gee-mail.com>
    Date:
    Mon Mar 17 21:52:11 2008 -0700
     
    changed the version number
    ```

  * 轻量标签

    轻量标签本质上是将提交校验和存储到一个文件中——没有保存任何其他信息。

    ```bash
    # 创建轻量标签
    $ git tag v1.4-lw
    $ git tag
    v0.1
    v1.3
    v1.4
    v1.4-lw
    v1.5
    # 使用git show来查看该tag，信息较少
    $ git show v1.4-lw
    commit ca82a6dff817ec66f44342007202690a93763949
    Author: Scott Chacon <schacon@gee-mail.com>
    Date:
    Mon Mar 17 21:52:11 2008 -0700
     
    changed the version numbe
    ```

* **后期打标签**

  ```bash
  $ git log --pretty=oneline
  15027957951b64cf874c3557a0f3547bd83b3ff6 Merge branch 'experiment'
  a6b4c97498bd301d84096da251c98a07c7723e65 beginning write support
  0d52aaab4479697da7686c15f77a3d64d9165190 one more thing
  6d52a271eda8725415634dd79daabbc4d9b6008e Merge branch 'experiment'
  0b7434d86859cc7b8c3d5e1dddfed66ff742fcbc added a commit function
  4682c3261057305bdd616e23b64b0857d832627b added a todo file
  166ae0c4d3f420721acbb115cc33848dfcc2121a started write support
  9fceb02d0ae598e95dc970b74767f19372d61af8 updated rakefile
  964f16d36dfccde844893cac5b347e7b3d44abbc commit the todo
  8a5cbc430f1a9c3d00faaeffd07798508422908a updated readme
  # 给9fceb02...提交打标签
  $ git tag -a v1.2 9fceb02
  ```

  


# 2.Git使用



### git实现文件夹和github上的repository关联

1、cd 文件夹         

2、生成本地的git管理

```
git init 
```

文件夹里会多一个.git文件夹，可能是隐藏的。     

3、添加文件（注意后面有一点）

```
git add . 
```

这里可设置特定的文件名，也可以全部都上传。

4、添加评论

```
git commit -m "评论"
```

5、本地仓库关联到github

```
git remote add origin http://github.com/你的仓库地址
```

eg.
```
git remote add origin http://github.com/Neyzoter/Deeplearning_Course_Homework.git
```

把github上的https（仓库地址输入，不是我们在浏览器上的地址，而是建立后HTTPS|SSH那里的地址）。

6、代码上传

```
git push -u origin master
```

7、输入账号和密码

### 常用命令

| 功能                      | 命令                                  |
|:--------------------------|:--------------------------------------|
| 添加文件/更改到暂存区     | git add filename                      |
| 添加所有文件/更改到暂存区 | git add .                             |
| 提交                      | git commit -m msg                     |
| 从远程仓库拉取最新代码    | git pull origin master                |
| 推送到远程仓库            | git push origin master                |
| 查看配置信息              | git config --list                     |
| 查看文件列表              | git ls-files                          |
| 比较工作区和暂存区        | git diff                              |
| 比较暂存区和版本库        | git diff --cached                     |
| 比较工作区和版本库        | git diff HEAD                         |
| 从暂存区移除文件          | git reset HEAD filename               |
| 查看本地远程仓库配置      | git remote -v                         |
| 回滚                      | git reset --hard 提交SHA              |
| 强制推送到远程仓库        | git push -f origin master             |
| 修改上次 commit           | git commit --amend                    |
| 推送 tags 到远程仓库      | git push --tags                       |
| 推送单个 tag 到远程仓库   | git push origin [tagname]             |
| 删除远程分支              | git push origin --delete [branchName] |
| 远程空分支（等同于删除）  | git push origin :[branchName]         |

### Q&A

#### 如何解决gitk中文乱码，git ls-files 中文文件名乱码问题？

在~/.gitconfig中添加如下内容

```
[core]
   quotepath = false
[gui]
   encoding = utf-8
[i18n]
   commitencoding = utf-8
[svn]
   pathnameencoding = utf-8
```

参考 <http://zengrong.net/post/1249.htm>

#### 如何处理本地有更改需要从服务器合入新代码的情况？

```
git stash
git pull
git stash pop
```

#### stash

查看 stash 列表：

```
git stash list
```

查看某一次 stash 的改动文件列表（不传最后一个参数默认显示最近一次）：

```
git stash show stash@{0}
```

以 patch 方式显示改动内容

```
git stash show -p stash@{0}
```

#### 如何合并 fork 的仓库的上游更新？

```
git remote add upstream https://upstream-repo-url
git fetch upstream
git merge upstream/master
```

#### 如何通过 TortoiseSVN 带的 TortoiseMerge.exe 处理 git 产生的 conflict？
* 将 TortoiseMerge.exe 所在路径添加到 `path` 环境变量。
* 运行命令 `git config --global merge.tool tortoisemerge` 将 TortoiseMerge.exe 设置为默认的 merge tool。
* 在产生 conflict 的目录运行 `git mergetool`，TortoiseMerge.exe 会跳出来供你 resolve conflict。

  > 也可以运行 `git mergetool -t vimdiff` 使用 `-t` 参数临时指定一个想要使用的 merge tool。

#### 不想跟踪的文件已经被提交了，如何不再跟踪而保留本地文件？

`git rm --cached /path/to/file`，然后正常 add 和 commit 即可。

#### 如何不建立一个没有 parent 的 branch？

```
git checkout --orphan newbranch
```

此时 `git branch` 是不会显示该 branch 的，直到你做完更改首次 commit。比如你可能会想建立一个空的 gh-pages branch，那么：

```
git checkout --orphan gh-pages
git rm -rf .
// add your gh-pages branch files
git add .
git commit -m "init commit"
```

#### submodule 的常用命令

**添加 submodule**

```
git submodule add git@github.com:philsquared/Catch.git Catch
```

这会在仓库根目录下生成如下 .gitmodules 文件并 clone 该 submodule 到本地。

```
[submodule "Catch"]
path = Catch
url = git@github.com:philsquared/Catch.git
```

**更新 submodule**

```
git submodule update
```

当 submodule 的 remote 有更新的时候，需要

```
git submodule update --remote
```

**删除 submodule**

在 .gitmodules 中删除对应 submodule 的信息，然后使用如下命令删除子模块所有文件：

```
git rm --cached Catch
```

**clone 仓库时拉取 submodule**

```
git submodule update --init --recursive
```

#### 删除远程 tag

```
git tag -d v0.0.9
git push origin :refs/tags/v0.0.9
```

或

```
git push origin --delete tag [tagname]
```

#### 清除未跟踪文件

```
git clean
```

可选项：

| 选项                    | 含义                             |
|-------------------------|----------------------------------|
| -q, --quiet             | 不显示删除文件名称               |
| -n, --dry-run           | 试运行                           |
| -f, --force             | 强制删除                         |
| -i, --interactive       | 交互式删除                       |
| -d                      | 删除文件夹                       |
| -e, --exclude <pattern> | 忽略符合 <pattern> 的文件        |
| -x                      | 清除包括 .gitignore 里忽略的文件 |
| -X                      | 只清除 .gitignore 里忽略的文件   |

#### 忽略文件属性更改

因为临时需求对某个文件 chmod 了一下，结果这个就被记为了更改，有时候这是想要的，有时候这会造成困扰。

```
git config --global core.filemode false
```

参考：[How do I make Git ignore file mode (chmod) changes?](http://stackoverflow.com/questions/1580596/how-do-i-make-git-ignore-file-mode-chmod-changes)

#### patch

将未添加到暂存区的更改生成 patch 文件：

```
git diff > demo.patch
```

将已添加到暂存区的更改生成 patch 文件：

```
git diff --cached > demo.patch
```

合并上面两条命令生成的 patch 文件包含的更改：

```
git apply demo.patch
```

将从 HEAD 之前的 3 次 commit 生成 3 个 patch 文件：

（HEAD 可以换成 sha1 码）

```
git format-patch -3 HEAD
```

生成 af8e2 与 eaf8e 之间的 commits 的 patch 文件：

（注意 af8e2 比 eaf8e 早）

```
git format-patch af8e2..eaf8e
```

合并 format-patch 命令生成的 patch 文件：

```
git am 0001-Update.patch
```

与 `git apply` 不同，这会直接 add 和 commit。

#### 只下载最新代码

```
git clone --depth 1 git://xxxxxx
```

这样 clone 出来的仓库会是一个 shallow 的状态，要让它变成一个完整的版本：

```
git fetch --unshallow
```

或

```
git pull --unshallow
```

#### 基于某次 commit 创建分支

```sh
git checkout -b test 5234ab
```

表示以 commit hash 为 `5234ab` 的代码为基础创建分支 `test`。

#### 恢复单个文件到指定版本

```sh
git reset 5234ab MainActivity.java
```

恢复 MainActivity.java 文件到 commit hash 为 `5234ab` 时的状态。

#### 设置全局 hooks

```sh
git config --global core.hooksPath C:/Users/mazhuang/git-hooks
```

然后把对应的 hooks 文件放在最后一个参数指定的目录即可。

比如想要设置在 commit 之前如果检测到没有从服务器同步则不允许 commit，那在以上目录下建立文件 pre-commit，内容如下：

​```sh
#!/bin/sh

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

git fetch origin $CURRENT_BRANCH

HEAD=$(git rev-parse HEAD)
FETCH_HEAD=$(git rev-parse FETCH_HEAD)

if [ "$FETCH_HEAD" = "$HEAD" ];
then
    echo "Pre-commit check passed"
    exit 0
fi

echo "Error: you need to update from remote first"

exit 1
```

#### 解决CRLF和LF的冲突
换行的时候，win：CRLF，linux：LF。

禁用自动转换，即将设置：

```
# push时转化CRLF为LF ，pull时把LF转化成CRLF
git config --global core.autocrlf true

# git在push时，把CRLF转换成LF，pull时不变
git config --global core.autocrlf input
# 本地和代码中都保留CRLF，无论pull还是push都不边
git config --global core.autocrlf false

git init

git add xxx.xx
```

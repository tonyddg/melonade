#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "Docker 笔记")

#import "/utility/include.typ": *

= Docker 笔记

== Docker 基础

=== 基本概念

- 镜像（Image）：
  - *镜像提供了运行容器所需的程序，资源与配置文件*。
  - 镜像是一个特殊的文件系统，不包含动态数据，且构建好后不会再改变。
- 容器（Container）：
  - 镜像与容器的关系相当于面向对象中类与对象（实例）的关系。*容器可以被创造销毁，也可以访问镜像的资源，但不能修改镜像*。
  - 容器本质为宿主机的一个进程，但是与之隔离，有自己的文件系统、网络配置等。
  - 容器中的应用程序在容器存储层与镜像基础上运行，*除非绑定到宿主目录上，否则容器消亡时其中的数据也将消亡*。
- 仓库（Repository）：
  - Docker Registry 提供了镜像存储与分发服务，仓库中的镜像表示为 `用户名/镜像名:标签`, 其中官方镜像（或本地构建的镜像）可省略用户名, 标签 `latest` 表示最新版本
  - 使用镜像时给定镜像名后将自动从远程仓库下载，已经下载过的镜像将使用本地缓存

== 基本命令

=== docker run <docker_run>

命令 `docker run` 用于从镜像中创建一个临时容器，并在其中执行指定命令

命令用法为 `docker run [options] <image> <command>`
- `image` 镜像名，表示方式为 `用户名/镜像名:标签`
- `command` 容器创建后执行的命令，没有给出则使用容器默认启动命令
- `options` 命令选项，常用的选项有
  - `-d/--detach` 在后台运行容器（使用命令 `docker attach <container>` 可接入容器查看输出）
  - `-e/--env` 指定容器的环境变量（部分容器通过该方式获取应用配置，可以多次使用该选项）
  - `-p <source>:<container>` 将容器端口映射到宿主机（用于通过网络访问容器内的应用，可以多次使用该选项）
  - `--rm` 命令退出或容器停止后删除临时创建的容器（默认保存）
  - `--name <name>` 创建一个指定名称的容器（默认随机分配）
  // - `-it` 创建并进入容器的伪终端与容器交互 (快捷键 #bl(0)[Ctrl]#bl(0)[P]+#bl(0)[Ctrl]#bl(0)[Q] 断开)

执行该命令时
- 本地搜索镜像，如果不存在将从网络上下载
- 基于该镜像创建一个随机名称的*新容器*并启动，然后执行给定命令
- 命令退出后*终止*容器运行（容器没有被删除）

=== 镜像与容器管理

- `docker images` 查询本地的镜像的 ID（IMAGE ID）与名称（REPOSITORY），两者均可在命令中表示镜像
- `docker ps [-a]` 查询现在正在运行容器的 ID（CONTAINER ID）与名称（NAMES），两者均可在命令中表示镜像
  - 选项 `-a` 可以显示所有容器，包括停止运行的容器
- `docker start [options] <container...>` 启动已停止运行的容器
- `docker stop [options] <container...>` 停止正在运行的容器，docker 的停止容器相当于是挂起系统，不会关闭正在运行的程序
- `docker rm [options] <container...>` 删除停止的容器
- `docker rmi [options] <image...>` 删除没有容器使用的镜像
- `docker cp [options] <src> <dest>` 从容器向宿主机复制文件 (或相反)
  - 容器内路径通过 `<容器名>:<路径>` 表示

=== 通过虚拟终端与容器交互

对于作为应用使用的镜像，通常执行 `docker run` 后即可启动任务，但对于作为虚拟机使用的镜像需要有一个终端作为接口才能与之交互

对于这一类镜像
- 命令 `docker run -it <image>` 创建容器并为之创建用于交互的虚拟终端，容器由于运行终端而保持在运行状态
- 如果要从虚拟终端中断开
  - 快捷键 #bl(0)[Ctrl]#bl(0)[P]+#bl(0)[Ctrl]#bl(0)[Q] 退出虚拟终端但不关闭，因此容器保持在运行状态
  - 连续三次 #bl(0)[Ctrl]#bl(0)[C] 也可以强制退出虚拟终端
  - 终端命令如 `exit` 则将关闭终端，#hl(2)[其他附加到容器的终端都将关闭，同时容器也会退出]
- 命令 `docker attach <container>` 可以重新接入容器查看容器终端输出或与容器虚拟终端交互
- 命令 `docker start/stop <container>` 启动与停止环境

== 自定义镜像

=== Dockerfile

Dockerfile 是一种用于构建镜像的脚本，在 Dockerfile 中指定基础镜像，然后在此基础上如何得到新镜像的所需环境

Dockerfile 即一个名称为 `Dockerfile` 的文件，因此一个文件夹中只能存在一个 Dockerfile

Dockerfile 中常用的指令有
- `FROM <image>` 指定基础镜像
- `RUN ['<命令>', '[参数1]', '[参数2 ...]']` 在基础镜像中执行命令（更推荐的使用方法#link(<image_layer>)[参见]）
- `WORKDIR <dir>` 设置默认工作目录，不存在时自动创建（与 `cd` 不同）
- `COPY ['<宿主机路径1>', '[宿主机路径2 ...]', '<当前镜像目录>']` 将宿主机多个文件复制到容器目录中（只能是相对#link(<docker_build>)[上下文目录]的路径）
- `ENV <key1>=<value1> [<key2>=<value2>]` 设置容器环境变量
- `EXPOSE <port1> [port2 ...]` 说明容器暴露的端口（在 `docker run -p <host_port>:<container_port>` 中主动开放才有效）
- `CMD ['<命令>', '[参数1]', '[参数2 ...]']` 重置容器的启动命令
- `SHELL ['<命令>', '[参数1]', '[参数2 ...]']` 设置 `RUN` 命令执行方式，即 `RUN` 命令的内容将接在 `SHELL` 指定的命令后
  - 例如 `SHELL ["/bin/bash", "-c"]` 可将默认的 sh 修改为 bash 执行命令（`-c` 表示执行后续命令）

例如以下命令将创建一个镜像，该镜像基于 Ubuntu22.04，首先安装 C++ 编译环境，然后将本地的 `main.cpp` 导入编译，运行镜像时执行编译结果

```Dockerfile
FROM ubuntu:22.04

# 设置 apt 源为清华源（由 ChatGPT 生成）
RUN sed -i 's|http://.*archive.ubuntu.com|http://mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list && \
    sed -i 's|http://.*security.ubuntu.com|http://mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list && \
    apt-get update && \
    # 安装验证软件包所需的软件
    # Dockerfile 中要使用 -y 选项避免命令的阻塞交互导致卡死
    apt-get install -y --no-install-recommends \
        ca-certificates \
        apt-transport-https \
        gnupg \ 
        software-properties-common && \
    update-ca-certificates && \
    apt-get update && \
    # 安装编译软件包
    apt-get install -y build-essential && \
    # 删除 apt-get update 所产生的软件包信息，减小镜像体积
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 将编译项目复制到镜像内
COPY ["./main.cpp", "./"]
RUN g++ ./main.cpp -o main
# 运行镜像时执行编译结果
CMD ["./main"]
``` <dockerfile_example>

=== 镜像分层机制 <image_layer>

镜像具有分层存储的特性，因此 Dockerfile 中，每一条指令的本质为在旧镜像的基础上创建一个新的层。

因此将镜像前的任意层去掉仍为一个有效的镜像，此时用 Dockerfile 构建镜像时，当 Docker 检测到前 n 层在本地镜像中也构建过将直接引用从而加快镜像构建速度（同一 Dockerfile 不会重复利用）。

为了防止最终生成的镜像过于臃肿，应当避免多个 `RUN` 指令，而是将多条指令合并为一起，例如以下示例：

```Dockerfile
RUN <指令 1> && \
    <指令 2> && \
    <指令 3>
```

=== docker build <docker_build>

命令 `docker build` 用于编译 Dockerfile 构建镜像

命令用法为 `docker build [options] <context_path>`
- `context_path` 上下文目录，构建镜像所有文件所在的目录，一般使用当前目录 `.`（即 `COPY` 命令的根目录，且通常无法获取外部的文件）
- `options` 命令选项，常用的选项有
  - `-t <tag>` 构建自定义镜像的镜像名
  - `-f <dockerfile>` 构建镜像使用的 Dockerfile 路径（默认在 `context_path` 中搜索）

=== 多阶段构建

在构建应用镜像时，应用的编译时依赖往往与应用的运行无关，仅会占用镜像的体积，而刚好支撑应用运行的环境又很难用于编译应用，因此多阶段构建的概念被提出：
- 首先基于一个较为大的镜像（如 `ubuntu`）构建应用的编译环境并编译得到可执行文件
- 将这个可执行文件及其运行时依赖转移到轻量化镜像（如 `scratch`）中，得到应用镜像

在 Dockerfile 中通过多个 `FROM` 命令即可开启多个阶段的构建，用于多阶段构建的命令主要如下
- `FROM <image> AS <stage>` 指定当前阶段的基础镜像，并命名为 `stage`（仅最后一个阶段的镜像会被作为构建结果输出）
- `COPY --from=<阶段名> ['<镜像路径1>', '[镜像路径2 ...]', '<当前镜像目录>']` 将指定阶段镜像内的文件复制到当前镜像内

例如以下 Dockerfile 与上文类似但利用分层构建可大幅缩小镜像体积（600MB #sym.arrow 3MB）
```Dockerfile
FROM ubuntu:22.04 AS builder

# 设置 apt 源为清华源（由 ChatGPT 生成）
RUN sed -i 's|http://.*archive.ubuntu.com|http://mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list && \
    sed -i 's|http://.*security.ubuntu.com|http://mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list && \
    apt-get update && \
    # 安装验证软件包所需的软件
    apt-get install -y --no-install-recommends \
        ca-certificates \
        apt-transport-https \
        gnupg \ 
        software-properties-common && \
    update-ca-certificates && \
    apt-get update && \
    # Dockerfile 中要使用 -y 选项避免命令的阻塞交互导致卡死
    apt-get install -y build-essential && \
    # 删除 apt-get update 所产生的软件包信息，减小镜像体积
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 将编译项目复制到镜像内
COPY ["./main.cpp", "./"]
# 使用 static 避免动态链接导致依赖缺失的问题
RUN g++ ./main.cpp -o main -static

FROM scratch

WORKDIR /app

# 镜像路径需要使用绝对路径
COPY --from=builder ["/app/main", "./"]
CMD ["./main"]
```

=== 镜像构建技巧

为了保证镜像的体积尽量小，不包含无用的文件
- 使用清华源作为 apt 的软件源：#link(<dockerfile_example>)[参见]
- 避免大量分段的 `RUN` 命令：#link(<image_layer>)[参见]
- 完成镜像构建前删除软件列表缓存 `rm -rf /var/lib/apt/lists/*`（用于 `apt-get`）
- `apt-get` 安装软件时避免无关的软件包安装与阻塞询问 `apt-get install -y --no-install-recommends`
- `pip3` 安装模块时避免无用的缓存 `pip3 install --no-cache-dir`

构建时编译可能会瞬间占用大量资源导致宿主机崩溃，需要对资源进行限制
- 限制使用的 cpu 数量，通常使用环境变量限制，常用的有（此处均设置为 2）：
  - MAX_JOBS=2
  - CMAKE_BUILD_PARALLEL_LEVEL=2
  - NINJA_NUM_CORES=2
- 除了 CPU，还可以添加交换内存设置，即在 `docker build` 中添加 `--memory=4g --memory-swap=4g`（两个大小需要一样）

当构建深度学习项目时
- 各种下载源码编译的包建议使用 `python3 -m pip install -v .` 安装到 pip 中，而不是 `python3 setup.py install`
- 构建时没有 GPU 环境，需要手动设置环境变量 `FORCE_CUDA=1` 与 `TORCH_CUDA_ARCH_LIST=${CUDA_ARCH}`，其中 `TORCH_CUDA_ARCH_LIST` 与使用的显卡有关，根据宿主机中运行 `print(torch.cuda.get_device_capability())` 获取（格式为 x.x 的字符串）

杂项
- 命令 `docker builder prune` 可用于清理构建镜像产生的临时文件（可以定期或构建失败后执行）

=== 常用配置命令

*apt 软件源配置*

对于 Ubuntu24.04 前的版本，通过如下脚本在 Dockerfile 中配置清华源

```Dockerfile
# 清华源（使用 http）
RUN sed -i 's|http://.*archive.ubuntu.com|http://mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list && \
    sed -i 's|http://.*security.ubuntu.com|http://mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list && \
    apt-get update && apt-get -y upgrade && \
    # 更新 ca 证书
    apt-get install -y --no-install-recommends apt-utils ca-certificates && \
    update-ca-certificates && \
```

对于 Ubuntu24.04 后的版本

```Dockerfile
    # 需要提前安装 ca 证书相关包
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils ca-certificates && \
    update-ca-certificates && \
    # 清华源
    cp /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources.bak && \
    # 写入清华镜像配置
    printf 'Types: deb deb-src\nURIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu/\nSuites: noble noble-security noble-updates noble-proposed noble-backports\nComponents: main restricted universe multiverse\nSigned-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg\n' \
  > /etc/apt/sources.list.d/ubuntu.sources && \
    apt-get update && apt-get -y upgrade && \
```

*pypi 软件源配置*

```Dockerfile
    # 升级 Python（非必要）
RUN python -m pip install --upgrade pip && \
    # 设置全局 pip
    pip config set global.index-url https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple
```

*miniconda 安装*

```Dockerfile
    # 改用 bash 作为命令解释器
SHELL ["/bin/bash", "-c"]

    # 安装 miniconda（需要先安装 wget）
RUN mkdir -p ~/miniconda3 && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh && \
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3 && \
    rm ~/miniconda3/miniconda.sh && \
    source ~/miniconda3/bin/activate && \
    conda init --all && \
    # CondaToSNonInteractiveError（同意协议，解决后续无法创建虚拟环境的问题）
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r && \
    # 创建虚拟环境（每个 run 命令使用 conda 前需要 source）
    source ~/miniconda3/bin/activate && \
    conda create -y -n <my_env> python=3.10 && \ 
    conda activate <my_env> && \
    # 写入 bashrc，自动打开虚拟环境
    echo "conda activate <my_env>" >> ~/.bashrc && \
```

== 数据管理

=== 数据卷与主机目录

数据卷是由 Docker 管理的一种特殊文件系统，他独立于容器之外，且可以挂在到容器内供不同容器访问

关于数据卷的命令有
- `docker volume create <vol_name>` 创建名为 `vol_name` 的数据卷
- `docker volume ls` 查看所有数据卷
- `docker volume rm <vol_name>` 删除数据卷

同样也可以挂在主机目录到容器中，与数据卷相比
- 数据卷独立于宿主机文件系统，读写速度更快（特别是 Windows 中）且更不容易出错
- 数据卷本体为一个文件，可以被不同宿主机的容器访问
- 主机目录多用于访问已有资源或主机编辑容器运行的代码，数据卷则用于存放应用的数据库

=== 将目录挂载到容器

通过 #link(<docker_run>)[docker run] 命令的参数 `--mount` 设置目录挂载配置（挂载必须使用绝对路径）
- 挂载数据卷 `--mount source=<数据卷名>,target=<容器挂载目录>`
- 挂载宿主机目录 `--mount type=bind,source=<主机绝对路径>,target=<容器挂载目录>[,readonly]` 后续的 `readonly` 可以设挂载目录为只读
  - Windows 中，主机路径使用 `/<磁盘名>/.../...` 的格式

== Docker Compose 容器编排

启用 Docker 容器时，依然存在大量配置将导致命令臃肿，Docker Compose 则可以使用清晰的 yaml 文件表示这些配置，方便容器的创建。除此之外 Docker Compose 也可用于同时创建多个容器集群。

=== docker-compose 配置

`docker-compose.yml` 文件中，第一级用于分类创建集群所需的数据卷、容器等，第二级键则表示创建数据卷、容器的名称（可以有多个），键值则为其具体配置

此处仅介绍用于定义容器的键 `services`，其常用的配置键有
- `image` 镜像名称（容器将基于给定镜像创建）
- `build` 镜像构建上下文及 `Dockerfile` 所在目录（将首先创建镜像，然后在该镜像基础上创建容器）
- `ports` 相当于 `-p` 选项，值为列表，列表中使用字符串 `<source>:<container>` 表示端口的映射
- `volumes` 相当于 `--mount` 选项，值为列表，列表中使用字符串 `<source>:<container>[:ro]` 表示挂载，可同时表示数据卷与主机目录的挂载，`ro` 即只读
  - `<source>` 中可以使用相对路径，路径起点为 `docker-compose.yml` 文件所在目录
  - `<source>` 表示 Windows 宿主机目录时，使用 `/c/...` 等方式表示磁盘号
- `environment` 相当于 `-e` 选项，值为字典，即环境变量的名称与值
- `restart: unless-stopped` 实用配置，表示不断重启直到成功启动，用于依赖于其他容器的容器等待依然容器启动成功

关于更多配置参见#link("https://www.runoob.com/docker/docker-compose.html")[相关教程]

=== docker-compose 命令

通过命令 `docker-compose up [-f <compose_path>] [-d] [--build]` 启动容器集群
- 选项 `-f` 从指定路径寻找 `docker-compose.yml`，默认从当前目录下寻找（通常 `docker-compose` 都会从当前目录下寻找，只有该子命令可以指定 `docker-compose.yml` 的路径）
  - `compose_path` 文件 `docker-compose.yml` 的路径（可以是任意名称的 `yaml` 文件）
- 选项 `-d` 从后台启动容器集群（类似 `docker run -d`）
- 选项 `--build` 强制重新构建镜像

通过命令 `docker-compose down` 关闭容器集群
- 该命令通过当前目录下的 `yml` 文件识别需要关闭的集群

== 杂项

=== Docker-Desktop 支持窗口显示

在 Docker-Desktop 中，Docker 引擎并不是直接运行在 Windows 上，而是将某个 WSL 作为宿主机，在该宿主机上同样可以运行 docker 相关命令，但地址将基于 WSL（Windows 下的文件挂载在如 `/mnt/c` 的位置）

要让容器支持显示窗口，需要将宿主 WSL 中相关的设备（文件）挂载到宿主 WSL 上，并且最好从宿主 WSL 中创建容器

首先在宿主 WSL 中运行以下指令检查（不正常时查看#link("https://github.com/microsoft/wslg/wiki/Diagnosing-%22cannot-open-display%22-type-issues-with-WSLg")[文档]）
```bash
echo $DISPLAY $WAYLAND_DISPLAY $XDG_RUNTIME_DIR      # 三个变量应都有值
ls -l /tmp/.X11-unix                                 # 有 X11 套接字
ls -l /mnt/wslg | grep runtime-dir                   # 有 Wayland/Pulse 目录
```

在#hl(2)[宿主 WSL 中启动容器]，并使用以下命令行参数添加环境变量与挂载目录
```bash
docker run \
-e DISPLAY=$DISPLAY \
-v /tmp/.X11-unix:/tmp/.X11-unix \
...
```

进入容器后还需要安装以下依赖包保证窗口正确显示
```bash
apt-get install -y --no-install-recommends \
  libgl1 libegl1 libx11-6 libglib2.0-0 libgomp1
```

=== 机器学习项目中使用 Docker

机器学习项目中使用 Docker 时，需要将 Windows 宿主机的 GPU 暴露给容器使用，容器才能使用 GPU 加速推理

- 在 Windows 宿主机安装显卡驱动、cuda、cudnn 等
- 在 docker 所在的宿主 WSL 中安装 cuda，根据 #link("https://zhuanlan.zhihu.com/p/555151725")，宿主 WSL 的 cuda 版本需要低于 Windows
- 参考#link("https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html")[官方教程], 在宿主 WSL 中安装 NVIDIA Container Toolkit
- 运行 `sudo nvidia-ctk runtime configure --runtime=docker` 启动配置
- 使用 `docker run` 创建容器时, 还需要参数 `--gpus all` 引入 GPU 设备

一个机器学习项目通常可使用以下配置启动 Docker 容器

```bash
docker run \
  -it \
  --gpus all \
  --name <容器名> \
  --mount type=bind,src=/mnt/e/dataset,dst=/dataset \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -p8000:8000 \
  --shm-size 4G \
  <镜像名>
```

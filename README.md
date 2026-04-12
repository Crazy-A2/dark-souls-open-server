![Dark Souls 3 - Open Server](./Resources/banner.png?raw=true)

![GitHub license](https://img.shields.io/github/license/TLeonardUK/ds3os)

English version: [README-en.md](README-en.md)

# DSOS 是什么？
DSOS 是《黑暗之魂 3》以及《黑暗之魂 2：原罪学者（SOTFS）》服务器的开源实现。

这个项目主要用于提供一个相对独立的联机环境，方便玩家在使用模组时降低被封禁的风险，或与朋友私下联机，避免作弊者、入侵等公开联机环境中的问题。

如果你在使用过程中遇到问题，可以加入 Discord 寻求技术支持：
https://discord.gg/pBmquc9Jkj

# 组件总览
当前仓库主要由以下几个部分组成：

- `Loader`：Windows 图形启动器，用于拉取服务器列表、启动游戏并连接到自定义服务器
- `Injector`：仅在 Windows 下构建的注入模块，用于把游戏连接目标切换到 DS3OS 服务器
- `Server`：主服务器程序，负责登录、认证、游戏逻辑以及 WebUI 服务
- `MasterServer`：用于发布和列出活动服务器的 Node.js API 服务
- `WebUI`：随服务器一起分发的管理页面静态资源

如果你是第一次接触这个仓库，可以把它理解为：

1. 玩家通常使用 `Loader` 加入服务器
2. 服主通常运行 `Server.exe` 自建服务器
3. 维护分叉或公共服务器列表时，才会额外接触 `MasterServer`

# 能用于盗版游戏吗？
不能。

服务器会校验 Steam 凭证，因此请不要询问盗版、Steam 模拟器或类似话题，项目本身不提供这类支持。

如果条件允许，也请支持 FROM SOFTWARE 的作品。

# 怎么使用？
构建完成后，默认会得到一个按平台、架构和模式划分的输出目录，例如：

- `bin/x64_release/`
- `bin/x64_debug/`
- `bin/x86_release/`

在常见的 Windows x64 构建流程下，`xmake build-server` 和 `xmake build-all` 还会进一步整理出：

- `bin/<arch>_<mode>/Loader/`
- `bin/<arch>_<mode>/Server/`

其中最常用的是 `Loader/` 和 `Server/` 两部分。

- `Loader`：用于启动游戏并连接到自定义服务器
- `Server`：用于启动你自己的专用服务器

## 玩家快速开始
1. 先准备好 `Loader` 目录中的启动器。
2. 以管理员身份运行 Loader。
3. 在 Loader 中选择要启动的游戏，刷新服务器列表后加入目标服务器。
4. 如果服务器开启了密码保护，先输入密码再连接。

## 服主快速开始
1. 运行 `Server` 目录中的 `Server.exe`。
2. 首次启动时，程序会生成 `Saved/default/config.json`。
3. 修改配置后重启服务器使其生效。
4. 如需公开给外网玩家访问，请同时检查端口转发、防火墙以及公网 / 局域网地址设置。

如果你希望服务器启用密码保护，可以在 `Saved/default/config.json` 中设置密码。之后，玩家连接该服务器时需要先输入密码。

**注意：** 运行 `Server.exe` 时，本机必须安装 **Steam 客户端**（无需登录）。否则 `Server.exe` 可能无法正常初始化。

## 开发者快速开始
如果你只是想快速构建并运行本 fork，建议优先走根目录 `xmake.lua` 对应的 XMake 流程，而不是旧的 CMake / CI 说明。常见入口是：

- `xmake build-loader`：只构建 Windows x64 Loader
- `xmake build-server`：构建 Server，并在 Windows x64 下额外构建 Injector 和 Loader
- `xmake build-all`：调用 `build-server` 后再复制运行时资源
- `xmake install-all`：只复制运行时资源，不执行完整构建

# 当前支持情况
目前，大部分核心功能已经可以工作，但与官方服务器相比，行为上仍可能存在差异。项目仍在持续改进，目标是进一步贴近官方服务端表现，并提升非官方服务器的整体可用性。

**注意：** 《黑暗之魂 2：原罪学者》的支持仍处于实验阶段，出现异常行为的概率较高。

| 功能 | 黑暗之魂 3 | 黑暗之魂 2 SOTFS |
| --- | --- | --- |
| 是否已具备基本可用性 | :heavy_check_mark: | 实验性 |
| 网络传输 | :heavy_check_mark: | :heavy_check_mark: |
| 公告消息 | :heavy_check_mark: | :heavy_check_mark: |
| 资料管理 | :heavy_check_mark: | :heavy_check_mark: |
| 血迹留言 | :heavy_check_mark: | :heavy_check_mark: |
| 血痕 | :heavy_check_mark: | :heavy_check_mark: |
| 幽灵 | :heavy_check_mark: | :heavy_check_mark: |
| 召唤 | :heavy_check_mark: | :heavy_check_mark: |
| 入侵 | :heavy_check_mark: | :heavy_check_mark: |
| 自动召唤（誓约） | :heavy_check_mark: | :heavy_check_mark: |
| 镜之骑士 | n/a | :heavy_check_mark: |
| 匹配系统 | :heavy_check_mark: | :heavy_check_mark: |
| 排行榜 | :heavy_check_mark: | :heavy_check_mark: |
| 敲钟机制 | :heavy_check_mark: | n/a |
| 快速对战（竞技场） | :heavy_check_mark: | :heavy_check_mark: |
| 遥测 / 其他 | :heavy_check_mark: | :heavy_check_mark: |
| Steam 凭证校验 | :heavy_check_mark: | :heavy_check_mark: |
| Master Server 支持 | :heavy_check_mark: | :heavy_check_mark: |
| Loader 支持 | :heavy_check_mark: | :heavy_check_mark: |
| 管理 WebUI | :heavy_check_mark: | :heavy_check_mark: |
| 分片支持 | :heavy_check_mark: | :heavy_check_mark: |
| Discord 活动推送 | :heavy_check_mark: |  |

## 后续计划

- 支持按服务器分别配置模组选项（例如移除召唤人数限制）
- 提供更完善的反作弊能力

# 会导致正式版账号被封吗？
DSOS 使用独立存档。

只要你**不要把 DS3OS 存档复制回正式版存档**，通常就不会有问题。

# 常见问题
## 如何在《黑暗之魂 3》和《黑暗之魂 2》之间切换？
服务器首次运行后，会生成 `Saved/default/config.json`。

你可以修改其中的 `GameType` 参数，在 `DarkSouls2` 和 `DarkSouls3` 之间切换，以决定当前服务器托管的游戏类型。

## 为什么看不到我的存档？
DSOS 使用自己的独立存档，以避免影响正式版存档。

如果你想把正式版存档导入到 DSOS，可以点击 Loader 底部的设置（齿轮）图标，然后使用“复制正式版存档”功能。

出于安全考虑，项目**不会提供**将 DS3OS 存档自动复制回正式版存档的功能。

如果你**确实非常清楚自己在做什么**，可以手动找到存档目录，并将 `.ds3os` 文件扩展名改名为 `.sl2`。

## 可以用 Docker 运行服务器吗？
可以。

目前 DSOS 提供两个 Docker 镜像，并会在新版本发布时自动更新：

- `timleonarduk/ds3os`：主服务器镜像，绝大多数用户使用这个即可
- `timleonarduk/ds3os-master`：Master Server 镜像，通常只有在你维护自己的分叉版本时才会用到

如果你想快速启动服务器，可以使用下面这条命令。它会把 `Saved` 目录挂载到宿主机的 `/opt/ds3os/Saved`，方便你直接修改配置文件。

`sudo mkdir -p /opt/ds3os/Saved && sudo chown 1000:1000 /opt/ds3os/Saved && sudo docker run -d -m 2G --restart always --net host --mount type=bind,source=/opt/ds3os/Saved,target=/opt/ds3os/Saved timleonarduk/ds3os:latest`

## 游戏启动了，但连不上服务器怎么办？
常见原因有以下几种。

最先要确认的是：**是否以管理员身份运行 Loader**。启动器需要修改游戏内存，使游戏连接到新的服务器，这通常需要管理员权限。

如果服务器是你自己搭建的，而且以上方法无效，可以继续检查：

1. 路由器是否已同时为 TCP 和 UDP 转发以下端口：`50000`、`50010`、`50050`、`50020`
2. Windows Defender 防火墙是否已允许服务器程序通信
3. `Saved/config.json` 中的网络配置是否正确

其中最关键的是：

- `ServerHostname`：应设置为你的公网 IP
- `ServerPrivateHostname`：应设置为你的局域网 IP

如果你在使用局域网模拟工具（例如 Hamachi），则需要将它们设置为对应的虚拟局域网 IP。

## 配置文件中的字段分别是什么意思？
配置项说明目前主要在源码中维护，参考：
https://github.com/Crazy-A2/ds3os/blob/main/Source/Server/Config/RuntimeConfig.h

常用字段速查：

| 字段 | 说明 |
| --- | --- |
| `GameType` | 服务器类型，`DarkSouls3` 或 `DarkSouls2` |
| `ServerHostname` | 公网 IP，外网玩家通过此地址连接 |
| `ServerPrivateHostname` | 局域网 IP，局域网玩家通过此地址连接 |
| `Password` | 服务器密码，留空则不需要密码 |
| `Advertise` | 是否向 MasterServer 公开此服务器 |
| `ServerName` | 服务器显示名称 |
| `Announcement` | 玩家进入时显示的公告文本 |

# 如何构建？
本 fork 当前以 **Windows + XMake** 为主，构建入口是根目录的 `xmake.lua`。

## 环境要求
- Visual Studio（含 MSVC 工具链）
- Windows SDK
- .NET 10 SDK（仅构建 Loader 时需要）
- XMake

## 构建步骤

### 1. 配置构建环境
首次构建前执行一次：

```bash
xmake config --plat=windows --arch=x64 --mode=release --toolchain=msvc
```

### 2. 一键构建（推荐）
```bash
xmake build-all
```

这条命令会依次完成：配置 MSVC 环境 → 构建 Server → 构建 Injector → 构建 Loader → 整理输出目录 → 复制运行时资源。

### 3. 分步构建
如果只需要构建某个部分：

```bash
# 只构建服务器（Windows x64 下同时构建 Injector 和 Loader）
xmake build-server

# 只构建 Loader（仅支持 Windows x64）
xmake build-loader

# 只构建 Server 可执行文件
xmake build Server

# 只构建 Injector DLL
xmake build Injector
```

### 4. 复制运行时资源
如果只需要把 WebUI、Steam 运行库等资源复制到输出目录，而不重新编译：

```bash
xmake install-all
```

## 常用 XMake 任务说明

| 命令 | 实际行为 |
| --- | --- |
| `xmake build-all` | 调用 `build-server`，再调用 `install-all` |
| `xmake build-server` | 构建 Server；Windows x64 下额外构建 Injector 和 Loader，并整理输出目录 |
| `xmake build-loader` | 仅限 Windows x64；构建 Injector 和 Loader |
| `xmake install-all` | 复制 `Source/WebUI`、Steam 运行库、`lib/` 下动态库到输出目录 |
| `xmake clean-bin-libs` | 清理 `bin/` 下的 `.lib` / `.pdb` 文件 |

## 输出目录结构
构建产物默认输出到 `bin/<arch>_<mode>/`，例如：

```
bin/
├── x64_release/
│   ├── Server/        ← Server.exe、WebUI、steam_api64.dll 等
│   └── Loader/        ← Loader.exe、Injector.dll 等
├── x64_debug/
└── x86_release/
```

`Server/` 目录下还会包含 `Source/WebUI` 的静态资源，Server 启动后直接从这里提供 WebUI 服务。

## OpenSSL 说明
默认使用预编译的 OpenSSL 库（从 `lib/` 目录链接）。如果需要从源码编译 OpenSSL，可以加上选项：

```bash
xmake config ... --bundled_openssl=y
```

## MasterServer（可选）
MasterServer 是独立的 Node.js 服务，只有在你需要维护自己的服务器列表时才需要运行。

```bash
cd Source/MasterServer
npm install
npm run start        # 生产模式
npm run start:dev    # 开发模式（nodemon 自动重启）
```

也可以使用 Docker 镜像（见下方 Docker 说明）。

# 仓库结构
```text
/
├── xmake.lua              构建入口，定义所有 C++ 编译目标
├── plugins/               XMake 自定义任务（build-all、build-server 等）
├── Protobuf/              服务器网络通信使用的 protobuf 定义
├── Resources/             构建与打包所需的通用资源，例如图标、说明文档等
├── Source/                项目全部源代码
│   ├── Injector/          注入到游戏中的 DLL（仅 Windows），用于重定向联机目标
│   ├── Loader/            WinForms 启动器（仅 Windows x64，.NET 10）
│   ├── MasterServer/      服务器注册中心，Node.js API 服务
│   ├── Server/            主服务器框架（登录、认证、游戏逻辑、WebUI）
│   ├── Server.DarkSouls3/ 《黑暗之魂 3》具体业务实现
│   ├── Server.DarkSouls2/ 《黑暗之魂 2》具体业务实现（实验性）
│   ├── Shared/            服务器与注入器共享的核心库
│   ├── ThirdParty/        第三方库源码（openssl、curl、sqlite、protobuf 等）
│   └── WebUI/             服务器管理页面静态资源，构建后随 Server 一起分发
├── Tools/                 辅助脚本（生成 VS 工程、protobuf、打包等）
└── lib/                   预编译的 OpenSSL 库（默认链接方式）
```

# 如何参与贡献？
你可以查看 Issues，或者直接联系项目维护者，了解当前哪些方向最需要帮助。

目前比较值得投入的方向包括：

- 完善那些仍然只是桩实现、或仅返回占位数据的服务器调用
- 逆向确认这些接口需要返回的数据格式
- 识别更多目前仍未知的 protobuf 字段含义

这些工作都会直接提升服务器实现的完整度。

# 致谢
这个项目能够推进，离不开社区长期积累的大量研究成果。

特别感谢 Souls Modding 社区的相关成员提供的信息与帮助。

以下仓库也为本项目提供了大量参考：

- https://github.com/garyttierney/ds3-open-re
- https://github.com/Jellybaby34/DkS3-Server-Emulator-Rust-Edition
- https://github.com/AmirBohd/ModEngine2

图形与图标来源：

- Campfire 图标：ultimatearm（www.flaticon.com）
- 部分 UI 图标：Mark James（http://www.famfamfam.com/lab/icons/silk/）

![Dark Souls 3 - Open Server](./Resources/banner.png?raw=true)

![GitHub license](https://img.shields.io/github/license/TLeonardUK/ds3os)

English version: [README-en.md](README-en.md)

# DS3OS 是什么？
DS3OS 是《黑暗之魂 3》以及《黑暗之魂 2：原罪学者（SOTFS）》服务器的开源实现。

这个项目主要用于提供一个相对独立的联机环境，方便玩家在使用模组时降低被封禁的风险，或与朋友私下联机，避免作弊者、入侵等公开联机环境中的问题。

如果你在使用过程中遇到问题，可以加入 Discord 寻求技术支持：
https://discord.gg/pBmquc9Jkj

# 能用于盗版游戏吗？
不能。

服务器会校验 Steam 凭证，因此请不要询问盗版、Steam 模拟器或类似话题，项目本身不提供这类支持。

如果条件允许，也请支持 FROM SOFTWARE 的作品。

# 在哪里下载？
发行版下载地址：
https://github.com/TLeonardUK/ds3os/releases

# 怎么使用？
构建完成后，通常会得到一个 `bin/` 目录，其中最常用的是 `Loader/` 和 `Server/` 两部分。

- `Loader`：用于启动游戏并连接到自定义服务器
- `Server`：用于启动你自己的专用服务器

运行 Loader 后，你可以选择创建服务器或加入已有服务器。

如果你想自己开服，需要运行 `Server` 目录中的 `Server.exe`。它会在你的电脑上启动 DS3OS 自定义服务器。

服务器首次启动时，会生成配置文件 `Saved/default/config.json`。你可以修改其中的匹配参数，并通过重启服务器使配置生效。

如果你希望服务器启用密码保护，可以在 `Saved/default/config.json` 中设置密码。之后，玩家连接该服务器时需要先输入密码。

**注意：** 运行 `Server.exe` 时，本机必须安装 **Steam 客户端**（无需登录）。否则 `Server.exe` 可能无法正常初始化。

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
https://github.com/TLeonardUK/ds3os/blob/main/Source/Server/Config/RuntimeConfig.h

# 如何构建？
本 fork 当前以 **Windows + XMake** 为主，不再沿用原项目中的 CMake 工作流。

如果你只是想快速构建并运行，推荐直接使用下面这套方式。

## 环境要求
- Visual Studio 2026 或更高版本
- Windows SDK
- .NET 10 SDK（用于构建 Loader）
- XMake

## 快速开始
### 1. 安装 XMake
可以参考 XMake 官方文档，或自行通过常用包管理器安装。

### 2. 配置构建
首次构建建议先执行：

```bash
xmake config --plat=windows --arch=x64 --mode=release --toolchain=msvc
```

### 3. 构建项目
常用命令如下：

```bash
# 构建 Loader
xmake build-loader

# 构建主服务器
xmake build Server

# 构建注入器
xmake build Injector

# 一键构建 Server、Injector、Loader，并整理输出目录
xmake build-all
```

### 4. 复制运行时文件
如果你需要整理运行时所需文件，可以执行：

```bash
xmake install-all
```

## 常见构建方式
### Debug 构建
```bash
xmake config --plat=windows --arch=x64 --mode=debug --toolchain=msvc
xmake build Server
```

### Release 构建
```bash
xmake config --plat=windows --arch=x64 --mode=release --toolchain=msvc
xmake build Server
```

### 32 位构建
```bash
xmake config --plat=windows --arch=x86 --mode=release --toolchain=msvc
xmake build Server
```

## 常用 XMake 任务
| 命令 | 说明 |
| --- | --- |
| `xmake build-loader` | 构建 C# Loader |
| `xmake build-all` | 构建 Server、Injector、Loader，并整理输出 |
| `xmake build-server` | 构建 Server，并在 x64 下额外构建 Injector、Loader |
| `xmake install-all` | 复制运行时文件 |
| `xmake clean-bin-libs` | 清理 `bin/` 下生成的 `.lib` / `.pdb` 文件 |

## 输出目录
默认输出目录类似如下：

- `bin/x64_debug/`
- `bin/x64_release/`
- `bin/x86_debug/`
- `bin/x86_release/`

其中 `xmake build-server` 和 `xmake build-all` 还会进一步整理出：

- `bin/<arch>_<mode>/Server/`
- `bin/<arch>_<mode>/Loader/`

## 构建补充说明
- `Server`、`Injector`、`Loader` 是最主要的三个构建目标
- `Loader` 依赖 .NET SDK
- 当前仓库根目录以 `xmake.lua` 为核心构建入口

## nix
原项目 README 中保留了 nix 相关说明，但当前这个 fork 的主要维护方向不是 nix 工作流。若你使用本 fork，优先参考上面的 XMake 构建方式。

# 仓库结构
```text
/
├── Protobuf/              服务器网络通信使用的 protobuf 定义
├── Resources/             构建与打包所需的通用资源，例如图标、说明文档等
├── Source/                项目全部源代码
│   ├── Injector/          注入到游戏中的 DLL，用于提供 DS3OS 功能
│   ├── Loader/            用于启动游戏并连接自定义服务器的 WinForms 程序
│   ├── MasterServer/      用于发布和列出活动服务器的 Node.js API 服务
│   ├── Server/            主服务器源码
│   ├── Server.DarkSouls3/ 《黑暗之魂 3》相关服务器实现
│   ├── Server.DarkSouls2/ 《黑暗之魂 2》相关服务器实现
│   ├── Shared/            服务器与注入器共享代码
│   ├── ThirdParty/        第三方库源码
│   └── WebUI/             服务器管理页面使用的静态资源
├── Tools/                 分析脚本、批处理、辅助工具等
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

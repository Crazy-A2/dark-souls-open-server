# DS3OS XMake 构建说明

## 概述

本项目已从 CMake 构建系统迁移到 XMake，提供更简单的一键构建体验。

## 环境要求

- **Windows**:
  - Visual Studio 2019 或更新版本
  - Windows SDK
  - .NET 5.0 SDK (用于构建 Loader)

- **Linux**:
  - GCC 9+ 或 Clang 10+
  - pthread 库
  - uuid 库
  - .NET 5.0 SDK (用于构建 Loader，可选)

## 快速开始

### 1. 安装 XMake

**Windows**:
```powershell
# 使用 PowerShell
Invoke-Expression (Invoke-WebRequest -Uri https://xmake.io/psget.txt -UseBasicParsing).Content

# 或使用 Scoop
scoop install xmake
```

**Linux**:
```bash
curl -fsSL https://xmake.io/shget.text | bash

# 或使用包管理器
# Ubuntu/Debian
sudo apt install xmake
```

### 2. 构建项目

```bash
# 配置项目（首次运行）
xmake config --arch=x64 --mode=release

# 构建 Server
xmake build Server

# 构建 Injector (仅 Windows)
xmake build Injector

# 构建 Loader (C#，需要 dotnet SDK)
xmake build-loader

# 一键构建所有组件
xmake build-all
```

### 3. 安装运行时文件

```bash
xmake install-all
```

## 构建配置

### Debug 模式
```bash
xmake config --arch=x64 --mode=debug
xmake build Server
```

### Release 模式
```bash
xmake config --arch=x64 --mode=release
xmake build Server
```

### 32 位构建 (仅 Windows)
```bash
xmake config --arch=x86 --mode=release
xmake build Server
```

## 可用命令

### 基础命令

| 命令 | 说明 |
|------|------|
| `xmake config` | 配置项目 |
| `xmake build [target]` | 构建指定目标 |
| `xmake clean [target]` | 清理指定目标 |
| `xmake rebuild [target]` | 重新构建指定目标 |
| `xmake install-all` | 安装所有运行时文件 |
| `xmake clean-all` | 清理所有构建产物 |

### 自定义任务

| 任务 | 说明 |
|------|------|
| `xmake build-loader` | 构建 C# Loader |
| `xmake build-all` | 构建所有组件 (Server, Injector, Loader) |

## 构建目标

### 主要目标

- **Server** - 主服务器可执行文件
- **Injector** - DLL 注入器 (仅 Windows)
- **Loader** - C# 启动器 (需要单独构建)

### 库目标

- **Shared** - 共享静态库
- **DarkSouls3** - Dark Souls 3 服务器库
- **DarkSouls2** - Dark Souls 2 服务器库

### 第三方库

- **lib_generic_c** - AES 核心加密
- **aes_modes** - AES 模式实现
- **zlib** - 压缩库
- **sqlite** - SQLite 数据库
- **civetweb** - 嵌入式 Web 服务器
- **libprotobuf-lite** - Protocol Buffers 运行时
- **libcurl** - HTTP 客户端
- **crypto/ssl** - OpenSSL 加密库
- **detours** - Windows API Hook (仅 Windows)
- **steam** - Steamworks SDK

## 输出目录

构建产物将输出到以下目录：

- **Windows x64 Debug**: `bin/x64_debug/`
- **Windows x64 Release**: `bin/x64_release/`
- **Windows x86 Debug**: `bin/x86_debug/`
- **Windows x86 Release**: `bin/x86_release/`
- **Linux Debug**: `bin/x64_debug/`
- **Linux Release**: `bin/x64_release/`

## 常见问题

### Q: 如何切换配置？

```bash
xmake config --platform=x64 --mode=debug
xmake build Server
```

### Q: 如何清理构建？

```bash
# 清理当前配置
xmake clean

# 清理所有构建产物
xmake clean-all
```

### Q: Loader 构建失败？

确保已安装 .NET 5.0 SDK：

```bash
# 检查 .NET 版本
dotnet --version

# 如果未安装，请访问 https://dotnet.microsoft.com/download
```

### Q: Windows 上缺少 Steam DLL？

运行 `xmake install-all` 会自动复制必要的 DLL 文件。

### Q: Linux 上编译错误？

确保安装了必要的依赖：

```bash
sudo apt-get update
sudo apt-get install build-essential libuuid-dev
```

## 原始 CMake 构建说明

如果你需要使用原始的 CMake 构建，请参考项目根目录的 `CMakeLists.txt`。

```bash
# 创建构建目录
mkdir build && cd build

# 配置
cmake .. -G Ninja

# 构建
ninja
```

## 故障排除

### 编译器版本问题

- **Windows**: 需要 Visual Studio 2019 或更新版本
- **Linux**: 需要 GCC 9+ 或 Clang 10+

### 路径问题

如果遇到路径相关错误，确保：
1. 项目路径不包含空格
2. 项目路径不包含非 ASCII 字符

### 内存不足

项目较大，构建时可能需要较多内存。如果遇到内存不足，可以：
1. 关闭其他应用程序
2. 使用 `-j` 参数限制并行任务数

```bash
xmake build -j2 Server
```

## 贡献

如果你发现构建系统的问题或有改进建议，请提交 Issue 或 Pull Request。

## 许可证

Copyright (C) 2021 Tim Leonard

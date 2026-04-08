@echo off
chcp 65001
REM ================================================================================================
REM  DS3OS Build Script for Windows
REM ================================================================================================

setlocal enabledelayedexpansion

set PLATFORM=x64
set MODE=release
set TARGET=server
set CLEAN=0

goto parse_args

:show_help
echo DS3OS Build Script - Usage
echo.
echo build.bat [options]
echo.
echo Options:
echo   --plat PLATFORM      Target architecture ^(x86 or x64, default: x64^)
echo   --mode MODE          Build mode ^(debug or release, default: release^)
echo   --target TARGET      Target to build:
echo                        server   - Build Server ^(default^)
echo                        injector - Build Injector
echo                        loader   - Build C# Loader ^(Windows x64 only^)
echo                        all      - Build Server + Injector, and Loader on x64
echo   --clean              Clean build artifacts before building
echo   --help               Show this help message
echo.
echo Examples:
echo   build.bat
echo   build.bat --mode debug
echo   build.bat --plat x86 --target injector
echo   build.bat --target all
echo   build.bat --clean --target all
goto end

:parse_args
if "%~1"=="" goto done_args
if /i "%~1"=="--plat" (
    set PLATFORM=%~2
    shift
    shift
    goto parse_args
)
if /i "%~1"=="--arch" (
    set PLATFORM=%~2
    shift
    shift
    goto parse_args
)
if /i "%~1"=="--mode" (
    set MODE=%~2
    shift
    shift
    goto parse_args
)
if /i "%~1"=="--target" (
    set TARGET=%~2
    shift
    shift
    goto parse_args
)
if /i "%~1"=="--clean" (
    set CLEAN=1
    shift
    goto parse_args
)
if /i "%~1"=="--help" (
    goto show_help
)
echo ERROR: Unknown option %~1
echo.
goto show_help

:done_args

if /i not "%PLATFORM%"=="x86" if /i not "%PLATFORM%"=="x64" (
    echo ERROR: Invalid platform "%PLATFORM%". Use x86 or x64.
    exit /b 1
)

if /i not "%MODE%"=="debug" if /i not "%MODE%"=="release" (
    echo ERROR: Invalid mode "%MODE%". Use debug or release.
    exit /b 1
)

if /i not "%TARGET%"=="server" if /i not "%TARGET%"=="injector" if /i not "%TARGET%"=="loader" if /i not "%TARGET%"=="all" (
    echo ERROR: Invalid target "%TARGET%".
    exit /b 1
)

if /i "%TARGET%"=="loader" if /i not "%PLATFORM%"=="x64" (
    echo ERROR: Loader is only supported on Windows x64.
    exit /b 1
)

echo.
echo ========================================
echo DS3OS Build Script
echo ========================================
echo.
echo Configuration:
echo   Platform: %PLATFORM%
echo   Mode: %MODE%
echo   Target: %TARGET%
echo.

where xmake >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: XMake is not installed or not in PATH.
    exit /b 1
)

if %CLEAN% equ 1 (
    call xmake clean-all
    if %errorlevel% neq 0 exit /b 1
)

call xmake config --plat=windows --arch=%PLATFORM% --mode=%MODE% --toolchain=msvc
if %errorlevel% neq 0 (
    echo ERROR: Configuration failed.
    exit /b 1
)

if /i "%TARGET%"=="loader" (
    where dotnet >nul 2>&1
    if %errorlevel% neq 0 (
        echo ERROR: dotnet SDK is required to build Loader.
        exit /b 1
    )
    call xmake build-loader
    goto after_build
)

if /i "%TARGET%"=="all" (
    where dotnet >nul 2>&1
    if %errorlevel% neq 0 if /i "%PLATFORM%"=="x64" (
        echo NOTE: dotnet SDK not found. build-all may skip Loader.
    )
    call xmake build-all
    goto after_build
)

if /i "%TARGET%"=="server" (
    call xmake build Server
    goto after_build
)

if /i "%TARGET%"=="injector" (
    call xmake build Injector
    goto after_build
)

:after_build
if %errorlevel% neq 0 (
    echo ERROR: Build failed.
    exit /b 1
)

if /i "%TARGET%"=="all" if /i "%PLATFORM%"=="x86" (
    echo NOTE: Loader was skipped because it only supports Windows x64.
)

echo.
echo ========================================
echo Build completed successfully!
echo Output directory: bin\%PLATFORM%_%MODE%
echo ========================================
echo.

:end
endlocal

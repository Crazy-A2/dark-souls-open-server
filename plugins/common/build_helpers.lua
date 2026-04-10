import("core.project.config")
import("lib.detect.find_tool")

local function exec_tool(tool, args, fallback)
    if os.execv then
        os.execv(tool.program, args)
    elseif os.runv then
        os.runv(tool.program, args)
    else
        fallback()
    end
end

local function exec_xmake(xmake, args, fallback_format, ...)
    local fallback_args = {...}
    exec_tool(xmake, args, function ()
        os.exec(fallback_format, xmake.program, table.unpack(fallback_args))
    end)
end

local function exec_dotnet(dotnet, args, fallback_format, ...)
    local fallback_args = {...}
    exec_tool(dotnet, args, function ()
        os.exec(fallback_format, dotnet.program, table.unpack(fallback_args))
    end)
end

function normalize_arch(arch)
    if arch == "x86_64" then
        return "x64"
    elseif arch == "i386" then
        return "x86"
    end
    return arch or "x64"
end

function current_plat()
    return config.plat() or (is_host("windows") and "windows" or "linux")
end

function current_arch()
    return normalize_arch(config.arch())
end

function current_mode()
    return config.mode() or "release"
end

function outputdir(arch, mode)
    arch = arch or current_arch()
    mode = mode or current_mode()
    return path.join(os.projectdir(), "bin", arch .. "_" .. mode)
end

function ensure_outputdir(dir)
    os.mkdir(dir)
    return dir
end

function dotnet_configuration(mode)
    return (mode or current_mode()) == "debug" and "Debug" or "Release"
end

function copy_runtime_assets(plat, dir)
    if os.isdir("Source/WebUI") then
        os.cp("Source/WebUI", dir)
    end

    local runtime = plat == "windows"
        and "Source/ThirdParty/steam/redistributable_bin/win64/steam_api64.dll"
        or "Source/ThirdParty/steam/redistributable_bin/linux64/libsteam_api.so"
    if os.isfile(runtime) then
        os.cp(runtime, dir)
    end
end

function find_xmake()
    return assert(find_tool("xmake"), "xmake not found!")
end

function find_dotnet()
    return assert(find_tool("dotnet"), "dotnet not found!")
end

function ensure_windows_msvc_config(xmake, arch, mode)
    if not is_host("windows") then
        return "linux"
    end

    local args = {"f", "-p", "windows", "-a", arch, "-m", mode, "--toolchain=msvc"}
    local bundled_openssl = config.get("bundled_openssl")
    if bundled_openssl ~= nil then
        table.insert(args, "--bundled_openssl=" .. (bundled_openssl and "y" or "n"))
    end

    local openssl_libdir = config.get("openssl_libdir")
    if openssl_libdir then
        table.insert(args, "--openssl_libdir=" .. openssl_libdir)
    end

    local openssl_includedir = config.get("openssl_includedir")
    if openssl_includedir then
        table.insert(args, "--openssl_includedir=" .. openssl_includedir)
    end

    exec_xmake(xmake, args, "%s f -p windows -a %s -m %s --toolchain=msvc", arch, mode)
    config.load()
    return "windows"
end

function load_context()
    config.load()
    return {
        plat = current_plat(),
        arch = current_arch(),
        mode = current_mode()
    }
end

function build_target(xmake, target)
    exec_xmake(xmake, {"build", target}, "%s build %s", target)
end

function run_task(xmake, taskname)
    exec_xmake(xmake, {taskname}, "%s %s", taskname)
end

function build_loader(dotnet, mode, dir)
    local configuration = dotnet_configuration(mode)
    exec_dotnet(
        dotnet,
        {"build", "Source/Loader/Loader.csproj", "-c", configuration, "-o", dir},
        "%s build %s -c %s -o %s",
        "Source/Loader/Loader.csproj",
        configuration,
        dir
    )
end

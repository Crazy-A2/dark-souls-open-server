task("build-loader")
    set_category("plugin")
    on_run(function ()
        import("core.project.config")

        config.load()

        local plat = config.plat() or (is_host("windows") and "windows" or "linux")
        if plat ~= "windows" then
            print("Loader is only supported on Windows.")
            return
        end

        local arch = config.arch() or "x64"
        if arch == "x86_64" then
            arch = "x64"
        elseif arch == "i386" then
            arch = "x86"
        end
        if arch ~= "x64" then
            print("Loader only supports x64.")
            return
        end

        local mode = config.mode() or "release"
        local configuration = mode == "debug" and "Debug" or "Release"
        local outputdir = path.join(os.projectdir(), "bin", arch .. "_" .. mode)

        import("lib.detect.find_tool")
        local dotnet = assert(find_tool("dotnet"), "dotnet not found!")
        if os.execv then
            os.execv(dotnet.program, {"build", "Source/Loader/Loader.csproj", "-c", configuration, "-o", outputdir})
        elseif os.runv then
            os.runv(dotnet.program, {"build", "Source/Loader/Loader.csproj", "-c", configuration, "-o", outputdir})
        else
            os.exec("%s build %s -c %s -o %s", dotnet.program, "Source/Loader/Loader.csproj", configuration, outputdir)
        end
        print("Loader build complete: %s", outputdir)
    end)
    set_menu {
        usage = "xmake build-loader [options]",
        description = "Build the Windows x64 Loader via dotnet",
        options = {}
    }

task("build-loader")
    set_category("plugin")
    on_run(function ()
        local helpers = import("common.build_helpers", {rootdir = path.join(os.projectdir(), "plugins")})

        local ctx = helpers.load_context()
        if ctx.plat ~= "windows" and not is_host("windows") then
            print("Loader is only supported on Windows.")
            return
        end

        if ctx.arch ~= "x64" then
            print("Loader only supports x64.")
            return
        end

        local outputdir = helpers.ensure_outputdir(helpers.outputdir(ctx.arch, ctx.mode))
        local xmake = helpers.find_xmake()
        local dotnet = helpers.find_dotnet()
        helpers.ensure_windows_msvc_config(xmake, ctx.arch, ctx.mode)
        helpers.build_target(xmake, "Injector")
        helpers.build_loader(dotnet, ctx.mode, outputdir)

        print("Loader build complete: %s", outputdir)
    end)
    set_menu {
        usage = "xmake build-loader [options]",
        description = "Build the Windows x64 Loader via dotnet",
        options = {}
    }

task("build-all")
    set_category("plugin")
    on_run(function ()
        local helpers = import("common.build_helpers", {rootdir = path.join(os.projectdir(), "plugins")})

        local ctx = helpers.load_context()
        local outputdir = helpers.outputdir(ctx.arch, ctx.mode)

        local xmake = helpers.find_xmake()
        if is_host("windows") then
            ctx.plat = helpers.ensure_windows_msvc_config(xmake, ctx.arch, ctx.mode)
        end
        local dotnet = ctx.plat == "windows" and helpers.find_dotnet() or nil

        helpers.run_task(xmake, "build-server")
        if ctx.plat == "windows" then
            helpers.build_target(xmake, "Injector")
            if ctx.arch == "x64" then
                helpers.ensure_outputdir(outputdir)
                helpers.build_loader(dotnet, ctx.mode, outputdir)
            else
                print("Skipping Loader: only available for Windows x64.")
            end
        end

        helpers.run_task(xmake, "install-all")
        print("Build complete: %s", outputdir)
    end)
    set_menu {
        usage = "xmake build-all [options]",
        description = "Build the native targets for the current configuration",
        options = {}
    }

task("install-all")
    set_category("plugin")
    on_run(function ()
        local helpers = import("common.build_helpers", {rootdir = path.join(os.projectdir(), "plugins")})

        local ctx = helpers.load_context()
        local outputdir = helpers.ensure_outputdir(helpers.outputdir(ctx.arch, ctx.mode))
        helpers.copy_runtime_assets(ctx.plat, outputdir)

        print("Installed runtime assets to: %s", outputdir)
    end)
    set_menu {
        usage = "xmake install-all [options]",
        description = "Copy runtime assets to the configured output directory",
        options = {}
    }

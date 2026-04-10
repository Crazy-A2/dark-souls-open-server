task("install-all")
    set_category("plugin")
    on_run(function ()
        import("core.project.config")

        config.load()

        local plat = config.plat() or (is_host("windows") and "windows" or "linux")
        local arch = config.arch() or "x64"
        local mode = config.mode() or "release"
        if arch == "x86_64" then
            arch = "x64"
        elseif arch == "i386" then
            arch = "x86"
        end

        local outputdir = path.join(os.projectdir(), "bin", arch .. "_" .. mode)
        os.mkdir(outputdir)

        if os.isdir("Source/WebUI") then
            os.cp("Source/WebUI", outputdir)
        end

        local runtime = plat == "windows"
            and "Source/ThirdParty/steam/redistributable_bin/win64/steam_api64.dll"
            or "Source/ThirdParty/steam/redistributable_bin/linux64/libsteam_api.so"
        if os.isfile(runtime) then
            os.cp(runtime, outputdir)
        end

        print("Installed runtime assets to: %s", outputdir)
    end)
    set_menu {
        usage = "xmake install-all [options]",
        description = "Copy runtime assets to the configured output directory",
        options = {}
    }

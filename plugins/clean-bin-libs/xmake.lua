task("clean-bin-libs")
    set_category("plugin")
    on_run(function ()
        local bindir = path.join(os.projectdir(), "bin")
        if not os.isdir(bindir) then
            print("Bin directory does not exist: %s", bindir)
            return
        end

        local patterns = {
            path.join(bindir, "**.lib"),
            path.join(bindir, "**.pdb")
        }

        local removed = 0
        for _, pattern in ipairs(patterns) do
            for _, filepath in ipairs(os.files(pattern)) do
                os.rm(filepath)
                removed = removed + 1
            end
        end

        if removed == 0 then
            print("No .lib/.pdb files found under: %s", bindir)
            return
        end

        print("Removed %d .lib/.pdb files from: %s", removed, bindir)
    end)
    set_menu {
        usage = "xmake clean-bin-libs [options]",
        description = "Remove generated .lib and .pdb files under the bin directory",
        options = {}
    }

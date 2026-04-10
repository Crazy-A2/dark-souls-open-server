-- ================================================================================================
--  DS3OS XMake Configuration
--  Mirrors the repository's native CMake target graph and build settings.
-- ================================================================================================

set_project("ds3os")
set_version("1.0.0")
add_rules("mode.debug", "mode.release")
set_languages("c++17")
add_plugindirs("plugins")

option("bundled_openssl")
    set_default(false)
    set_showmenu(true)
    set_description("Build bundled OpenSSL sources instead of linking prebuilt libraries")
option_end()

option("openssl_libdir")
    set_default(path.join(os.projectdir(), "lib"))
    set_showmenu(true)
    set_description("Directory containing prebuilt OpenSSL libraries")
option_end()

option("openssl_includedir")
    set_default(path.join(os.projectdir(), "Source", "ThirdParty", "openssl", "include"))
    set_showmenu(true)
    set_description("Directory containing OpenSSL headers")
option_end()

local function current_plat()
    return get_config("plat") or (is_host("windows") and "windows" or "linux")
end

local function is_windows_plat()
    return current_plat() == "windows"
end

local function is_macos_plat()
    return current_plat() == "macosx"
end

local function current_arch()
    local arch = get_config("arch") or "x64"
    if arch == "x86_64" then
        return "x64"
    elseif arch == "i386" then
        return "x86"
    end
    return arch
end

local function use_bundled_openssl()
    return get_config("bundled_openssl")
end

local function openssl_libdir()
    return get_config("openssl_libdir") or path.join(os.projectdir(), "lib")
end

local function openssl_includedir()
    return get_config("openssl_includedir") or path.join(os.projectdir(), "Source", "ThirdParty", "openssl", "include")
end

local function current_mode()
    return get_config("mode") or "release"
end

local function output_dir()
    return path.join(os.projectdir(), "bin", current_arch() .. "_" .. current_mode())
end

local function ensure_output_dir()
    os.mkdir(output_dir())
end

local function copy_path(src, dst)
    os.cp(src, dst)
end

local function ensure_openssl_generated_headers()
    return
end

local function apply_common_native_settings()
    set_targetdir(output_dir())
    set_rundir(output_dir())

    if is_windows_plat() then
        add_defines("_CRT_SECURE_NO_WARNINGS", "DDS_PLATFORM_WINDOWS", "NOMINMAX", "WIN32_LEAN_AND_MEAN")
        set_symbols("debug")
        add_cxflags("/MP", "/FS", {force = true})
        add_ldflags("/DEBUG", {force = true})
    else
        add_defines("DDS_PLATFORM_LINUX")
        add_cxflags("-fpermissive", "-g")
        add_ldflags("-rdynamic", "-g")
    end

    if current_arch() == "x86" then
        add_defines("DDS_PLATFORM_X86")
    else
        add_defines("DDS_PLATFORM_X64")
    end

    if is_mode("debug") then
        add_defines("DDS_CONFIG_DEBUG")
    else
        add_defines("DDS_CONFIG_RELEASE")
    end
end

local function apply_project_warning_defines()
    add_defines("_CRT_SECURE_NO_WARNINGS", "_WINSOCK_DEPRECATED_NO_WARNINGS", "_SILENCE_ALL_CXX17_DEPRECATION_WARNINGS")
end

local function apply_openssl_includes()
    add_includedirs(
        openssl_includedir(),
        {public = true}
    )

    if use_bundled_openssl() then
        add_includedirs(
            "Source/ThirdParty/openssl",
            "Source/ThirdParty/openssl/crypto",
            "Source/ThirdParty/openssl/crypto/ec/curve448",
            "Source/ThirdParty/openssl/crypto/ec/curve448/arch_32",
            "Source/ThirdParty/openssl/crypto/modes",
            {public = true}
        )
    end
end

local function openssl_link_names()
    if is_windows_plat() then
        return "libcrypto", "libssl"
    end
    return "ssl", "crypto"
end

local function apply_openssl_links()
    apply_openssl_includes()

    if use_bundled_openssl() then
        add_deps("crypto", "ssl")
    else
        local crypto_lib, ssl_lib = openssl_link_names()
        add_linkdirs(openssl_libdir(), {public = true})
        add_links(crypto_lib, ssl_lib, {public = true})
        if is_windows_plat() then
            add_syslinks("ws2_32", "crypt32", {public = true})
        else
            add_syslinks("dl", "pthread", {public = true})
        end
    end
end

local function copy_steam_runtime(target)
    local source = is_windows_plat()
        and "Source/ThirdParty/steam/redistributable_bin/win64/steam_api64.dll"
        or "Source/ThirdParty/steam/redistributable_bin/linux64/libsteam_api.so"

    if os.isfile(source) then
        copy_path(source, target:targetdir())
    end
end

-- ================================================================================================
-- Third-party targets
-- ================================================================================================

target("lib_generic_c")
    set_kind("static")
    apply_common_native_settings()
    add_files(
        "Source/ThirdParty/aes/aes_modes.c",
        "Source/ThirdParty/aes/aes_ni.c",
        "Source/ThirdParty/aes/aescrypt.c",
        "Source/ThirdParty/aes/aeskey.c",
        "Source/ThirdParty/aes/aestab.c"
    )
    add_headerfiles("Source/ThirdParty/aes/*.h")
    add_includedirs("Source/ThirdParty/aes", {public = true})

target("aes_modes")
    set_kind("static")
    apply_common_native_settings()
    add_files("Source/ThirdParty/aes_modes/cwc.c")
    add_headerfiles("Source/ThirdParty/aes_modes/*.h")
    add_includedirs("Source/ThirdParty/aes", "Source/ThirdParty/aes_modes", {public = true})

target("zlib")
    set_kind("static")
    apply_common_native_settings()
    add_files(
        "Source/ThirdParty/zlib/adler32.c",
        "Source/ThirdParty/zlib/compress.c",
        "Source/ThirdParty/zlib/crc32.c",
        "Source/ThirdParty/zlib/deflate.c",
        "Source/ThirdParty/zlib/gzclose.c",
        "Source/ThirdParty/zlib/gzlib.c",
        "Source/ThirdParty/zlib/gzread.c",
        "Source/ThirdParty/zlib/gzwrite.c",
        "Source/ThirdParty/zlib/infback.c",
        "Source/ThirdParty/zlib/inffast.c",
        "Source/ThirdParty/zlib/inflate.c",
        "Source/ThirdParty/zlib/inftrees.c",
        "Source/ThirdParty/zlib/trees.c",
        "Source/ThirdParty/zlib/uncompr.c",
        "Source/ThirdParty/zlib/zutil.c"
    )
    add_headerfiles("Source/ThirdParty/zlib/*.h")
    add_includedirs("Source/ThirdParty/zlib", {public = true})
    add_defines("_CRT_NONSTDC_NO_DEPRECATE=1", "_CRT_SECURE_NO_WARNINGS=1")
    if is_windows_plat() then
        add_cxflags("/wd4267")
    end

target("sqlite")
    set_kind("static")
    apply_common_native_settings()
    add_files("Source/ThirdParty/sqlite/sqlite3.c")
    add_headerfiles("Source/ThirdParty/sqlite/sqlite3.h")
    add_includedirs("Source/ThirdParty/sqlite", {public = true})

target("civetweb")
    set_kind("static")
    apply_common_native_settings()
    add_files("Source/ThirdParty/civetweb/src/civetweb.c", "Source/ThirdParty/civetweb/src/CivetServer.cpp")
    add_headerfiles("Source/ThirdParty/civetweb/include/*.h")
    add_includedirs("Source/ThirdParty/civetweb/include", {public = true})
    add_defines("NO_SSL=1")

target("libprotobuf-lite")
    set_kind("static")
    apply_common_native_settings()
    add_files(
        "Source/ThirdParty/protobuf-2.6.1rc1/src/google/protobuf/io/coded_stream.cc",
        "Source/ThirdParty/protobuf-2.6.1rc1/src/google/protobuf/io/zero_copy_stream.cc",
        "Source/ThirdParty/protobuf-2.6.1rc1/src/google/protobuf/io/zero_copy_stream_impl_lite.cc",
        "Source/ThirdParty/protobuf-2.6.1rc1/src/google/protobuf/stubs/common.cc",
        "Source/ThirdParty/protobuf-2.6.1rc1/src/google/protobuf/stubs/once.cc",
        "Source/ThirdParty/protobuf-2.6.1rc1/src/google/protobuf/stubs/stringprintf.cc",
        "Source/ThirdParty/protobuf-2.6.1rc1/src/google/protobuf/repeated_field.cc",
        "Source/ThirdParty/protobuf-2.6.1rc1/src/google/protobuf/extension_set.cc",
        "Source/ThirdParty/protobuf-2.6.1rc1/src/google/protobuf/generated_message_util.cc",
        "Source/ThirdParty/protobuf-2.6.1rc1/src/google/protobuf/message_lite.cc",
        "Source/ThirdParty/protobuf-2.6.1rc1/src/google/protobuf/wire_format_lite.cc"
    )
    add_headerfiles("Source/ThirdParty/protobuf-2.6.1rc1/src/google/protobuf/**/*.h")
    add_defines("_SILENCE_STDEXT_HASH_DEPRECATION_WARNINGS", "_USRDLL", "LIBPROTOBUF_EXPORTS")
    if is_windows_plat() then
        add_files("Source/ThirdParty/protobuf-2.6.1rc1/src/google/protobuf/stubs/atomicops_internals_x86_msvc.cc")
        add_includedirs(
            "Source/ThirdParty/protobuf-2.6.1rc1/src",
            "Source/ThirdParty/protobuf-2.6.1rc1/vsprojects",
            {public = true}
        )
        add_cxflags("/wd4244", "/wd4267", "/wd4018", "/wd4355", "/wd4800", "/wd4251", "/wd4996", "/wd4146", "/wd4305")
    else
        add_files("Source/ThirdParty/protobuf-2.6.1rc1/src/google/protobuf/stubs/atomicops_internals_x86_gcc.cc")
        add_includedirs(
            "Source/ThirdParty/protobuf-2.6.1rc1/src",
            "Source/ThirdParty/protobuf-2.6.1rc1/gccprojects",
            {public = true}
        )
        add_defines("HAVE_PTHREAD")
        add_cxflags("-pthread")
        add_syslinks("pthread")
    end

target("libcurl")
    set_kind("static")
    apply_common_native_settings()
    apply_openssl_includes()
    add_files("Source/ThirdParty/curl/lib/*.c", "Source/ThirdParty/curl/lib/vauth/*.c", "Source/ThirdParty/curl/lib/vtls/*.c", "Source/ThirdParty/curl/lib/vquic/*.c", "Source/ThirdParty/curl/lib/vssh/*.c")
    add_defines("BUILDING_LIBCURL", "CURL_HIDDEN_SYMBOLS", "_USRDLL", "HAVE_CONFIG_H", "libcurl_EXPORTS")
    add_defines("CURL_STATICLIB", {public = true})
    add_includedirs("Source/ThirdParty/curl", "Source/ThirdParty/curl/lib")
    add_includedirs("Source/ThirdParty/curl/include", {public = true})

if use_bundled_openssl() then
    target("crypto")
        set_kind("static")
        before_build(function ()
            ensure_openssl_generated_headers()
        end)
        apply_common_native_settings()
        apply_openssl_includes()
        add_files(
        "Source/ThirdParty/openssl/crypto/cpt_err.c",
        "Source/ThirdParty/openssl/crypto/cryptlib.c",
        "Source/ThirdParty/openssl/crypto/ctype.c",
        "Source/ThirdParty/openssl/crypto/cversion.c",
        "Source/ThirdParty/openssl/crypto/ebcdic.c",
        "Source/ThirdParty/openssl/crypto/ex_data.c",
        "Source/ThirdParty/openssl/crypto/init.c",
        "Source/ThirdParty/openssl/crypto/mem.c",
        "Source/ThirdParty/openssl/crypto/mem_clr.c",
        "Source/ThirdParty/openssl/crypto/mem_dbg.c",
        "Source/ThirdParty/openssl/crypto/mem_sec.c",
        "Source/ThirdParty/openssl/crypto/o_dir.c",
        "Source/ThirdParty/openssl/crypto/o_fips.c",
        "Source/ThirdParty/openssl/crypto/o_fopen.c",
        "Source/ThirdParty/openssl/crypto/o_init.c",
        "Source/ThirdParty/openssl/crypto/o_str.c",
        "Source/ThirdParty/openssl/crypto/o_time.c",
        "Source/ThirdParty/openssl/crypto/uid.c",
        "Source/ThirdParty/openssl/crypto/getenv.c",
        "Source/ThirdParty/openssl/crypto/aes/*.c",
        "Source/ThirdParty/openssl/crypto/aria/*.c",
        "Source/ThirdParty/openssl/crypto/asn1/*.c",
        "Source/ThirdParty/openssl/crypto/async/*.c",
        "Source/ThirdParty/openssl/crypto/async/arch/*.c",
        "Source/ThirdParty/openssl/crypto/bf/*.c",
        "Source/ThirdParty/openssl/crypto/bio/*.c",
        "Source/ThirdParty/openssl/crypto/blake2/*.c",
        "Source/ThirdParty/openssl/crypto/bn/*.c",
        "Source/ThirdParty/openssl/crypto/buffer/*.c",
        "Source/ThirdParty/openssl/crypto/camellia/*.c",
        "Source/ThirdParty/openssl/crypto/cast/*.c",
        "Source/ThirdParty/openssl/crypto/chacha/*.c",
        "Source/ThirdParty/openssl/crypto/cmac/*.c",
        "Source/ThirdParty/openssl/crypto/cms/*.c",
        "Source/ThirdParty/openssl/crypto/comp/*.c",
        "Source/ThirdParty/openssl/crypto/conf/*.c",
        "Source/ThirdParty/openssl/crypto/ct/*.c",
        "Source/ThirdParty/openssl/crypto/des/*.c",
        "Source/ThirdParty/openssl/crypto/dh/*.c",
        "Source/ThirdParty/openssl/crypto/dsa/*.c",
        "Source/ThirdParty/openssl/crypto/dso/*.c",
        "Source/ThirdParty/openssl/crypto/ec/*.c",
        "Source/ThirdParty/openssl/crypto/ec/curve448/*.c",
        "Source/ThirdParty/openssl/crypto/ec/curve448/arch_32/*.c",
        "Source/ThirdParty/openssl/crypto/engine/*.c",
        "Source/ThirdParty/openssl/crypto/err/*.c",
        "Source/ThirdParty/openssl/crypto/evp/*.c",
        "Source/ThirdParty/openssl/crypto/hmac/*.c",
        "Source/ThirdParty/openssl/crypto/idea/*.c",
        "Source/ThirdParty/openssl/crypto/kdf/*.c",
        "Source/ThirdParty/openssl/crypto/lhash/*.c",
        "Source/ThirdParty/openssl/crypto/md4/*.c",
        "Source/ThirdParty/openssl/crypto/md5/*.c",
        "Source/ThirdParty/openssl/crypto/mdc2/*.c",
        "Source/ThirdParty/openssl/crypto/modes/*.c",
        "Source/ThirdParty/openssl/crypto/objects/*.c",
        "Source/ThirdParty/openssl/crypto/ocsp/*.c",
        "Source/ThirdParty/openssl/crypto/pem/*.c",
        "Source/ThirdParty/openssl/crypto/pkcs12/*.c",
        "Source/ThirdParty/openssl/crypto/pkcs7/*.c",
        "Source/ThirdParty/openssl/crypto/poly1305/*.c",
        "Source/ThirdParty/openssl/crypto/rand/*.c",
        "Source/ThirdParty/openssl/crypto/rc2/*.c",
        "Source/ThirdParty/openssl/crypto/rc4/*.c",
        "Source/ThirdParty/openssl/crypto/ripemd/*.c",
        "Source/ThirdParty/openssl/crypto/rsa/*.c",
        "Source/ThirdParty/openssl/crypto/seed/*.c",
        "Source/ThirdParty/openssl/crypto/sha/*.c",
        "Source/ThirdParty/openssl/crypto/siphash/*.c",
        "Source/ThirdParty/openssl/crypto/sm2/*.c",
        "Source/ThirdParty/openssl/crypto/sm3/*.c",
        "Source/ThirdParty/openssl/crypto/sm4/*.c",
        "Source/ThirdParty/openssl/crypto/srp/*.c",
        "Source/ThirdParty/openssl/crypto/stack/*.c",
        "Source/ThirdParty/openssl/crypto/store/*.c",
        "Source/ThirdParty/openssl/crypto/ts/*.c",
        "Source/ThirdParty/openssl/crypto/txt_db/*.c",
        "Source/ThirdParty/openssl/crypto/ui/*.c",
        "Source/ThirdParty/openssl/crypto/whrlpool/*.c",
        "Source/ThirdParty/openssl/crypto/x509/*.c",
        "Source/ThirdParty/openssl/crypto/x509v3/*.c"
    )
    remove_files(
        "Source/ThirdParty/openssl/crypto/ec/ecp_nistz256_table.c",
        "Source/ThirdParty/openssl/crypto/rc5/*.c",
        "Source/ThirdParty/openssl/crypto/LPdir*.c",
        "Source/ThirdParty/openssl/crypto/*cap.c",
        "Source/ThirdParty/openssl/crypto/dllmain.c",
        "Source/ThirdParty/openssl/crypto/threads_*.c",
        "Source/ThirdParty/openssl/crypto/engine/eng_devcrypto.c"
    )
    add_defines(
        "OPENSSL_NO_ASM",
        "OPENSSL_NO_STATIC_ENGINE",
        "OPENSSL_NO_MD2",
        "OPENSSL_NO_RC5",
        "OPENSSL_NO_RFC3779",
        "OPENSSL_NO_EC_NISTP_64_GCC_128",
        'OPENSSLDIR="C:/ssl"',
        'ENGINESDIR="C:/engines-1.1"'
    )
    if is_windows_plat() then
        add_files("Source/ThirdParty/openssl/crypto/threads_win.c")
        add_syslinks("ws2_32", "crypt32")
        add_defines("OPENSSL_SYSNAME_WIN32", "WIN32_LEAN_AND_MEAN", "_CRT_SECURE_NO_WARNINGS")
    else
        add_files("Source/ThirdParty/openssl/crypto/threads_pthread.c")
        add_syslinks("pthread", "dl")
    end

    target("ssl")
        set_kind("static")
        before_build(function ()
            ensure_openssl_generated_headers()
        end)
        apply_common_native_settings()
        apply_openssl_includes()
        add_files("Source/ThirdParty/openssl/ssl/*.c", "Source/ThirdParty/openssl/ssl/record/*.c", "Source/ThirdParty/openssl/ssl/statem/*.c")
        add_deps("crypto")
end

if is_windows_plat() then
    target("detours")
        set_kind("static")
        apply_common_native_settings()
        add_files("Source/ThirdParty/detours/src/*.cpp")
        remove_files("Source/ThirdParty/detours/src/uimports.cpp")
        add_headerfiles("Source/ThirdParty/detours/src/*.h")
end

target("steam")
    set_kind("headeronly")
    add_includedirs("Source/ThirdParty/steam/public", {public = true})
    if is_windows_plat() then
        add_linkdirs("Source/ThirdParty/steam/redistributable_bin/win64", {public = true})
        add_links("steam_api64", {public = true})
    else
        add_linkdirs("Source/ThirdParty/steam/redistributable_bin/linux64", {public = true})
        add_links("steam_api", {public = true})
    end

-- ================================================================================================
-- Project targets
-- ================================================================================================

target("Shared")
    set_kind("static")
    apply_common_native_settings()
    apply_project_warning_defines()
    apply_openssl_links()
    add_files(
        "Source/Shared/Core/Crypto/*.cpp",
        "Source/Shared/Core/Network/*.cpp",
        "Source/Shared/Core/Utils/*.cpp",
        "Source/Shared/Game/*.cpp"
    )
    if is_windows_plat() then
        add_files("Source/Shared/Platform/Win32/Win32Platform.cpp")
        add_syslinks("user32", "dbghelp", "rpcrt4")
    else
        add_files("Source/Shared/Platform/Linux/LinuxPlatform.cpp")
        add_syslinks("uuid")
    end
    add_headerfiles("Source/Shared/**/*.h")
    add_includedirs("Source/Shared", "Source", {public = true})
    add_deps("aes_modes", "lib_generic_c", "zlib", "libcurl", "libprotobuf-lite")

target("DarkSouls3")
    set_kind("static")
    apply_common_native_settings()
    apply_project_warning_defines()
    add_files(
        "Source/Server.DarkSouls3/Server/*.cpp",
        "Source/Server.DarkSouls3/Server/GameService/**/*.cpp",
        "Source/Server.DarkSouls3/Protobuf/Generated/*.pb.cc"
    )
    add_headerfiles("Source/Server.DarkSouls3/**/*.h")
    add_includedirs("Source/Server.DarkSouls3", "Source", "Source/Server", {public = true})
    add_deps("Shared", "civetweb", "libprotobuf-lite", "sqlite", "steam")

target("DarkSouls2")
    set_kind("static")
    apply_common_native_settings()
    apply_project_warning_defines()
    add_files(
        "Source/Server.DarkSouls2/Server/*.cpp",
        "Source/Server.DarkSouls2/Server/GameService/**/*.cpp",
        "Source/Server.DarkSouls2/Protobuf/Generated/*.pb.cc"
    )
    add_headerfiles("Source/Server.DarkSouls2/**/*.h")
    add_includedirs("Source/Server.DarkSouls2", "Source", "Source/Server", {public = true})
    add_deps("Shared", "civetweb", "libprotobuf-lite", "sqlite", "steam")

target("Server")
    set_kind("binary")
    apply_common_native_settings()
    apply_project_warning_defines()
    add_files(
        "Source/Server/Entry.cpp",
        "Source/Server/Client/*.cpp",
        "Source/Server/Config/*.cpp",
        "Source/Server/Protobuf/Generated/*.pb.cc",
        "Source/Server/Server/*.cpp",
        "Source/Server/Server/AuthService/*.cpp",
        "Source/Server/Server/Database/*.cpp",
        "Source/Server/Server/GameService/*.cpp",
        "Source/Server/Server/LoginService/*.cpp",
        "Source/Server/Server/Streams/*.cpp",
        "Source/Server/Server/WebUIService/Handlers/*.cpp",
        "Source/Server/Server/WebUIService/*.cpp"
    )
    add_headerfiles("Source/Server/**/*.h")
    add_includedirs("Source/Server", "Source", {public = true})
    add_deps("DarkSouls3", "DarkSouls2", "Shared", "civetweb", "libprotobuf-lite", "sqlite", "steam", "libcurl")

if is_windows_plat() then
    target("Injector")
        set_kind("shared")
        apply_common_native_settings()
        apply_project_warning_defines()
        add_files(
            "Source/Injector/Entry.cpp",
            "Source/Injector/Config/*.cpp",
            "Source/Injector/Injector/*.cpp",
            "Source/Injector/Hooks/*.cpp",
            "Source/Injector/Hooks/DarkSouls3/*.cpp",
            "Source/Injector/Hooks/DarkSouls2/*.cpp",
            "Source/Injector/Hooks/Shared/*.cpp"
        )
        add_headerfiles("Source/Injector/**/*.h")
        add_includedirs("Source/Injector", "Source", {public = true})
        add_deps("Shared", "detours")
end

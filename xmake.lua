-- set minimum xmake version
set_xmakever("2.7.8")

-- set project
set_project("OpenAnimationReplacer-Math")
set_version("1.0.2")
set_license("gplv3")
set_languages("c++20")
set_optimize("faster")
set_warnings("allextra", "error")

-- set allowed
set_allowedarchs("windows|x64")
set_allowedmodes("debug", "releasedbg")

-- set defaults
set_defaultarchs("windows|x64")
set_defaultmode("releasedbg")

-- add rules
add_rules("mode.debug", "mode.releasedbg")
add_rules("plugin.vsxmake.autoupdate")

-- set policies
set_policy("package.requires_lock", true)

-- require packages
add_requires("commonlibsse-ng", "imgui", "rapidjson", "exprtk")

-- targets
target("OpenAnimationReplacer-Math")
    -- add packages to target
    add_packages("fmt", "spdlog", "commonlibsse-ng", "imgui", "rapidjson", "exprtk")

    -- add commonlibsse-ng plugin
    add_rules("@commonlibsse-ng/plugin", {
        name = "OpenAnimationReplacer-Math",
        author = "Ersh",
        description = "SKSE64 plugin adding math statement conditions for Open Animation Replacer"
    })

    -- add src files
    add_files("src/**.cpp")
    add_headerfiles("src/**.h")
    add_includedirs("src")
    set_pcxxheader("src/pch.h")

    -- copy build files to MODS or SKYRIM paths
    after_build(function(target)
        local copy = function(env, ext)
            for _, env in pairs(env:split(";")) do
                if os.exists(env) then
                    local plugins = path.join(env, ext, "SKSE/Plugins")
                    os.mkdir(plugins)
                    os.trycp(target:targetfile(), plugins)
                    os.trycp(target:symbolfile(), plugins)
                end
            end
        end
        if os.getenv("SKYRIM_MODS_PATH") then
            copy(os.getenv("SKYRIM_MODS_PATH"), target:name())
        elseif os.getenv("SKYRIM_PATH") then
            copy(os.getenv("SKYRIM_PATH"), "Data")
        end
    end)

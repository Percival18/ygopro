local ygopro_config=function(static_core)
	if _OPTIONS["pics"] then
		defines { "DEFAULT_PIC_URL=" .. _OPTIONS["pics"] }
	end
	if _OPTIONS["fields"] then
		defines { "DEFAULT_FIELD_URL=" .. _OPTIONS["fields"] }
	end
	if _OPTIONS["discord"] then
		defines { "DISCORD_APP_ID=" .. _OPTIONS["discord"] }
	end
	kind "WindowedApp"
	cppdialect "C++14"
	rtti "Off"
	files { "**.cpp", "**.cc", "**.c", "**.h" }
	excludes "lzma/**"
	defines "CURL_STATICLIB"
	includedirs "../ocgcore"
	links { "clzma", "freetype", "Irrlicht" }
	filter "options:not no-irrklang"
		includedirs "../irrKlang/include"
		defines "YGOPRO_USE_IRRKLANG"
		links "IrrKlang"
		excludes "sound_openal.*"

	filter "system:windows"
		kind "ConsoleApp"
		files "ygopro.rc"
		includedirs { "../freetype/include", "../irrlicht/include" }
		dofile("../irrlicht/defines.lua")
		libdirs "../irrKlang/lib/Win32-visualStudio"
		links { "opengl32", "ws2_32", "winmm", "gdi32", "kernel32", "user32", "imm32", "Wldap32", "Crypt32", "Advapi32", "Rpcrt4", "Ole32", "Winhttp" }

	filter { "system:windows", "options:no-direct3d" }
		defines "NO_IRR_COMPILE_WITH_DIRECT3D_9_"

	filter { "system:windows", "options:not no-direct3d" }
		defines "IRR_COMPILE_WITH_DX9_DEV_PACK"

	filter "system:not windows"
		defines "LUA_COMPAT_5_2"
		buildoptions { "-fpermissive" }
		if _OPTIONS["discord"] then
			links "discord-rpc"
		end
		links { "sqlite3", "event", "event_pthreads", "dl", "pthread", "git2" }

	filter "system:macosx"
		files "*.m"
		defines "LUA_USE_MACOSX"
		buildoptions { "-fms-extensions" }
		includedirs { "/usr/local/include/freetype2", "/usr/local/include/irrlicht" }
		linkoptions { "-Wl,-rpath ./" }
		libdirs "../irrKlang/bin/macosx-gcc/"
		links { "fmt", "curl", "Cocoa.framework", "IOKit.framework", "OpenGL.framework" }
		if static_core then
			links  "lua"
		end

	filter { "system:macosx", "options:no-irrklang" }
		includedirs "/usr/local/opt/openal-soft/include"
		libdirs "/usr/local/opt/openal-soft/lib"
		links { "openal", "mpg123", "sndfile", "vorbis", "vorbisenc", "ogg", "FLAC" }

	filter { "system:linux", "configurations:Debug" }
		links { "fmtd", "curl-d" }

	filter { "system:linux", "configurations:Release" }
		links { "fmt", "curl" }	

	filter "system:linux"
		defines "LUA_USE_LINUX"
		includedirs { "/usr/include/freetype2", "/usr/include/irrlicht" }
		linkoptions { "-Wl,-rpath=./" }
		libdirs "../irrKlang/bin/linux-gcc-64/"
		links { "GL", "X11" }
		if static_core then
			links  "lua:static"
		end
		if _OPTIONS["vcpkg-root"] then
			links { "ssl", "crypto", "z" }
		end
end

include "lzma/."
project "ygopro"
	targetname "ygopro"
	if _OPTIONS["prebuilt-core"] then
		libdirs { _OPTIONS["prebuilt-core"] }
	end
	links { "ocgcore" }
	ygopro_config(true)
		
project "ygoprodll"
	targetname "ygoprodll"
	defines "YGOPRO_BUILD_DLL"
	ygopro_config()	

-- Radiant vendor build script for Catch2 v3 (fork branch radiant/v3.16.1).
-- Upstream ships CMake, Meson and Bazel; this file mirrors src/CMakeLists.txt:
-- one static library from everything under src/catch2 except catch_main.cpp
-- (upstream builds that into a second target, Catch2WithMain; Radiant's test
-- program has its own main), with src as the public include directory.
--
-- src/catch2/catch_user_config.hpp is the one other file this branch adds. CMake
-- generates it from catch_user_config.hpp.in at configure time; here it is committed,
-- with every option at its default: nothing defined, the default reporter "console",
-- the console width 80.

project "Catch2"
	kind "StaticLib"
	language "C++"
	-- The library and the tests that include its headers are compiled under one
	-- standard: Catch2 switches features on by the standard it sees (it asks for C++14).
	cppdialect "C++20"
	staticruntime "off"
	warnings "off"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		"src/catch2/**.hpp",
		"src/catch2/**.cpp"
	}

	removefiles
	{
		"src/catch2/internal/catch_main.cpp"
	}

	includedirs
	{
		"src"
	}

	filter "system:windows"
		systemversion "latest"

	filter "configurations:Debug"
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		runtime "Release"
		optimize "on"

	filter "configurations:Dist"
		runtime "Release"
		optimize "on"
		symbols "off"

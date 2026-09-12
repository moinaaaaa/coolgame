#!/usr/bin/env python
import os
import sys

env = SConscript("godot-cpp/SConstruct")

cpp_dir = "gdextension-cpp/"

lib_name = "coolgame"

includes = []
sources = []

for dir in os.listdir(cpp_dir):
	include = cpp_dir + dir + "/include"
	src = cpp_dir + dir + "/src"
	if os.path.isdir(include):
		print("Found " + dir)
		includes.append(include)
	if os.path.isdir(src):
		sources.append(Glob(src + "/*.cpp"))

env.Append(CPPPATH=includes)
env["CXXFLAGS"]=['/std:c++20']

if env["platform"] == "macos":
    library = env.SharedLibrary(
        "gdextension-cpp/bin/lib{}.{}.{}.framework/lib{}.{}.{}".format(
            lib_name, env["platform"], env["target"], lib_name, env["platform"], env["target"]
        ),
        source=sources,
    )
elif env["platform"] == "ios":
    if env["ios_simulator"]:
        library = env.StaticLibrary(
            "gdextension-cpp/bin/lib{}.{}.{}.simulator.a".format(lib_name, env["platform"], env["target"]),
            source=sources,
        )
    else:
        library = env.StaticLibrary(
            "gdextension-cpp/bin/lib{}.{}.{}.a".format(lib_name, env["platform"], env["target"]),
            source=sources,
        )
else:
    if env["platform"] == "linux":
        env["CXXFLAGS"]=['-std=c++20']
    library = env.SharedLibrary(
        "gdextension-cpp/bin/lib{}{}{}".format(lib_name, env["suffix"], env["SHLIBSUFFIX"]),
        source=sources,
    )

Default(library)
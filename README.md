----
> ⚠️ This is a customized fork of the [Sokol](https://github.com/floooh/sokol) imgui utility library, maintained by [Wake.Tools](https://wake.tools), for integration into the Wake runtime.
----
>🔹 Only the `cimgui utility library` component of this fork is currently used to build the Wake-compatible cimgui.

 While this fork is built and packaged internally for Wake.Tools, it remains compatible with the original Sokol sources and build process.  
 The maintained version is tailored for high stability and deep integration with the Wake environment.

 🛠️ Developers may create functional derivatives of this fork. However, it is **strongly recommended** to stay aligned with the official Wake.Tools version, which is actively maintained and tested for consistent runtime behavior.

 📦 To ensure full compatibility with Wake's module system, dynamic libraries should be built using the following naming convention:  
 `author--name-version-sys-type.ext`
> (e.g., `myrepo--sokolgfx-0.2.0rc1-w32-r.dll`, `myrepo--sokolgfx-0.2.0rc1-osx-d.dylib`, etc.)

 🔄 If your changes could benefit the broader Sokol community, consider submitting pull requests to the upstream repository as well.

 👉 For original sources and full documentation, visit: [Sokol project](https://github.com/floooh/sokol)

----

[![Build](https://github.com/floooh/dcimgui/actions/workflows/build.yml/badge.svg)](https://github.com/floooh/dcimgui/actions/workflows/build.yml)

A version-tagged all-in-one [Dear ImGui](https://github.com/ocornut/imgui)
source distribution repository for C, C++ and Zig coding with:

- regular and docking flavours of Dear ImGui
- C bindings for both flavours (generated with the
  new [dear_bindings](https://github.com/dearimgui/dear_bindings) approach.

The C bindings use the `ig` prefix and cimgui.h/cimgui.cpp filenames to be as
compatible as possible with the 'legacy' cimgui bindings (but please be aware
that there are still significant differences to the legacy cimgui bindings).

The CMakeLists.txt file can be used both from regular cmake projects and
from fips projects (https://floooh.github.io/fips/) and defines two
static link libraries (`imgui` and `imgui-docking`).

NOTE: do not use the `imgui` and `imgui-docking` libraries together in the
same project since this will confuse header search paths.

To use the C API:

- for the regular version: link with `imgui` and include `cimgui.h`
- for the docking version: link with `imgui-docking` and include `cimgui.h`
- NOTE: the cimgui.h header contains duplicate symbol definitions and
  must be compiled in C11 mode.

To use the C++ API:

- for regular version: link with `imgui` and include `imgui.h`
- for the docking version: link with `imgui-docking` and include `imgui.h`

To use the Zig module:

- add a dependency to your build.zig.zon:
    ```
    zig fetch --save=cimgui git+https://github.com/floooh/dcimgui.git
    ```
- ...and see https://github.com/floooh/sokol-zig-imgui-sample/blob/main/build.zig
  for how to integrate the `cimgui` or `cimgui_docking` module with your Zig project

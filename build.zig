// NOTE: unfortunately switching to the 'prefix-less' functions in
// zimgui.h isn't that easy because some Dear ImGui functions collide
// with Win32 function (Set/GetCursorPos and Set/GetWindowPos).
const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const opt_dylib = b.option(bool, "dylib", "Builds sokol_clib as dylib") orelse false;

    var cflags = try std.BoundedArray([]const u8, 64).init(0);
    if (target.result.cpu.arch.isWasm()) {
        // on WASM, switch off UBSAN (zig-cc enables this by default in debug mode)
        // but it requires linking with an ubsan runtime)
        try cflags.append("-fno-sanitize=undefined");
    }
    const lib_cimgui = b.addLibrary(.{
        .name = "cimgui_clib",
        .linkage = switch (opt_dylib) {
            true => .dynamic,
            else => .static,
        },
        .root_module = b.addModule("cimgui_clib", .{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        }),
    });
    lib_cimgui.linkLibCpp();
    lib_cimgui.addCSourceFiles(.{
        .files = &.{
            "src/cimgui.cpp",
            "src/imgui_demo.cpp",
            "src/imgui_draw.cpp",
            "src/imgui_tables.cpp",
            "src/imgui_widgets.cpp",
            "src/imgui.cpp",
        },
        .flags = cflags.slice(),
    });

    // make cimgui available as artifact, this allows to inject
    // the Emscripten sysroot include path in another build.zig
    b.installArtifact(lib_cimgui);

    // translate-c the cimgui.h file
    // NOTE: running this step with the host target is intended to avoid
    // any Emscripten header search path shenanigans
    const translateC = b.addTranslateC(.{
        .root_source_file = b.path("src/cimgui.h"),
        .target = b.graph.host,
        .optimize = optimize,
    });

    // build cimgui as module
    const mod_cimgui = b.addModule("cimgui", .{
        .root_source_file = translateC.getOutput(),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .link_libcpp = true,
    });
    mod_cimgui.linkLibrary(lib_cimgui);
}

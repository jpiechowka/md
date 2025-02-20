const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) void {
    comptime {
        if (builtin.zig_version.minor < 13) @compileError("Zig version >= 0.13.0 is required");
    }

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const enable_logging = b.option(
        bool,
        "enable_logging",
        "Enable logging functionality (default: enabled in Debug, disabled in Release)",
    ) orelse (optimize == .Debug);

    const options = b.addOptions();
    options.addOption(bool, "enable_logging", enable_logging);

    const lib_mod = b.addModule("libmd", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "libmd",
        .root_module = lib_mod,
    });

    lib.root_module.addOptions("build_options", options);

    b.installArtifact(lib);

    const install_docs = b.addInstallDirectory(.{
        .source_dir = lib.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "docs",
    });

    const docs_step = b.step("docs", "Install docs into zig-out/docs");
    docs_step.dependOn(&install_docs.step);

    const lib_unit_tests = b.addTest(.{
        .root_module = lib_mod,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const full_test_step = b.step("test", "Run all unit tests");
    full_test_step.dependOn(&run_lib_unit_tests.step);

    const fmt = b.addFmt(.{
        .check = true,
        .paths = &.{
            "src",
            "build.zig",
        },
    });

    const fmt_step = b.step("fmt", "Run formatting checks");
    fmt_step.dependOn(&fmt.step);
}

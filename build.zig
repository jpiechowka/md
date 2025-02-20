const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) void {
    comptime {
        if (builtin.zig_version.minor < 13) @compileError("Zig version >= 0.13.0 is required");
    }

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib_mod = b.addModule("libmd", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe_mod.addImport("libmd", lib_mod);

    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "libmd",
        .root_module = lib_mod,
    });

    b.installArtifact(lib);

    const exe = b.addExecutable(.{
        .name = "md",
        .root_module = exe_mod,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the executable");
    run_step.dependOn(&run_cmd.step);

    const lib_docs = b.addInstallDirectory(.{
        .source_dir = lib.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "docs",
    });

    const docs_step = b.step("docs", "Generate documentation for the libraries");
    docs_step.dependOn(&lib_docs.step);

    const lib_unit_tests = b.addTest(.{
        .root_module = lib_mod,
    });

    const exe_unit_tests = b.addTest(.{
        .root_module = exe_mod,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);
    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const full_test_step = b.step("test", "Run all unit tests");
    full_test_step.dependOn(&run_lib_unit_tests.step);
    full_test_step.dependOn(&run_exe_unit_tests.step);

    const exe_test_step = b.step("test-exe", "Run executable unit tests only");
    exe_test_step.dependOn(&run_exe_unit_tests.step);

    const libs_test_step = b.step("test-libs", "Run library unit tests only");
    libs_test_step.dependOn(&run_lib_unit_tests.step);

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

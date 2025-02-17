const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) void {
    b.verbose = true;

    comptime {
        if (builtin.zig_version.minor < 13) @compileError(" Zig version >= 0.13.0 is required");
    }

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const enigma_mod = b.createModule(.{
        .root_source_file = b.path("libs/enigma/src/enigma.zig"),
        .target = target,
        .optimize = optimize,
    });

    const shadow_mod = b.createModule(.{
        .root_source_file = b.path("libs/shadow/src/shadow.zig"),
        .target = target,
        .optimize = optimize,
    });

    const syringe_mod = b.createModule(.{
        .root_source_file = b.path("libs/syringe/src/syringe.zig"),
        .target = target,
        .optimize = optimize,
    });

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe_mod.addImport("enigma", enigma_mod);
    exe_mod.addImport("shadow", shadow_mod);
    exe_mod.addImport("syringe", syringe_mod);

    const enigma_lib = b.addLibrary(.{
        .linkage = .static,
        .name = "enigma",
        .root_module = enigma_mod,
    });

    const shadow_lib = b.addLibrary(.{
        .linkage = .static,
        .name = "shadow",
        .root_module = shadow_mod,
    });

    const syringe_lib = b.addLibrary(.{
        .linkage = .static,
        .name = "syringe",
        .root_module = syringe_mod,
    });

    b.installArtifact(enigma_lib);
    b.installArtifact(shadow_lib);
    b.installArtifact(syringe_lib);

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

    const enigma_lib_unit_tests = b.addTest(.{
        .root_module = enigma_mod,
    });

    const shadow_lib_unit_tests = b.addTest(.{
        .root_module = shadow_mod,
    });

    const syringe_lib_unit_tests = b.addTest(.{
        .root_module = syringe_mod,
    });

    const exe_unit_tests = b.addTest(.{
        .root_module = exe_mod,
    });

    const run_enigma_unit_tests = b.addRunArtifact(enigma_lib_unit_tests);
    const run_shadow_unit_tests = b.addRunArtifact(shadow_lib_unit_tests);
    const run_syringe_unit_tests = b.addRunArtifact(syringe_lib_unit_tests);
    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const full_test_step = b.step("test", "Run all unit tests");
    full_test_step.dependOn(&run_enigma_unit_tests.step);
    full_test_step.dependOn(&run_shadow_unit_tests.step);
    full_test_step.dependOn(&run_syringe_unit_tests.step);
    full_test_step.dependOn(&run_exe_unit_tests.step);

    const exe_test_step = b.step("test-exe", "Run executable unit tests only");
    exe_test_step.dependOn(&run_exe_unit_tests.step);

    const libs_test_step = b.step("test-libs", "Run libraries unit tests only");
    libs_test_step.dependOn(&run_enigma_unit_tests.step);
    libs_test_step.dependOn(&run_shadow_unit_tests.step);
    libs_test_step.dependOn(&run_syringe_unit_tests.step);
}

const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "jellyfish",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // const scroll_dependency = b.dependency("scroll", .{});
    const zig_webui = b.dependency("zig-webui", .{
        .target = target,
        .optimize = optimize,
        .enable_tls = false, // whether enable tls support
        .is_static = true, // whether static link
    });

    // add modules
    // exe.root_module.addImport("scroll", scroll_dependency.module("scroll"));
    exe.root_module.addImport("webui", zig_webui.module("webui"));

    b.installArtifact(exe);

    // const archive = b.addSystemCommand(&[_][]const u8{
    //     "scroll",
    //     b.fmt("{s}/bin/ui.jellyfish", .{b.install_path}),
    //     "ui",
    // });

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    // run_cmd.step.dependOn(&archive.step);
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/test/test.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}

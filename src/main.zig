const std = @import("std");
const expect = std.testing.expect;

const lib_enigma = @import("enigma");
const lib_homer = @import("homer");
const lib_shadow = @import("shadow");
const lib_syringe = @import("syringe");

pub fn main() !void {
    lib_homer.info("Enigma: {}", .{lib_enigma.add(1, 2)});
    lib_homer.warn("Shadow: {}", .{lib_shadow.add(3, 4)});
    lib_homer.err("Syringe: {}", .{lib_syringe.add(5, 6)});

    lib_syringe.show_msg_box_winapi_test();
}

test "main test" {
    try expect(lib_enigma.add(1, 2) == 3);
    try expect(lib_shadow.add(3, 4) == 7);
    try expect(lib_syringe.add(5, 6) == 11);
}

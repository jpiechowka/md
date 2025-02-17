const std = @import("std");
const expect = std.testing.expect;

const lib_enigma = @import("enigma");
const lib_shadow = @import("shadow");
const lib_syringe = @import("syringe");

pub fn main() !void {
    std.debug.print("Enigma: {}\n", .{lib_enigma.add(1, 2)});
    std.debug.print("Shadow: {}\n", .{lib_shadow.add(3, 4)});
    std.debug.print("Syringe: {}\n", .{lib_syringe.add(5, 6)});
}

test "main test" {
    try expect(lib_enigma.add(1, 2) == 3);
    try expect(lib_shadow.add(3, 4) == 7);
    try expect(lib_syringe.add(5, 6) == 11);
}

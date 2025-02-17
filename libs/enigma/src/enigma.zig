const std = @import("std");
const expect = std.testing.expect;

pub fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "test add" {
    try expect(add(1, 2) == 3);
    try expect(add(-1, 69) == 68);
    try expect(add(0, 69) == 69);
}

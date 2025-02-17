const std = @import("std");
const windows = std.os.windows;
const expect = std.testing.expect;

pub fn add(a: i32, b: i32) i32 {
    return a + b;
}

pub fn show_msg_box_winapi_test() void {
    _ = MessageBoxA(null, "World!", "Hello", 0);
}

extern "user32" fn MessageBoxA(
    hWnd: ?windows.HWND,
    lpText: ?windows.LPCSTR,
    lpCaption: ?windows.LPCSTR,
    uType: windows.UINT,
) callconv(std.builtin.CallingConvention.winapi) windows.INT;

test "test add" {
    try expect(add(1, 2) == 3);
    try expect(add(-1, 69) == 68);
    try expect(add(0, 69) == 69);
}

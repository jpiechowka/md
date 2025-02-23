const std = @import("std");
const windows = std.os.windows;

const log = @import("log.zig");

/// Test to call WinAPI MessageBoxA
pub fn show_msg_box_winapi_test() void {
    log.debug("Calling MessageBoxA WinAPI func", .{});
    _ = MessageBoxA(null, "World!", "Hello", 0);
}

extern "user32" fn MessageBoxA(
    hWnd: ?windows.HWND,
    lpText: ?windows.LPCSTR,
    lpCaption: ?windows.LPCSTR,
    uType: windows.UINT,
) callconv(std.builtin.CallingConvention.winapi) windows.INT;

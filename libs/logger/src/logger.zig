const std = @import("std");

/// Logs debug level message using std.log
pub fn debug(
    comptime format: []const u8,
    args: anytype,
) void {
    std.log.debug(format, args);
}

/// Logs info level message using std.log
pub fn info(
    comptime format: []const u8,
    args: anytype,
) void {
    std.log.info(format, args);
}

/// Logs warning level message using std.log
pub fn warn(
    comptime format: []const u8,
    args: anytype,
) void {
    std.log.warn(format, args);
}

/// Logs error level message using std.log
pub fn err(
    comptime format: []const u8,
    args: anytype,
) void {
    std.log.err(format, args);
}

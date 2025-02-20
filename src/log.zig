const std = @import("std");
const build_options = @import("build_options");

/// Check if logging is enabled via build option
const is_logging_enabled = build_options.enable_logging;

/// Log debug level message using std.log.debug
pub fn debug(comptime format: []const u8, args: anytype) void {
    if (comptime is_logging_enabled) {
        std.log.debug(format, args);
    }
}

/// Log info level message using std.log.info
pub fn info(comptime format: []const u8, args: anytype) void {
    if (comptime is_logging_enabled) {
        std.log.info(format, args);
    }
}

/// Log warn level message using std.log.warn
pub fn warn(comptime format: []const u8, args: anytype) void {
    if (comptime is_logging_enabled) {
        std.log.warn(format, args);
    }
}

/// Log error level message using std.log.err
pub fn err(comptime format: []const u8, args: anytype) void {
    if (comptime is_logging_enabled) {
        std.log.err(format, args);
    }
}

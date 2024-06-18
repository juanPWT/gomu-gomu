const ANSI_COLOR = struct {
    balck: []const u8 = "\x1b[0;30m",
    red: []const u8 = "\x1b[0;31m",
    green: []const u8 = "\x1b[0;32m",
    blue: []const u8 = "\x1b[0;34m",
    yellow: []const u8 = "\x1b[0;33m",
    purple: []const u8 = "\x1b[0;35m",
    cyan: []const u8 = "\x1b[0;36m",
    white: []const u8 = "\x1b[0;37m",
};

pub const ANSI_RESET: []const u8 = "\x1b[0m";

pub fn ansiColor() *const ANSI_COLOR {
    return &ANSI_COLOR{};
}

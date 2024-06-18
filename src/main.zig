const std = @import("std");
const service = @import("service.zig");
const print = std.debug.print;

const Command = struct {
    start: []const u8 = "start",
    help: []const u8 = "help",
    quit: []const u8 = "quit",
};

pub fn main() !void {
    // args
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        print("usage: {s} <command>", .{args[0]});
        std.process.exit(1);
    }

    // condition args
    const cmd = args[1];
    const cmdPatern = Command{};

    if (std.mem.eql(u8, cmd, cmdPatern.start)) {
        try start(cmdPatern);
    } else if (std.mem.eql(u8, cmd, cmdPatern.help)) {
        print(
            \\ +---------------------------------------------+
            \\ |   list command gomu-gomu:                   |
            \\ |                                             |
            \\ |   start          for start a game           |
            \\ |   help           here                       |
            \\ |                                             |
            \\ +---------------------------------------------+
        , .{});
        std.process.exit(1);
    } else {
        print("command {s} not found", .{cmd});
        std.process.exit(1);
    }
}

fn start(cmdPatern: Command) !void {
    const stdin = std.io.getStdIn().reader();
    var line: [256]u8 = undefined;

    // TODO: randword execute again when input == randWord
    // else randword not execute until input == randWord;
    var randWord: []const u8 = service.generateWord();

    while (true) {
        print("run quit for exit!\n", .{});
        print("try : {s}\n", .{randWord});
        print("your: ", .{});
        const meybeLine = try nextLine(stdin, &line);

        if (meybeLine == null) {
            break;
        }

        const input = std.mem.trim(u8, meybeLine.?, " \n");

        if (std.mem.eql(u8, input, cmdPatern.quit)) {
            print("EXITING...", .{});
            break;
        }

        if (std.mem.eql(u8, randWord, input)) {
            print("YES\n", .{});
            randWord = service.generateWord();
        } else {
            print("!WRONG\n", .{});
        }
    }
}

fn nextLine(reader: anytype, buffer: []u8) !?[]const u8 {
    const line = (try reader.readUntilDelimiterOrEof(buffer, '\n')) orelse return null;

    if (@import("builtin").os.tag == .windows) {
        return std.mem.trimRight(u8, line, "\r");
    } else {
        return line;
    }
}

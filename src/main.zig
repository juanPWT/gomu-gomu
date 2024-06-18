const std = @import("std");
const service = @import("service.zig");
const print = std.debug.print;

var TIME_LIMIT: u16 = 0;

const TimeMode = struct {
    easy: []const u8 = "easy", // 60000
    medium: []const u8 = "medium", // 30000
    hard: []const u8 = "hard", //10000
};

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
        if (args.len < 3) {
            print("usage-start: {s} start <mode>", .{args[0]});
            std.process.exit(1);
        }

        const cmdStartTime = args[2];
        const timeMode = TimeMode{};
        // time mode
        if (cmdStartTime.len != 0) {
            if (std.mem.eql(u8, cmdStartTime, timeMode.easy)) {
                TIME_LIMIT = TIME_LIMIT;
            } else if (std.mem.eql(u8, cmdStartTime, timeMode.medium)) {
                TIME_LIMIT = 30000;
            } else if (std.mem.eql(u8, cmdStartTime, timeMode.hard)) {
                TIME_LIMIT = 10000;
            } else {
                print("mode {s} not exist!", .{cmdStartTime});
            }
        }

        try start(cmdPatern);
    } else if (std.mem.eql(u8, cmd, cmdPatern.help)) {
        print(
            \\ +---------------------------------------------+
            \\ |   list command gomu-gomu:                   |
            \\ |                                             |
            \\ |   start <mode>   for start a game           |
            \\ |   help           here                       |
            \\ |                                             |
            \\ |   game mode:                                |
            \\ |                                             |
            \\ |   usage: gomu-gomu start <mode>             |
            \\ |   mode :                                    |
            \\ |   easy         [60s],                       |
            \\ |   medium       [30s],                       |
            \\ |   hard         [10s],                       |
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

    var randWord: []const u8 = service.generateWord();
    var wordTotal: u8 = 0;

    const startTime = std.time.milliTimestamp();

    while (true) {
        // init time
        const currentTime = std.time.milliTimestamp();
        const elapsedTime = currentTime - startTime;
        if (elapsedTime >= TIME_LIMIT) {
            print(
                \\   +----------------------------------------------+
                \\          time       :  {}ms                   
                \\          word total :  {}                        
                \\   +______________________________________________+
            , .{ TIME_LIMIT, wordTotal });
            break;
        }

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
            wordTotal += 1;
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

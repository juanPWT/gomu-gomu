const std = @import("std");

const words = [_][]const u8{
    "fn",
    "[]u8",
    "[]const",
    "func",
    "git",
    "pull",
    "string",
    "int",
    "enum",
    "struct",
    "pub",
    "console",
    "go",
    "zig",
    "javascript",
    "html",
    "php",
    "c/c++",
    "rust",
    "ocaml",
    "function",
    "parameter",
    "return",
    "pub",
    "push",
    "interface",
    "typeof",
    "main.zig",
    "main.go",
    "index.js",
    "interval",
    "nvim",
    "one-dark-pro",
    "std",
    "allocate",
    "allocator",
    "mem",
    "float",
    "bolean",
    "bool",
};

pub fn generateWord() []const u8 {
    var rng = std.crypto.random;
    const i = rng.intRangeAtMost(u8, 0, words.len);
    return words[i];
}

test "generateWord returns a valid word" {
    const word = generateWord();
    var found = false;
    for (words) |w| {
        if (std.mem.eql(u8, word, w)) {
            found = true;
            break;
        }
    }
    try std.testing.expect(found);
}

test "generateWord returns different words" {
    const word1 = generateWord();
    const word2 = generateWord();
    try std.testing.expect(!std.mem.eql(u8, word1, word2));
}

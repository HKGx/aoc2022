const std = @import("std");

const RPS = enum(u2) { rock, paper, scissors };

fn score(your_choice: RPS, opponents_choice: RPS) u4 {
    // first row is your choice, first column is opponents choice
    //         rock    paper   scissor
    // rock    1 + 3   2 + 6   3 + 0
    // paper   1 + 0   2 + 3   3 + 6
    // scissor 1 + 6   2 + 0   3 + 3

    const table = [_][3]u4{
        [_]u4{ 4, 8, 3 },
        [_]u4{ 1, 5, 9 },
        [_]u4{ 7, 2, 6 },
    };
    return table[@enumToInt(opponents_choice)][@enumToInt(your_choice)];
}

fn part1(content: []u8) u64 {
    var current_score: u64 = 0;
    var lines = std.mem.split(u8, content, "\n");
    while (lines.next()) |line| {
        var words = std.mem.split(u8, line, " ");
        const first_word_char = words.next().?[0];
        const second_word_char = words.next().?[0];
        const opponents_choice = switch (first_word_char) {
            'A' => RPS.rock,
            'B' => RPS.paper,
            'C' => RPS.scissors,
            else => unreachable,
        };
        const your_choice = switch (second_word_char) {
            'X' => RPS.rock,
            'Y' => RPS.paper,
            'Z' => RPS.scissors,
            else => unreachable,
        };
        current_score += score(your_choice, opponents_choice);
    }
    return current_score;
}

fn beating_choice(choice: RPS) RPS {
    return switch (choice) {
        RPS.rock => RPS.paper,
        RPS.paper => RPS.scissors,
        RPS.scissors => RPS.rock,
    };
}

fn losing_choice(choice: RPS) RPS {
    return switch (choice) {
        RPS.rock => RPS.scissors,
        RPS.paper => RPS.rock,
        RPS.scissors => RPS.paper,
    };
}

fn drawing_choice(choice: RPS) RPS {
    return choice;
}

fn part2(content: []u8) u64 {
    var current_score: u64 = 0;
    var lines = std.mem.split(u8, content, "\n");
    while (lines.next()) |line| {
        var words = std.mem.split(u8, line, " ");
        const first_word_char = words.next().?[0];
        const second_word_char = words.next().?[0];
        const opponents_choice = switch (first_word_char) {
            'A' => RPS.rock,
            'B' => RPS.paper,
            'C' => RPS.scissors,
            else => unreachable,
        };
        // X is a lose, Y is a draw, Z is a win
        const your_choice = switch (second_word_char) {
            'X' => losing_choice(opponents_choice),
            'Y' => drawing_choice(opponents_choice),
            'Z' => beating_choice(opponents_choice),
            else => unreachable,
        };
        current_score += score(your_choice, opponents_choice);
    }
    return current_score;
}
pub fn main() !void {
    const file = try std.fs.cwd().openFile("inputs/day2.txt", .{ .mode = std.fs.File.OpenMode.read_only });
    defer file.close();

    const allocator = std.heap.page_allocator;
    const stat = try file.stat();
    const content = try file.reader().readAllAlloc(allocator, stat.size);

    defer allocator.free(content);

    const part1_score = part1(content);
    const part2_score = part2(content);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("part 1 score: {d}\npart 2 score: {d}", .{ part1_score, part2_score });
}

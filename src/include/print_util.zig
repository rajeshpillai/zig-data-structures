const std = @import("std");

pub fn printArray(comptime T: type, nums: []T) void {
    std.debug.print("[", .{});
    if (nums.len > 0) {
        for (nums, 0..) |num, j| {
            std.debug.print("{}{s}", .{ num, if (j == nums.len - 1) "]" else ", " });
        }
    } else {
        std.debug.print("]", .{});
    }
}

pub fn printList(comptime T: type, list: std.ArrayList(T)) void {
    std.debug.print("[", .{});
    if (list.items.len > 0) {
        for (list.items, 0..) |value, i| {
            std.debug.print("{}{s}", .{ value, if (i == list.items.len - 1) "]" else ", " });
        }
    } else {
        std.debug.print("]", .{});
    }
}

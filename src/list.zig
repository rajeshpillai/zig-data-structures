const std = @import("std");
const util  = @import("include/print_util.zig");

pub fn main() !void {
    var list = std.ArrayList(i32).init(std.heap.page_allocator);

    defer list.deinit();

    try list.appendSlice(&[_]i32{ 1, 2, 4, 3, 5 });

    std.debug.print("list = ", .{});
    util.printList(i32, list);

    const num  = list.items[1];
    std.debug.print("\n 1 num = {}", .{num});

    list.items[1] = 0;
    std.debug.print("\n 1 -> 0, list = ", .{});
    util.printList(i32, list);

    list.clearRetainingCapacity();
    std.debug.print("\n list = ", .{});
    util.printList(i32, list);

    try list.append(1);
    try list.append(3);
    try list.append(4);
    try list.append(7);

    std.debug.print("\n list = ", .{});
    util.printList(i32, list);

    try list.insert(3,6);
    std.debug.print("\n3 -> 6, list = ", .{});
    util.printList(i32, list);
    
    // Remove
    _ = list.orderedRemove(3);
    std.debug.print("\n3, list ", .{});
    util.printList(i32, list);

    // Loops
    var count: i32 = 0;
    var i: i32 = 0;
    while (i < list.items.len) :(i += 1) {
      count += 1;
    }

    count = 0;
    for (list.items) |_| {
      count += 1;
    }

    var list1 = std.ArrayList(i32).init(std.heap.page_allocator);
    defer list1.deinit();
    
    try list1.appendSlice(&[_]i32{6,2,8,9,10});
    try list.insertSlice(list.items.len, list1.items);
    
    std.debug.print("\n list1 ------- list ----------- list  = ", .{});
    util.printList(i32, list);

    // Sort
    std.mem.sort(i32, list.items, {}, comptime std.sort.asc(i32));
    std.debug.print("\n list = ", .{});
    util.printList(i32, list);

    // _ = try std.io.getStdIn().reader().readByte();

}

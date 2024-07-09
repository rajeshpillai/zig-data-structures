const std = @import("std");
const util  = @import("include/print_util.zig");

pub fn MyList(comptime T: type) type {
  return struct {
    const Self = @This();

    nums: []T = undefined,
    numsCapacity: usize = 10,
    numSize: usize = 0,
    extendRatio: usize = 2,
    mem_arena: ?std.heap.ArenaAllocator = null,
    mem_allocator: std.mem.Allocator = undefined,

    pub fn init(self: *Self, allocator: std.mem.Allocator) !void {
      if (self.mem_arena == null) {
        self.mem_arena = std.heap.ArenaAllocator.init(allocator);
        self.mem_allocator = self.mem_arena.?.allocator();
      }
      self.nums = try self.mem_allocator.alloc(T, self.numsCapacity);
      @memset(self.nums, @as(T, 0));
    }
    
    pub fn deinit(self: *Self) void {
      if (self.mem_arena == null) return;
      self.mem_arena.?.deinit();
    }

    pub fn size(self: *Self) usize {
      return self.numSize;
    }

    pub fn capacity(self: *Self) usize {
      return self.numsCapacity;
    }

    pub fn get(self: *Self, index: usize) T {
      if (index < 0 or index >= self.size()) @panic("Size error");
      return self.nums[index];
    }
 
    pub fn set(self: *Self, index: usize, num: T) void {
      if (index < 0 or index >= self.size()) @panic("Index out of bounds");
      self.nums[index] = num;
    }

    pub fn add(self: *Self, num: T) !void {
      if (self.size() == self.capacity()) try self.extendCapacity();
      self.nums[self.size()] = num;
      self.numSize += 1;
    }

    pub fn insert(self: *Self, index: usize, num: T) !void {
      if (index < 0 or index >= self.size()) @panic ("Invalid index");
      if (self.size() == self.capacity()) try self.extendCapacity();
      var j = self.size() - 1;
      while(j >= index) : (j -= 1) {
        self.nums[j + 1] = self.nums[j];
      }
      self.nums[index] = num;
      self.numSize += 1;
    }

    // remove
    pub fn remove(self: *Self, index: usize) T {
      if (index < 0 or index >= self.size()) @panic("Index out of bounds");
      const num = self.nums[index];

      var j = index;
      while(j < self.size() - 1) : (j += 1) {
        self.nums[j] = self.nums[j + 1];
      }
      self.numSize  -= 1;
      return num;
    }

    // Extend capacity
    pub fn extendCapacity(self: *Self) !void {
      const newCapacity = self.capacity() * self.extendRatio;
      const extend = try self.mem_allocator.alloc(T, newCapacity);
      @memset(extend, @as(T, 0));

      //std.mem.copy(T, extend, self.nums);
      std.mem.copyForwards(T, extend, self.nums);
      self.nums = extend;

      self.numsCapacity = newCapacity;
    }

    // toArray
    pub fn toArray(self: *Self) ![]T {
      const nums = try self.mem_allocator.alloc(T, self.size());
      @memset(nums, @as(T,0));
      for (nums, 0..) |*num, i| {
        num.* = self.get(i);
      }
      return nums;
    }
  };
}

pub fn main() !void {
  var list = MyList(i32){};
  try list.init(std.heap.page_allocator);

  defer list.deinit();

  try list.add(1);
  try list.add(2);
  try list.add(3);
  try list.add(4);

  std.debug.print("list = ", .{});
  util.printArray(i32, try list.toArray());
  std.debug.print("Capacity = {}, Size = {}", .{list.capacity(), list.size()});

  try list.insert(3, 6);
  std.debug.print("\n list = ", .{});
  util.printArray(i32, try list.toArray());

  _ = list.remove(3);
  std.debug.print("\n 3 list = ", .{});
  util.printArray(i32, try list.toArray());

  const num = list.get(1);
  std.debug.print("\n 1 , num = {}", .{num});

  list.set(1, 0);
  std.debug.print("\n 1 0 ,list = ", .{});
  util.printArray(i32, try list.toArray());

  var i: i32 = 0;
  while (i < 10) : (i += 1) {
    try list.add(i);
  }
    std.debug.print("\nlist = ", .{});
    util.printArray(i32, try list.toArray());
    std.debug.print(" ，capacity = {} , size = {}\n", .{list.capacity(), list.size()});

   // _ = try std.io.getStdIn().reader().readByte();
}

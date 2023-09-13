pub const RCC_APB2PCENR = @as(*volatile u32, @ptrFromInt(0x40021018));
pub const GPIOA_CFGHR = @as(*volatile u32, @ptrFromInt(0x40010804));
pub const GPIOA_OUTDR = @as(*volatile u16, @ptrFromInt(0x4001080C));

export fn main() void {
    RCC_APB2PCENR.* |= @as(u32, 1 << 2); // Enable PA clk
    GPIOA_CFGHR.* &= ~@as(u32, 0b1111 << 4); // Clear all bits for PA9
    GPIOA_CFGHR.* |= @as(u32, 0b0011 << 4); // Set push-pull output for PA9

    while (true) {
        var i: u32 = 0;
        GPIOA_OUTDR.* ^= @as(u16, 1 << 9); // Toggle PA9
        while (i < 100_000) { // busy wait
            i += 1;
        }
    }
}

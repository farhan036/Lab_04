module align_mantissa (
    input  [23:0] small_mantissa,
    input  [7:0]  big_exp,
    input  [7:0]  small_exp,
    output [24:0] shifted_small_mantissa,
    output        sticky
);
    wire [7:0] exp_diff = big_exp - small_exp;
    wire [24:0] shifted = {1'b0, small_mantissa} >> exp_diff;
    assign shifted_small_mantissa = shifted;
 // Sticky bit for rounding i searching it
    wire [23:0] small_mantissa_masked = small_mantissa & ((1 << exp_diff) - 1);
    assign sticky = |small_mantissa_masked;
endmodule
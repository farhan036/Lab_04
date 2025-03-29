module round (
    input  [23:0] normalized_mantissa,
    input  [7:0]  normalized_exp,
    input         sticky,
    output [23:0] final_mantissa,
    output [7:0]  final_exponent
);
    wire LSB_mantissa = normalized_mantissa[0];
    wire round_bit = 0;
    wire round_up = LSB_mantissa & (sticky | round_bit);
    wire [24:0] rounded_mantissa = {1'b0, normalized_mantissa} + round_up;
// Normalization after rounding
    assign final_mantissa = rounded_mantissa[24] ? rounded_mantissa[24:1] : rounded_mantissa[23:0];
    assign final_exponent = rounded_mantissa[24] ? (normalized_exp + 8'd1) : normalized_exp;
endmodule
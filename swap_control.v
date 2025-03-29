module swap_op_decision (
    input        sign_x,
    input        sign_y,
    input  [7:0] exp_x,
    input  [7:0] exp_y,
    input  [23:0] mantissa_x,
    input  [23:0] mantissa_y,
    output       swap,
    output       do_subtract,
    output [23:0] big_mantissa,
    output [23:0] small_mantissa,
    output [7:0]  big_exp,
    output [7:0]  small_exp,
    output        sign_big
);
    assign do_subtract = sign_x ^ sign_y;
    assign swap = (exp_x < exp_y) || ((exp_x == exp_y) && (mantissa_x < mantissa_y));
    assign sign_big = swap ? sign_y : sign_x;
    assign big_mantissa = swap ? mantissa_y : mantissa_x;
    assign small_mantissa = swap ? mantissa_x : mantissa_y;
    assign big_exp = swap ? exp_y : exp_x;
    assign small_exp = swap ? exp_x : exp_y;
endmodule
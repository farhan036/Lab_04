module floating (
    input  [31:0] x,
    input  [31:0] y,
    output [31:0] result,
    input         clk
);
    wire sign_x, sign_y;
    wire [7:0] exp_x, exp_y;
    wire [23:0] mantissa_x, mantissa_y;

    unpack unpack_x (.float(x), .sign(sign_x), .exp(exp_x), .mantissa(mantissa_x));
    unpack unpack_y (.float(y), .sign(sign_y), .exp(exp_y), .mantissa(mantissa_y));

    wire swap, do_subtract;
    wire [23:0] big_mantissa, small_mantissa;
    wire [7:0] big_exp, small_exp;
    wire sign_big;

    swap_op_decision swap_op (
        .sign_x(sign_x),
        .sign_y(sign_y),
        .exp_x(exp_x),
        .exp_y(exp_y),
        .mantissa_x(mantissa_x),
        .mantissa_y(mantissa_y),
        .swap(swap),
        .do_subtract(do_subtract),
        .big_mantissa(big_mantissa),
        .small_mantissa(small_mantissa),
        .big_exp(big_exp),
        .small_exp(small_exp),
        .sign_big(sign_big)
    );

    wire result_is_nan, result_is_inf, result_sign_special;
    wire x_is_zero, y_is_zero;

    special_case_detector special_detect (
        .exp_x(exp_x),
        .exp_y(exp_y),
        .mantissa_x(mantissa_x),
        .mantissa_y(mantissa_y),
        .sign_x(sign_x),
        .sign_y(sign_y),
        .swap(swap),
        .do_subtract(do_subtract),
        .result_is_nan(result_is_nan),
        .result_is_inf(result_is_inf),
        .result_sign_special(result_sign_special),
        .x_is_zero(x_is_zero),
        .y_is_zero(y_is_zero)
    );

    wire [24:0] shifted_small_mantissa;
    wire sticky;

    align_mantissa align (
        .small_mantissa(small_mantissa),
        .big_exp(big_exp),
        .small_exp(small_exp),
        .shifted_small_mantissa(shifted_small_mantissa),
        .sticky(sticky)
    );

    wire [24:0] result_mantissa;

    add_sub addsub (
        .big_mantissa(big_mantissa),
        .shifted_small_mantissa(shifted_small_mantissa),
        .do_subtract(do_subtract),
        .result_mantissa(result_mantissa)
    );

    wire [7:0] normalized_exp;
    wire [23:0] normalized_mantissa;

    normalize norm (
        .clk(clk),
        .result_mantissa(result_mantissa),
        .do_subtract(do_subtract),
        .big_exp(big_exp),
        .normalized_exp(normalized_exp),
        .normalized_mantissa(normalized_mantissa)
    );

    wire [7:0] final_exponent;
    wire [23:0] final_mantissa;

    round round (
        .normalized_mantissa(normalized_mantissa),
        .normalized_exp(normalized_exp),
        .sticky(sticky),
        .final_mantissa(final_mantissa),
        .final_exponent(final_exponent)
    );

    result_packer pack (
        .result_is_nan(result_is_nan),
        .result_is_inf(result_is_inf),
        .result_sign_special(result_sign_special),
        .x_is_zero(x_is_zero),
        .y_is_zero(y_is_zero),
        .do_subtract(do_subtract),
        .sign_big(sign_big),
        .final_exponent(final_exponent),
        .final_mantissa(final_mantissa),
        .final_result(result)
    );

endmodule
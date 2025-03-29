module special_case_detector (
    input  [7:0]  exp_x,
    input  [7:0]  exp_y,
    input  [23:0] mantissa_x,
    input  [23:0] mantissa_y,
    input         sign_x,
    input         sign_y,
    input         swap,
    input         do_subtract,
    output        result_is_nan,
    output        result_is_inf,
    output        result_sign_special,
    output        x_is_zero,
    output        y_is_zero
);
    wire x_is_nan = (exp_x == 8'hFF) && (|mantissa_x[22:0]); // NaN if exp=255 & mantissa≠0
    wire y_is_nan = (exp_y == 8'hFF) && (|mantissa_y[22:0]); // Inf if exp=255 & mantissa=0
    wire x_is_inf = (exp_x == 8'hFF) && (mantissa_x[22:0] == 0);
    wire y_is_inf = (exp_y == 8'hFF) && (mantissa_y[22:0] == 0);
    assign x_is_zero = (exp_x == 8'h00) && (mantissa_x[22:0] == 0); // Zero if exp=0 & mantissa=0
    assign y_is_zero = (exp_y == 8'h00) && (mantissa_y[22:0] == 0);

    assign result_is_nan = x_is_nan || y_is_nan || (x_is_inf && y_is_inf && do_subtract); // Any input is NaN // Inf - Inf = NaN
    assign result_is_inf = (x_is_inf || y_is_inf) && !(x_is_inf && y_is_inf && do_subtract); // At least one is Inf // Unless Inf-Inf

    assign result_sign_special = 
        (x_is_nan || y_is_nan) ? 1'b0 : // NaN is positive
        (x_is_inf && !y_is_inf) ? sign_x :  // Inf + num = Inf(sign_x)
        (y_is_inf && !x_is_inf) ? (swap ? sign_x : sign_y) : // num + Inf
        (sign_x ^ do_subtract); // Inf + Inf or Inf - Inf
endmodule
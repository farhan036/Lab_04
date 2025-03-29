module result_packer (
    input         result_is_nan,
    input         result_is_inf,
    input         result_sign_special,
    input         x_is_zero,
    input         y_is_zero,
    input         do_subtract,
    input         sign_big,
    input  [7:0]  final_exponent,
    input  [23:0] final_mantissa,
    output [31:0] final_result
);
    reg [31:0] final_result_reg;

    always @(*) begin
        if (result_is_nan) begin
            final_result_reg = 32'h7FC00000;
        end else if (result_is_inf) begin
            final_result_reg = {result_sign_special, 8'hFF, 23'h000000};
        end else if (x_is_zero && y_is_zero) begin
            final_result_reg = do_subtract ? {sign_big ^ 1'b1, 31'h0} : {sign_big, 31'h0};
        end else begin
            final_result_reg = {sign_big, final_exponent, final_mantissa[22:0]}; //concatenate
        end
    end

    assign final_result = final_result_reg;
endmodule
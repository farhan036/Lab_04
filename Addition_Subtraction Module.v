module add_sub (
    input  [23:0] big_mantissa,
    input  [24:0] shifted_small_mantissa,
    input         do_subtract,
    output [24:0] result_mantissa
);
    reg [24:0] result_mantissa_reg;

    always @(*) begin
        if (do_subtract)
            result_mantissa_reg = {1'b0, big_mantissa} - shifted_small_mantissa;
        else
            result_mantissa_reg = {1'b0, big_mantissa} + shifted_small_mantissa;
    end

    assign result_mantissa = result_mantissa_reg;
endmodule
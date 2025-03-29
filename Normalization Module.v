module normalize (
    input         clk, //using clocked logic instead of a while loop
    input  [24:0] result_mantissa,
    input         do_subtract,
    input  [7:0]  big_exp,
    output reg [7:0]  normalized_exp,
    output reg [23:0] normalized_mantissa
);
    reg [4:0] shift_reg; // Counter to replace the while loop (5 bits can count up to 24)
    reg [23:0] mantissa_reg;

    always @(posedge clk) begin
        if (result_mantissa == 0) begin
            normalized_exp <= 0;
            normalized_mantissa <= 0;
            shift_reg <= 0;
        end else if (do_subtract) begin // Subtraction: Normalize by shifting left
            if (shift_reg < 24 && result_mantissa[23 - shift_reg] == 0) begin
                shift_reg <= shift_reg + 1;
            end else begin
                normalized_mantissa <= result_mantissa[23:0] << shift_reg;
                normalized_exp <= big_exp - shift_reg;
                shift_reg <= 0;
            end
        end else begin // Addition: Check for overflow
            if (result_mantissa[24]) begin
                normalized_mantissa <= result_mantissa[24:1];
                normalized_exp <= big_exp + 1;
            end else begin
                normalized_mantissa <= result_mantissa[23:0];
                normalized_exp <= big_exp;
            end
            shift_reg <= 0;
        end
    end
endmodule
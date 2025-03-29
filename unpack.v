module unpack (
    input  [31:0] float,
    output        sign,
    output [7:0]  exp,
    output [23:0] mantissa
);
    assign sign = float[31];
    assign exp = float[30:23];
    assign mantissa = (exp == 0) ? {1'b0, float[22:0]} : {1'b1, float[22:0]};
endmodule
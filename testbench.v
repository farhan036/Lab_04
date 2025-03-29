module tb_floating;

    reg [31:0] x;
    reg [31:0] y;
    reg clk;
    wire [31:0] result;

    // Instantiate the floating-point adder
    floating uut (
        .x(x),
        .y(y),
        .result(result),
        .clk(clk)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // 10ns period
    end

    // Test cases
    initial begin
        // Initialize the clock
        clk = 0;

        // Test 1: Normal addition (1.0 + 2.0)
        x = 32'h3F800000; // 1.0
        y = 32'h40000000; // 2.0
        #10;
        $display("Test 1 (1.0 + 2.0) result: %h", result);

        // Test 2: Normal subtraction (2.0 - 1.0)
        x = 32'h40000000; // 2.0
        y = 32'h3F800000; // 1.0
        #10;
        $display("Test 2 (2.0 - 1.0) result: %h", result);

        // Test 3: Adding zero to a number (0.0 + 2.0)
        x = 32'h00000000; // 0.0
        y = 32'h40000000; // 2.0
        #10;
        $display("Test 3 (0.0 + 2.0) result: %h", result);

        // Test 4: Subtracting zero from a number (2.0 - 0.0)
        x = 32'h40000000; // 2.0
        y = 32'h00000000; // 0.0
        #10;
        $display("Test 4 (2.0 - 0.0) result: %h", result);

        // Test 5: Adding infinity and a number (Inf + 2.0)
        x = 32'h7F800000; // +Inf
        y = 32'h40000000; // 2.0
        #10;
        $display("Test 5 (Inf + 2.0) result: %h", result);

        // Test 6: Subtracting infinity and a number (Inf - 2.0)
        x = 32'h7F800000; // +Inf
        y = 32'h40000000; // 2.0
        #10;
        $display("Test 6 (Inf - 2.0) result: %h", result);

        // Test 7: Infinity minus infinity (Inf - Inf)
        x = 32'h7F800000; // +Inf
        y = 32'h7F800000; // +Inf
        #10;
        $display("Test 7 (Inf - Inf) result: %h", result);

        // Test 8: Adding two large numbers (1e10 + 1e10)
        x = 32'h4C6F1C00; // 1e10 in IEEE 754 single precision
        y = 32'h4C6F1C00; // 1e10 in IEEE 754 single precision
        #10;
        $display("Test 8 (1e10 + 1e10) result: %h", result);

        // Test 9: NaN propagation (NaN + 1.0)
        x = 32'h7FC00000; // NaN
        y = 32'h3F800000; // 1.0
        #10;
        $display("Test 9 (NaN + 1.0) result: %h", result);

        // Test 10: Adding subnormal numbers (subnormal + subnormal)
        x = 32'h00000001; // Smallest positive subnormal
        y = 32'h00000001; // Smallest positive subnormal
        #10;
        $display("Test 10 (subnormal + subnormal) result: %h", result);

        // Test 11: Subnormal + normal number (subnormal + 1.0)
        x = 32'h00000001; // Smallest positive subnormal
        y = 32'h3F800000; // 1.0
        #10;
        $display("Test 11 (subnormal + 1.0) result: %h", result);

        // Test 12: Handling rounding (1.5 + 2.5)
        x = 32'h3FC00000; // 1.5
        y = 32'h40200000; // 2.5
        #10;
        $display("Test 12 (1.5 + 2.5) result: %h", result);

        // Test 13: Denormalized number plus normal number (Denorm + Norm)
        x = 32'h00000001; // Smallest denormalized number
        y = 32'h3F800000; // Normal number 1.0
        #10;
        $display("Test 13 (Denormalized + Normal) result: %h", result);

        // Test 14: Subtracting large numbers (1e10 - 1e10)
        x = 32'h4C6F1C00; // 1e10 in IEEE 754 single precision
        y = 32'h4C6F1C00; // 1e10 in IEEE 754 single precision
        #10;
        $display("Test 14 (1e10 - 1e10) result: %h", result);

        // End of tests
        $finish;
    end

endmodule
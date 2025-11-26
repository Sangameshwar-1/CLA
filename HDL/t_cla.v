`timescale 1ns/1ps

module t_cla;
    reg  [4:0] a;
    reg  [4:0] b;
    reg        cin;
    wire [4:0] sum;
    wire       cout;

    // Instantiate the DUT (Device Under Test)
    cla_5bit dut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    // Expected result - separated for GTKWave
    reg [5:0] expected;
    reg [5:0] calculated;
    reg [4:0] expected_sum;   // Separate expected sum for waveform
    reg       expected_cout;   // Separate expected cout for waveform
    integer errors;
    integer test_num;
    integer i, j;

    // Generate waveform dump - MUST BE FIRST
    initial begin
        $dumpfile("cla_5bit.vcd");
        $dumpvars(0, t_cla);
    end

    initial begin
        $display("================================================================");
        $display("  5-BIT CARRY LOOKAHEAD ADDER - EXHAUSTIVE TEST SUITE");
        $display("  Testing ALL combinations with Cin=0: 32 x 32 = 1024 tests");
        $display("  Gate-Level Verilog (matching CMOS-static-2 SPICE)");
        $display("================================================================");
        $display("");

        errors = 0;
        test_num = 0;

        // Initialize - Cin is always 0
        cin = 1'b0;
        expected_sum = 5'b00000;
        expected_cout = 1'b0;

        $display("Starting exhaustive testing with Cin = 0...");
        $display("");

        // Loop through all combinations of A (0 to 31)
        for (i = 0; i < 32; i = i + 1) begin
            // Loop through all combinations of B (0 to 31)
            for (j = 0; j < 32; j = j + 1) begin
                test_num = test_num + 1;
                
                // Set inputs
                a = i[4:0];
                b = j[4:0];
                
                // Calculate expected result (A + B + 0)
                calculated = a + b;
                expected = calculated;
                expected_sum = expected[4:0];
                expected_cout = expected[5];
                
                // Wait for circuit propagation
                #10;
                
                // Check result
                if ({cout, sum} !== expected) begin
                    $display("================================================================");
                    $display("TEST %0d FAILED!", test_num);
                    $display("================================================================");
                    $display("  Inputs:");
                    $display("    A     = %b (%2d decimal)", a, a);
                    $display("    B     = %b (%2d decimal)", b, b);
                    $display("    Cin   = %b (always 0)", cin);
                    $display("  Expected:");
                    $display("    Sum   = %b (%2d decimal)", expected_sum, expected_sum);
                    $display("    Cout  = %b", expected_cout);
                    $display("    Total = %2d (6-bit: %b)", expected, expected);
                    $display("  Got:");
                    $display("    Sum   = %b (%2d decimal)", sum, sum);
                    $display("    Cout  = %b", cout);
                    $display("    Total = %2d (6-bit: %b)", {cout, sum}, {cout, sum});
                    $display("================================================================");
                    $display("");
                    errors = errors + 1;
                end
                
                // Print progress every 128 tests (more frequent for 1024 total)
                if (test_num % 128 == 0) begin
                    $display("Progress: %4d/1024 tests completed (%3d%%)...", 
                             test_num, (test_num * 100) / 1024);
                end
            end
        end

        // Summary
        $display("");
        $display("================================================================");
        $display("  VERIFICATION SUMMARY");
        $display("================================================================");
        $display("Test configuration: Cin = 0 (fixed)");
        $display("Total tests run:    %0d", test_num);
        $display("Tests passed:       %0d", test_num - errors);
        $display("Tests failed:       %0d", errors);
        $display("Pass rate:          %0d%%", ((test_num - errors) * 100) / test_num);
        $display("================================================================");
        
        if (errors == 0) begin
            $display("");
            $display("    ****************************************************");
            $display("    ***  SUCCESS! ALL %0d TESTS PASSED!  ***", test_num);
            $display("    ****************************************************");
            $display("");
        end else begin
            $display("");
            $display("    ****************************************************");
            $display("    ***  FAILURE! %0d out of %0d tests FAILED  ***", errors, test_num);
            $display("    ****************************************************");
            $display("");
        end
        
        $display("================================================================");
        $display("");
        $display("Waveform file: cla_5bit.vcd");
        $display("View with:     gtkwave cla_5bit.vcd");
        $display("               gtkwave cla_5bit.vcd cla_5bit.gtkw");
        $display("");
        $display("================================================================");

        #10;
        $finish;
    end

endmodule
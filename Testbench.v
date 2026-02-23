`timescale 1ns / 1ps

module tb_palindrome_system;

    reg clk;
    reg reset;                  // Simulates VIO probe_out0
    reg [3:0] B_length;         // Simulates VIO probe_out1
    reg [63:0] input_sequence;  // Simulates VIO probe_out2


    wire [63:0] C_out;          // Output from DUT
    wire D_out;                 // Output from DUT
    wire done_sig;              // Output from DUT
    
    reg [3:0] input_counter;    // The counter tracking digits sent
    wire [3:0] A_seq;           // The specific nibble sent to DUT


    always @(posedge clk or posedge reset) begin
        if (reset) begin
            input_counter <= 0;
        end else begin
            // Stop counting if we have sent 'B' digits
            if (input_counter < B_length) begin
                input_counter <= input_counter + 1;
            end
        end
    end


    assign A_seq = input_sequence[(63 - (input_counter * 4)) -: 4];

    palindrome_detector DUT (
        .clk(clk),
        .reset(reset),
        .A(A_seq),          
        .B(B_length),       
        .C(C_out),
        .D(D_out),
        .done(done_sig)
    );


    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end


    initial begin
        // Initialize
        reset = 1;
        B_length = 0;
        input_sequence = 0;

        // Wait for global reset
        #100;
        $display("---------------------------------------------------");
        $display("   PALINDROME SYSTEM TEST (VIO EMULATION)        ");
        $display("---------------------------------------------------");

        // ============================================================
        // TEST CASE 1: Palindrome "12321" (Length 5)
        // ============================================================
        $display("Test 1: Input 12321 (Length 5)");
        
        // 1. Set the VIO inputs (like typing in the dashboard)
        B_length = 5;
        // Hex: 1, 2, 3, 2, 1, followed by zeros
        input_sequence = 64'h1232100000000000; 

        // 2. Toggle Reset to start the sequence (simulate pushing VIO button)
        reset = 1;
        #20;
        reset = 0; 
        
       
        wait(done_sig == 1); 
        #20; 

 
        if (D_out == 1) $display(" -> [PASS] Detected Palindrome.");
        else            $display(" -> [FAIL] Failed to detect Palindrome.");
        
        $display("    Captured Number (C): %h", C_out);


        // ============================================================
        // TEST CASE 2: Non-Palindrome "12345" (Length 5)
        // ============================================================
        $display("\nTest 2: Input 12345 (Length 5)");

        // 1. Set VIO inputs
        B_length = 5;
        input_sequence = 64'h1234500000000000;

        // 2. Toggle Reset
        reset = 1;
        #20;
        reset = 0; 

        // 3. Wait
        wait(done_sig == 1);
        #20;

        // 4. Check Result
        if (D_out == 0) $display(" -> [PASS] Correctly identified Non-Palindrome.");
        else            $display(" -> [FAIL] Incorrectly marked as Palindrome.");


        // ============================================================
        // TEST CASE 3: Even Length Palindrome "ABBA" (Length 4)
        // ============================================================
        $display("\nTest 3: Input ABBA (Length 4)");

        // 1. Set VIO inputs
        B_length = 4;
        input_sequence = 64'hABBA000000000000;

        // 2. Toggle Reset
        reset = 1;
        #20;
        reset = 0; 

        // 3. Wait
        wait(done_sig == 1);
        #20;

        // 4. Check Result
        if (D_out == 1) $display(" -> [PASS] Detected Palindrome.");
        else            $display(" -> [FAIL] Failed to detect Palindrome.");
        $display("    Captured Number (C): %h", C_out);

        $display("---------------------------------------------------");
        $stop;
    end

endmodule

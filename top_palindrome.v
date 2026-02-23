`timescale 1ns / 1ps

module top_palindrome(
    input clk 
);

    wire reset;
    wire [3:0] B_length;
    wire [63:0] input_sequence;
    wire [63:0] C_out;
    wire D_out;
    wire done_sig;
    
    reg [3:0] input_counter;
    wire [3:0] A_seq;

    always @(posedge clk or posedge reset) begin
        if (reset) input_counter <= 0;
        else if (input_counter < B_length) input_counter <= input_counter + 1;
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

  vio_0 ABC (
        .clk(clk),
        .probe_in0(C_out),     // 64-bit
        .probe_in1(D_out),     // 1-bit
        .probe_in2(done_sig),  // 1-bit
        .probe_out0(reset),    // 1-bit
        .probe_out1(B_length), // 4-bit
        .probe_out2(input_sequence) // 64-bit
);

endmodule


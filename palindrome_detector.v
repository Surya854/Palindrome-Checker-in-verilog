`timescale 1ns / 1ps

module palindrome_detector (
    input clk,
    input reset,
    input [3:0] A,          // 4-bit BCD input (Sequential)
    input [3:0] B,          // Total Number of digits to expect
    output reg [63:0] C,    // The detected number (concatenated)
    output reg D,           // 1 = Palindrome, 0 = Not
    output reg done         // Handshake signal to indicate check is complete
);

    reg [3:0] digit_mem [0:15]; 
    reg [4:0] count;            
    integer i;
    reg palindrome_flag;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            C <= 64'b0;
            D <= 0;
            done <= 0;
        end else begin
          
            if (count < B) begin
              
                digit_mem[count] <= A;
                
                
                C <= (C << 4)| A; 
                
                count <= count + 1;
                done <= 0; 
            end 
            
            else if (count == B && !done) begin
                palindrome_flag = 0;
                
                for (i = 0; i < 16; i = i + 1) begin
                    if (i < B/2) begin

                       if (digit_mem[i] == digit_mem[(B - 1) - i]) begin
                            D = 1;
                        end
                    end
                end
                done <= 1; 
                if(D==0)begin
                 C <= 64'b0;
                 end  
            end
        end
 end
endmodule

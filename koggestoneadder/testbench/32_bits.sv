`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2025 12:20:56
// Design Name: 
// Module Name: sim_ksa_32bits
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sim_ksa_32bits();
    bit clk;
    logic arst_n;
    logic [31:0] first;
    logic [31:0] second;
    logic carry_in;
    logic [31:0] final_result;
    logic carry_out_final;
    
    //instanciación
    ksa_32bits ksa_32bits_dut(
    .clk(clk),
    .arst_n(arst_n),
    .en(1'b1),
    .first(first),
    .second(second),
    .carry_in(carry_in),
    .final_result(final_result),
    .carry_out_final(carry_out_final)
    );
    
    logic [31:0] sum_test;
    logic carry_out_test;
    
    
    assign {carry_out_test, sum_test} = first + second + carry_in;
    
    always #5ns clk = ~clk;
    
    initial begin
        arst_n='0;
        first = '0;
        second = '0;
        carry_in = '0;
        repeat(5)@(posedge clk);
        arst_n=1;
        repeat(50)begin
        std::randomize(first);
        std::randomize(second);
        std::randomize(carry_in);
        @(posedge clk);
        end
        $finish;
    end

   
endmodule

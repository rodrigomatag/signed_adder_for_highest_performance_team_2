`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Rodrigo Mata 
// 
// Create Date: 03.11.2025 10:06:26
// Design Name: 
// Module Name: half_adder

//////////////////////////////////////////////////////////////////////////////////


module half_adder(
    input logic clk,
    input logic arst_n,
    input logic a,
    input logic b,
    output logic s,
    output logic c
    );
    
//internal signals 
logic s_comb;
logic c_comb;
logic s_reg;
logic c_reg;
//combinagional logic 
assign s_comb = a ^ b;
assign c_comb = a & b;
//secuential_logic 
always_ff @(posedge clk, negedge arst_n) begin 
    if(!arst_n) begin 
        s_reg <= 1'b0;
        c_reg <= 1'b0;
    end else begin 
        s_reg <= s_comb;
        c_reg <= c_comb;
    end
end
//outputs
assign s = s_reg;
assign c = c_reg;
endmodule

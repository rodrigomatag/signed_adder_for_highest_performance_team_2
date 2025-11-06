`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2025 20:16:46
// Design Name: 
// Module Name: half_adder_primitives

//////////////////////////////////////////////////////////////////////////////////


module half_adder_primitives(
    input logic clk,
    input logic arst_n,
    input logic a,
    input logic b,
    output logic s, 
    output logic c
    );
//internal signals 
logic c_comb;
logic c_reg;
logic s_comb;
logic s_reg;
//combinational logic 
and g1 (c_comb, a, b);
xor g2 (s_comb, a, b);
//secuential logic 
always_ff @(posedge clk, negedge arst_n) begin
    if(!arst_n) begin 
        s_reg <= 1'b0;
        c_reg <= 1'b0;
    end else begin 
        s_reg <= s_comb;
        c_reg <= c_comb;
    end
end

assign c = c_reg;
assign s = s_reg;

endmodule

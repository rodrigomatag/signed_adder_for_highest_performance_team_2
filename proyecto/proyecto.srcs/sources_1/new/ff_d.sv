`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Rodrigo Mata 
// 
// Create Date: 04.11.2025 14:57:54
// Design Name: 
// Module Name: ff_d

//////////////////////////////////////////////////////////////////////////////////


module ff_d(
    input logic clk,
    input logic arst_n,
    input logic d,
    output logic q
    );
    
always_ff @(posedge clk, negedge arst_n) begin 
    if(!arst_n) begin 
        q <= 1'b0;
    end else begin 
        q <= d;
    end
end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2025 19:29:34
// Design Name: 
// Module Name: full_adder

//////////////////////////////////////////////////////////////////////////////////
module full_adder(
    input logic a,
    input logic b,
    input logic cin,
    output logic s,
    output logic cout
);

assign cout = ((a ^ b) & cin) | (a & b);
assign s = a ^ b ^ cin;

endmodule

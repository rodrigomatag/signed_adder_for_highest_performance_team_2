`timescale 1ns / 1ps

module full_adder(
    input logic a_i,
    input logic b_i,
    input logic cin_i,
    output logic sum_o,
    output logic cout_o
    );
    
    assign sum_o = (a_i ^ b_i) ^ cin_i;
    assign cout_o = (cin_i & (a_i ^ b_i)) | (a_i & b_i); 
endmodule

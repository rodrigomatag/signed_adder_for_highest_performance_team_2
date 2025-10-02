`timescale 1ns / 1ps

module ripple_carry_adder(
    input logic a0_i,
    input logic a1_i,
    input logic a2_i,
    input logic b0_i,
    input logic b1_i,
    input logic b2_i,
    input logic cin_i,
    output logic [3:0] sum_o,
    output logic cout_o
);

    logic cin1_i;
    logic cin2_i;
    logic sum0_o;
    logic sum2_o;
    logic sum1_o;
    
    full_adder fa2_i(
        .a_i(a2_i),
        .b_i(b2_i),
        .cin_i(cin_i),
        .sum_o(sum2_o),
        .cout_o(cin1_i)
    );

    full_adder fa1_i(
        .a_i(a1_i),
        .b_i(b1_i),
        .cin_i(cin1_i),
        .sum_o(sum1_o),
        .cout_o(cin2_i)
    );
    
    full_adder fa0_i(
        .a_i(a0_i),
        .b_i(b0_i),
        .cin_i(cin2_i),
        .sum_o(sum0_o),
        .cout_o(cout_o)
    );
        assign sum_o = {cout_o, sum2_o, sum1_o, sum0_o};
endmodule

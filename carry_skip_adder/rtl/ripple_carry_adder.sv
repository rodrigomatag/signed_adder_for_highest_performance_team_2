`timescale 1ns / 1ps

module ripple_carry_adder(
    input logic [3:0] a_i,
    input logic [3:0] b_i,
    input logic cin_i,
    output logic [4:0] sum_o,
    output logic cout_o
);
    
    logic skip0;
    logic skip1;
    logic skip2;
    logic skip3;
    logic skip4;
    logic skip5;
    logic skip6;
    logic cin_1_i;
    logic cin_2_i;
    logic cin_3_i;
    logic sum0_o;
    logic sum2_o;
    logic sum1_o;
    
    skip skip_0_i(
      .a_i(a_i[0]),
      .b_i(b_i[0]),
      .cin_i(cin_i),
      .y_o(skip0) 
    );
    
    full_adder fa0_i(
        .a_i(a_i[0]),
        .b_i(b_i[0]),
        .cin_i(skip0),
        .sum_o(sum_o[0]),
        .cout_o(skip1)
    );

    skip skip_1_i(
      .a_i(a_i[1]),
      .b_i(b_i[1]),
      .cin_i(skip1),
      .y_o(skip2) 
    );

    full_adder fa1_i(
        .a_i(a_i[1]),
        .b_i(b_i[1]),
        .cin_i(skip2),
        .sum_o(sum_o[1]),
        .cout_o(skip3)
    );
    
    skip skip_2_i(
      .a_i(a_i[1]),
      .b_i(b_i[1]),
      .cin_i(skip3),
      .y_o(skip4) 
    );

    full_adder fa2_i(
        .a_i(a_i[2]),
        .b_i(b_i[2]),
        .cin_i(skip4),
        .sum_o(sum_o[2]),
        .cout_o(skip5)
    );

    skip skip_3_i(
      .a_i(a_i[1]),
      .b_i(b_i[1]),
      .cin_i(skip5),
      .y_o(skip6) 
    );
    
    full_adder fa3_i(
        .a_i(a_i[3]),
        .b_i(b_i[3]),
        .cin_i(skip6),
        .sum_o(sum_o[3]),
        .cout_o(cout_o)
    );
        assign sum_o = {cout_o, sum_o};
endmodule

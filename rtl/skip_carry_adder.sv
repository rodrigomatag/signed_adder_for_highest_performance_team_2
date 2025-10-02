`timescale 1ns / 1ps

module skip_carry_adder(
        input logic     a_i,
        input logic     b_i,
        input logic     cin_i,
        output logic    sum_o,
        output logic    cout_o
    );
    logic [2:0] sel_o;
    logic d0_i = 1'b0;
    logic d1_i = 1'b1;
    logic y_o;
    
    skip skip_i(
        .a_i(a_i),
        .b_i(b_i),
        .sel_o(sel_o)
    );
    
    mux_3_to_1 mux_i(
        .d0_i(d0_i),
        .d1_i(d1_i),
        .d2_i(cin_i),
        .sel_o(sel_o),
        .y_o(y_o)
    );
    
    full_adder fa_i (
        .a_i(a_i),
        .b_i(b_i),
        .cin_i(y_o),
        .cout_o(cout_o),
        .sum_o(sum_o)
    );
endmodule

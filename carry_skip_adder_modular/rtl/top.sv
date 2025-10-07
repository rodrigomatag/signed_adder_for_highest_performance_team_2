`timescale 1ns / 1ps

module top #(
    parameter int N = 8
)(
    input logic     [N-1:0] a_i,
    input logic     [N-1:0] b_i,
    input logic             cin_i,
    output logic    [N-1:0] sum_o,
    output logic            cout_o
    );
    
    logic [N:0] c; // c[0] es cin_i, c[N] va a cout_o
    logic [N-1:0] cin_to_fa; //carry que seconecta al FA luego del skip (uno por bit)
    assign c[0] = cin_i;
    assign c[N] = cout_o;
    
    genvar i;
    for (i = 0; i < N; i++) begin : skip_adder
        skip skip_i(
          .a_i(a_i[i]),
          .b_i(b_i[i]),
          .cin_i(c[i]),         // carry que llega desde el bit anterior
          .y_o(cin_to_fa[i])    // carry que entra al FA de este bit
        );
        
        full_adder fa_i(
        .a_i(a_i[i]),
        .b_i(b_i[i]),
        .cin_i(cin_to_fa[i]),
        .sum_o(sum_o[i]),
        .cout_o(c[i+1])         // carry que sale hacia el siguiente bit          
        );
    end
endmodule

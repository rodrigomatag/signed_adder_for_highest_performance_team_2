`timescale 1ns / 1ps

module mux_2_to_1(
    input logic d0_i,
    input logic d1_i,
    input logic sel_i,
    output logic y_o
    );
    
    assign y_o = sel_i ? d0_i : d1_i;
endmodule

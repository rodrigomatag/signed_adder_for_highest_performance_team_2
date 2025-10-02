`timescale 1ns / 1ps

module mux_3_to_1(
    input logic d0_i,
    input logic d1_i,
    input logic d2_i,
    input logic [2:0] sel_o,
    output logic y_o
    );
    always_comb begin 
    //Evitar latches 
        y_o = 1'bz;
        unique case (sel_o)
            2'b000: y_o = d0_i; // kill
            2'b001: y_o = d1_i; // Generate 
            2'b010: y_o = d2_i;  // Propagation
            default: y_o = 1'bz;
        endcase 
    end
endmodule

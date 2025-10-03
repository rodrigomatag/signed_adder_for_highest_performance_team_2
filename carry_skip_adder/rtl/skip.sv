`timescale 1ns / 1ps

module skip(
        input logic a_i,
        input logic b_i,
        input logic cin_i,
        output logic y_o
    );
    logic [1:0] sel_o;
    logic d0_i = 1'b0;
    logic d1_i = 1'b1;
    always_comb begin 
        sel_o  = 2'bzz;
        if (a_i & b_i)         sel_o = 3'b01; //Generation
        else if(!(a_i & b_i))  sel_o = 3'b00; //Kill
        else if (a_i^b_i)      sel_o = 3'b10; //Propagation
        else                   sel_o = 2'bzz;
    end
    
    mux_3_to_1(
        .d0_i(d0_1),
        .d1_i(cin_i),
        .d2_i(d2_i),
        .sel_o(sel_o),
        .y_o(y_o)
    ); 
endmodule

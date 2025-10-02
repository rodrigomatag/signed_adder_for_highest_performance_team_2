`timescale 1ns / 1ps

module skip(
        input logic a_i,
        input logic b_i,
        output logic [2:0] sel_o
    );
    always_comb begin 
        sel_o  = 3'b100;
        if (a_i & b_i)         sel_o = 3'b001; //Generation
        else if(!(a_i & b_i))  sel_o = 3'b000; //Kill
        else if (a_i^b_i)      sel_o = 3'b010; //Propagation
        else                   sel_o = 3'b100;
    end 
endmodule

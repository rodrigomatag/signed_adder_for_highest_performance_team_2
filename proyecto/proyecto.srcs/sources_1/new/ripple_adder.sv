`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Rodrigo Mata  
// 
// Create Date: 03.11.2025 21:14:54
// Design Name: 
// Module Name: ripple_adder

//////////////////////////////////////////////////////////////////////////////////


module ripple_adder #(parameter N = 128)(
    input logic signed [N-1:0] a,
    input logic signed [N-1:0] b,
    input logic cin,
    output logic signed [N-1:0] s,
    output logic overflow
    );

//internal signal for carry porpagation 
logic cout;
logic [N-1:0] carry;
assign carry[0] = cin; //carry in assigned to first full adder

genvar i;
generate 
    for(i = 0; i < N; i++) begin : full_adder_gen
        full_adder FA (
            .a(a[i]),
            .b(b[i]),
            .cin(carry[i]),
            .s(s[i]),
            .cout(carry[i+1])
        );
    end
endgenerate
//outputs 
assign cout = carry[N]; // final carry out 
assign overflow = carry[N-1] ^ carry[N]; //if the result if incorrect carry[MSB] ^ carry[LSB] = 1'b1

endmodule

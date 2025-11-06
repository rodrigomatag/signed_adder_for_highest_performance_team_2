`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Rodrigo Mata 
// 
// Create Date: 04.11.2025 15:03:12
// Design Name: 
// Module Name: top

//////////////////////////////////////////////////////////////////////////////////


module top(
    input logic clk,
    input logic arst_n,
    input logic [1:0] a,
    input logic [1:0] b,
    input logic cin,
    output logic [1:0] sum,
    output logic cout
    );
// Internal signals 
logic s;
logic sI0;
logic cin0;
logic cinI0;
logic AI1;
logic BI1;

full_adder FA_0 (
    .a(a[0]),
    .b(b[0]),
    .cin(cin),
    .s(s),
    .cout(cin0)
);

full_adder FA_1 (
    .a(AI1),
    .b(BI1),
    .cin(cinI0),
    .s(sum[1]),
    .cout(cout)
);

ff_d FFa1 (
    .clk(clk),
    .arst_n(arst_n),
    .d(a[1]),
    .q(AI1)
);

ff_d FFb1 (
    .clk(clk),
    .arst_n(arst_n),
    .d(b[1]),
    .q(BI1)
);


ff_d FFcarry (
    .clk(clk),
    .arst_n(arst_n),
    .d(cin0),
    .q(cinI0)
);

ff_d FFsum1 (
    .clk(clk),
    .arst_n(arst_n),
    .d(s),
    .q(sI0)
);

ff_d FFsum2 (
    .clk(clk),
    .arst_n(arst_n),
    .d(sI0),
    .q(sum[0])
);

endmodule

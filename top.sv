`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Rodrigo Mata 
// Create Date: 04.11.2025 15:03:12
// Design Name: 
// Module Name: top
//////////////////////////////////////////////////////////////////////////////////
module rodrigo_adder(
    input logic clk,
    input logic arst_n,
    input logic [3:0] a,
    input logic [3:0] b,
    input logic cin,
    output logic [3:0] sum,
    output logic cout
    );
// Internal signals
logic [1:0] internal_sum;
logic [4:0] out_sum; 
logic carry_0, carry_1, carry_2, carry_3, carry_4, carry_5, carry_6; 
logic [4:2] q_a;
logic [4:2] q_b;
//full_adder FA_0
full_adder FA_0 (
    .a(a[0]),
    .b(b[0]),
    .cin(carry_0),
    .s(internal_sum[0]),
    .cout(carry_1)
);
//ff for sum_0
ff_d ff_sum_0(
    .clk(clk),
    .arst_n(arst_n),
    .d(internal_sum[0]),
    .q(out_sum[0])
);
//full_adder FA_1
full_adder FA_1 (
    .a(a[1]),
    .b(b[1]),
    .cin(carry_1),
    .s(internal_sum[1]),
    .cout(carry_2)
);
//ff for sum_1
ff_d ff_sum_1(
    .clk(clk),
    .arst_n(arst_n),
    .d(internal_sum[1]),
    .q(out_sum[1])
);
//ff for cout
ff_d ff_cout(
    .clk(clk),
    .arst_n(arst_n),
    .d(carry_2),
    .q(carry_3)
);
//ff for inputs of FA_2
ff_d ff_a2( // for a[2]
    .clk(clk),
    .arst_n(arst_n),
    .d(a[2]),
    .q(q_a[2])
);
ff_d ff_b2( // for b[2]
    .clk(clk),
    .arst_n(arst_n),
    .d(b[2]),
    .q(q_b[2])
);
//full_adder FA_2
full_adder FA_2 (
    .a(q_a[2]),
    .b(q_b[2]),
    .cin(carry_3),
    .s(out_sum[2]),
    .cout(carry_4)
);
///////////////////////
//ff for inputs of FA_3
ff_d ff_a3( // for a[3]
    .clk(clk),
    .arst_n(arst_n),
    .d(a[3]),
    .q(q_a[3])
);
ff_d ff_b3( // for b[3]
    .clk(clk),
    .arst_n(arst_n),
    .d(b[3]),
    .q(q_b[3])
);
//full_adder FA_3
full_adder FA_3 (
    .a(q_a[3]),
    .b(q_b[3]),
    .cin(carry_4),
    .s(out_sum[3]),
    .cout(carry_5)
);
//ff for cout of FA_3 (input to FA_4)
ff_d ff_cout_3(
    .clk(clk),
    .arst_n(arst_n),
    .d(carry_5),
    .q(carry_6)
);
//ff for inputs of FA_4 (Sign Extension)
ff_d ff_a4( // Sign extension for a[4]
    .clk(clk),
    .arst_n(arst_n),
    .d(q_a[3]), // Ya registrado de la etapa anterior (FA_2)
    .q(q_a[4])
);
ff_d ff_b4( // Sign extension for b[4]
    .clk(clk),
    .arst_n(arst_n),
    .d(q_b[3]), // Ya registrado de la etapa anterior (FA_2)
    .q(q_b[4])
);
//full_adder FA_4 (Signed Bit sum[4])
full_adder FA_4 (
    .a(q_a[4]), // a[3] retrasado
    .b(q_b[4]), // b[3] retrasado
    .cin(carry_6),
    .s(out_sum[4]),
    .cout(cout)
);
//outputs
assign carry_0 = cin;
assign sum = out_sum; 
endmodule


module ff_d(
    input logic clk,
    input logic arst_n,
    input logic d,
    output logic q
    );
    
always_ff @(posedge clk, negedge arst_n) begin 
    if(!arst_n) begin 
        q <= 1'b0;
    end else begin 
        q <= d;
    end
end
endmodule

module full_adder(
    input logic a,
    input logic b,
    input logic cin,
    output logic s,
    output logic cout
);

assign cout = ((a ^ b) & cin) | (a & b);
assign s = a ^ b ^ cin;

endmodule
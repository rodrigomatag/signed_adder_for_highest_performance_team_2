`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Rodrigo Mata  
// 
// Create Date: 05.11.2025 22:26:50
// Design Name: 
// Module Name: top_tb
//////////////////////////////////////////////////////////////////////////////////


module top_tb();
bit clk;
bit arst_n;
logic [1:0] a;
logic [1:0] b;
logic cin;
logic [1:0] sum;
logic cout;

//module instantation 
top top_i (
    .clk(clk),
    .arst_n(arst_n),
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
);



always #5ns clk = !clk;

initial begin 
// set a, b to 0
    a = 2'b0;
    b = 2'b0;
    cin = 1'b0;
    repeat (3) @(posedge clk);
    arst_n = 1'b1;
    @(posedge clk);
    a =     2'b11;
    b =     2'b11;
    cin =   1'b_1;
            //111
    @(posedge clk);
    #1us;
    $finish;  
end
endmodule

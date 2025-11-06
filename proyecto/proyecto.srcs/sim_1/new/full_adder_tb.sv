`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2025 20:39:32
// Design Name: 
// Module Name: half_adder_primitives_tb

//////////////////////////////////////////////////////////////////////////////////


module full_adder_tb();

//Internal signals?
bit clk;
bit arst_n;
logic a;
logic b;
logic cin;
logic s;
logic cout;

//module instantation 
full_adder full_adder_i (
    .clk(clk),
    .arst_n(arst_n),
    .a(a),
    .b(b),
    .cin(cin),
    .s(s),
    .cout(cout)
);

always #5ns clk = !clk;

initial begin 
// set a, b to 0
    a = 1'b0;
    b = 1'b0;
    cin = 1'b0;
    repeat (3) @(posedge clk);
    arst_n = 1'b1;
    @(posedge clk);
    for (int i = 0; i < 8; i++) begin 
        {a, b, cin} = i;
        @(posedge clk);
    end
    #1us;
    $finish;  
end
//Assertions 
a1_sum_correct: assert property (@(posedge clk)
    (arst_n) |-> ##1 (s == (a ^ b ^ cin)) 
    ) else $error("Fallo Funcional (Suma): S=%b, Esperado S_comb=%b. Entradas A=%b, B=%b, Cin=%b.", 
                  s, (a ^ b ^ cin), a, b, cin);
                  
a2_carry_correct: assert property (@(posedge clk)
    (arst_n) |-> ##1 (cout == ((a & b) | (cin & (a ^ b)))) 
    ) else $error("Fallo Funcional (Acarreo): Cout=%b, Esperado Cout_comb=%b. Entradas A=%b, B=%b, Cin=%b.", 
                  cout, ((a & b) | (cin & (a ^ b))), a, b, cin);
endmodule

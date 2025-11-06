`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2025 20:39:32
// Design Name: 
// Module Name: half_adder_primitives_tb

//////////////////////////////////////////////////////////////////////////////////


module half_adder_primitives_tb();

//Internal signals?
bit clk;
bit arst_n;
logic a;
logic b;
logic s;
logic c;

//module instantation 
half_adder_primitives half_adder_primitives_i (
    .clk(clk),
    .arst_n(arst_n),
    .a(a),
    .b(b),
    .s(s),
    .c(c)
);

always #5ns clk = !clk;

initial begin 
// set a, b to 0
    a = 1'b0;
    b = 1'b0;
    repeat (3) @(posedge clk);
    arst_n = 1'b1;
    wait(arst_n)
    @(posedge clk);
    for (int i = 0; i < 4; i++) begin 
        {a, b} = i;
        @(posedge clk);
    end
    #1us;
    $finish;  
end
//Assertions 
a1_sum_correct: assert property (@(posedge clk)
        (arst_n) |-> ##1 (s == (a ^ b))
        ) else $error("Fallo Funcional: S=%b, Esperado S_comb=%b. Entradas A=%b, B=%b.", 
                  s, (a ^ b), a, b);
a2_carry_corract: assert property (@(posedge clk) 
        (!arst_n) |-> ##1 (c == (a & b))
    ) else $error("Fallo Funcional: C=%b, Esperado C_comb=%b. Entradas A=%b, B=%b.", 
                  c, (a & b), a, b);
endmodule

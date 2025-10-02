`timescale 1ns / 1ps

module skip_carry_adder_tb();
    logic a_i;
    logic b_i; 
    logic cin_i;
    logic sum_o;
    logic cout_o;
    
    skip_carry_adder dut(
        .a_i(a_i),
        .b_i(b_i),
        .cin_i(cin_i),
        .sum_o(sum_o),
        .cout_o(cout_o)
    );
    initial begin 
        for (int i = 0; i < 8; i++) begin
            {a_i, b_i, cin_i} = i[2:0];
            #10ns;
        end
        $finish;
    end
endmodule

module sim_ksa_corregido();

    logic [7:0] first;
    logic [7:0] second;
    logic carry_in;
    logic [7:0] result;
    logic carry_out;
    
    //instanciación
    ksa_corregido ksa_corregido_dut(
    
    .first(first),
    .second(second),
    .carry_in(carry_in),
    .result(result),
    .carry_out(carry_out)
    );
    
    logic [7:0] sum_test;
    logic carry_out_test;
    
    
    assign {carry_out_test, sum_test} = first + second + carry_in;
    initial begin
    
        repeat(100)begin
        std::randomize(first);
        std::randomize(second);
        std::randomize(carry_in);
        #10ns;
        end
        $finish;
    end
endmodule

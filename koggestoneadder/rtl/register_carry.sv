module reg_carry(
    input logic clk,
    input logic arst_n,
    input logic en,
    input logic in,
    output logic out
    );
    
    always_ff@(posedge clk, negedge arst_n)begin
        if(!arst_n)
            out <= '0;
        else if(en)
            out <= in;
            else 
            out <= out;
    end
    
endmodule

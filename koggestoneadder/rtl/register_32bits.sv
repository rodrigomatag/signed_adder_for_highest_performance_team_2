module register_adder_32bits(
    input logic clk,
    input logic arst_n,
    input logic en,
    input logic [31:0] in,
    output logic [31:0] out
    );
    always_ff@(posedge clk, negedge arst_n)begin
        if(!arst_n) 
            out<=8'd0;
        else if(en)
                out <= in;
            else 
                out<=out;
    end
endmodule

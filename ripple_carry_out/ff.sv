module ff #(parameter WIDTH = 1)(
  input logic clk,
  input logic arst_n,
  input logic [WIDTH-1:0] d,
  output logic [WIDTH-1:0] q
);

  always_ff @(posedge clk or negedge arst_n)
    if(!arst_n)
      q <= {WIDTH{1'b0}};
    else 
      q <= d;

endmodule

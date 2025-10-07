module ripple_carry_adder #(parameter WIDTH = 64) (
  input logic clk,
  input logic arst_n,    
  input logic [WIDTH-1:0] a, b, 
  input logic cin,              
  output logic [WIDTH-1:0] sum,
  output logic cout            
);  

  logic [WIDTH-1:0] a_d [WIDTH:0]; // WIDTH  to save the final result
  logic [WIDTH-1:0] b_d [WIDTH-1:0]; 
  logic             c_d [WIDTH:0]; // WIDTH to save for final carry 

  assign a_d[0] = a;
  assign b_d[0] = b;
  assign c_d[0] = cin;
    
  genvar i, j;
  generate
    for(i = 0; i < WIDTH; i = i+1) begin: comp_gen
      // For each pipeline stage in a pipelined adder
      logic [WIDTH-1:0] a_q;
      logic [WIDTH-1:i] b_q;
      logic c_q;
      logic s_i;
    
      // 2*WIDTH-i+1 Registers per stage
      ff #(WIDTH)   a_dff (.clk(clk), .arst_n(arst_n), .d(a_d[i]), .q(a_q));
      ff #(WIDTH-i) b_dff (.clk(clk), .arst_n(arst_n), .d(b_d[i][WIDTH-1:i]), .q(b_q));
      ff #(1)       c_dff (.clk(clk), .arst_n(arst_n), .d(c_d[i]), .q(c_q));

      // One Full Adder 
      full_adder u_add(.a(a_q[i]), .b(b_q[i]), .cin(c_q), .cout(c_d[i+1]), .sum(s_i));
            
      // Copy all A bits to next stage except for current, sum is copied instead
      for(j=0; j < WIDTH; j = j+1) begin: comp_a_d
        if(j == i) 
          assign a_d[i+1][j] = s_i;
        else
          assign a_d[i+1][j] = a_q[j];
        end
            
        if( i != WIDTH-1) // Propagate all bits except current and priors
          assign b_d[i+1][WIDTH-1:i+1] = b_q[WIDTH-1:i+1]; 
      end
  endgenerate
   
    assign sum = a_d[WIDTH]; 
    assign cout = c_d[WIDTH];
    
endmodule
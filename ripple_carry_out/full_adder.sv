module full_adder(
  input logic a, b, cin,
  output logic cout, sum
);

  logic t;
    
  assign t = a ^ b;
  assign cout = (cin & t) | (a & b);
  assign sum = t ^ cin;
    
endmodule
`timescale 1ns / 1ps

// Alternative implementation of Ling Adder, might be trivial
module ling_adder_carry #( parameter int N = 8)(
  input  logic [N-1:0] a,
  input  logic [N-1:0] b,
  input  logic         cin,
  output logic [N-1:0] sum,
  output logic         cout
);

    // Pre-processing: generate "K", "T", "D"
    logic [N-1:0] K;  	// Generate 
    logic [N-1:0] T; 	// Propagate 
    logic [N-1:0] D;	// Half-sum
    logic [N-1:0] H;	// Ling signal
	logic [N:0]   C;  	// Carry signals
	
	// Step 1: Generate, Propagate, and half-sum
    always_comb begin
        for (int i=0; i<N; i++) begin
          K[i] = a[i] & b[i];
          T[i] = a[i] | b[i];
          D[i] = a[i] ^ b[i];
        end
    end
    
	// Step 2: Ling Logic function
    // Ling carry array H
	assign H[0] = K[0];	// Only consider the Propagate signal for the LSB of Ling
	
    always_comb begin
        for (int i = 1; i < N; i++) begin
          H[i] = K[i] | (T[i] & H[i-1]);
        end
    end
    
	// Step 3: Actual carry out of bit i C[i] = H[i] & T[i]
    always_comb begin
        for (int i = 0; i < N; i++) begin
          C[i+1] = H[i] & T[i];
        end
    end
	assign C[0] = cin;	// Input carry as the first carry
	assign cout = C[N];	// Final carry
    
	// Step 4:  Full-sum bits: sum[i] = D[i] ^ C[i]
    always_comb begin
        for (int i = 0; i < N; i++) begin
          sum[i] = D[i] ^ C[i];
        end
    end

endmodule 

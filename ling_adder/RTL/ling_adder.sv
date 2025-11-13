`timescale 1ns / 1ps

// Simple implementations of Ling Adder, precursor for more complex adders
module ling_adder #(parameter N = 8)(
	input  logic [N-1:0] a,		// First operand
	input  logic [N-1:0] b,		// Second operand
	input  logic 		 cin,	// Input carry
	output logic [N-1:0] sum,	// sum
	output logic         cout	// Output carry
);

	logic [N-1:0] G;	// "Generate" signal
	logic [N-1:0] P;	// "Propagate" signal
	logic [N-1:0] D;	// Mod-2 half-sum, we deal with carries later
	logic [N-1:0] L;	// Ling signal for carries

    // Step 1: Generate, Propagate, and half-sum
    // The calculation of this signals is very common on other adders implementations.
	// All of this happen simultaneously; can be replaced with primitives.
	always_comb begin
		for (int i = 0; i < N; i++) begin
			G[i] = a[i] & b[i];	
			P[i] = a[i] | b[i];	
			D[i] = a[i] ^ b[i];	
		end
	end

	// Step 2: Ling Logic function
	// The Ling function calculates the carry "slightly" ahead. Consist of two parts
	// 1. OR the Propagate signal P_{i} with the previous Ling signal L_{i-1}
	// 2. AND the Generate G_{i} with the result of the previous step

	// Since the L_i bit requires the L_{i-1}, the base case has a different
	// definition: the LSB only depends of the first bit of
	// the generated step. Additionally, we also need to consider if there
	// is a carry bit coming as an input.
	assign L[0] = G[0] ^ cin;

	generate
		for (genvar i = 1; i < N; i++) begin : ling_step
			assign L[i] = G[i] | (P[i] & L[i-1]);
		end
	endgenerate
	// Note: in the original article, the Propagate signal is of size N+1; is left
	// shifted once, changing the index for the definition in the boolean algebra.
	// Future lectures by Ling also had the L signal size of N+1, or consider the
	// MSB as the 0-index. This peculiarity has to be considered if someone looks
	// at different implementations and variations of the Ling Adder.

	// Step 3: Full-sum computation with the carries of the Ling signal
	generate
		for (genvar i = 1; i < N; i++) begin : sum_step
			assign sum[i] = D[i] ^ L[i-1];   // L_{i-1} is the carry of the previous sum
		end
	endgenerate

	// Special cases.
	assign sum[0] = D[0] ^ cin;	// LSB of the sum has to consider the input carry
	assign cout = L[N-1];		// The carry bit is the MSB of the Ling signal.

endmodule

`timescale 1ns / 1ps

// Testbench, nothing complicated here
module ling_adder_tb();
    localparam N = 16;
    localparam int NUM_TESTS = 50;

    bit clk;			// Not needed
    logic [N-1:0]    a;	// First operand, input
    logic [N-1:0]    b;	// Second operand, input
    logic          cin;	// Initial carry, input
    logic [N-1:0]  sum;	// Sum result, output
    logic         cout;	// Carry of the sum, output
    
    always #5ns clk = !clk;
    
    task set_numbers();
        std::randomize(a);  // Randomize number for a
        std::randomize(b);  // Randomize number for b
        cin = cout;         // Take carry of the last test as the new initial
    endtask
    
    initial begin
        // Initialize all inputs to 0; the outputs should be 0
        a <= 0;
        b <= 0;
        cin <= 0;
        #10ns    // Wait 5ns before starting tests
        a <= 64281;     //   fb19
        b <= 54615;     //   d557
		// sum = 118896	// 1 d070
        $display("Test");
        
        // Repeat randomized tests
        repeat(NUM_TESTS) begin
            set_numbers();	// Randomize the numbers
            #10ns;			// Wait 10ns before the next test
            //$display("Something");
        end
    end
    
    ling_adder #(.N(N)) LA1(
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

	ling_adder_carry #(.N(N)) LA2(
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );
endmodule

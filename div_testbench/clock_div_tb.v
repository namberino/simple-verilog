// define timescale for simulation (horizontal axis) <time unit> / <time precision>
// things will be rounded to 10ps in this case
`timescale 1 ns / 10 ps

module clock_div_tb();
	wire out;

	// initial values
	reg clk = 0;
	reg rst = 0;

	// simulation time (10000 * 1ns = 10000ns = 10us)
	localparam DURATION = 10000;

	// generate clock signal (1 / ((2 * 41.67) * 1ns) = 11.99MHx
	always begin
		// delay for 41.67 time units
		// 10ps means 41.667 is rounded to 41.67
		#41.667

		// toggle clock line after delay
		clk = ~clk;
	end

	// instantiate uut (unit under test)
	// in this case, count should be fast so that the dump file won't be huge
	clock_divider #(.COUNT_WIDTH(4), .MAX_COUNT(6 - 1)) uut (
		.clk(clk),
		.rst(rst),
		.out(out)
	);

	// pulse reset line high at the beginning
	initial begin
		#10
		rst = 1'b1;
		#1
		rst = 1'b0;
	end

	// run simulation (output to .vcd file)
	initial begin
		$dumpfile("clock_div_tb.vcd");
		$dumpvars(0, clock_div_tb); // watch variables at level 0 (variables in all modules). Level 1 to watch vars of this testbench, level 2 to watch vars from the uut as well

		// wait for given amount of time for sim to complete
		#(DURATION)

		// notify end of sim
		$display("Done");
		$finish;
	end
endmodule

module top_design(
	input clk,
	input rst_button,

	output[1:0] led
);

	wire rst;

	assign rst = ~rst_button;

	clock_divider #(.COUNT_WIDTH(32), .MAX_COUNT(1500000)) div1(
		.clk(clk),
		.rst(rst),
		.out(led[0])
	);
	//defparam div1.COUNT_WIDTH = 32;
	//defparam div1.MAX_COUNT = 1500000;
	
	clock_divider div2(
		.clk(clk),
		.rst(rst),
		.out(led[1])
	);

endmodule

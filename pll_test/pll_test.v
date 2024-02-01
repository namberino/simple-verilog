module pll_test(
	input ref_clk,

	output clk
);
	
	SB_PLL40_CORE #(
		.FEEDBACK_PATH("SIMPLE"), // don't use fine delay adjustment
		.PLLOUT_SELECT("GENCLK"), // no phase shift on output
		.DIVR(4'b0000),			  // reference clock divider
		.DIVF(7'b1001111),		  // feedback clock divider
		.DIVQ(3'b011),			  // VCO clock divider
		.FILTER_RANGE(3'b001)
	) pll (
		.REFERENCECLK(ref_clk),
		.PLLOUTCORE(clk),
		.LOCK(),				  // this lets you know that the pll is working and it has locked the output phase to the input phase
		.RESETB(1'b1),			  // active low reset
		.BYPASS(1'b0)			  // no bypass, use PLL signal as output
	);

endmodule

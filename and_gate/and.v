// Module: button 0 lights up 2 leds, button 0 and 1 lights up the 3rd as well
module and_gate(
	// Inputs (2 buttons)
	input[1:0]	pmod,

	// Outputs (using 3 leds)
	output[2:0]	led
);

	// connections
	wire not_pmod_0;

	assign not_pmod_0 = ~pmod[0];
	assign led[1:0] = {2{not_pmod_0}}; // copy not_mod_0 to both leds (led 1 and led 0)

	assign led[2] = not_pmod_0 & ~pmod[1];

endmodule

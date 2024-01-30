// Module: Adding 3 bits together (input buttons are active low inputs)
module adder(
	input[2:0] pmod,
	output[1:0] led
);

	wire[1:0] and_out;
	wire[1:0] xor_out;

	assign and_out[0] = ~pmod[0] & ~pmod[1];
	assign xor_out[0] = ~pmod[0] ^ ~pmod[1];
	assign and_out[1] = xor_out[0] & ~pmod[2];
	assign xor_out[1] = xor_out[0] ^ ~pmod[2];
	
	assign led[0] = and_out[0] | and_out[1];
	assign led[1] = xor_out[1];

endmodule

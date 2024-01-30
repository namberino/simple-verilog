module counter(
	input[1:0] pmod,
	output reg[3:0] led
);

	wire rst;
	wire clk;
	
	assign clk = ~pmod[1];
	assign rst = ~pmod[0];

	// count up on clock rising edge or reset on reset button push
	always @ (posedge clk or posedge rst)
	begin
		if (rst == 1'b1)
		begin
			led <= 4'b0;
		end else
		begin
			led <= led + 1'b1;
		end
	end
endmodule

// Module: count up with each button presses and use LEDs to display binary value
module counter(
	input rst_button,
	input clk,
	output reg[3:0] led		// reg means connect these led lines to the DFF inside the circuit to store values
);

	wire rst;
	reg div_clk;
	reg[28:0] count;
	localparam[28:0] max_count = 6000000;

	assign rst = ~pmod[0];

	// count up on divided clock rising edge or reset on reset button push
	always @ (posedge div_clk or posedge rst)
	begin
		if (rst == 1'b1)
		begin
			led <= 4'b0;
		end else
		begin
			led <= led + 1'b1;
		end
	end

	// clock divider (if count hit max, invert div_clk signal)
	// since this method takes 2 clock ticks to complete 1 clock cycle, setting 6 mil as max count will turn the 12MHz clock to 1Hz (6 mil * 2)
	always @ (posedge clk or posedge rst)
	begin
		if (rst == 1'b1)
		begin
			count = 28'b0;
		end else if (count == max_count)
		begin
			count = 28'b0;
			div_clk <= ~div_clk;
		end else
		begin
			count <= count + 1;
		end
	end

endmodule

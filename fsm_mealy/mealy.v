module mealy(
	input clk,
	input rst_button,
	input go_button,

	output reg[3:0] led,
	output reg done_sig
);
	localparam STATE_IDLE = 1'd0;
	localparam STATE_COUNTING = 1'd1;

	localparam MAX_CLK_COUNT = 24'd1500000;
	localparam MAX_LED_COUNT = 4'hF;

	wire rst;
	wire go;

	reg div_clk;
	reg[1:0] state;
	reg[23:0] clk_count;

	assign rst = ~rst_button;
	assign go = ~go_button;

	// clock divider
	always @ (posedge clk or posedge rst)
	begin
		if (rst == 1'b1)
		begin
			clk_count <= 24'b0;
		end else if (clk_count == MAX_CLK_COUNT)
		begin
			clk_count <= 24'b0;
			div_clk = ~div_clk;
		end else
		begin
			clk_count <= clk_count + 1;
		end
	end

	// state transition logic
	always @ (posedge div_clk or posedge rst)
	begin
		// on reset, return to idle state
		if (rst == 1'b1)
		begin
			state <= STATE_IDLE;
		end else
		begin
			// state transition
			case (state)
				STATE_IDLE:
					begin
						done_sig <= 1'b0;

						if (go == 1'b1)
						begin
							state <= STATE_COUNTING;
						end
					end

				STATE_COUNTING:
					begin
						if (led == MAX_LED_COUNT)
						begin
							done_sig <= 1'b1;
							state <= STATE_IDLE;
						end
					end

				default: state <= STATE_IDLE;
			endcase
		end
	end

	// led counter
	always @ (posedge div_clk or posedge rst)
	begin
		if (rst == 1'b1)
		begin
			led <= 4'b0;
		end else
		begin
			if (state == STATE_COUNTING)
			begin
				led <= led + 1;
			end else
			begin
				led <= 4'b0;
			end
		end
	end
endmodule

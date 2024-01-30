module counter(
	input rst_button,
	input inc_button,
	input clk,

	output reg[3:0] led
);

	wire rst;
	wire inc;

	localparam STATE_HIGH = 2'd0;
	localparam STATE_LOW = 2'd1;
	localparam STATE_WAIT = 2'd2;
	localparam STATE_PRESSED = 2'd3;
	localparam MAX_CLK_COUNT = 20'd480000;

	reg[1:0] state;
	reg[20:0] clk_count;
	
	assign rst = ~rst_button;
	assign inc = ~inc_button;

	// state transition logic
	always @ (posedge clk or posedge rst)
	begin
		if (rst == 1'b1)
		begin
			state = STATE_HIGH;
		end else
		begin
			case (state)
				STATE_HIGH:
					begin
						if (inc == 1'b0)
						begin
							state = STATE_LOW;
						end
					end

				STATE_LOW:
					begin
						if (inc == 1'b1)
						begin
							state = STATE_WAIT;
						end
					end

				STATE_WAIT:
					begin
						if (clk_count == MAX_CLK_COUNT)
						begin
							if (inc == 1'b1)
							begin
								state = STATE_PRESSED;
							end else
							begin
								state = STATE_HIGH;
							end
						end
					end

				STATE_PRESSED:
					begin
						led <= led + 1;
						state = STATE_HIGH;
					end

				default: state = STATE_HIGH;
			endcase
		end
	end

	// count up on clock rising edge or reset on reset button push
	always @ (posedge clk or posedge rst)
	begin
		if (rst == 1'b1)
		begin
			led <= 4'b0;
			clk_count = 20'd0;
		end else
		begin
			if (state == STATE_WAIT)
			begin
				clk_count <= clk_count + 1;
			end
		end
	end
endmodule

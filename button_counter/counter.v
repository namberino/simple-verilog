module counter(
	input clk,
	input rst_button,
	input inc_button,

	output reg[3:0] led
);
	wire rst;
	wire inc;

	reg[1:0] state;
	reg[20:0] clk_count;

	localparam STATE_PRESSED = 2'd0;
	localparam STATE_WAIT = 2'd1;
	localparam STATE_INCREMENT = 2'd2;

	localparam MAX_CLK_COUNT = 20'd960000; // 80ms delay

	assign rst = ~rst_button;
	assign inc = ~inc_button;
	
	always @ (posedge clk or posedge rst)
	begin
		if (rst == 1'b1)
		begin
			state <= STATE_PRESSED;
		end else
		begin
			case (state)
				STATE_PRESSED:
					begin
						if (inc == 1'b1)
						begin
							state <= STATE_WAIT;
						end
					end

				STATE_WAIT:
					begin
						if (clk_count == MAX_CLK_COUNT)
						begin
							if (inc == 1'b1)
							begin
								state <= STATE_INCREMENT;
							end else
							begin
								state <= STATE_PRESSED;
							end
						end
					end

				STATE_INCREMENT:
					begin
						led <= led + 1;
						state <= STATE_PRESSED;
					end
			endcase
		end
	end

	always @ (posedge clk or posedge rst)
	begin
		if (rst == 1'b1)
		begin
			clk_count = 20'd0;
			led <= 4'd0;
		end else 
		begin
			if (state == STATE_WAIT)
			begin
				clk_count <= clk_count + 1;
			end else
			begin
				clk_count <= 20'd0;
			end
		end
	end
endmodule

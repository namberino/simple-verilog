`timescale 1 ns / 10 ps

module ram_tb();
	wire[7:0] r_data;
	
	reg clk = 0;
	reg w_enable = 0;
	reg r_enable = 0;
	reg[3:0] w_addr;
	reg[3:0] r_addr;
	reg[7:0] w_data;

	integer i;

	localparam DURATION = 10000;

	always begin
		#41.67
		clk = ~clk;
	end

	ram #(.INIT_FILE("mem_init.txt")) uut( 
		.clk(clk),
		.w_enable(w_enable),
		.r_enable(r_enable),
		.w_addr(w_addr),
		.r_addr(r_addr),
		.w_data(w_data),
		.r_data(r_data)
	);

	// tests
	initial begin
		// test 1: read data
		for (i = 0; i < 16; i++)
		begin
			#(2 * 41.67)
			r_addr = i;
			r_enable = 1;

			#(2 * 41.67)
			r_addr = 0;
			r_enable = 0;
		end

		// test 2: write to address 0x0F and read it back
		#(2 * 41.67)
		w_addr = 'h0F;
		w_data = 'hA5;
		w_enable = 1;

		#(2 * 41.67)
		w_addr = 0;
		w_data = 0;
		w_enable = 0;
		r_addr = 'h0F;
		r_enable = 1;

		#(2 * 41.67)
		r_addr = 0;
		r_enable = 0;
	end
	
	initial begin
		$dumpfile("ram_tb.vcd");
		$dumpvars(0, ram_tb);

		#(DURATION)

		$display("Done");
		$finish;
	end
endmodule

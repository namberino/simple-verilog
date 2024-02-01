// infered block ram
module ram #(
	parameter INIT_FILE = ""
) (
	input clk,
	input w_enable,
	input r_enable,
	input[3:0] w_addr,
	input[3:0] r_addr,
	input[7:0] w_data,

	output reg[7:0] r_data
);
	reg[7:0] mem[0:15]; // this memory block is 16 elements deep
	
	always @ (posedge clk)
	begin
		if (w_enable == 1'b1)
		begin
			mem[w_addr] <= w_data;
		end

		if (r_enable == 1'b1)
		begin
			r_data <= mem[r_addr];
		end
	end

	// we can make it so that the memory can only receive data from this input
	// file by removing the write inputs and write logic from this file
	initial if (INIT_FILE) begin
		$readmemh(INIT_FILE, mem);
	end

endmodule

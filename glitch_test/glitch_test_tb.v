`timescale 1 ns / 1 ps

// half adder with gate delays
module half_adder (
    input a,
    input b,
    
    output sum,
    output c_out
);

    // output logic (with delay)
    assign #1 sum = a ^ b;
    assign #1 c_out = a & b;
    
endmodule

module glitch_test_tb();

    // sim time: 10000 * 1 ns = 10000 ns
    localparam DURATION = 10000;

    wire            c_0;
    wire            c_1;
    wire            c_2;
    wire    [3:0]   out;
    
    reg             clk = 0;
    reg             rst = 0;
    reg     [3:0]   count;
    
    // generate clock signal: 1 / ((2 * 4.167) * 1 ns) = 119,990,400.77 Hz
    always begin
        #4.167
        clk = ~clk;
    end
    
    half_adder ha_0 (.a(1'b1), .b(count[0]), .sum(out[0]), .c_out(c_0));
    half_adder ha_1 (.a(c_0), .b(count[1]), .sum(out[1]), .c_out(c_1));
    half_adder ha_2 (.a(c_1), .b(count[2]), .sum(out[2]), .c_out(c_2));
    half_adder ha_3 (.a(c_2), .b(count[3]), .sum(out[3]), .c_out());
    
    // let the counter count
    always @ (posedge clk or posedge rst) 
	begin
        if (rst == 1'b1) 
		begin
            count = 0;
        end else 
		begin
            count <= out;
        end
    end
    
    // pulse reset line high at the beginning
    initial begin
        #10
        rst = 1;
        #1
        rst = 0;
    end
    
    initial 
	begin
        $dumpfile("glitch_test_tb.vcd");
        $dumpvars(0, glitch_test_tb);
        
        #(DURATION)
        
        $display("Done");
        $finish;
    end
    
endmodule

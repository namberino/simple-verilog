`timescale 1 ns / 1 ps

module counter (
    input clk,
    input rst,
    
    output reg[3:0] count
);

    always @ (posedge clk or posedge rst) 
	begin
        if (rst == 1'b1) 
		begin
            count <= 0;
        end else 
		begin
            case (count)                            // state
                4'b0000:    #1 count <= 4'b0001;    // 0
                4'b0001:    #1 count <= 4'b0011;    // 1
                4'b0011:    #1 count <= 4'b0010;    // 2
                4'b0010:    #1 count <= 4'b0110;    // 3
                4'b0110:    #1 count <= 4'b0111;    // 4
                4'b0111:    #1 count <= 4'b0101;    // 5
                4'b0101:    #1 count <= 4'b0100;    // 6
                4'b0100:    #1 count <= 4'b1100;    // 7
                4'b1100:    #1 count <= 4'b1101;    // 8
                4'b1101:    #1 count <= 4'b1111;    // 9
                4'b1111:    #1 count <= 4'b1110;    // 10
                4'b1110:    #1 count <= 4'b1010;    // 11
                4'b1010:    #1 count <= 4'b1011;    // 12
                4'b1011:    #1 count <= 4'b1001;    // 13
                4'b1001:    #1 count <= 4'b1000;    // 14
                4'b1000:    #1 count <= 4'b0000;    // 15
                default:    #1 count <= 4'b0000;
            endcase
        end
    end
    
endmodule

module no_glitch_tb();
    localparam DURATION = 10000;

    wire[3:0] out;
    
    reg clk = 0;
    reg rst = 0;
    
    always begin
        #4.167
        clk = ~clk;
    end
    
    counter c1 (.clk(clk), .rst(rst), .count(out));
    
    // pulse reset line high at the beginning
    initial begin
        #10
        rst = 1;
        #1
        rst = 0;
    end
    
    initial begin
        $dumpfile("no_glitch_tb.vcd");
        $dumpvars(0, no_glitch_tb);
        
        #(DURATION)
        
        $display("Done");
        $finish;
    end
    
endmodule

module Adder #(
    parameter ADDR_W = 64
)(
    src1_i,
	src2_i,
	sum_o
);
     
//I/O ports
input  [ADDR_W-1:0]  src1_i;
input  [ADDR_W-1:0]	 src2_i;
output [ADDR_W-1:0]	 sum_o;

//Internal Signals
wire    [ADDR_W-1:0]	 sum_o;
    
//Main function
assign sum_o = src1_i + src2_i;

endmodule





                    
                    

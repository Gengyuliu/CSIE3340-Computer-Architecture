module Shift_Left_One_64 #(
    parameter ADDR_W = 64
)(
    data_i,
    data_o
);

//I/O ports                    
input [ADDR_W-1:0] data_i;
output [ADDR_W-1:0] data_o;

reg [ADDR_W-1:0] data_o;
//shift left 1

always@(*) begin
	data_o[63:1] = data_i[62:0];
	data_o[0] = 0;
    //data_o = {data_i[ADDR_W-2:0], 1'b0};
end
  
endmodule

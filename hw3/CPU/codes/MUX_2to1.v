module MUX_2to1 #(
    parameter DATA_W = 64
)(
       data0_i,
       data1_i,
       select_i,
       data_o
);

parameter size = 0;			   
			
//I/O ports               
input   [DATA_W-1:0] data0_i;          
input   [DATA_W-1:0] data1_i;
input              select_i;
output  [DATA_W-1:0] data_o; 

//Internal Signals
reg     [DATA_W-1:0] data_o;

//Main function
always@(*) begin
    data_o = (select_i)? data0_i: data1_i;
end

endmodule      
          
          

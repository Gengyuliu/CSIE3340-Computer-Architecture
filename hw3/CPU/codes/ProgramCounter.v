module ProgramCounter #(
    parameter ADDR_W = 64
)(
    clk_i,
	nrst_i,
    pc_valid_i,
    pc_in_i,
    pc_valid_o,
	pc_out_o
);
     
//I/O ports
input               clk_i;
input	            nrst_i;
input               pc_valid_i;
input  [ADDR_W-1:0] pc_in_i;
output              pc_valid_o;
output [ADDR_W-1:0] pc_out_o;
 
//Internal Signals
reg                 pc_valid_o;
reg    [ADDR_W-1:0] pc_out_o;
    
//Main function
always @(posedge clk_i) begin
    if(~nrst_i) begin
        pc_valid_o = 0;
	    pc_out_o <= 0;
    end
    else begin
        if (pc_valid_i) begin
            pc_valid_o = 1;
            pc_out_o <= pc_in_i;
        end
        else begin
            pc_valid_o = 0;
        end
    end
end

endmodule



                    
                    

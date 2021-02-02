module Reg_File #(
    parameter ADDR_W = 64,
    parameter DATA_W = 64
)(
    pc_addr_i,
    clk_i,
	nrst_i,
    RSaddr_i,
    RTaddr_i,
    RDaddr_i,
    RDdata_i,
    RegWrite_i,
    RSdata_o,
    RTdata_o,
    equal_o
);
          
//I/O ports
input  [ADDR_W-1:0] pc_addr_i;
input               clk_i;
input               nrst_i;
input               RegWrite_i;
input  [5-1:0]      RSaddr_i;
input  [5-1:0]      RTaddr_i;
input  [5-1:0]      RDaddr_i;
input  [DATA_W-1:0] RDdata_i;

output [DATA_W-1:0] RSdata_o;
output [DATA_W-1:0] RTdata_o;   
output              equal_o;
//Internal signals/registers           
reg  signed [DATA_W-1:0] REGISTER_BANK [0:32-1];     //32 word registers
wire        [DATA_W-1:0] RSdata_o;
wire        [DATA_W-1:0] RTdata_o;

//Read the data
assign RSdata_o = REGISTER_BANK[RSaddr_i] ;
assign RTdata_o = REGISTER_BANK[RTaddr_i] ;   
assign equal_o   = (RSdata_o == RTdata_o);

integer i;
//Writing data when postive edge clk_i and RegWrite_i was set.
always @( posedge clk_i  ) begin
    //$display("Reg_File.v : pc= %d, rd %d = %b", pc_addr_i,RDaddr_i,RDdata_i);
    if(nrst_i == 0) begin
        for (i = 0; i < 32; i = i + 1) begin
            REGISTER_BANK[i] <= 0;
        end
    end
    else begin
        if(RegWrite_i) 
            REGISTER_BANK[RDaddr_i] <= RDdata_i;	
		else 
		    REGISTER_BANK[RDaddr_i] <= REGISTER_BANK[RDaddr_i];
	    //$display("reg[%d] = %b", RDaddr_i, REGISTER_BANK[RDaddr_i]);
    end
end

endmodule     





                    
                    

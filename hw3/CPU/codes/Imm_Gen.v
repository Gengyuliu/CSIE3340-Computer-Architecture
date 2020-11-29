module Imm_Gen#(
    parameter INST_W = 32,
    parameter ADDR_W = 64
)(
    instr_i,
    signed_extend_o
);
               
//I/O ports
input   [INST_W-1:0] instr_i;
output  [ADDR_W-1:0] signed_extend_o;

//Internal Signals
reg     [ADDR_W-1:0] signed_extend_o;

//Sign extended
integer	i;
always@(instr_i) begin
	signed_extend_o[INST_W:0] = instr_i[31:0];
    signed_extend_o[ADDR_W-1:INST_W] = (instr_i[31])? {32{1'b1}}:{32'b0};
end
          
endmodule      
     

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
reg     [32-1:0]     immediate;
//Sign extended
integer	i;
always@(*) begin
    case (instr_i[6:0])
        7'b0000011: begin 
            /*	LD	*/
            immediate[11:0] = instr_i[31:20];
            immediate[31:12] = (immediate[11])? {20{1'b1}}:{20'b0};
        end
        7'b0100011: begin
            /*	SD	*/
            //$display("enter sd");
            immediate[11:0] = {instr_i[31:25], instr_i[11:7]};
            immediate[31:12] = (immediate[11])? {20{1'b1}}:{20'b0};
        end
        7'b1100011: begin
            /*	BEQ & BNE */
            //$display("enter BEQ");
            immediate[12:0] = {instr_i[31],instr_i[7], instr_i[30:25],instr_i[11:8], 1'b0};
            immediate[31:13] = (immediate[12])? {19{1'b1}}:{19'b0};
        end
        7'b0010011: begin
            /*	ADDI, XORI, ANDI, ORI, SLLI, SLRI	*/
            //immediate[4:0] = i_i_inst[24:20];
            immediate[11:0] = instr_i[31:20];
            immediate[31:12] = (immediate[11])? {20{1'b1}}:{20'b0};
            //$display("enter addi imm : %d", immediate);
        end
    endcase	
    signed_extend_o[INST_W:0] = immediate[31:0];
    signed_extend_o[ADDR_W-1:INST_W] = (immediate[31])? {32{1'b1}}:{32'b0};
end
endmodule      
     

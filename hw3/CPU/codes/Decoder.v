module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	Branch_o,
	MemRead_o,
	MemWrite_o,
	MemtoReg_o,
	JALornot_o
);
     
//I/O ports
input	[7-1:0]	instr_op_i;

output			RegWrite_o;
output	[2-1:0]	ALU_op_o;
output			ALUSrc_o;
output			Branch_o;
output			MemRead_o;
output			MemWrite_o;
output			MemtoReg_o;
output			JALornot_o;
 
//Internal Signals
reg	[2-1:0]		ALU_op_o;
reg				ALUSrc_o;
reg				RegWrite_o;
reg				Branch_o;
reg				MemRead_o;
reg				MemWrite_o;
reg				MemtoReg_o;
reg				JALornot_o;

initial begin
	ALUSrc_o = 0;
	RegWrite_o = 0;
	Branch_o = 0;
	MemRead_o = 0;
	MemWrite_o = 0;
	MemtoReg_o = 0;
	JALornot_o = 0;
end

//Main function
always@(*) begin
	ALUSrc_o = 0;
	RegWrite_o = 0;
	Branch_o = 0;
	MemRead_o = 0;
	MemWrite_o = 0;
	MemtoReg_o = 0;
	JALornot_o = 0;

	case(instr_op_i)
		7'b0000011: begin 
            /*	LD	*/
            ALUSrc_o = 1; 
            RegWrite_o = 1; 
            MemRead_o = 1 ;
            MemtoReg_o = 1; 
            ALU_op_o = 2'b00; 
        end 
		7'b0100011: begin 
            /*	SD	*/
            ALUSrc_o = 1; 
            MemWrite_o = 1; 
            ALU_op_o = 2'b00; 
        end 
		7'b1100011: begin 
            /*	BEQ & BNE	*/
            Branch_o = 1; 
            ALU_op_o = 2'b01; 
        end 
		7'b0010011: begin 
            /*	Arithmetic i	*/ 
            ALUSrc_o = 1; 
            RegWrite_o = 1; 
            ALU_op_o = 2'b11; 
        end 
		7'b0110011: begin 
            /*	Arithmetic	*/
            RegWrite_o = 1; 
            ALU_op_o = 2'b10; 
        end
		7'b1101111: begin 
            /*	JAL	*/
            RegWrite_o = 1; 
            Branch_o = 1; 
            JALornot_o = 1;
        end 
	endcase

end

endmodule              

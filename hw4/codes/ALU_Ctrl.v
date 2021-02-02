module ALU_Ctrl(
    funct3_i,
	funct7_i,
    ALUOp_i,
    ALUCtrl_o
);
          
//I/O ports
input      [3-1:0] funct3_i;
input      [7-1:0] funct7_i;
input      [2-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Select exact operation
always@(*) begin
	case(ALUOp_i)
		2'b00: 
                ALUCtrl_o = 4'b0010; /*	LD & SD	*/
        2'b01: begin 
            if (funct3_i == 3'b000)     
                ALUCtrl_o = 4'b0110; /*	BEQ	*/
            else if (funct3_i == 3'b001)
                ALUCtrl_o = 4'b1001;
        end
		2'b11: begin
            if (funct3_i == 3'b000) 
                ALUCtrl_o = 4'b0010;    /*	ADDI	*/
            else if (funct3_i == 3'b110) 
                ALUCtrl_o = 4'b0001;    /*  ORI	*/
            else if (funct3_i == 3'b111)
                ALUCtrl_o = 4'b0000;    /*	ANDI	*/
            else if (funct3_i == 3'b100)
                ALUCtrl_o = 4'b0111;    /*	XORI	*/
            else if (funct3_i == 3'b001) 
                ALUCtrl_o = 4'b0100;    /*	SLLI	*/
            else if (funct3_i == 3'b101)
                ALUCtrl_o = 4'b0101;    /*	SRLI	*/
        end
		2'b10:begin
				if (funct3_i == 3'b000) begin
				    if (funct7_i == 7'b0000000) 
                        ALUCtrl_o = 4'b0010;    /*	ADD	*/
					else if (funct7_i == 7'b0100000) 
                        ALUCtrl_o = 4'b0011;    /*	SUB	*/
				end
				else if (funct3_i == 3'b110) 
                    ALUCtrl_o = 4'b0001;        /*	OR	*/
				else if (funct3_i == 3'b111) 
                    ALUCtrl_o = 4'b0000;        /*	AND	*/
				else if (funct3_i == 3'b100)     
                    ALUCtrl_o = 4'b0111;        /*	XOR	*/
		end
	endcase
end

endmodule     
                    
                    

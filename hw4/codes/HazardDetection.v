module HazardDetection(
    input [4:0] rd_i,
    input MemRead_i,
    input RegWrite_i,
    input [5-1:0] rs1_i,
    input [5-1:0] rs2_i,
    input [7-1:0] opCode_i,
    output stall_o
);
reg stall;
assign stall_o = stall;
/*	combinational circuit	*/    
always @(*) begin
    if (MemRead_i && rd_i!=0 && RegWrite_i)begin
        if (rd_i==rs1_i || (rd_i==rs2_i && opCode_i!=7'b0010011 && opCode_i!=7'b0000011))
            stall = 1'b1;
        else
            stall = 1'b0;
    end
    else
        stall = 1'b0;
end
endmodule

`timescale 1ns/1ps

module ALU #(
    parameter ADDR_W = 64,
    parameter DATA_W = 64
)(
       src1,          
       src2,      
       ALU_control,  
       result,               
       //zero
);

input   [DATA_W-1:0]    src1;
input   [DATA_W-1:0]    src2;
input   [4-1:0]         ALU_control;

output reg [DATA_W-1:0]    result;
//output reg                 zero;

//reg     [DATA_W-1:0]    result;
//reg                     zero;


always@(*) begin
    //zero = 0;
    case(ALU_control) 
        4'b0010: begin
            /*	LD & ADDI& ADD	*/
            result = src1 + src2;
        end
        //4'b0110: begin
        //    /*	BEQ	*/
        //    result = 64'b0;
        //    zero   = (src1==src2)? 1:0;
        //end
        //4'b1001: begin
        //    /*	BNE	*/
        //    result = 64'b0;
        //    zero   = (src1!=src2)? 1:0;
        //end
        4'b0011: begin
            /*	SUB	*/
            result = src1 - src2;
            //$display("rs1: %d, rs2: %d", src1, src2);
        end
        4'b0001: begin
            /*	OR & ORI */
            result = src1 | src2;
        end
        4'b0000: begin
            /*	AND	& ANDI*/
            result = src1 & src2;
        end
        4'b0111: begin
            /*	XOR	& XORI*/
            result = src1 ^ src2;
        end
        4'b0100: begin
            /*	SLLI	*/
            result = src1 << src2;
        end
        4'b0101: begin
            /*	SRLI	*/
            result = src1 >> src2;
        end
        default:
            /*	DO NOT TOUCH HERE	*/
            result = 64'hffffffffffffffff; 
    endcase
end

endmodule

/*	A few bugs in bne and beq 	*/
/*	Mostly come from the pc handling	*/

`define I_LD    7'b0000011  /*	I-type(ld)	*/
`define I_IM    7'b0010011  /*	I-type(immediate)	*/
`define S_      7'b0100011  /*	S-type	*/
`define SB      7'b1100011  /*	conditional jump	*/
`define R_      7'b0110011  /*	R-type	*/

module cpu #( // Do not modify interface
	parameter ADDR_W = 64,
	parameter INST_W = 32,
	parameter DATA_W = 64
)(
    input                   i_clk,
    input                   i_rst_n,
    input                   i_i_valid_inst, // from instruction memory
    input  [ INST_W-1 : 0 ] i_i_inst,       // from instruction memory
    input                   i_d_valid_data, // from data memory
    input  [ DATA_W-1 : 0 ] i_d_data,       // from data memory
    output                  o_i_valid_addr, // to instruction memory
    output [ ADDR_W-1 : 0 ] o_i_addr,       // to instruction memory
    output [ DATA_W-1 : 0 ] o_d_w_data,     // to data memory
    output [ ADDR_W-1 : 0 ] o_d_w_addr,     // to data memory
    output [ ADDR_W-1 : 0 ] o_d_r_addr,     // to data memory
    output                  o_d_MemRead,    // to data memory
    output                  o_d_MemWrite,   // to data memory
    output                  o_finish
);

// homework
localparam CI = 3;
localparam CD = 4;
localparam L2 = 5;
localparam L3 = 7;
localparam L4 = 12;

reg                     o_finish;
/*	instruction memory	*/
reg                     o_i_valid_addr;
reg     [ADDR_W-1:0]    o_i_addr;
//reg     [INST_W-1:0]    i_i_inst;

/*	data memory	*/
reg     [DATA_W-1:0]    o_d_w_data;
reg     [ADDR_W-1:0]    o_d_w_addr, o_d_r_addr;
reg                     o_d_MemRead;
reg                     o_d_MemWrite;
reg     [DATA_W-1:0]    d_data;

/*	IF/ID	*/
reg     [INST_W-1:0]    inst;
reg     [INST_W-1:0]    IF_ID_inst; //inst
reg     [ADDR_W-1:0]    IF_ID_pc;

reg                     next_pc_valid;
reg	    [ADDR_W-1:0]	next_pc;
wire	[ADDR_W-1:0]	current_pc;
wire	[ADDR_W-1:0]	pc_1;
wire	[ADDR_W-1:0]	pc_1_extended;
wire	[ADDR_W-1:0]	pc_2;

/*	ID/EX	*/
reg     [INST_W-1:0]    ID_EX_pc;
reg     [5-1:0]         ID_EX_rs1_addr, ID_EX_rs2_addr, ID_EX_rd;
reg     [DATA_W-1:0]    ID_EX_rs1_data, ID_EX_rs2_data; 
reg     [DATA_W-1:0]    ID_EX_imm_ext;
reg     [2-1:0]         ID_EX_ALUop;
reg                     ID_EX_ALUSrc;
reg                     ID_EX_MemRd, ID_EX_MemWr, ID_EX_MemtoReg, ID_EX_RegWr;
reg     [3-1:0]         ID_EX_funct3;
reg     [7-1:0]         ID_EX_funct7;

/*	EX/MEM	*/
reg     [DATA_W-1:0]    EX_MEM_ALU_result;
reg     [DATA_W-1:0]    EX_MEM_rs2_data;
reg     [5-1:0]         EX_MEM_rd;
reg                     EX_MEM_MemRd, EX_MEM_MemWr, EX_MEM_MemtoReg, EX_MEM_RegWr;


/*	MEM/WB	*/
reg     [DATA_W-1:0]    MEM_WB_MemData;
reg     [DATA_W-1:0]    wait1_ALU_result, wait2_ALU_result, MEM_WB_ALU_result;
reg     [5-1:0]         wait1_rd, wait2_rd, MEM_WB_rd;
reg                     wait1_MemtoReg, wait2_MemtoReg, MEM_WB_MemtoReg;
reg                     wait1_RegWr, wait2_RegWr, MEM_WB_RegWr;
reg                     wait1_MemRd, wait2_MemRd;
/*	connecting wire	*/
/*	module output	*/
wire    [5-1:0]         ID_rs1_addr, ID_rs2_addr, ID_rd;
wire    [7-1:0]         ID_OpCode;
wire    [3-1:0]         ID_funct3;
wire    [7-1:0]         ID_funct7;
wire	[ADDR_W-1:0]	imm_ext;
wire	[ADDR_W-1:0]	immediate_pc;
wire	[DATA_W-1:0]	Reg_rs1_data, Reg_rs2_data;
wire	[DATA_W-1:0]	rd;
wire 	[DATA_W-1:0]	WB_data;
wire	[DATA_W-1:0]	ALU_rs2_data;
wire	[ADDR_W-1:0]	ALU_result;
wire	[4-1:0]		    ALU_control;
wire	[DATA_W-1:0]	memory_output;
wire	[2-1:0]		    ALU_op;
reg	    [L2-1:0]		previous_RD;

wire            pc_valid;
reg     [4:0]   cs_i, ns_i;     /*	current state, next state	*/
reg     [4:0]   cs_d, ns_d;     /*		*/
reg             stop;
reg			    branchornot;
wire			equal;
wire            ALUSrc;
wire			Branch, MemRd, MemtoReg, MemWr, RegWr, JALornot;

wire            Hazard, Stall;
wire            hang;

integer j;


/*	wire assignment	*/
assign ID_next_pc   = (~next_pc_valid && branchornot)? pc_2 : pc_1; 

assign ID_rs1_addr  = IF_ID_inst[19:15];
assign ID_rs2_addr  = IF_ID_inst[24:20];
assign ID_rd        = IF_ID_inst[11:7];
assign ID_OpCode    = IF_ID_inst[6:0];
assign ID_funct3    = IF_ID_inst[14:12];
assign ID_funct7    = IF_ID_inst[31:25];


assign WB_data     = (MEM_WB_MemtoReg)? d_data:MEM_WB_ALU_result;
)
assign Stall = Hazard;
/*	Initialize	*/
initial begin
    next_pc_valid = 1;
    next_pc[ADDR_W-1:0] = {64{1'b0}};
    //imm[INST_W-1:0] = 32'b0;
end


always@(posedge i_clk) begin
    if (pc_valid) begin
        o_i_valid_addr = 1;
        o_i_addr = current_pc;
        next_pc_valid = 0;
        //inst = 32'b0;
    end
    else begin
        o_i_valid_addr = 0;
    end
    
    if (i_d_valid_data)
        d_data = i_d_data;

    //if (cs_i == 1 && ~next_pc_valid ) begin
    //    next_pc = (branchornot)? pc_2:pc_1;
    //    next_pc_valid = 1;
    //end

    /*	IF/ID	*/
    IF_ID_pc            <= Stall ? IF_ID_pc : current_pc;
    IF_ID_inst          <= Stall ? IF_ID_inst : i_i_inst;
    /*	ID/EX	*/
    ID_EX_rd            <= ID_rd;
    ID_EX_imm_ext       <= imm_ext;
    
    ID_EX_ALUop         <= ALU_op;
    ID_EX_ALUSrc        <= ALUSrc;
    ID_EX_MemtoReg      <= MemtoReg & ~Stall;
    ID_EX_RegWr         <= RegWr & ~Stall;
    ID_EX_MemRd         <= MemRd;
    ID_EX_MemWr         <= MemWr;
    ID_EX_rs1_data      <= Reg_rs1_data;
    ID_EX_rs2_data      <= Reg_rs2_data;  
    ID_EX_funct3        <= ID_funct3;
    ID_EX_funct7        <= ID_funct7;
    /*	EX/MEM	*/
    EX_MEM_rs2_data     <= ID_EX_rs2_data;
    EX_MEM_ALU_result   <= ALU_result;
    EX_MEM_rd           <= ID_EX_rd;
    EX_MEM_MemtoReg     <= ID_EX_MemtoReg;
    EX_MEM_RegWr        <= ID_EX_RegWr; 
    EX_MEM_MemWr        <= ID_EX_MemWr;
    EX_MEM_MemRd        <= ID_EX_MemRd; 
    /*	MEM/WB	*/
    wait1_ALU_result    <= EX_MEM_ALU_result;
    wait1_rd            <= EX_MEM_rd;
    wait1_MemtoReg      <= EX_MEM_MemtoReg;
    wait1_RegWr         <= EX_MEM_RegWr;
    wait1_MemRd         <= EX_MEM_MemRd;

    wait2_rd            <= wait1_rd;
    wait2_ALU_result    <= wait1_ALU_result;
    wait2_MemtoReg      <= wait1_MemtoReg;
    wait2_RegWr         <= wait1_RegWr;
    wait2_MemRd         <= wait1_MemRd;

    MEM_WB_rd           <= EX_MEM_MemRd | wait2_MemRd? wait2_rd : EX_MEM_rd; 
    MEM_WB_ALU_result   <= EX_MEM_MemRd | wait2_MemRd? wait2_ALU_result : EX_MEM_ALU_result;
    MEM_WB_MemtoReg     <= EX_MEM_MemRd | wait2_MemRd? wait2_MemtoReg : EX_MEM_MemtoReg; 
    MEM_WB_RegWr        <= EX_MEM_MemRd | wait2_MemRd? wait2_RegWr : EX_MEM_RegWr; 
end

//always@( negedge i_clk) begin
//    previous_RD = inst[L2+L3-1:L3]; /*	save rd: inst[11:7]	*/    
//end

always@(posedge i_clk or negedge i_rst_n) begin
    if (~i_rst_n) begin
        cs_i = 0;
        cs_d = 0;
    end
    else begin
        cs_i = ns_i;
        cs_d = ns_d;
    end
end


/*	hang for 12 cycles	*/
always@(*) begin
    case (cs_i)
        0:  ns_i = (o_i_valid_addr)? 1:0;
        1:  ns_i = 2;
        2:  ns_i = 3;
        //3:  ns_i = 4;
        //4:  ns_i = 5;
        CI: ns_i = 0; 
    endcase
    case (cs_d)
        0:  ns_d = (cs_i == CI)? 1:0;
        1:  ns_d = 2;
        2:  ns_d = 3;
        3:  ns_d = 4;
        //4:  ns_d = 5;
        CD: ns_d = 0; 
    endcase

    /*	IF	*/
    if (cs_i == CI) begin
        //inst = i_i_inst;
        stop = &i_i_inst;
        o_finish = (stop)? 1'b1:1'b0;
    end
end

/*	IF stage	*/
ProgramCounter _PC(
    .clk_i(i_clk),
    .nrst_i(i_rst_n),
    .pc_valid_i(next_pc_valid),
    .pc_in_i(next_pc),
    .pc_valid_o(pc_valid),
    .pc_out_o(current_pc)
);


/*	ID stage	*/
Reg_File _REG(
    .pc_addr_i(IF_ID_pc),
    .clk_i(i_clk),
    .nrst_i(i_rst_n),
    .RSaddr_i(ID_rs1_addr),
    .RTaddr_i(ID_rs2_addr),
    .RDaddr_i(MEM_WB_rd),
    .RDdata_i(WB_data),
    .RegWrite_i(MEM_WB_RegWr),
    .RSdata_o(Reg_rs1_data),
    .RTdata_o(Reg_rs2_data),
    .equal_o(equal)
);

Decoder _DE(
    .instr_op_i(ID_OpCode),
    .cs_i(cs_d),
    .RegWrite_o(RegWr),
    .ALU_op_o(ALU_op),
    .ALUSrc_o(ALUSrc),
    .Branch_o(Branch),
    .MemRead_o(MemRd),
    .MemWrite_o(MemWr),
    .MemtoReg_o(MemtoReg),
    .JALornot_o(JALornot)
);

/*	instruction is ready	*/
Imm_Gen _ImmG(
    .instr_i(IF_ID_inst),
    .signed_extend_o(imm_ext)
);

/*	PC = PC + 4	*/
Adder _Adder1(
    .src1_i(IF_ID_pc),
    .src2_i(64'b100),
    .sum_o(pc_1)
);

/*	PC = PC + offset 	*/
Adder _Adder2(
    .src1_i(IF_ID_pc), 
    .src2_i(imm_ext),
    .sum_o(pc_2)
);

always@(*) begin
    if (ALU_op == 2'b01) begin
        case (ID_funct3)
            3'b000: /*	BEQ	*/
                branchornot = Branch & equal;
            3'b001: /*	BNE	*/
                branchornot = Branch & ~equal;
            default:
                branchornot = 0;
        endcase   
    end 
    else begin
        branchornot = 0;
    end
end

/*	EX stage	*/
ALU_Ctrl _AC(
    .funct3_i(ID_EX_funct3),
    .funct7_i(ID_EX_funct7),
    .ALUOp_i(ID_EX_ALUop),
    .ALUCtrl_o(ALU_control)
);

MUX_2to1 Mux_ALUSrc(
    .data0_i(imm_ext),
    .data1_i(ID_EX_rs2_data),
    .select_i(ID_EX_ALUSrc),
    .data_o(ALU_rs2_data)
);

ALU ALU_RegtoData(
    .src1(ID_EX_rs1_data), 
    .src2(ALU_rs2_data),
    .ALU_control(ALU_control),
    .result(ALU_result)
    //.zero(zeroornot)
);


always@(*) begin
    o_d_w_data  = EX_MEM_rs2_data;
    o_d_w_addr  = EX_MEM_ALU_result;
    o_d_r_addr  = EX_MEM_ALU_result;
    o_d_MemRead = EX_MEM_MemRd;
    o_d_MemWrite= EX_MEM_MemWr;
end


/*	Hazard	*/
HazardDetection HzrdDetect(
    .rd_i(ID_EX_rd),
    .MemRead_i(ID_EX_MemtoReg),
    .RegWrite_i(ID_EX_RegWr),
    .rs1_i(ID_rs1_addr),
    .rs2_i(ID_rs2_addr),
    .opCode_i(ID_OpCode),
    .stall_o(Hazard)
);
endmodule




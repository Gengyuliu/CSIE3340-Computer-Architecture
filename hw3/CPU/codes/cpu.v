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
    output [ DATA_W-1 : 0 ] o_d_data,       // to data memory
    output [ ADDR_W-1 : 0 ] o_d_addr,       // to data memory
    output                  o_d_MemRead,    // to data memory
    output                  o_d_MemWrite,   // to data memory
    output                  o_finish
);

// homework
localparam L1 = 3;
localparam L2 = 5;
localparam L3 = 7;
localparam L4 = 12;

reg                     o_finish;
/*	instruction memory	*/
reg                     o_i_valid_addr;
reg     [ADDR_W-1:0]    o_i_addr;
//reg     [INST_W-1:0]    i_i_inst;

/*	data memory	*/
reg     [DATA_W-1:0]    o_d_data;
reg     [DATA_W-1:0]    o_d_addr;
reg                     o_d_MemRead;
reg                     o_d_MemWrite;
reg     [DATA_W-1:0]    d_data;

//wire	[ADDR_W-1:0]	next_pc;
reg     [INST_W-1:0]    inst;
reg                     next_pc_valid;
reg	    [ADDR_W-1:0]	next_pc;
wire	[ADDR_W-1:0]	current_pc;
wire	[ADDR_W-1:0]	pc_1;
wire	[ADDR_W-1:0]	pc_1_extended;
wire	[ADDR_W-1:0]	pc_2;
wire	[INST_W-1:0]	instruction;
reg	    [INST_W-1:0]	immediate;
wire	[ADDR_W-1:0]	immediate_extended;
wire	[ADDR_W-1:0]	immediate_pc;
wire	[DATA_W-1:0]	rs1;
wire	[DATA_W-1:0]	rs2;
wire	[DATA_W-1:0]	rd;
reg 	[DATA_W-1:0]	rd_final;
wire	[DATA_W-1:0]	rs2_selected;
wire	[ADDR_W-1:0]	ALU_result;
wire	[4-1:0]		    ALU_control;
wire	[DATA_W-1:0]	memory_output;
wire	[2-1:0]		    ALU_op;
reg	    [L2-1:0]		previous_RD;

wire            pc_valid;
reg     [4:0]   cs_i, ns_i;     /*	current state, next state	*/
reg     [3:0]   cs_d, ns_d;     /*		*/
reg             stop;
reg			    branchornot;
wire			zeroornot;
wire			Branch;
wire			MemRead;
wire			MemtoReg;
wire			MemWrite;
wire			ALUSrc;
wire			RegWrite;
wire			JALornot;

integer j;
/*	Initialize	*/
initial begin
    //o_i_valid_addr = 1;
    next_pc_valid = 1;
    next_pc[ADDR_W-1:0] = {64{1'b0}};
    immediate[INST_W-1:0] = 32'b0;
end

/*		*/
ProgramCounter PC(
    .clk_i(i_clk),
    .nrst_i(i_rst_n),
    .pc_valid_i(next_pc_valid),
    .pc_in_i(next_pc),
    .pc_valid_o(pc_valid),
    .pc_out_o(current_pc)
);

always@(posedge i_clk) begin
    if (pc_valid) begin
        o_i_valid_addr = 1;
        o_i_addr = current_pc;
        next_pc_valid = 0;
    end
    else begin
        o_i_valid_addr = 0;
    end
    
    //$display("current pc:(%d)", o_i_addr);
    //o_i_valid_addr = 0; 
    /*	stall for 12 cycles	??*/
end

always@( negedge i_clk) begin
    previous_RD = inst[L2+L3-1:L3]; /*	save rd: inst[11:7]	*/    
end

/*	hang for 12 cycles	*/
always@(*) begin
    case (cs_i)
        0:  ns_i = (o_i_valid_addr)? 1:0;
        1:  ns_i = 2;
        2:  ns_i = 3;
        3:  ns_i = 4;
        4:  ns_i = 5;
        5:  ns_i = 6;
        6:  ns_i = 7;
        7:  ns_i = 8;
        8:  ns_i = 9;
        9:  ns_i = 10;
        10: ns_i = 11;
        11: ns_i = 12;
        12: ns_i = 13;
        13: ns_i = 14;
        14: ns_i = 15;
        15: ns_i = 16;
        16: ns_i = 0; 
    endcase
    if (o_i_valid_addr)
        inst = 32'b0;
end


always@(posedge i_clk or negedge i_rst_n) begin
    if (~i_rst_n) begin
        cs_i = 0;
    end
    else begin
        cs_i = ns_i;
        /*	fetch instruction	*/
        if (i_i_valid_inst) begin 
            //$display("cs:%d  in cpu.v: store test:inst-->%b", cs, i_i_inst);
            //o_i_valid_addr = 0;;
            /*	STOP	*/ 
            stop = &i_i_inst; 
            o_finish = (stop)? 1'b1:1'b0;
            inst = i_i_inst; 
        end 
        //rd_final = (i_d_valid_data)? i_d_data:ALU_result;
        //$display("rd_final: %b", rd_final);
    end
end


Reg_File REG(
    .pc_addr_i(current_pc),
    .clk_i(i_clk),
    .nrst_i(i_rst_n),
    .RSaddr_i(inst[19:15]),
    .RTaddr_i(inst[24:20]),
    .RDaddr_i(previous_RD),
    .RDdata_i(rd_final),
    .RegWrite_i(RegWrite),
    .RSdata_o(rs1),
    .RTdata_o(rs2)
);

Decoder DE(
    .instr_op_i(inst[L3-1:0]),
    .RegWrite_o(RegWrite),
    .ALU_op_o(ALU_op),
    .ALUSrc_o(ALUSrc),
    .Branch_o(Branch),
    .MemRead_o(MemRead),
    .MemWrite_o(MemWrite),
    .MemtoReg_o(MemtoReg),
    .JALornot_o(JALornot)
);

ALU_Ctrl AC(
    .funct3_i(inst[14:12]),
    .funct7_i(inst[31:25]),
    .ALUOp_i(ALU_op),
    .ALUCtrl_o(ALU_control)
);

/*	instruction is ready	*/
always@(i_i_valid_inst) begin
    case (i_i_inst[L3-1:0])
        7'b0000011: begin 
            /*	LD	*/
            immediate[11:0] = i_i_inst[31:20];
            immediate[31:12] = (immediate[11])? {20{1'b1}}:{20'b0};
        end
        7'b0100011: begin
            /*	SD	*/
            //$display("enter sd");
            immediate[11:0] = {i_i_inst[31:25], i_i_inst[11:7]};
            immediate[31:12] = (immediate[11])? {20{1'b1}}:{20'b0};
        end
        7'b1100011: begin
            /*	BEQ & BNE */
            //$display("enter BEQ");
            immediate[12:0] = {i_i_inst[31],i_i_inst[7], i_i_inst[30:25],i_i_inst[11:8], 1'b0};
            immediate[31:13] = (immediate[12])? {19{1'b1}}:{19'b0};
        end
        7'b0010011: begin
            /*	ADDI, XORI, ANDI, ORI, SLLI, SLRI	*/
            //immediate[4:0] = i_i_inst[24:20];
            immediate[11:0] = i_i_inst[31:20];
            immediate[31:12] = (immediate[11])? {20{1'b1}}:{20'b0};
            //$display("enter addi imm : %d", immediate);
        end
    endcase
end

Imm_Gen IG(
    .instr_i(immediate),
    .signed_extend_o(immediate_extended)
);

MUX_2to1 Mux_ALUSrc(
    .data0_i(immediate_extended),
    .data1_i(rs2),
    .select_i(ALUSrc),
    .data_o(rs2_selected)
);

ALU ALU_RegtoData(
    .src1(rs1), 
    .src2(rs2_selected),
    .ALU_control(ALU_control),
    .result(ALU_result),
    .zero(zeroornot)
);


always@(*) begin
    o_d_data      = rs2;
    o_d_addr      = ALU_result;
    o_d_MemRead   = MemRead;
    o_d_MemWrite  = MemWrite;
end

/*	PC = PC + 4	*/
Adder Adder1(
    .src1_i(current_pc),
    .src2_i(64'b100),
    .sum_o(pc_1)
);

/*	offset*2	*/
Shift_Left_One_64 Shifter(
    .data_i(immediate_extended),
    .data_o(immediate_pc)
);

/*	PC = PC + offset 	*/
Adder Adder2(
    .src1_i(current_pc), 
    .src2_i(immediate_extended),
    .sum_o(pc_2)
);

always@(Branch or zeroornot) begin
    branchornot = Branch & zeroornot;
end

always@(posedge i_clk) begin
    if (i_d_valid_data)
        d_data = i_d_data;

    if (cs_i == 16 && ~next_pc_valid) begin
        next_pc = (branchornot)? pc_2:pc_1;
        next_pc_valid = 1;
    end

    if (cs_i == 16) begin
        rd_final = (MemtoReg)?d_data:ALU_result;
    end
    //rd_final = (MemtoReg && i_d_valid_data)? i_d_data : ALU_result;
end
endmodule




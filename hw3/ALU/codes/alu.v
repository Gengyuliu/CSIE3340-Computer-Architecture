`define ADD     4'b0000
`define SUB     4'b0001
`define MUL     4'b0010
`define MAX     4'b0011
`define MIN     4'b0100
`define ADD_U   4'b0101
`define SUB_U   4'b0110
`define MUL_U   4'b0111
`define MAX_U   4'b1000
`define MIN_U   4'b1001
`define AND     4'b1010
`define OR      4'b1011
`define XOR     4'b1100
`define BITFLIP 4'b1101
`define BITRVRS 4'b1110  

    


module alu #(
    parameter DATA_WIDTH = 32,
    parameter INST_WIDTH = 4
)(
    input                   i_clk,      /*	Clock signal	*/
    input                   i_rst_n,    /*	Active low asynchronous reset	*/
    input  [DATA_WIDTH-1:0] i_data_a,   /*	Input data A may be signed or unsigned	*/
    input  [DATA_WIDTH-1:0] i_data_b,   /*	Input data B	*/
    input  [INST_WIDTH-1:0] i_inst,     /*	Instruction signal representing functions to be performed	*/
    input                   i_valid,    /*	One clock signal when input data a and b are valud	*/
    output [DATA_WIDTH-1:0] o_data,     /*	Calculation result	*/
    output                  o_overflow, /*	Overflow signal	*/
    output                  o_valid     /*	Should be one cycle signal when your result are valid	*/
);

    // homework
    localparam MSB = DATA_WIDTH - 1;
    reg [DATA_WIDTH-1:0] o_data;
    reg o_overflow;
    reg o_valid;
    reg extra;
    reg [DATA_WIDTH-1:0] tmp;
    integer i;
    integer high, low, maskHigh;
    integer leftmost_bit_a, leftmost_bit_b;
    integer cnt;


    always@(posedge i_clk && i_valid) begin
        o_overflow = 0;
        case (i_inst)
            `ADD: begin 
            {extra, o_data}={i_data_a[MSB],i_data_a}+{i_data_b[MSB],i_data_b}; 
            if ({extra, o_data[MSB]}==2'b01 || {extra, o_data[MSB]}==2'b10) 
                o_overflow = 1;
            end
            `SUB: begin
                {extra, o_data}={i_data_a[MSB],i_data_a}-{i_data_b[MSB],i_data_b};
                if ({extra, o_data[MSB]}==2'b01 || {extra, o_data[MSB]}==2'b10)
                    o_overflow = 1;
            end
            `MUL: begin
                o_data = i_data_a*i_data_b;
                if (o_data[MSB] != i_data_a[MSB]^i_data_b[MSB])
                   o_overflow = 1; 
            end
            `MAX: begin
                if ($signed(i_data_a) > $signed(i_data_b)) begin 
                    o_data = i_data_a;
                end
                else begin
                    o_data = i_data_b;
                end
            end
            `MIN: begin
                if ($signed(i_data_a) < $signed(i_data_b)) begin
                    o_data = i_data_a;
                end
                else begin
                    o_data = i_data_b;
                end
            end
            `ADD_U: begin
                extra = i_data_a[MSB] + i_data_b[MSB];
                o_data = i_data_a+i_data_b;
                if (({extra,o_data[MSB]}==2'b00 && i_data_a[MSB]==1'b1 && i_data_b[MSB]==1'b1) || {extra, o_data[MSB]}==2'b10)
                   o_overflow = 1; 
            end
            `SUB_U: begin
                o_data = i_data_a - i_data_b;
                if ( i_data_a < i_data_b )
                  o_overflow = 1;  
                
            end
            `MUL_U: begin
                o_data  = i_data_a*i_data_b;
                
                high    = 32;
                low     = 0;
                while (high -low > 1) begin
                    leftmost_bit_a = (high + low)>>1;
                    maskHigh = (1<<high) - (1<<leftmost_bit_a);
                    if ((maskHigh & i_data_a) > 0)
                        low = leftmost_bit_a;
                    else
                        high = leftmost_bit_a;
                end

                high    = 32;
                low     = 0;
                while (high - low > 1) begin
                    leftmost_bit_b = (high + low)>>1;
                    maskHigh = (1<<high) - (1<<leftmost_bit_b);
                    if ((maskHigh & i_data_b) > 0)
                        low = leftmost_bit_b;
                    else
                        high = leftmost_bit_b; 
                end

                if (leftmost_bit_a + leftmost_bit_b > 31)
                    o_overflow = 1;
            end
            `MAX_U: begin
                if (i_data_a > i_data_b)
                    o_data = i_data_a;
                else 
                    o_data = i_data_b;
            
            end
            `MIN_U: begin
                if (i_data_a < i_data_b)
                    o_data = i_data_a;
                else
                    o_data = i_data_b;
            end
            `AND: begin
                o_data = i_data_a & i_data_b;
            
            end
            `OR: begin
                o_data = i_data_a | i_data_b;
            end
            `XOR: begin
                o_data = i_data_a ^ i_data_b;  
            end
            `BITFLIP: begin
                o_data = ~i_data_a;
            end
            `BITRVRS: begin
                cnt     = DATA_WIDTH - 1;
                tmp     = i_data_a;
                o_data  = i_data_a;            
                
                tmp = tmp >>1;
                while(tmp) begin
                    o_data = o_data << 1;
                    o_data = o_data | (tmp&1);
                    tmp    = tmp >> 1;
                    cnt    = cnt -1;
                end
                o_data = o_data << cnt;
            end
        endcase
        o_valid = 1;
    end     

endmodule

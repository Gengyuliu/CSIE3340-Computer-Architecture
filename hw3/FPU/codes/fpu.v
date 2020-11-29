`define ADD 1'b0
`define MUL 1'b1

module fpu #(
    parameter DATA_WIDTH = 32,
    parameter INST_WIDTH = 1
)(
    input                   i_clk,
    input                   i_rst_n,
    input  [DATA_WIDTH-1:0] i_data_a,
    input  [DATA_WIDTH-1:0] i_data_b,
    input  [INST_WIDTH-1:0] i_inst,
    input                   i_valid,
    output [DATA_WIDTH-1:0] o_data,
    output                  o_valid
);
   
    localparam FRAC_WIDTH = 23;
    localparam EXP_WIDTH = 8;
    reg cmp_enable;
    //reg [DATA_WIDTH-1:0] i_data_a;
    //reg [DATA_WIDTH-1:0] i_data_b;
    reg [DATA_WIDTH-1:0]    a, b;
    reg [DATA_WIDTH-1:0]    o_data;
    reg [FRAC_WIDTH:0]      sig_a, sig_b;
    reg o_valid;
    
    /*	addition	*/
    reg perform;
    reg [EXP_WIDTH-1:0] exp_a, exp_b, exp_diff;
    
    reg [FRAC_WIDTH:0] sig_b_shift;
    reg [EXP_WIDTH-1:0] exp_b_shift;

    reg [FRAC_WIDTH+1:0] sig_add;
    reg [DATA_WIDTH-2:0] add_sum;
    reg sign_a, sign_b;
    reg R;
    reg S;
    integer i; 
    
    /*	multiplication	*/
    reg sign;
    reg product_round, normalized;

    reg [EXP_WIDTH:0] o_exp, exp_sum;
    reg [FRAC_WIDTH-1:0] o_sig;
    reg [2*FRAC_WIDTH+1:0] sig_product, product_norm;
    // homework
    
    always@(posedge i_clk && i_valid) begin 
        case(i_inst)
            `ADD: begin
                /*	a must always be no less than b	*/
                {cmp_enable, a, b} = (i_data_a[DATA_WIDTH-2:0]>i_data_b[DATA_WIDTH-2:0])? {1'b0, i_data_a, i_data_b} : {1'b1, i_data_b, i_data_a};
                /*	sign	*/
                sign_a = a[DATA_WIDTH-1]? 1 : 0;
                sign_b = (b[DATA_WIDTH-1])? 1 : 0;

                exp_a = a[DATA_WIDTH-2:FRAC_WIDTH];
                exp_b = b[DATA_WIDTH-2:FRAC_WIDTH];
                
                sig_a = {1'b1, a[FRAC_WIDTH-1:0]};
                sig_b = {1'b1, b[FRAC_WIDTH-1:0]};
                
                /*	do the alignment	*/
                exp_diff = exp_a - exp_b;
                //$display("exp_diff : %d", exp_diff);
                sig_b_shift = sig_b >> exp_diff;
                exp_b_shift = exp_b + exp_diff;
                S = 0;
                if (exp_diff > 1) begin
                    for (i = 0; i < exp_diff-1; i = i+1)begin
                        S = S| sig_b[i];
                    end
                end

                perform = (exp_a == exp_b_shift); //check exponents are same   
                 
                /*	add	*/
                if (perform) begin
                    if ((!sign_a && !sign_b) || (sign_a && sign_b))
                        sig_add = sig_a + sig_b_shift;
                    else if ((!sign_a && sign_b) || (sign_a && !sign_b) )
                        sig_add = sig_a - sig_b_shift;

                    //$display(">>\n%b\n%b\n%b", sig_a, sig_b_shift, sig_add);
                end
                add_sum[FRAC_WIDTH-1:0] = (sig_add[FRAC_WIDTH+1])? sig_add[FRAC_WIDTH:1]: sig_add[FRAC_WIDTH-1:0]; 
                
                add_sum[DATA_WIDTH-2:FRAC_WIDTH] = (sig_add[FRAC_WIDTH+1])? 1'b1 + exp_a: exp_a;
                R = (sig_add[FRAC_WIDTH+1])? sig_add[0]: sig_b[exp_diff-1];
                S = (sig_add[FRAC_WIDTH+1])? S|sig_b[exp_diff-1]: S;

                if ({R,S} == 2'b11 || ({R,S}==2'b10 && add_sum[0])) begin
                    /*	some tricky here	*/ 
                    add_sum = (sign_a || sign_b)?add_sum-1:add_sum + 1;
                end
                 
                o_data = {sign_a, add_sum};
                //$display("%b %b %b", a[31], a[30:23], a[22:0]);
                //$display("%b %b %b", b[31], b[30:23], b[22:0]);
                //$display("%b %b %b", o_data[31], o_data[30:23], o_data[22:0]);
            end
            `MUL: begin
                sig_a = {1'b1, i_data_a[FRAC_WIDTH-1:0]}; 
                sig_b = {1'b1, i_data_b[FRAC_WIDTH-1:0]};
               
                /*	sign	*/
                sign = i_data_a[DATA_WIDTH-1]^i_data_b[DATA_WIDTH-1];

                /*	handle mantissa product	*/ 
                sig_product = sig_a*sig_b;
                product_round = |sig_product[FRAC_WIDTH-1:0];
                normalized = sig_product[2*FRAC_WIDTH+1]? 1'b1: 1'b0;
                
                sig_product = normalized? sig_product : sig_product << 1;
                o_sig = sig_product[2*FRAC_WIDTH:FRAC_WIDTH+1] + (sig_product[FRAC_WIDTH] & product_round);
                
                /*	exponent sum	*/
                exp_sum = i_data_a[DATA_WIDTH-2:FRAC_WIDTH] + i_data_b[DATA_WIDTH-2:FRAC_WIDTH];
                o_exp = exp_sum - 8'd127 + normalized;

                o_data = {sign, o_exp[EXP_WIDTH-1:0], o_sig};
            end
        endcase
        o_valid = 1;
    end   

endmodule

module new_cmm #(parameter data_width = 12)(
    input clk,rst,
    input [data_width-1:0] A,
    input [data_width-1:0] B,
    input sel,
    output wire [data_width-1:0] C_out
);


    parameter Br = 13'd5039;
    parameter PBr = 26'd46063009;
    parameter q = 12'd3329;


    parameter PBr_low =13'd7585;
    parameter PBr_up  =13'd5622;

    wire [data_width-1:0] A_q1;
    // wire [data_width*2-1:0] z,z_q1,z_q2,z_q3;
    wire [data_width:0] z_shift; 
    wire [data_width:0] mux_out1;
    wire [data_width+1:0] mux_out2,mux_out3,mux_out4;
    wire [2*data_width+1:0] mul1,mul1_q,mul1_q1,mul1_q2;
    wire [data_width:0] z_shift;
    wire [3*data_width:0] p_shift;
    wire [3*data_width:0] adder;
    wire [2*data_width+1:0] mul2,mul2_q;
    wire [2*data_width:0] mul3,mul3_q;
    reg  [2*data_width+1:0] a_s;
    reg  [data_width:0] a_s_reg;
    wire [data_width:0] p,p_b;
    wire  [2*data_width-1:0] p_out;
    wire  [data_width-1:0] b_out;
    wire [11:0] p_reg;
    wire  [data_width-1:0] P_out,B_out;
    wire sign;


    assign mux_out1 = sel == 1'b0 ? PBr_up : B;
    assign mul1 = A * mux_out1; //26
    DFF #(.data_width(26)) d0(.clk(clk),.rst(rst),.d(mul1),.q(mul1_q));
    DFF #(.data_width(26)) d1(.clk(clk),.rst(rst),.d(mul1_q),.q(mul1_q1));

    assign z_shift = mul1_q[23:11]; //13
    assign p_shift = mul1_q1 <<(data_width+1); //37

    DFF #(.data_width(12)) d2(.clk(clk),.rst(rst),.d(A),.q(A_q1));  
    assign mux_out2 = sel == 1'b0 ? A_q1 : Br;         //13
    assign mux_out3 = sel == 1'b0 ? PBr_low : z_shift; //13

    assign mul2 = mux_out2 * mux_out3;                 //26
    DFF #(.data_width(26)) d3(.clk(clk),.rst(rst),.d(mul2),.q(mul2_q));
    assign adder = p_shift + mul2_q; //37
    assign mux_out4 = sel == 1'b0 ? adder[25:13] :  mul2[24:13]; //13

    assign mul3 = mux_out4 *q;
    DFF #(.data_width(25)) d4(.clk(clk),.rst(rst),.d(mul3),.q(mul3_q));
    DFF #(.data_width(26)) d5(.clk(clk),.rst(rst),.d(mul1_q1),.q(mul1_q2));   
   
   always @(*) begin
        if(~sel)
            begin
                a_s   = mul3_q + q;
                a_s_reg = a_s[25:13];
            end
        else 
            begin
                a_s   = mul1_q2  - mul3_q;
                a_s_reg = a_s[12:0];
            end
   end

    assign p = a_s_reg;

    DFF #(.data_width(13)) d6(.clk(clk),.rst(rst),.d(p),.q(p_b));   

    assign P_out = (p_b== q) ? 0: p_b;

    assign {sign,b_out} = p_b - q ;
    assign B_out = sign == 1? p_b : b_out;
    assign C_out = sel == 1'b0 ? P_out:B_out;


endmodule
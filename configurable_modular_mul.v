module configurable_modular_mul #(parameter data_width = 12)(
    input clk,rst,
    input [data_width-1:0] A,
    input [data_width-1:0] B,
    input sel,
    output wire [data_width-1:0] C_out
);
    // wire clk_c;
    // assign clk_c = clk & sel;

    parameter Br = 13'd5039;
    parameter PBr = 26'd46063009;
    parameter q = 12'd3329;


    wire [data_width-1:0] A_q1,A_q2;
    wire [data_width*2-1:0] z,z_q1,z_q2,z_q3;
    wire [data_width:0] z_shift; 
    wire [data_width:0] mux_out1;
    wire [2*data_width+1:0] mux_out2;
    wire [3*data_width:0] mul1,mul1_q;
    wire [data_width:0] mul1_shift;
    wire [2*data_width:0] mul2,mul2_q;
    reg  [2*data_width+1:0] a_s;
    reg  [data_width:0] a_s_reg;
    wire [data_width:0] p,p_b;
    wire  [2*data_width-1:0] p_out;
    wire  [data_width-1:0] b_out;
    wire [11:0] p_reg;
    wire  [data_width-1:0] P_out,B_out;
    wire sign;


    assign z = A*B;
    DFF #(.data_width(24)) d0(.clk(clk),.rst(rst),.d(z),.q(z_q1));

    assign z_shift = z_q1[23:11];

    DFF #(.data_width(12)) d6(.clk(clk),.rst(rst),.d(A),.q(A_q1));  
    // DFF #(.data_width(12)) d7(.clk(clk),.rst(rst),.d(A_q1),.q(A_q2));    

    assign mux_out1 = sel == 1'b0 ? A_q1 : z_shift;
    assign mux_out2 = sel == 1'b0 ? PBr : Br;
    
    assign mul1 = mux_out1 * mux_out2;
    DFF #(.data_width(37)) d1(.clk(clk),.rst(rst),.d(mul1),.q(mul1_q));

    assign mul1_shift = sel == 1'b0 ? mul1_q[25:13] : mul1_q[24:13] ;

    assign mul2 = mul1_shift * q ;
    DFF #(.data_width(25)) d2(.clk(clk),.rst(rst),.d(mul2),.q(mul2_q));

    DFF #(.data_width(24)) d3(.clk(clk),.rst(rst),.d(z_q1),.q(z_q2));        
    DFF #(.data_width(24)) d4(.clk(clk),.rst(rst),.d(z_q2),.q(z_q3));   

   always @(*) begin
        if(~sel)
            begin
                a_s   = mul2_q + q;
                a_s_reg = a_s[25:13];
            end
        else 
            begin
                a_s   = z_q3  - mul2_q;
                a_s_reg = a_s[12:0];
            end
   end

    assign p = a_s_reg;

    DFF #(.data_width(13)) d5(.clk(clk),.rst(rst),.d(p),.q(p_b));   

    assign P_out = (p_b== q) ? 0: p_b;

    assign {sign,b_out} = p_b - q ;
    assign B_out = sign == 1? p_b : b_out;
    assign C_out = sel == 1'b0 ? P_out:B_out;

endmodule
module plantard_mm #(parameter data_width = 12)(
    input clk,rst,
    input [data_width-1:0] A_in, 
    output wire [data_width-1:0]  C_out
    );

    // parameter B = 12'd2285
    // parameter B = 12'd2721     //将(c_mod * B )mod q  结果

    parameter BR = 38'd167080025505;
    parameter BR_shift = 26'd46063009;
    parameter R = 26'd61403905;
    parameter q = 12'd3329;
    parameter c_mod = 12'd447;

    wire [36:0] mul1; 
    wire [36:0] mul1_q; 
    wire [12:0] mul1_shift; 

    wire [24:0] mul2; // 12+13=25位
    wire [24:0] mul2_q; // 12+13=25位

    wire [25:0] add;
    wire [25:0] add_q;

    wire [23:0] C;
    
    wire [11:0] c_out;
    wire [11:0] c_d;

    assign mul1 = BR_shift * A_in;
    DFF #(.data_width(37)) d1(.clk(clk),.rst(rst),.d(mul1),.q(mul1_q));
    assign mul1_shift = mul1_q[25:13];

    assign mul2 = mul1_shift * q;
    DFF #(.data_width(25)) d2(.clk(clk),.rst(rst),.d(mul2),.q(mul2_q));

    assign add = mul2_q + q;
    DFF #(.data_width(26)) d3(.clk(clk),.rst(rst),.d(add),.q(add_q));

    // assign C = add_q[25:13] * c_mod;
    assign C = add_q[25:13];

    // assign c_out = C % q;
    assign c_d = (C == q) ? 0 : C;
    DFF #(.data_width(24)) d4(.clk(clk),.rst(rst),.d(c_d),.q(C_out));

endmodule


//可以为三个周期输出结果
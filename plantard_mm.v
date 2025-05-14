// module plantard_mm #(parameter data_width = 12)(
//     input clk,rst,
//     input [data_width-1:0] A_in, 
//     output wire [data_width-1:0]  C_out
//     );

//     // parameter B = 12'd2285
//     // parameter B = 12'd2721     //将(c_mod * B )mod q  结果

//     parameter BR = 38'd167080025505;
//     parameter BR_shift = 26'd46063009;
//     parameter R = 26'd61403905;
//     parameter q = 12'd3329;
//     parameter c_mod = 12'd447;

//     wire [36:0] mul1; 
//     wire [36:0] mul1_q; 
//     wire [12:0] mul1_shift; 

//     wire [24:0] mul2; // 12+13=25位
//     wire [24:0] mul2_q; // 12+13=25位

//     wire [25:0] add;
//     wire [25:0] add_q;

//     wire [23:0] C;
    
//     wire [11:0] c_out;
//     wire [11:0] c_d;

//     assign mul1 = BR_shift * A_in;
//     DFF #(.data_width(37)) d1(.clk(clk),.rst(rst),.d(mul1),.q(mul1_q));
//     assign mul1_shift = mul1_q[25:13];

//     assign mul2 = mul1_shift * q;
//     DFF #(.data_width(25)) d2(.clk(clk),.rst(rst),.d(mul2),.q(mul2_q));

//     assign add = mul2_q + q;
//     DFF #(.data_width(26)) d3(.clk(clk),.rst(rst),.d(add),.q(add_q));

//     // assign C = add_q[25:13] * c_mod;
//     assign C = add_q[25:13];

//     // assign c_out = C % q;
//     assign c_d = (C == q) ? 0 : C;
//     DFF #(.data_width(24)) d4(.clk(clk),.rst(rst),.d(c_d),.q(C_out));

// endmodule


//可以为三个周期输出结果

module plantard_mm #(parameter data_width = 12)(
    input clk,rst,
    input [data_width-1:0] A_in, 
    output wire [data_width-1:0]  C_out
    );

    // parameter B = 12'd2285       14'd10810
    // parameter B = 12'd2721     //将(c_mod * B )mod q  结果
    // parameter B = 14'd10810       14'd10810
    // parameter B = 14'd6421     //将(c_mod * B )mod q  结果

    parameter PBR = 38'd167080025505;
    parameter PBR_shift = 26'd46063009;
    parameter R = 26'd61403905;
    parameter q = 12'd3329;
    parameter c_mod = 12'd447;
    parameter PBr_low =13'd7585;
    parameter PBr_up  =13'd5622;


    wire [24:0] mul1; 
    wire [24:0] mul1_q; 
    wire [37:0] mul1_shift; 
    // wire [13:0] A_in_q1; 

    wire [24:0] mul2; // 15+14=29位
    wire [24:0] mul2_q; 

    wire [24:0] mul3; // 15+14=29位
    wire [24:0] mul3_q; 

    wire [37:0] adder;
    wire [12:0] adder_s;
    wire [12:0] adder_shift;
    wire [25:0] add;
    wire [25:0] add_q;

    wire [12:0] C;
    
    // wire [14:0] c_out;
    wire [11:0] c_d;

    assign mul1 = PBr_up * A_in; //13+12 25
    DFF #(.data_width(25)) d0(.clk(clk),.rst(rst),.d(mul1),.q(mul1_q));
    assign mul1_shift = mul1_q <<(data_width+1); //25+13 38

    // DFF #(.data_width(14)) d1(.clk(clk),.rst(rst),.d(A_in),.q(A_in_q1));  
    assign mul2 = A_in * PBr_low;
    DFF #(.data_width(25)) d1(.clk(clk),.rst(rst),.d(mul2),.q(mul2_q));

    assign adder = mul1_shift + mul2_q; //38
    assign adder_s = adder[25:13]; //12
    DFF #(.data_width(13)) d2(.clk(clk),.rst(rst),.d(adder_s),.q(adder_shift));

    assign mul3 = adder_shift * q; 
    DFF #(.data_width(25)) d3(.clk(clk),.rst(rst),.d(mul3),.q(mul3_q));

    assign add = mul3_q + q;
    DFF #(.data_width(26)) d4(.clk(clk),.rst(rst),.d(add),.q(add_q));

    // assign C = add_q[25:13] * c_mod;
    assign C = add_q[25:13];

    assign C_out = (C == q) ? 0 : C;

endmodule
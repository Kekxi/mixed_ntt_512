module plantard_mm #(parameter data_width = 14)(
    input clk,rst,
    input [data_width-1:0] A_in, 
    output wire [data_width-1:0]  C_out
    );

    // parameter B = 12'd2285       14'd10810
    // parameter B = 12'd2721     //将(c_mod * B )mod q  结果
    // parameter B = 14'd10810       14'd10810
    // parameter B = 14'd6421     //将(c_mod * B )mod q  结果

    parameter PBR = 44'd969459640597;
    parameter PBR_shift = 30'd944515349;
    parameter R = 30'd150982657;
    parameter q = 14'd12289;
    parameter c_mod = 14'd9551;
    parameter PBr_low =15'd10517;
    parameter PBr_up  =15'd28824;


    wire [28:0] mul1; 
    wire [28:0] mul1_q; 
    wire [43:0] mul1_shift; 
    // wire [13:0] A_in_q1; 

    wire [28:0] mul2; // 15+14=29位
    wire [28:0] mul2_q; 

    wire [28:0] mul3; // 15+14=29位
    wire [28:0] mul3_q; 

    wire [43:0] adder;
    wire [14:0] adder_s,adder_shift;
    wire [29:0] add;
    wire [29:0] add_q;

    wire [23:0] C;
    
    // wire [14:0] c_out;
    wire [14:0] c_d;

    assign mul1 = PBr_up * A_in; //15+14 29 
    DFF #(.data_width(29)) d0(.clk(clk),.rst(rst),.d(mul1),.q(mul1_q));
    assign mul1_shift = mul1_q <<(data_width+1); //29+15=44

    // DFF #(.data_width(14)) d1(.clk(clk),.rst(rst),.d(A_in),.q(A_in_q1));  
    assign mul2 = A_in * PBr_low;
    DFF #(.data_width(29)) d2(.clk(clk),.rst(rst),.d(mul2),.q(mul2_q));

    assign adder = mul1_shift + mul2_q; //44
    assign adder_s = adder[29:15]; //15
    DFF #(.data_width(15)) d6(.clk(clk),.rst(rst),.d(adder_s),.q(adder_shift));

    assign mul3 = adder_shift * q; 
    DFF #(.data_width(29)) d3(.clk(clk),.rst(rst),.d(mul3),.q(mul3_q));

    assign add = mul3_q + q;
    DFF #(.data_width(30)) d4(.clk(clk),.rst(rst),.d(add),.q(add_q));

    // assign C = add_q[25:13] * c_mod;
    assign C = add_q[29:15];

    // assign c_out = C % q;
    assign C_out = (C == q) ? 0 : C;
    // DFF #(.data_width(15)) d5(.clk(clk),.rst(rst),.d(c_d),.q(C_out));

endmodule
module configurable_modular_mul #(parameter data_width = 14)(
    input clk,rst,
    input [data_width-1:0] A,
    input [data_width-1:0] B,
    input sel,
    output wire [data_width-1:0] C_out
);

    parameter Br = 15'h5553;
    parameter PBr = 30'd944515349;
    parameter q = 14'd12289;
    parameter PBr_low =15'd10517;
    parameter PBr_up  =15'd28824;

    wire [data_width:0] mux_out1,mux_out2,mux_out3,mux_out4;
    wire [2*data_width:0] mul1,mul1_q,mul1_q1,mul1_q2,mul3,mul3_q;  //[28:0]
    wire [2*data_width+1:0] mul2,mul2_q;  //[29:0]
    wire [data_width:0] z_shift;
    wire [43:0] p_shift; 
    wire [43:0] adder;
    wire [14:0] adder_s,adder_shift;
    reg  [2*data_width+1:0] a_s; //[29:0]
    reg  [data_width:0] a_s_reg;
    wire [data_width:0] p,p_b;
    wire [data_width-1:0] b_out;
    wire [data_width-1:0] P_out,B_out;
    wire sign;

    assign mux_out1 = sel == 1'b0 ? PBr_up : B; //15
    assign mul1 = A * mux_out1; //14+15 = 29
    DFF #(.data_width(29)) d0(.clk(clk),.rst(rst),.d(mul1),.q(mul1_q));
    assign z_shift = mul1_q[27:13]; //14
    assign p_shift = mul1_q <<(data_width+1); //29+15=44

    // DFF #(.data_width(14)) d1(.clk(clk),.rst(rst),.d(A),.q(A_q));  
    assign mux_out2 = sel == 1'b0 ? A : Br;
    assign mux_out3 = sel == 1'b0 ? PBr_low : z_shift;
    assign mul2 = mux_out2 * mux_out3;    //14+15=29
    DFF #(.data_width(30)) d2(.clk(clk),.rst(rst),.d(mul2),.q(mul2_q));

    assign adder = p_shift + mul2_q; //37
    assign adder_s = adder[29:15];
    DFF #(.data_width(15)) d3(.clk(clk),.rst(rst),.d(adder_s),.q(adder_shift));
    assign mux_out4 = sel == 1'b0 ? adder_shift:  mul2_q[29:15]; 
    assign mul3 = mux_out4 *q;  //14+14 =28
    DFF #(.data_width(29)) d4(.clk(clk),.rst(rst),.d(mul3),.q(mul3_q));
    DFF #(.data_width(29)) d5(.clk(clk),.rst(rst),.d(mul1_q),.q(mul1_q1));   
    DFF #(.data_width(29)) d6(.clk(clk),.rst(rst),.d(mul1_q1),.q(mul1_q2));

   always @(*) begin
        if(~sel)
            begin
                a_s   = mul3_q + q;   //30
                a_s_reg = a_s[29:15];
            end
        else 
            begin
                a_s   = mul1_q2  - mul3_q;
                a_s_reg = a_s[14:0];
            end
   end

    assign p = a_s_reg;

    DFF #(.data_width(15)) d7(.clk(clk),.rst(rst),.d(p),.q(p_b));   

    assign P_out = (p_b== q) ? 0: p_b;

    assign {sign,b_out} = p_b - q ;
    assign B_out = sign == 1? p_b : b_out;
    assign C_out = sel == 1'b0 ? P_out:B_out;





//     assign z = A*B;

//     DFF #(.data_width(14)) d1(.clk(clk),.rst(rst),.d(A),.q(A_q1));      
//     DFF #(.data_width(28)) d0(.clk(clk),.rst(rst),.d(z),.q(z_q1));
    
//     assign z_shift = z_q1[27:13];
//     // DFF #(.data_width(12)) d_mux1(.clk(clk),.rst(rst),.d(A_q1),.q(A_q1_reg));  
//     // DFF #(.data_width(14)) d_mux2(.clk(clk),.rst(rst),.d(z_shift),.q(z_shift_reg));  
//     // DFF #(.data_width(12)) d7(.clk(clk),.rst(rst),.d(A_q1),.q(A_q2));    

//     assign mux_out1 = sel == 1'b0 ? A_q1 :z_shift;
//     assign mux_out2 = sel == 1'b0 ? PBr : Br;
    
//     assign mul1 = mux_out1 * mux_out2;

//     DFF #(.data_width(42)) d2(.clk(clk),.rst(rst),.d(mul1),.q(mul1_q));

//     assign mul1_shift = sel == 1'b0 ? mul1_q[29:15] : mul1_q[28:15];

//     assign mul2 = mul1_shift * q;
//     DFF #(.data_width(29)) d3(.clk(clk),.rst(rst),.d(mul2),.q(mul2_q));

//     DFF #(.data_width(28)) d4(.clk(clk),.rst(rst),.d(z_q1),.q(z_q2));        
//     DFF #(.data_width(28)) d5(.clk(clk),.rst(rst),.d(z_q2),.q(z_q3));   

//    always @(*) begin
//         if(~sel)
//             begin
//                 a_s   = mul2_q + q;
//                 a_s_reg = a_s[29:15];
//             end 
//         else 
//             begin
//                 a_s   = z_q3  - mul2_q;
//                 a_s_reg = a_s[14:0];
//             end
//    end

//     assign p = a_s_reg;

//     DFF #(.data_width(15)) d6(.clk(clk),.rst(rst),.d(p),.q(p_b));   

//     assign P_out = (p_b== q) ? 0: p_b;

//     assign {sign,b_out} = p_b - q ;
//     assign B_out = sign == 1? p_b : b_out;
//     assign C_out = sel == 1'b0 ? P_out:B_out;

endmodule
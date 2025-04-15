`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/25 19:15:35
// Design Name: 
// Module Name: compact_bf
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PE2 #(parameter data_width = 12)(
    input clk,rst,
    input [data_width-1:0] u,v,w1,w2,
    input sel,
    input sel_ntt,
    output [data_width-1:0] bf_upper,bf_lower
    );
    
    wire [data_width-1:0] u_q1;
    wire [data_width-1:0] w1_q1,w2_q1;
    // wire [data_width-1:0] mux_out3,mux_out4;
    // wire [data_width-1:0] mux_out5,mux_out6,mux_out7,mux_out8;
    wire [data_width-1:0] v_q1;
    wire [data_width-1:0] mult_out1,mult_out2,add_out,sub_out;
    wire [data_width-1:0] add_out_q1,sub_out_q1;
    wire [data_width-1:0] sub_op1,sub_op2;
    wire [data_width-1:0] half_out1,half_out2;
    
    DFF dff_u(.clk(clk),.rst(rst),.d(u),.q(u_q1));
    
    DFF dff_w1(.clk(clk),.rst(rst),.d(w1),.q(w1_q1));

    modular_mul mult1_pe2(.clk(clk),.rst(rst),.A_in(u_q1),.B_in(w1_q1),.P_out(mult_out1));

    modular_add  add(
               .x_add(mult_out1),
               .y_add(mult_out2),
               .z_add(add_out));

    DFF dff_add(.clk(clk),.rst(rst),.d(add_out),.q(add_out_q1));
    
    assign bf_lower = add_out_q1;
    
    //mux about signal v
    DFF dff_v(.clk(clk),.rst(rst),.d(v),.q(v_q1));
    // assign mux_out5 = v_q1;
    
    DFF dff_w2(.clk(clk),.rst(rst),.d(w2),.q(w2_q1));

    modular_mul mult2_pe2(.clk(clk),.rst(rst),.A_in(v_q1),.B_in(w2_q1),.P_out(mult_out2));

    assign sub_op1 = mult_out1;
    assign sub_op2 = mult_out2;
    modular_substraction  sub(.x_sub(sub_op1),.y_sub(sub_op2),.z_sub(sub_out)); 
    DFF dff_sub(.clk(clk),.rst(rst),.d(sub_out),.q(sub_out_q1));   
    assign bf_upper = sub_out_q1; 
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/06 19:45:50
// Design Name: 
// Module Name: PE3
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


module PE3 #(parameter data_width = 12)(
        input clk,rst,
        input [data_width-1:0] u,v,
        input sel,
        input sel_ntt,
        output [data_width-1:0] bf_upper,bf_lower
        );
       

    parameter const_w = 3095;
    
    wire [data_width-1:0] u_q1,u_q5;
    wire [data_width-1:0] mux_out1,mux_out2,mux_out3;
    // wire [data_width-1:0] mux_out5;
    wire [data_width-1:0] mux_out4,mux_out5;
    wire [data_width-1:0] v_q1;
    wire [data_width-1:0] mult_out_1,mult_out_2;
    wire [data_width-1:0] mult_out,add_out,sub_out;
    wire [data_width-1:0] add_out_q1,sub_out_q1,add_out_q5;
    wire [data_width-1:0] sub_op1,sub_op2;
    wire [data_width-1:0] half_out1,half_out2;
    
    //mux about signal u 
    DFF dff_u(.clk(clk),.rst(rst),.d(u),.q(u_q1));
    shift_4  shf_u (.clk(clk),.rst(rst),.din(u_q1),.dout(u_q5));
    assign mux_out1 = u_q5;
    
    //mux about signal v
    DFF dff_v(.clk(clk),.rst(rst),.d(v),.q(v_q1));
    assign mux_out3 = v_q1;
    plantard_mm mult_pe3 (.clk(clk),.rst(rst),.A_in(mux_out3),.C_out(mult_out));
    assign mux_out2 = mult_out;
    
    //mux about tf
    // DFF dff_w(.clk(clk),.rst(rst),.d(w),.q(w_q1));
    // assign mux_out4 = const_w;

    // mux about sub
    // assign mux_out5 = mux_out4;
    assign sub_op1  = mux_out1;
    assign sub_op2  = mux_out2;
    modular_substraction  sub(.x_sub(sub_op1),.y_sub(sub_op2),.z_sub(sub_out)); 
    DFF dff_sub(.clk(clk),.rst(rst),.d(sub_out),.q(sub_out_q1));   

    modular_add  add(
               .x_add(mux_out1),
               .y_add(mux_out2),
               .z_add(add_out));
    
    DFF dff_add(.clk(clk),.rst(rst),.d(add_out),.q(add_out_q1));

    assign bf_lower = add_out_q1;
    assign bf_upper = sub_out_q1;                
endmodule

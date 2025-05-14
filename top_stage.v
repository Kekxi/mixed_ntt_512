`timescale 1ns / 1ps
module top_stage(
    input clk,rst,
    input [3:0] conf,
    output [1:0] done_flag);

    //fsm port signal
    wire sel;
    // wire sel_ntt;
    wire [6:0] i;
    wire [6:0] k,j;
    wire [2:0] p;
//     wire [1:0] done_flag;
    wire wen,ren,en;

    //stage_address_generator port signal
    wire [8:0] old_address_0,old_address_1,old_address_2,old_address_3;

    // data_in 
    wire [11:0] q0,q1,q2,q3;

    // radix-4_bf_out  bf_0_upper,bf_0_lower
    wire [11:0] bf_0_upper,bf_0_lower;
    wire [11:0] bf_1_upper,bf_1_lower;

    //data into bfu
    wire [11:0] u0,v0,u1,v1;

    // //data into banks
    wire [11:0] d0,d1,d2,d3;

    //memory map port signal
    wire [6:0] new_address_0,new_address_1,new_address_2,new_address_3;
    wire [1:0] bank_number_0,bank_number_1,bank_number_2,bank_number_3;    

    //arbiter port signal
    wire [1:0] sel_a_0,sel_a_1,sel_a_2,sel_a_3;

    wire [6:0] bank_address_0,bank_address_1,bank_address_2,bank_address_3; 
    wire [6:0] bank_address_0_dy_reg_s,bank_address_1_dy_reg_s,bank_address_2_dy_reg_s,bank_address_3_dy_reg_s;
    wire [6:0] bank_address_0_dy_reg_i,bank_address_1_dy_reg_i,bank_address_2_dy_reg_i,bank_address_3_dy_reg_i;

    wire [6:0] bank_address_0_dy,bank_address_1_dy;
    wire [6:0] bank_address_2_dy,bank_address_3_dy;    


    assign bank_address_0_dy = sel == 0 ?  bank_address_0_dy_reg_s :bank_address_0_dy_reg_i;
    assign bank_address_1_dy = sel == 0 ?  bank_address_1_dy_reg_s :bank_address_1_dy_reg_i;
    assign bank_address_2_dy = sel == 0 ?  bank_address_2_dy_reg_s :bank_address_2_dy_reg_i;
    assign bank_address_3_dy = sel == 0 ?  bank_address_3_dy_reg_s :bank_address_3_dy_reg_i;

    //twiddle factors into banks
    wire [35:0] w;  
    wire [11:0] win1,win2,win3;
    
    //twiddle factor address
    wire [6:0] tf_address;

  (*DONT_TOUCH = "true"*) 
    fsm m1( .clk(clk),.rst(rst),
            .conf(conf),
            .sel(sel),
            .i(i),
            .j(j),
            .k(k),
            .p(p),
            .wen(wen),
            .ren(ren),
            .en(en),
            .done_flag(done_flag));

  (*DONT_TOUCH = "true"*) 
    address_generator m2(
               .i(i),
               .j(j),
               .k(k),
               .p(p),               
               .old_address_0(old_address_0),.old_address_1(old_address_1),
               .old_address_2(old_address_2),.old_address_3(old_address_3));

  (*DONT_TOUCH = "true"*) 
   conflict_free_memory_map map(
              .clk(clk),
              .rst(rst),
              .old_address_0(old_address_0),
              .old_address_1(old_address_1),
              .old_address_2(old_address_2),
              .old_address_3(old_address_3),
              .new_address_0(new_address_0),
              .new_address_1(new_address_1),
              .new_address_2(new_address_2),
              .new_address_3(new_address_3),
              .bank_number_0(bank_number_0),
              .bank_number_1(bank_number_1),
              .bank_number_2(bank_number_2),
              .bank_number_3(bank_number_3));    

  (*DONT_TOUCH = "true"*) 
  arbiter m3(
             .a0(bank_number_0),.a1(bank_number_1),
             .a2(bank_number_2),.a3(bank_number_3),
             .sel_a_0(sel_a_0),.sel_a_1(sel_a_1),
             .sel_a_2(sel_a_2),.sel_a_3(sel_a_3)); 


  (*DONT_TOUCH = "true"*) 
  network_bank_in mux1(
                 .b0(new_address_0),.b1(new_address_1),
                 .b2(new_address_2),.b3(new_address_3),
                 .sel_a_0(sel_a_0),.sel_a_1(sel_a_1),
                 .sel_a_2(sel_a_2),.sel_a_3(sel_a_3),
                 .new_address_0(bank_address_0),.new_address_1(bank_address_1),
                 .new_address_2(bank_address_2),.new_address_3(bank_address_3)
                 );    

   shifter #(.data_width(7) ,.depth(7))   shf1 (.clk(clk),.rst(rst),.din(bank_address_0),.dout(bank_address_0_dy_reg_s));   
   shifter #(.data_width(7) ,.depth(7))   shf2 (.clk(clk),.rst(rst),.din(bank_address_1),.dout(bank_address_1_dy_reg_s)); 
   shifter #(.data_width(7) ,.depth(7))   shf3 (.clk(clk),.rst(rst),.din(bank_address_2),.dout(bank_address_2_dy_reg_s)); 
   shifter #(.data_width(7) ,.depth(7))   shf4 (.clk(clk),.rst(rst),.din(bank_address_3),.dout(bank_address_3_dy_reg_s));     

   shifter #(.data_width(7)  ,.depth(13)) shf5 (.clk(clk),.rst(rst),.din(bank_address_0),.dout(bank_address_0_dy_reg_i));   
   shifter #(.data_width(7)  ,.depth(13)) shf6 (.clk(clk),.rst(rst),.din(bank_address_1),.dout(bank_address_1_dy_reg_i)); 
   shifter #(.data_width(7)  ,.depth(13)) shf7 (.clk(clk),.rst(rst),.din(bank_address_2),.dout(bank_address_2_dy_reg_i)); 
   shifter #(.data_width(7)  ,.depth(13)) shf8 (.clk(clk),.rst(rst),.din(bank_address_3),.dout(bank_address_3_dy_reg_i));       
    
  (*DONT_TOUCH = "true"*) 
  data_bank bank_0(
                   .clk(clk),
                   .A1(bank_address_0_dy),
                   .A2(bank_address_0),
                   .D(d0),
                   .IWEN(wen),
                   .IREN(ren),
                   .IEN(en),
                   .Q(q0));

  (*DONT_TOUCH = "true"*)          
  data_bank bank_1(
                   .clk(clk),
                   .A1(bank_address_1_dy),
                   .A2(bank_address_1),
                   .D(d1),
                   .IWEN(wen),
                   .IREN(ren),
                   .IEN(en),
                   .Q(q1));

  (*DONT_TOUCH = "true"*)              
  data_bank bank_2(
                   .clk(clk),
                   .A1(bank_address_2_dy),
                   .A2(bank_address_2),
                   .D(d2),
                   .IWEN(wen),
                   .IREN(ren),
                   .IEN(en),
                   .Q(q2));  

  (*DONT_TOUCH = "true"*)         
  data_bank bank_3(
                   .clk(clk),
                   .A1(bank_address_3_dy),
                   .A2(bank_address_3),
                   .D(d3),
                   .IWEN(wen),
                   .IREN(ren),
                   .IEN(en),
                   .Q(q3));

  (*DONT_TOUCH = "true"*) 
   network_bf_in mux2(
                      .clk(clk),.rst(rst),
                      .sel_a_0(sel_a_0),.sel_a_1(sel_a_1),.sel_a_2(sel_a_2),
                      .sel_a_3(sel_a_3),
                      .q0(q0),.q1(q1),.q2(q2),.q3(q3),
                      .u0(u0),.v0(v0),.u1(u1),.v1(v1)); 

  (*DONT_TOUCH = "true"*) 
   compact_bf bf(
           .clk(clk),
           .rst(rst),
           .u0(u0),.v0(u1),.u1(v0),.v1(v1),
           .wa1(win1),.wa2(win2),.wa3(win3),
           .sel(sel),
           .bf_0_upper(bf_0_upper),.bf_0_lower(bf_0_lower),
           .bf_1_upper(bf_1_upper),.bf_1_lower(bf_1_lower)); 

  (*DONT_TOUCH = "true"*) 
  network_bf_out mux4(
                       .clk(clk),.rst(rst),
                       .sel(sel),
                       .bf_0_upper(bf_0_upper),.bf_0_lower(bf_0_lower),
                       .bf_1_upper(bf_1_upper),.bf_1_lower(bf_1_lower),
                       .sel_a_0(sel_a_0),.sel_a_1(sel_a_1),
                       .sel_a_2(sel_a_2),
                       .sel_a_3(sel_a_3),
                       .d0(d0),.d1(d1),.d2(d2),.d3(d3));  

  tf_address_generator m_tf(.clk(clk),.rst(rst),.conf(conf),.k(k),.p(p),.tf_address(tf_address));  
  
  assign win1 = w[35:24];
  assign win2 = w[23:12];
  assign win3 = w[11:0];

  (*DONT_TOUCH = "true"*) 
  tf_ROM rom0(
              .clk(clk),
              .A(tf_address),
              .IREN(ren),
              .Q(w));

endmodule
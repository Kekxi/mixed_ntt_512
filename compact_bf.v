
(*DONT_TOUCH = "true"*) 
module compact_bf #(parameter data_width = 14)(
        input clk,rst,
        input [data_width-1:0] u0,v0,u1,v1,
        input [data_width-1:0] wa1,wa2,wa3,
        input sel,
        input sel_ntt,
        output [data_width-1:0] bf_0_upper,bf_0_lower,bf_1_upper,bf_1_lower
        );
        wire [data_width-1:0] PE0_in_up,PE0_in_low,PE0_out_up,PE0_out_low;
        wire [data_width-1:0] PE1_in_up,PE1_in_low,PE1_out_up,PE1_out_low;
        wire [data_width-1:0] PE2_in_up,PE2_in_low,PE2_out_up,PE2_out_low;
        wire [data_width-1:0] PE3_in_up,PE3_in_low,PE3_out_up,PE3_out_low;

        reg [data_width-1:0] PE0_in_up_reg,PE0_in_low_reg;
        reg [data_width-1:0] PE1_in_up_reg,PE1_in_low_reg;
        reg [data_width-1:0] PE2_in_up_reg,PE2_in_low_reg;
        reg [data_width-1:0] PE3_in_up_reg,PE3_in_low_reg;
        reg [data_width-1:0] bf_0_upper_reg,bf_0_lower_reg,bf_1_upper_reg,bf_1_lower_reg;

        PE0 m_pe0(
             .clk(clk),.rst(rst),
             .sel(sel),
             .sel_ntt(sel_ntt),
             .u(PE0_in_up),.v(PE0_in_low),.w(wa2),
             .bf_upper(PE0_out_low),.bf_lower(PE0_out_up));
        PE1 m_pe1(
             .clk(clk),.rst(rst),
             .sel(sel),
             .sel_ntt(sel_ntt),
             .u(PE1_in_up),.v(PE1_in_low),
             .bf_upper(PE1_out_low),.bf_lower(PE1_out_up));     
        PE2 m_pe2(
              .clk(clk),.rst(rst),
              .u(PE2_in_up),.v(PE2_in_low),.w1(wa1),.w2(wa3),
              .sel(sel),
              .sel_ntt(sel_ntt),
              .bf_upper(PE2_out_low),.bf_lower(PE2_out_up));       
        PE3 m_pe3(
              .clk(clk),.rst(rst),
              .u(PE3_in_up),.v(PE3_in_low),
              .sel(sel),
              .sel_ntt(sel_ntt),
              .bf_upper(PE3_out_low),.bf_lower(PE3_out_up));
              

 
     assign PE0_in_up =  PE0_in_up_reg;
     assign PE0_in_low = PE0_in_low_reg;
     assign PE1_in_up =  PE1_in_up_reg;
     assign PE1_in_low = PE1_in_low_reg;
     assign PE2_in_up =  PE2_in_up_reg;
     assign PE2_in_low = PE2_in_low_reg;
     assign PE3_in_up =  PE3_in_up_reg;
     assign PE3_in_low = PE3_in_low_reg;
     assign bf_0_upper = bf_0_upper_reg;
     assign bf_0_lower = bf_0_lower_reg;
     assign bf_1_upper = bf_1_upper_reg;
     assign bf_1_lower = bf_1_lower_reg;    
     

      always@(*)
     begin
          if((~sel) & (~sel_ntt))
          begin
               PE0_in_up_reg  <= u0;
               PE0_in_low_reg <= v0;
               PE2_in_up_reg  <= 0;
               PE2_in_low_reg <= 0;
               PE1_in_up_reg  <= 0;
               PE1_in_low_reg <= 0;
               PE3_in_up_reg  <= u1;
               PE3_in_low_reg <= v1;
               bf_0_lower_reg <= PE0_out_up; 
               bf_0_upper_reg <= PE3_out_up;
               bf_1_lower_reg <= PE0_out_low;
               bf_1_upper_reg <= PE3_out_low;
          end
          else if((sel) & (~sel_ntt))
          begin
               PE0_in_up_reg  <= u0;
               PE0_in_low_reg <= v0;
               PE2_in_up_reg  <= u1;
               PE2_in_low_reg <= v1;
               PE1_in_up_reg  <= PE0_out_up;
               PE1_in_low_reg <= PE2_out_up;
               PE3_in_up_reg  <= PE0_out_low;
               PE3_in_low_reg <= PE2_out_low;
               bf_0_lower_reg <= PE1_out_up; 
               bf_0_upper_reg <= PE3_out_up;
               bf_1_lower_reg <= PE1_out_low;
               bf_1_upper_reg <= PE3_out_low;
          end
          else if((sel) & (sel_ntt))
          begin
               PE0_in_up_reg  <= PE3_out_up;
               PE0_in_low_reg <= PE1_out_up;
               PE2_in_up_reg  <= PE3_out_low;
               PE2_in_low_reg <= PE1_out_low;
               PE1_in_up_reg  <= u1;
               PE1_in_low_reg <= v1;
               PE3_in_up_reg  <= u0;
               PE3_in_low_reg <= v0;
               bf_0_lower_reg <= PE0_out_up;
               bf_0_upper_reg <= PE2_out_up;
               bf_1_lower_reg <= PE0_out_low;
               bf_1_upper_reg <= PE2_out_low;
          end
          else 
          begin
               PE0_in_up_reg  <= u1;
               PE0_in_low_reg <= v1;
               PE2_in_up_reg  <= 0;
               PE2_in_low_reg <= 0;
               PE1_in_up_reg  <= 0;
               PE1_in_low_reg <= 0;
               PE3_in_up_reg  <= u0;
               PE3_in_low_reg <= v0;
               bf_0_lower_reg <= PE0_out_up; 
               bf_0_upper_reg <= PE0_out_low;
               bf_1_lower_reg <= PE3_out_up;
               bf_1_upper_reg <= PE3_out_low;
          end
     end  

endmodule
module fsm (
  input clk,rst,
  input [3:0] conf,
  output wire sel,
  // output wire sel_ntt,
  output wire [6:0] i,
  output wire [6:0] k, //max = 127
  output wire [6:0] j, //max = 127
  output wire [2:0] p, //max = 2
  output wire wen,
  output wire ren,
  output wire en,
  output wire [2:0] done_flag);
  
  parameter IDLE = 4'b0000;
  parameter RADIX2_NTT = 4'b0001;
  parameter RADIX4_NTT = 4'b0010;
  parameter DONE_RADIX2_NTT = 4'b0011;
  parameter DONE_RADIX4_NTT = 4'b0100;
  parameter RADIX2_INTT = 4'b0110;
  parameter RADIX4_INTT = 4'b0101;
  parameter DONE_RADIX2_INTT = 4'b0111;
  parameter DONE_RADIX4_INTT = 4'b1000;

  // wire clk_en;
  // assign clk_en = clk & (~sel);

  // wire clk_c;
  // assign clk_c = clk & (sel);

  // reg sel_reg_ntt;
  reg sel_reg;
  reg wen_reg,ren_reg,en_reg;
  wire wen_s,en_reg_q_s;
  wire wen_i,en_reg_q_i;
  wire en_reg_q,en_reg_q_tmp;
  reg [2:0] conf_state;
  reg [6:0] i_reg;
  reg [6:0] k_reg,j_reg;
  reg [2:0] p_reg;
  reg [3:0] done_reg;
  wire [1:0] end_stage,begin_stage;
  wire [3:0] p_shift;
  
  assign i = i_reg;
  assign j = j_reg;
  assign k = k_reg;
  assign p = p_reg;
  assign done_flag = done_reg;

  assign en = ((conf == DONE_RADIX4_NTT) || (conf == DONE_RADIX2_NTT) || (conf == DONE_RADIX2_INTT) || (conf == DONE_RADIX4_INTT)) ? en_reg_q : en_reg_q_tmp;

  shift_8 #(.data_width(1)) shif_iwen_s(.clk(clk),.rst(rst),.din(iwen_reg),.dout(iwen_s));
  shift_7 #(.data_width(1)) shif_ien_s(.clk(clk),.rst(rst),.din(ien_reg_q_tmp),.dout(ien_reg_q_s));

  shift_14 #(.data_width(1)) shif_iwen_i(.clk(clk),.rst(rst),.din(iwen_reg),.dout(iwen_i));
  shift_13 #(.data_width(1)) shif_ien_i(.clk(clk),.rst(rst),.din(ien_reg_q_tmp),.dout(ien_reg_q_i));
  
  DFF #(.data_width(1)) dff_ien(.clk(clk),.rst(rst),.d(en_reg),.q(en_reg_q_tmp));
  DFF #(.data_width(1)) dff_iren(.clk(clk),.rst(rst),.d(ren_reg),.q(ren));

  assign wen = sel == 0 ? iwen_s : iwen_i;
  assign en_reg_q = sel == 0 ? ien_reg_q_s : ien_reg_q_i;

  // 生成控制信号
  DFF #(.data_width(1)) dff_sel0(.clk(clk),.rst(rst),.d(sel_reg),.q(sel));
  // DFF #(.data_width(1)) dff_sel1(.clk(clk),.rst(rst),.d(sel_reg_ntt),.q(sel_ntt));
  always@(posedge clk or posedge rst)
  begin
    if(rst)
      conf_state <= IDLE;
    else
      conf_state <= conf;
  end
  
  always@(*)
  begin
    // sel_reg_ntt =0;
    sel_reg = 0;
    en_reg = 0; 
    wen_reg = 0;
    ren_reg = 0; 
    done_reg = 3'b0;
    case(conf_state)
    IDLE:begin 
        // sel_reg_ntt =0;
        sel_reg = 0;
        en_reg  = 0; 
        wen_reg = 0;
        ren_reg = 0; 
        done_reg = 3'b0;
        end

    RADIX2_NTT:begin
        // sel_reg_ntt =0;
        sel_reg = 0;
        en_reg = 1; 
        wen_reg = 1;
        ren_reg = 1;
         if(i_reg == 127)
           done_reg = 3'b001;
         else
           done_reg = 3'b0;
        end

    RADIX4_NTT:begin 
        //  sel_reg_ntt =0; 
         sel_reg = 1;
         en_reg = 1; 
         wen_reg = 1;
         ren_reg = 1;
         if((p_reg == 0)&&(k_reg == 127)&&(j_reg == 0))begin
           done_reg = 3'b010; end
         else begin
           done_reg = 3'b0; end
         end

    DONE_RADIX2_NTT:begin 
        //  sel_reg_ntt =0; 
         sel_reg = 0;
         en_reg = 0;
         wen_reg = 0;
         ren_reg = 0; 
        //  p_reg <= 3'b0;
        end

    DONE_RADIX4_NTT:begin 
        //  sel_reg_ntt =0; 
         sel_reg = 1;
         en_reg = 0;
         wen_reg = 0;
         ren_reg = 0; 
        //  p_reg <= 3'b0;
        end

    default:begin 
        //  sel_reg_ntt =0; 
         sel_reg = 0;
         done_reg = 2'b0;
         en_reg = 0;
         wen_reg = 0;
         ren_reg = 0; 
         end
     endcase
  end
 
 assign end_stage = conf == RADIX4_NTT ? 0 : 3;
 assign begin_stage = conf == RADIX4_NTT ? 3 : 0;
 assign p_shift = p_reg << 1;
 
  always@(posedge clk or posedge rst)
  begin 
     if(rst)
     begin
         p_reg <= begin_stage;
         j_reg <= 0;
         k_reg <= 0;
         i_reg <= 0;
     end
     else if((conf_state == RADIX2_NTT))
     begin
         i_reg <= i_reg + 1;
     end

     else if((conf == RADIX2_NTT))
     begin
         p_reg <= 3'b100;
     end

     else if((conf_state == RADIX4_NTT))
     begin
        if(j_reg == (1 << (p_shift)) - 1)
        begin
           j_reg <= 0;
           if(k_reg == (128 >> p_shift) - 1)
           begin
              k_reg <= 0;
              if(p_reg == end_stage)
                   p_reg <= begin_stage;
              else
              begin
                   p_reg <= p_reg - 1;
              end

           end
           else
              k_reg <= k_reg + 1;
         end
         else
            j_reg <= j_reg + 1;
     end
     else
     begin
       p_reg <= begin_stage;
       j_reg <= 0;
       k_reg <= 0;
       i_reg <= 0;
     end
   end
endmodule
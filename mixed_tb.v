`timescale 1ns / 1ps
module mixed_tb;

   reg clk,rst;
   reg [3:0]conf;
   wire [1:0] done_flag;


   initial
  begin
    clk=1'b0;
    forever #5 clk=~clk;
  end
  
  initial 
  begin
    conf = 0;
    rst = 1;
    # 7 rst = 0;
    # 2 conf = 1;
    # 1280 conf = 3;
    # 440 conf = 2;
    // # 15 conf = 2;
    # 5126 conf = 4;
    # 500 conf = 5;
    # 5126 conf = 8;
    # 500 conf = 6;
    # 1280 conf = 7;
  end
  

top_stage tb_mixed(
    .clk(clk),.rst(rst),
    .conf(conf),
    .done_flag(done_flag));

  initial
  begin 
     $readmemb("D:/NTT/mixed_ntt_512/bank0.txt",mixed_tb.tb_mixed.bank_0.bank);
     $readmemb("D:/NTT/mixed_ntt_512/bank1.txt",mixed_tb.tb_mixed.bank_1.bank);
     $readmemb("D:/NTT/mixed_ntt_512/bank2.txt",mixed_tb.tb_mixed.bank_2.bank);
     $readmemb("D:/NTT/mixed_ntt_512/bank3.txt",mixed_tb.tb_mixed.bank_3.bank);
  end

endmodule
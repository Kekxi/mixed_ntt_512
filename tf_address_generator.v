module tf_address_generator(
    input clk,rst,
    input [3:0] conf,
    input [4:0] k,
    input [1:0] p,
    output wire [6:0] tf_address
    );
    
    reg [6:0] tf_address_reg_0,tf_address_reg_1;
    wire [6:0] tf_address_tmp;
    //sel = 0 NTT mode; sel = 1 INTT mode
    assign tf_address_tmp =((conf == 4'b010) || (conf == 4'b0100) || (conf == 4'b0001) || (conf == 4'b0011)) ? tf_address_reg_0 : tf_address_reg_1;
     
    DFF #(.data_width(7)) dff_tf(.clk(clk),.rst(rst),.d(tf_address_tmp),.q(tf_address));
    
    always@(*)
    begin
      case(p)
      3:begin tf_address_reg_0 = k; tf_address_reg_1 = k; end     
      2:begin tf_address_reg_0 = k + 2;   tf_address_reg_1 = 9 - k; end   
      1:begin tf_address_reg_0 = k + 10;  tf_address_reg_1 = 41- k; end
      0:begin tf_address_reg_0 = k + 42;  tf_address_reg_1 = 107 - k; end
      default: tf_address_reg_0 = 0;
      endcase
    end
endmodule



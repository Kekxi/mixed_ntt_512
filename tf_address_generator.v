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
    assign tf_address_tmp = tf_address_reg_0;
     
    DFF #(.data_width(7)) dff_tf(.clk(clk),.rst(rst),.d(tf_address_tmp),.q(tf_address));
    
    always@(*)
    begin
      case(p)
      3:tf_address_reg_0 = k;     
      2:tf_address_reg_0 = k + 2;     
      1:tf_address_reg_0 = k + 10; 
      0:tf_address_reg_0 = k + 42;
      default: tf_address_reg_0 = 0;
      endcase
    end
endmodule
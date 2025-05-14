module DFF #(parameter data_width = 14)(
    input clk,rst,
    input [data_width-1:0] d,
    output reg [data_width-1:0] q 
    );
    always@(posedge clk or posedge rst)
    begin
      if(rst)
        q <= 0;
      else
        q <= d;
    end
endmodule

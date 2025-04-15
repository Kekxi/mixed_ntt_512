module data_bank 
    (
    input clk,
    input [6:0] A1,
    input [6:0] A2,
    input [11:0] D,
    input IWEN,
    input IREN,
    input IEN,
    output reg [11:0] Q
    );
    (*ram_style = "block"*)reg [11:0] bank [127:0];

    always@(posedge clk)
    begin
      if (IEN == 1)
        begin         
          if(IWEN == 1'b1)
             bank[A1] <= D;
          else
             bank[A1] <= bank [A1];
          end
    end
    
    always@(posedge clk)
    begin
      if(IEN == 1)
        begin
          if(IREN == 1'b1)
            Q <= bank[A2];
          else
            Q <= Q;
        end
    end
endmodule
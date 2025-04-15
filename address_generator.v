module address_generator(
    input [6:0] i,//max = 127
    input [6:0] k,//max = 127
    input [6:0] j,//max = 127
    input [2:0] p,//阶段数 
    output wire [8:0] old_address_0,old_address_1,old_address_2,
    output wire [8:0] old_address_3
);

	reg [8:0] old_address_0_reg,old_address_1_reg,old_address_2_reg,old_address_3_reg;

    assign old_address_1 = old_address_1_reg;
    assign old_address_2 = old_address_2_reg;
    assign old_address_3 = old_address_3_reg;
    assign old_address_0 = old_address_0_reg;

    always@(*)
    begin
      case(p)
      3'b100: old_address_0_reg = i;
      3'b011: old_address_0_reg = ((k << 2) << (p << 1)) + j; 
      3'b010: old_address_0_reg = ((k << 2) << (p << 1)) + j; 
      3'b001: old_address_0_reg = ((k << 2) << (p << 1)) + j; 
      3'b000: old_address_0_reg = ((k << 2) << (p << 1)) + j;  
      default:old_address_0_reg = old_address_0_reg;
      endcase
    end
    
    always@(*)
    begin
      case(p)
      3'b100: old_address_1_reg = {old_address_0_reg[8],1'b1,old_address_0_reg[6:0]};
      3'b011: old_address_1_reg = {old_address_0_reg[8:7],1'b1,old_address_0_reg[5:0]};
      3'b010: old_address_1_reg = {old_address_0_reg[8:5],1'b1,old_address_0_reg[3:0]};  
      3'b001: old_address_1_reg = {old_address_0_reg[8:3],1'b1,old_address_0_reg[1:0]};  
      3'b000: old_address_1_reg = {old_address_0_reg[8:1],1'b1};  
      default:old_address_1_reg = old_address_0_reg;
      endcase
    end
    
    always@(*)
    begin
      case(p)
      3'b100: old_address_2_reg = {1'b1,old_address_0_reg[7:0]};    
      3'b011: old_address_2_reg = {old_address_0_reg[8],1'b1,old_address_0_reg[6:0]};    
      3'b010: old_address_2_reg = {old_address_0_reg[8:6],1'b1,old_address_0_reg[4:0]};  
      3'b001: old_address_2_reg = {old_address_0_reg[8:4],1'b1,old_address_0_reg[2:0]};  
      3'b000: old_address_2_reg = {old_address_0_reg[8:2],1'b1,old_address_0_reg[0]};  
      default:old_address_2_reg = old_address_0_reg;
      endcase
    end
    
    always@(*)
    begin
      case(p)
      3'b100: old_address_3_reg = {1'b1,old_address_1_reg[7:0]};     
      3'b011: old_address_3_reg = {old_address_1_reg[8],2'b11,old_address_1_reg[5:0]};     
      3'b010: old_address_3_reg = {old_address_0_reg[8:6],2'b11,old_address_0_reg[3:0]};  
      3'b001: old_address_3_reg = {old_address_0_reg[8:4],2'b11,old_address_0_reg[1:0]};
      3'b000: old_address_3_reg = {old_address_0_reg[8:2],2'b11};
      default: old_address_3_reg = old_address_0_reg;
      endcase
    end
     

endmodule
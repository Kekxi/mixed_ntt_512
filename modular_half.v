module modular_half #(parameter data_width = 256)(
    input [data_width-1:0] x_half,
    output [data_width-1:0] y_half
    );
    
    parameter M = 12'd3329;
    parameter M_half = 11'd1665;//M+1/2

    wire [data_width-1:0] x_sh;
    wire c;
    wire [data_width-1:0] s;
    
    assign x_sh = x_half >> 1;
    assign {c,s} = x_sh + M_half;
    assign y_half = x_half[0] == 1? s : x_sh;
endmodule
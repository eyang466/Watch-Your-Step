`timescale 1ns / 1ps

module timeCounter(
    input clk_i,
    input inc_i,
    input reset_i,
    output [7:0] q_o
    );
    
    countUD16L CC1 (.clk_i(clk_i),.Din(16'b0000000000000000),.Up(inc_i),.reset_i(reset_i),.Q(q_o[7:0]));

endmodule
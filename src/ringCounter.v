`timescale 1ns / 1ps

module ringCounter (
    input advance_i,
    input clk_i,
    output [3:0] data_o 

    );

    wire [3:0] D;

    FDRE #(.INIT(1'b1)) R0 (.C(clk_i), .R(1'b0), .CE(advance_i), .D(D[3]), .Q(D[0]));
    FDRE #(.INIT(1'b0)) R1 (.C(clk_i), .R(1'b0), .CE(advance_i), .D(D[0]), .Q(D[1]));
    FDRE #(.INIT(1'b0)) R2 (.C(clk_i), .R(1'b0), .CE(advance_i), .D(D[1]), .Q(D[2]));
    FDRE #(.INIT(1'b0)) R3 (.C(clk_i), .R(1'b0), .CE(advance_i), .D(D[2]), .Q(D[3]));

    assign data_o = D;

endmodule

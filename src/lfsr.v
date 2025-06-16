`timescale 1ns / 1ps

module lfsr(
    input clk_i,
    output [7:0] q_o
    );

    wire [7:0] rnd;
    wire temp;

    assign temp = rnd[0]^rnd[5]^rnd[6]^rnd[7];

    FDRE #(.INIT(1'b1)) L0 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(temp), .Q(rnd[0]));
    FDRE #(.INIT(1'b0)) L1[6:0] (.C({7{clk_i}}), .R({7{1'b0}}), .CE({7{1'b1}}), .D(rnd[6:0]), .Q(rnd[7:1]));

    assign q_o = rnd;

endmodule
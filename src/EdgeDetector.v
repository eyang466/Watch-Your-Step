`timescale 1ns / 1ps

module EdgeDetector (
    input btnD,
    input clk,
    output Dw
    );
    wire [1:0] Q;
    FDRE #(.INIT(1'b0)) E0 (.C(clk), .R(1'b0), .CE(1'b1), .D(btnD), .Q(Q[0]));
    FDRE #(.INIT(1'b0)) E1 (.C(clk), .R(1'b0), .CE(1'b1), .D(Q[0]), .Q(Q[1]));
    assign Dw = Q[0] & ~ Q[1];

endmodule
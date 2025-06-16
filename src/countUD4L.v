`timescale 1ns / 1ps

module countUD4L(
    input clk_i,
    input up_i,
    input dw_i,
    input ld_i,
    input [3:0] din_i,
    input reset_i,
    output [3:0] q_o,
    output utc_o,
    output dtc_o
    );
  
    wire [3:0] d, k, q;

    mux8bit M1 (.A(q),.B(din_i),.Sel(ld_i & ~up_i & ~dw_i),.C(d));

    wire ce;
    assign ce = up_i ^ dw_i ^ ld_i;
    AddSub8 AS0 (.A(d),.B({3'b000,(up_i|dw_i)}),.sub(~up_i&dw_i),.S(k),.ovfl(ovfl),.Cout(Cout));
  
    FDRE #(.INIT(1'b0)) C0 (.C(clk_i), .R(reset_i), .CE(ce), .D(k[0]), .Q(q[0]));
    FDRE #(.INIT(1'b0)) C1 (.C(clk_i), .R(reset_i), .CE(ce), .D(k[1]), .Q(q[1]));
    FDRE #(.INIT(1'b0)) C2 (.C(clk_i), .R(reset_i), .CE(ce), .D(k[2]), .Q(q[2]));
    FDRE #(.INIT(1'b0)) C3 (.C(clk_i), .R(reset_i), .CE(ce), .D(k[3]), .Q(q[3]));

    assign q_o = q;
    assign utc_o = &q_o;
    assign dtc_o = ~(|q_o);

endmodule
`timescale 1ns / 1ps

module AddSub8(
    input [3:0] A,
    input [3:0] B,
    input sub,
    output [3:0] S,
    output ovfl,
    output Cout
    );

    wire [3:0] newB;
    mux8bit MEB (.A(B),.B(~B),.Sel(sub),.C(newB));
    adder8 ADD0 (.A(A),.B(newB),.Cin(sub),.S(S),.ovfl(ovfl),.Cout(Cout));

endmodule

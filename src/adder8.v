`timescale 1ns / 1ps

module adder8(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output ovfl,
    output Cout
    );

    wire[6:0] j;
    full_adder FA0  (.a(A[0]),.b(B[0]),.Cin(Cin),.Cout(j[0]),.s(S[0])); 
    full_adder FA1  (.a(A[1]),.b(B[1]),.Cin(j[0]),.Cout(j[1]),.s(S[1]));
    full_adder FA2  (.a(A[2]),.b(B[2]),.Cin(j[1]),.Cout(j[2]),.s(S[2]));
    full_adder FA3  (.a(A[3]),.b(B[3]),.Cin(j[2]),.Cout(Cout),.s(S[3]));

    assign ovfl = (Cout^j[2]);  

endmodule








`timescale 1ns / 1ps

module full_adder(
    input a,
    input b,
    input Cin,
    output Cout,
    output s
    );

    wire carry_out;
    wire j;
    half_adder HA0  (.a(a),.b(b),.s(j),.Cout(carry_out)); 

    assign s = (j^Cin);
    assign Cout = carry_out | (a&Cin) | (b&Cin);
endmodule
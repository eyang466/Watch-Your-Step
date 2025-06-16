`timescale 1ns / 1ps

module mux8bit(
    input [3:0] A,
    input [3:0] B,
    input Sel,
    output [3:0] C
    );

    assign C = (~{4{Sel}}&A)|({4{Sel}}&B);

endmodule

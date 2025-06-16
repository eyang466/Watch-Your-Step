`timescale 1ns / 1ps

module half_adder(
    input a,
    input b,
    output Cout,  
    output s
    );
    
    assign s = (a^b);
    assign Cout = (a&b);
endmodule

`timescale 1ns / 1ps

module countUD16L(
    input clk_i,
    input [15:0] Din,
    input Up,
    input LD,
    input Dw,
    input reset_i,
    output UTC,
    output DTC,
    output [15:0] Q
    );

    wire [3:0] utc_o, dtc_o;

    countUD4L C1 (.clk_i(clk_i),.up_i(Up),.dw_i(Dw),.ld_i(LD),.din_i(Din[3:0]),.q_o(Q[3:0]),.utc_o(utc_o[0]),.dtc_o(dtc_o[0]),.reset_i(reset_i));
    countUD4L C2 (.clk_i(clk_i),.up_i(Up&utc_o[0]),.dw_i(Dw&dtc_o[0]),.ld_i(LD),.din_i(Din[7:4]),.q_o(Q[7:4]),.utc_o(utc_o[1]),.dtc_o(dtc_o[1]),.reset_i(reset_i));
    countUD4L C3 (.clk_i(clk_i),.up_i(Up&utc_o[1]&utc_o[0]),.dw_i(Dw&dtc_o[1]&dtc_o[0]),.ld_i(LD),.din_i(Din[11:8]),.q_o(Q[11:8]),.utc_o(utc_o[2]),.dtc_o(dtc_o[2]),.reset_i(reset_i));
    countUD4L C4 (.clk_i(clk_i),.up_i(Up&utc_o[2]&utc_o[1]&utc_o[0]),.dw_i(Dw&dtc_o[2]&dtc_o[1]&dtc_o[0]),.ld_i(LD),.din_i(Din[15:12]),.q_o(Q[15:12]),.utc_o(utc_o[3]),.dtc_o(dtc_o[3]),.reset_i(reset_i));

    assign UTC = &utc_o;
    assign DTC = &dtc_o;
    

endmodule
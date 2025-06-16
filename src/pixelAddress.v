`timescale 1ns / 1ps

module pixelAddress(
    input clkin,
    output [15:0] H_o,
    output [15:0] V_o,
    output active_region,
    output refresh
);

    wire [15:0] H, V;
    wire reset_H, reset_V;

    assign reset_H = (H == 16'd799);
    assign reset_V = (V == 16'd524);

    countUD16L HCount(.clk_i(clkin),.Din({16{1'b0}}),.Up(~reset_H),.LD(reset_H),.Dw(1'b0),.reset_i(1'b0),.UTC(h_utc),.DTC(h_dtc),.Q(H)); 
    countUD16L VCount(.clk_i(clkin),.Din({16{1'b0}}),.Up(reset_H&~reset_V),.LD(reset_H&reset_V),.Dw(1'b0),.reset_i(1'b0),.UTC(v_utc),.DTC(v_dtc),.Q(V)); 


    assign H_o = H;
    assign V_o = V;

    assign active_region = (H < 16'd640) && (V < 16'd480);
    assign refresh = reset_H&reset_V;

endmodule






`timescale 1ns / 1ps

module syncs(
    input [15:0] H_i,
    input [15:0] V_i,
    output Hsync_o,
    output Vsync_o

);

    wire H, V;

    assign H = ~((16'd654 < H_i) & (H_i < 16'd751));
    assign V = ~((16'd488 < V_i) & (V_i < 16'd491));

    assign Hsync_o = H;
    assign Vsync_o = V;
    

endmodule
module points (
    input clkin,
    input paused_coin,
    input stop,
    output [7:0] points

    );

    countUD16L CC1 (.clk_i(clkin),.Din(16'b0000000000000000),.Up(paused_coin && ~stop),.reset_i(reset_i),.Q(points));

endmodule
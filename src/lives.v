module lives(
    input clkin,
    input refresh,
    input game_started,
    input stop,
    input btnC,
    input btnL,
    input stop_game,
    input [7:0] sw,
    output restart,
    output [7:0] lives,
    output game_over
);

    wire [7:0] lives_temp;
    countUD16L livesCounter (
        .clk_i(clkin),
        .Din(sw[7:0]),
        .Up((btnC && ~game_start && ~stop) && lives_temp == 8'b0),
        .LD(btnL & ~game_started),
        .Dw(stop_game && (lives_temp>0) ),
        .reset_i(1'b0),
        .Q(lives_temp)
    );

    
    assign lives = lives_temp;
    assign game_over = lives_temp == 1'b0;
    assign restart = btnC && stop && ~game_over;

endmodule

module coin(
    input clkin,
    input game_started,
    input load_game,
    input refresh,
    input [15:0] H,
    input [15:0] V,
    input stop,
    input paused,
    input three_sec,
    input sw,
    input restart,

    output [15:0] coin_position,
    output coin,
    output [15:0] coin_height
    );  
    wire [7:0] temp_num;
    wire [7:0] coin_height_temp;

    wire min_coin_position;
    wire [15:0] coin_position_temp;
    wire [7:0] coin_height_actual;


    assign min_coin_position = ((16'd640  - coin_position_temp - coin_position_temp - coin_position_temp - coin_position_temp) == 16'd0);

    countUD16L C16L_coin (
            .clk_i(clkin),
            .Din({16{1'b0}}),
            .Up(refresh && game_started && ~stop && ~paused),
            .LD(1'b0),
            .Dw(1'b0),
            .reset_i(min_coin_position || (three_sec && paused && ~stop) || restart),
            .Q(coin_position_temp)
        ); 

    lfsr RandomcoinSize (.clk_i(clkin),.q_o(temp_num));

    assign coin_height_temp[7:0] = 8'd192 + (temp_num[5:0] > 62 ? temp_num - 62 : temp_num[5:0]);

    FDRE #(.INIT(1'b0)) coinLocation [7:0] (.C(clkin), .R(1'b0), .CE((min_coin_position && game_started) || load_game || three_sec && paused || restart), .D(coin_height_temp), .Q(coin_height_actual));

    assign coin_height = sw ? 16'd339 : coin_height_actual;

    assign coin = ((V <= coin_height) && (V >= (coin_height - 8'd7))) && 
                  ((H >= (16'd640 - (coin_position_temp <= 16'd160 ? coin_position_temp : 16'd160) - (coin_position_temp <= 16'd160 ? coin_position_temp : 16'd160) - (coin_position_temp <= 16'd160 ? coin_position_temp : 16'd160) - (coin_position_temp <= 16'd160 ? coin_position_temp : 16'd160))) && (H <= (16'd640 + 16'd8 - coin_position_temp - coin_position_temp - coin_position_temp - coin_position_temp)));

    assign coin_position = coin_position_temp;

endmodule

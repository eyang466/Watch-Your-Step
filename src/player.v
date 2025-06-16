module player (
    input clkin,
    input refresh,
    input [15:0] H,
    input [15:0] V,
    input jump_released,
    input ground,
    input load_game,
    input stop,
    input [15:0] height_to_jump,
    input restart,

    output min_player_height,
    output player_model,
    output [15:0] player_height,
    output [15:0] player_height_lost
    );
    
        wire max_player_height;
        wire [15:0] player_height_temp, player_height_lost_temp;
  
        assign min_player_height = (player_height_temp == 16'd0);
        assign max_player_height = (player_height_temp == height_to_jump);

        wire max_height_reached;
        FDRE #(.INIT(1'b0)) MaxHeightReached (.C(clkin), .R((min_player_height && max_height_reached && ~stop) || restart), .CE(max_player_height), .D(1'b1), .Q(max_height_reached));
        
        countUD16L C16L_PlayerUp (
            .clk_i(clkin),
            .Din({16{1'b0}}),
            .Up(refresh && jump_released && ~max_height_reached && ~max_player_height && ~stop),
            .LD(1'b0),
            .Dw(refresh && jump_released && max_height_reached && ~min_player_height && ~stop),
            .reset_i(restart),
            .Q(player_height_temp)
        ); 

        countUD16L C16L_PlayerDown (
            .clk_i(clkin),
            .Din({16{1'b0}}),
            .Up(refresh && stop && (player_height_lost_temp < 16'd66) && ~restart),
            .LD(1'b0),
            .Dw(1'b0),
            .reset_i(restart),
            .Q(player_height_lost_temp)
        ); 

        assign player_height = player_height_temp;
        assign player_height_lost = player_height_lost_temp;
        assign player_model = (H >= 160 && H <= 175) && ((V >= (16'd324 - player_height_temp - player_height_temp + player_height_lost_temp + player_height_lost_temp)) && (V <= (16'd339 - player_height_temp - player_height_temp + player_height_lost_temp + player_height_lost_temp)));
        
endmodule

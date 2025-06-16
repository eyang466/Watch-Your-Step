`timescale 1ns / 1ps

module gameplay (
    input clkin,
    input refresh,
    input btnU,
    input btnR,
    input btnC,
    input btnL,
    input [15:0] H,
    input [15:0] V,
    input active_region,
    output [3:0] rgbRed,
    output [3:0] rgbGreen,  
    output [3:0] rgbBlue,
    input [15:0] sw,
    output [7:0] points,
    output [7:0] lives
    );

    wire [15:0] height_to_jump, player_height, player_height_lost, hole_position, coin_position, coin_height;
    wire [6:0] hole_size;    
    wire [5:0] timer;
    wire [7:0] timer2; 
    wire game_started;
    wire load_game;
    wire stop_game;
    wire stop;
    wire flash;
    wire stop_flash;
    wire pause_flash;
    wire red_border;
    wire jump_released;
    wire jump_bar;
    wire min_player_height;
    wire player_model;
    wire ground;
    wire hole;
    wire paused;
    wire pause_x;
    wire pause_y;
    wire pause;
    wire paused_coin;
    wire restart;
    wire three_sec;
    wire stop_x;
    wire stop_y;


//Game Started
    FDRE #(.INIT(1'b0)) GameStart(.C(clkin), .R(restart), .CE(btnC), .D(1'b1), .Q(game_started));
    EdgeDetector LoadGame(.btnD(game_started),.clk(clkin),.Dw(load_game));
    EdgeDetector StopGame(.btnD(stop),.clk(clkin),.Dw(stop_game));


//Time Counter
    timeCounter FrameCounter (.clk_i(clkin),.inc_i(refresh),.reset_i(stop_game || load_game || flash || (restart)),.q_o(timer[5:0]));
    timeCounter TimeCounter (.clk_i(clkin),.inc_i(refresh),.reset_i(stop_game || load_game || paused_coin || (restart)),.q_o(timer2));

    assign flash = timer[4:0] == 5'b10100;
    assign three_sec = timer2 == 8'b10110100;

    FDRE #(.INIT(1'b0)) STOPFLASH (.C(clkin), .R((restart)), .CE(flash && stop), .D(~stop_flash), .Q(stop_flash));
    FDRE #(.INIT(1'b0)) PAUSEFLASH (.C(clkin), .R(~paused || (restart)), .CE(flash && paused), .D(~pause_flash), .Q(pause_flash));


//Red Border
    assign red_border = (H < 16'd8 || H > 16'd631) || (V < 16'd8 || V> 16'd471);

//Jump Bar
    jumpBar JumpBar (
        .clkin(clkin),
        .btnU(btnU),
        .btnR(btnR),
        .refresh(refresh),
        .H(H),
        .V(V),
        .min_player_height(min_player_height),
        .stop(stop),

        .jump_released(jump_released),
        .height_to_jump(height_to_jump),
        .jump_bar(jump_bar)
    );


//Player Module
    player Player (
        .clkin(clkin),
        .refresh(refresh),
        .H(H),
        .V(V),
        .jump_released(jump_released),
        .ground(ground),
        .load_game(load_game),
        .stop(stop),
        .height_to_jump(height_to_jump),
        .restart(restart),

        .min_player_height(min_player_height),
        .player_model(player_model),
        .player_height(player_height),
        .player_height_lost(player_height_lost)
    );


//Hole Module
    hole Hole (
        .clkin(clkin),
        .refresh(refresh),
        .game_started(game_started),
        .load_game(load_game),
        .H(H),
        .V(V),
        .stop(stop),
        .restart(restart),


        .hole_position(hole_position),
        .ground(ground),
        .hole(hole),
        .hole_size(hole_size)
    );

//Coin Module
    coin Coin(
        .clkin(clkin),
        .refresh(refresh),
        .game_started(game_started),
        .load_game(load_game),
        .H(H),
        .V(V),
        .stop(stop),
        .paused(paused),
        .three_sec(three_sec),
        .sw(sw[14]),
        .restart(restart),

        .coin_position(coin_position),
        .coin(coin),
        .coin_height(coin_height)
    );  

//Points
    points Points(
        .clkin(clkin),
        .paused_coin(paused_coin),
        .stop(stop),
        .points(points)
    );

//Lives
    lives Lives(
        .clkin(clkin),
        .refresh(refresh),
        .game_started(game_started),
        .stop(stop),
        .btnC(btnC),
        .btnL(btnL),
        .stop_game(stop_game),
        .sw(sw[7:0]),
        .restart(restart),
        .lives(lives)
    );

//Random 
    wire [7:0] random_color, random_color_temp;
    lfsr RandomColor (.clk_i(clkin),.q_o(random_color_temp));
    FDRE #(.INIT(1'b0)) RememberRandColor [7:0] (.C(clkin), .R(restart), .CE(paused_coin), .D(random_color_temp), .Q(random_color));

//Pause Coin
    assign pause_x = ((16'd636 - coin_position - coin_position - coin_position - coin_position) <= 16'd175) && (16'd160 <= (16'd636 + 16'd8 - coin_position - coin_position - coin_position - coin_position));
    assign pause_y = (coin_height >= (16'd324 - player_height - player_height)) && ((coin_height - 8'd7) <= (16'd339 - player_height - player_height));
    assign pause  = pause_x && pause_y;

    FDRE #(.INIT(1'b0)) Pause (.C(clkin), .R((three_sec && paused) || (restart)), .CE(pause), .D(1'b1), .Q(paused));
    EdgeDetector PauseCoin(.btnD(paused),.clk(clkin),.Dw(paused_coin));

//Stop Game
    assign stop_x = ((16'd639 - hole_position) < 16'd160) && (16'd175 <= (16'd639 + hole_size - hole_position));
    assign stop_y = (16'd340 - player_height - player_height ) == 16'd340;
    FDRE #(.INIT(1'b0)) Stop (.C(clkin), .R(restart || load_game), .CE(stop_x && stop_y && ~sw[15]), .D(1'b1), .Q(stop));
    
//RGB
    
    assign rgbRed = ~active_region ? 4'b0000 :
                    red_border ? 4'b1111 :
                    (coin && ~pause_flash) ? 4'b1111 :
                    (player_model && ~stop_flash) ? random_color[3:0] :
                    4'b0000;

    assign rgbGreen = ~active_region ? 4'b0000 :
                    jump_bar ? 4'b1111 :
                    (player_model && ~stop_flash) ? ~random_color[5:2] :
                    (coin && ~pause_flash) ? 4'b1111 :
                    4'b0000;

    assign rgbBlue = ~active_region ? 4'b0000 :
                    (ground && ~red_border) ? 4'b1111 :
                    (player_model && ~stop_flash) ? random_color[7:4] :
                    4'b0000;

                     
    // assign rgbRed = (active_region && (red_border || (coin && ~pause_flash)) ? 4'b1111 : 4'b0000) ;
    // assign rgbGreen = (active_region && (jump_bar || (player_model && stop_flash) || (coin && ~pause_flash))  ? 4'b1111 : 4'b0000) ; 
    // assign rgbBlue = (active_region && (ground && ~red_border) ? 4'b1111 : 4'b0000 );

    // assign rgbRed = (active_region && (red_border || (coin && ~pause_flash)) ? 4'b1111 : 4'b0000) || ((active_region && player_model && stop_flash) ? random_color[3:0]: 4'b0000);
    // assign rgbGreen = (active_region && (jump_bar || (player_model && stop_flash) || (coin && ~pause_flash))  ? 4'b1111 : 4'b0000) || ((active_region && player_model && stop_flash) ? random_color[5:2]: 4'b0000); 
    // assign rgbBlue = (active_region && (ground && ~red_border) ? 4'b1111 : 4'b0000 )|| ((active_region && player_model && stop_flash) ? random_color[7:4]: 4'b0000);

endmodule




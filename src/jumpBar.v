module jumpBar(
    input clkin,
    input btnU, btnR,
    input refresh,
    input [15:0] H,
    input [15:0] V,
    input min_player_height,
    input stop,
    output jump_released,
    output [15:0] height_to_jump,
    output jump_bar
);

    wire max_bar_height, min_bar_height;
    wire [15:0] bar_height_temp, height_to_jump_temp;
    wire jump_released_temp;
    wire h_utc, h_dtc;
    
    assign max_bar_height = (bar_height_temp == 16'd64);
    assign min_bar_height = (bar_height_temp == 16'd0);

    countUD16L C16L_JumpBar (
        .clk_i(clkin),
        .Din({16{1'b0}}),
        .Up(btnU && refresh && ~jump_released_temp && ~max_bar_height && ~stop),
        .LD(1'b0),
        .Dw(jump_released_temp && refresh && ~min_bar_height),
        .reset_i(restart),
        .Q(bar_height_temp)
    ); 
    
    FDRE #(.INIT(1'b0)) Jumped (
        .C(clkin), 
        .R(min_player_height && min_bar_height), 
        .CE(~min_bar_height && ~btnU && refresh), 
        .D(1'b1), 
        .Q(jump_released_temp)
    );

    FDRE #(.INIT(1'b0)) Bar_height [15:0] (
        .C(clkin), 
        .R(min_player_height && min_bar_height), 
        .CE(~jump_released_temp), 
        .D(bar_height_temp), 
        .Q(height_to_jump_temp)
    );
    
    assign height_to_jump = height_to_jump_temp;
    assign jump_bar = (H >= 32 && H < 47) && (V < 16'd96 && V >= (96 - bar_height_temp));
    assign jump_released = jump_released_temp;

endmodule
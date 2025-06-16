module hole(
    input clkin,
    input game_started,
    input load_game,
    input refresh,
    input [15:0] H,
    input [15:0] V,
    input stop,
    input restart,
    output [15:0] hole_position,
    output ground,
    output hole,
    output [6:0] hole_size
    );  
    wire [7:0] temp_num;
    wire [6:0] hole_size_temp;
    wire min_hole_position;
    wire [15:0] hole_position_temp;

    assign min_hole_position = ((16'd639 + hole_size - hole_position_temp) == 16'd0);

    countUD16L C16L_Hole (
            .clk_i(clkin),
            .Din({16{1'b0}}),
            .Up(refresh && game_started && ~stop),
            .LD(1'b0),
            .Dw(1'b0),
            .reset_i(min_hole_position || restart),
            .Q(hole_position_temp)
        ); 

    lfsr RandomHoleSize (.clk_i(clkin),.q_o(temp_num));

    assign hole_size_temp[6:0] = temp_num[4:0] == 0 ? 7'd41 + temp_num[4:0] : 7'd40 + temp_num[4:0];
    
    FDRE #(.INIT(1'b0)) HoleSize [6:0] (.C(clkin), .R(1'b0), .CE((min_hole_position && game_started) || load_game || restart), .D(hole_size_temp), .Q(hole_size));

    assign ground = (V > 16'd339) && ~((H > (16'd639 - (hole_position_temp <= 16'd639 ? hole_position_temp : 16'd639))) && (H <= (16'd639 + hole_size - hole_position_temp)));
    assign hole = (V > 16'd338) && ((H > (16'd639 - (hole_position_temp <= 16'd639 ? hole_position_temp : 16'd639))) && (H <= (16'd639 + hole_size - hole_position_temp)));

    assign hole_position = hole_position_temp;

endmodule

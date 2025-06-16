`timescale 1ns / 1ps

module top(
    input clkin,
    input btnC, btnD, btnU, btnL, btnR,
    input [15:0] sw,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output Hsync,
    output Vsync,
    output [6:0] seg,
    output [15:0] led,
    output [3:0] an,
    output dp,
    output [3:0] hdmiRed,
    output [3:0] hdmiGreen,
    output [3:0] hdmiBlue,
    output hdmi_hsync, 
    output hdmi_vsync,
    output hdmi_clk,
    output hdmi_dispen
    );

    wire clk, digsel;
    wire [15:0] H, V;
    wire Hsync_temp, Vsync_temp;
    wire active_region;
    wire [15:0] q;
    wire [7:0] points;
    wire [7:0] lives;

    wire [3:0] rgbRed, rgbGreen, rgbBlue;

    pixelAddress PA (.clkin(clk),.H_o(H),.V_o(V),.active_region(active_region),.refresh(refresh));

    syncs S (.H_i(H),.V_i(V),.Hsync_o(Hsync_temp),.Vsync_o(Vsync_temp));


    gameplay GP (
        .clkin(clk),
        .refresh(refresh),
        .btnU(btnU),
        .btnR(btnR),
        .btnC(btnC),
        .btnL(btnL),
        .H(H),
        .V(V),
        .active_region(active_region),
        .rgbRed(rgbRed),
        .rgbGreen(rgbGreen),
        .rgbBlue(rgbBlue),
        .sw(sw),
        .points(points),
        .lives(lives)
    );

//Sync FlipFlops
    FDRE #(.INIT(1'b1)) HSYNC (.C(clk), .R(1'b0), .CE(1'b1), .D(Hsync_temp), .Q(Hsync));
    FDRE #(.INIT(1'b1)) VSYNC (.C(clk), .R(1'b0), .CE(1'b1), .D(Vsync_temp), .Q(Vsync));

//VGA Color FlipFlops
    FDRE #(.INIT(1'b0)) RED [3:0] (.C({4{clk}}), .R(4'b0), .CE(4'b1111), .D(rgbRed), .Q(vgaRed));
    FDRE #(.INIT(1'b0)) GREEN [3:0] (.C({4{clk}}), .R(4'b0), .CE(4'b1111), .D(rgbGreen), .Q(vgaGreen));
    FDRE #(.INIT(1'b0)) BLUE [3:0] (.C({4{clk}}), .R(4'b0), .CE(4'b1111), .D(rgbBlue), .Q(vgaBlue));

//Clock
    labVGA_clks not_so_slow (.clkin(clkin), .greset(btnR), .clk(clk), .digsel(digsel));

//ringCounter
    assign q = {lives,points};
    wire [3:0] rc;
    ringCounter RC1 (.advance_i(digsel),.clk_i(clk),.data_o(rc));

//Selector
    wire [3:0] h;
    selector SS1 (.N(q),.sel(rc),.H(h));

//hex7seg
    hex7seg THS0 (.n(h),.seg(seg));

//Other
    assign an = ~rc;
    assign dp = 1;
    assign led[15] = sw[15];
    assign led[14] = sw[14];

//HDMI Stuff
    assign hdmiRed = vgaRed;
    assign hdmiGreen = vgaGreen;
    assign hdmiBlue = vgaBlue;
    assign hdmi_hsync = Hsync;
    assign hdmi_vsync = Vsync;
    assign hdmi_clk = clk;
    assign hdmi_dispen = active_region;

endmodule

/*

FDRE #(.INIT(1'b0)) NAME (.C(clk), .R(), .CE(game_over_temp), .D(), .Q());

FDRE #(.INIT(1'b0)) BUS [15:0] (.C({16{clk_i}}), .R({16{1'b0}}), .CE({16{1'b1}}), .D(d), .Q(q));

assign y = (S) ? B : A;
assign y = (~S & A)|(S & B);


assign led[15] = GP.Jumping.max_height_reached;
assign led[14] = GP.Jumping.max_player_height;
assign led[13] = GP.Jumping.min_player_height;
assign led[12] = GP.Jumping.jump_pressed;
assign led[11] = GP.JB.jump_pressed;

*/

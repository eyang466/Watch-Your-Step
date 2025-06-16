module top_tb(

    );

    reg clkin;
    reg btnC, btnD, btnU, btnL, btnR;
    reg [15:0] sw;
    wire [3:0] vgaRed;
    wire [3:0] vgaGreen;
    wire [3:0] vgaBlue;
    wire Hsync;
    wire Vsync;
    wire [6:0] seg;
    wire [15:0] led;
    wire [3:0] an;
    wire dp;
    wire [3:0] hdmiRed;
    wire [3:0] hdmiGreen;
    wire [3:0] hdmiBlue;
    wire hdmi_hsync; 
    wire hdmi_vsync;
    wire hdmi_clk;
    wire hdmi_dispen;


    top UUT (
        .clkin(clkin),
        .btnC(btnC),.btnD(btnD),.btnU(btnU),.btnL(bntL),.btnR(btnR),
        .sw(sw),
        .vgaRed(vgaRed),
        .vgaGreen(vgaGreen),
        .vgaBlue(vgaBlue),
        .Hsync(Hsync),
        .Vsync(Vsync),
        .seg(seg),
        .led(led),
        .an(an),
        .dp(dp),
        .hdmiRed(hdmiRed),
        .hdmiGreen(hdmiGreen),
        .hdmiBlue(hdmiBlue),
        .hdmi_hsync(hdmi_hsync), 
        .hdmi_vsync(hdmi_vsync),
        .hdmi_clk(hdmi_clk),
        .hdmi_dispen(hdmi_dispen)
    );


    initial begin
        clkin = 0;
        forever clkin = #5 ~clkin;
    end

    initial begin
        btnC = 0;
        btnD = 0;
        btnL = 0;
        btnR = 0;
        btnU = 0;
        sw = 0;
        #20000;


    end

endmodule
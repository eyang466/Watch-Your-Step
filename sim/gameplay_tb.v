`timescale 1ns / 1ps

module gameplay_sim(
    );
    reg clkin;
    reg refresh;
    reg btnU;
    reg btnR;
    reg btnC;
    reg btnL;
    reg [15:0] H;
    reg [15:0] V;
    reg [15:0] sw;
    reg active_region;
    wire red_border;
    wire jump_bar;
    wire [3:0] rgbRed;
    wire [3:0] rgbGreen;  
    wire [3:0] rgbBlue;


    gameplay UUT (
        .clkin(clkin),
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
        .sw(sw)
    );


    initial begin
        clkin = 0;
        forever clkin = #5 ~clkin;
    end


    initial begin
        forever begin
            refresh = 0;
            repeat (70) @(negedge clkin);
            refresh = 1; 
            @(negedge clkin);
        end
    end

    initial begin
        H = 16'b0;
        V = 16'b0;
        active_region = 0;
        sw[0] = 0;
        sw[1] = 1;
        sw[2] = 2;


        btnR = 0;
        btnU = 0;
        btnC = 0;
        btnL = 1;
        # 100; @(negedge clkin);

        btnL = 0;
        # 100; @(negedge clkin);

        // btnR = 1;
        
        // # 100; @(negedge clkin);
        btnR = 0;
        btnC = 1;
        #100;  @(negedge clkin);
        btnC = 0;
        // btnU = 1;
        // #7000;  @(negedge clkin);
        // btnU = 0;
        #1000000000;
        btnC = 1;
        #100;  @(negedge clkin);
        btnC = 0;
        $stop;
    end
endmodule

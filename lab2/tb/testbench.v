//=============================================================================
// Lab 2 : Testbench cho SR, D, JK Flip-Flop
//=============================================================================
`timescale 1ns/1ps

module testbench;

    reg  clk, rst;
    reg  s, r;              // SR flip-flop
    reg  d;                 // D  flip-flop
    reg  j, k;              // JK flip-flop

    wire q_sr, q_bar_sr;
    wire q_d,  q_bar_d;
    wire q_jk, q_bar_jk;

    sr_ff u_sr (.clk(clk), .rst(rst), .s(s), .r(r), .q(q_sr), .q_bar(q_bar_sr));
    d_ff  u_d  (.clk(clk), .rst(rst), .d(d),        .q(q_d),  .q_bar(q_bar_d));
    jk_ff u_jk (.clk(clk), .rst(rst), .j(j), .k(k), .q(q_jk), .q_bar(q_bar_jk));

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, testbench);
    end

    // Clock chu ky 10ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1; s = 0; r = 0; d = 0; j = 0; k = 0;
        #15 rst = 0;

        //--------------------- 1. SR FLIP-FLOP ---------------------
        $display("=================== 1. SR FLIP-FLOP ===================");
        $display(" Time  | RST | S | R |  Q  | Q_bar");
        $display("-------------------------------------------------------");

        s = 1; r = 0;                       // Set
        @(posedge clk); #1;
        $display("%3d ns |  %b  | %b | %b |  %b  |   %b", $time, rst, s, r, q_sr, q_bar_sr);

        s = 0; r = 0;                       // Hold
        @(posedge clk); #1;
        $display("%3d ns |  %b  | %b | %b |  %b  |   %b", $time, rst, s, r, q_sr, q_bar_sr);

        s = 0; r = 1;                       // Reset
        @(posedge clk); #1;
        $display("%3d ns |  %b  | %b | %b |  %b  |   %b", $time, rst, s, r, q_sr, q_bar_sr);

        s = 0; r = 0;

        //--------------------- 2. D FLIP-FLOP ----------------------
        $display("");
        $display("=================== 2. D FLIP-FLOP ====================");
        $display(" Time  | RST | D |  Q  | Q_bar");
        $display("-------------------------------------------------------");

        d = 1;
        @(posedge clk); #1;
        $display("%3d ns |  %b  | %b |  %b  |   %b", $time, rst, d, q_d, q_bar_d);

        d = 0;
        @(posedge clk); #1;
        $display("%3d ns |  %b  | %b |  %b  |   %b", $time, rst, d, q_d, q_bar_d);

        //--------------------- 3. JK FLIP-FLOP ---------------------
        $display("");
        $display("=================== 3. JK FLIP-FLOP ===================");
        $display(" Time  | RST | J | K |  Q  | Q_bar");
        $display("-------------------------------------------------------");

        j = 1; k = 0;                       // Set
        @(posedge clk); #1;
        $display("%3d ns |  %b  | %b | %b |  %b  |   %b", $time, rst, j, k, q_jk, q_bar_jk);

        j = 0; k = 1;                       // Reset
        @(posedge clk); #1;
        $display("%3d ns |  %b  | %b | %b |  %b  |   %b", $time, rst, j, k, q_jk, q_bar_jk);

        j = 1; k = 1;                       // Toggle
        @(posedge clk); #1;
        $display("%3d ns |  %b  | %b | %b |  %b  |   %b", $time, rst, j, k, q_jk, q_bar_jk);

        @(posedge clk); #1;                 // Toggle lan 2
        $display("%3d ns |  %b  | %b | %b |  %b  |   %b", $time, rst, j, k, q_jk, q_bar_jk);

        $display("=======================================================");
        #10 $finish;
    end

endmodule

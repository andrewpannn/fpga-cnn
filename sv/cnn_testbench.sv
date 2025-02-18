module cnn_testbench ();
    parameter N_p=4, M_p=4, K_p=2, R_p=16, C_p=16, S_p=1, Tn_p=2, Tm_p=2;

    shortreal fm_i[N_p][R_p][C_p] = '{default:0};
    shortreal weights_i[M_p][N_p][K_p][K_p] = '{default:0};
    shortreal fm_o[M_p][R_p][C_p];
    logic clk_i, reset_i;

    cnn #(.N_p( 4 ), .M_p( 4 ), .K_p( 2 ), .R_p( 16 )
        ,.C_p( 16 ), .S_p( 1 ), .Tn_p ( 2 ), .Tm_p( 2 ) )
        dut
        (fm_i
        ,weights_i
        ,clk_i
        ,reset_i
        ,fm_o
        );

    // Set up a simulated clock.
    parameter CLOCK_PERIOD=100;
    initial begin
        clk_i <= 0;
        forever #(CLOCK_PERIOD/2) clk_i <= ~clk_i;
    end

    // test counter
    initial begin
        reset_i <= 0; @(posedge clk_i);
        reset_i <= 1; @(posedge clk_i);
        reset_i <= 0; @(posedge clk_i);
        repeat(100) @(posedge clk_i);
        $stop;

    end
endmodule
module cnn_testbench ();
    parameter N_p=4, M_p=4, K_p=2, R_p=4, C_p=4, S_p=1, Tn_p=2, Tm_p=2;

    shortreal fm_i[N_p][R_p][C_p];
    shortreal weights_i[M_p][N_p][K_p][K_p];
    shortreal fm_o[M_p][R_p][C_p];
    logic clk_i, reset_i, valid_i;

    initial begin
        for (int i = 0; i < N_p; i++) begin
            for (int j = 0; j < R_p; j++) begin
                for (int k = 0; k < C_p; k++) begin
                    fm_i[i][j][k] = shortreal'($urandom_range(0, 1000000)) / 1000000.0;
                end
            end
        end
    end

    initial begin
        for (int x = 0; x < M_p; x++) begin
            for (int i = 0; i < N_p; i++) begin
                for (int j = 0; j < K_p; j++) begin
                    for (int k = 0; k < K_p; k++) begin
                        weights_i[x][i][j][k] = 1;
                    end
                end
            end
        end
    end

    cnn #(.N_p( N_p ), .M_p( M_p ), .K_p( K_p ), .R_p( R_p )
        ,.C_p( C_p ), .S_p( S_p ), .Tn_p ( Tn_p ), .Tm_p( Tm_p ) )
        dut
        (fm_i
        ,weights_i
        ,clk_i
        ,reset_i
        ,valid_i
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
        valid_i <= 1; @(posedge clk_i);
        valid_i <= 0; @(posedge clk_i);
        repeat(300) @(posedge clk_i);
        $stop;

    end
endmodule
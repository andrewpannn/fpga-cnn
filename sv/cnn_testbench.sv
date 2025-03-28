module cnn_testbench ();
    parameter N_p=1, M_p=2, K_p=1, R_p=4, C_p=4, S_p=1, Tn_p=1, Tm_p=1;

    shortreal fm_i[N_p][R_p][C_p];
    shortreal weights_i[M_p][N_p][K_p][K_p];
    shortreal fm_o[M_p][R_p][C_p];
    shortreal output_final[M_p][R_p][C_p];
    logic clk_i, reset_i, valid_i;

    /*
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
    */

    // initialize mem
    mem #(.N_p( N_p ), .M_p( M_p ), .K_p( K_p ), .R_p( R_p ), .C_p( C_p ))
        cnn_mem
        (.input_fm_o( fm_i )
        ,.weights_o( weights_i )
        ,.output_fm_o( output_final )
        );

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
        // check output values match python script
        for ( int i = 0; i < M_p; i++ ) begin
            for ( int j = 0; j < R_p; j ++) begin
                for ( int k = 0; k < C_p; k++ ) begin
                    assert ( (fm_o[i][j][k] < (output_final[0][0][0] * 1.01)) | (fm_o[0][0][0] > (output_final[0][0][0] * 0.99)) ) $display("output fm[%0d][%0d][%0d] match", i, j, k);
                    else                                            $display("output fm[%0d][%0d][%0d] does not match", i, j, k);
                end
            end
        end

        $stop;
    end
endmodule
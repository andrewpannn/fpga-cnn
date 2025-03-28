// Andrew Pan
// EE 538D
// reads memfiles to initialize matrices for cnn
// acts as a ROM for system to use
// utilizes IEEE 754 (float in C, shortreal in SV)
// transform N x 32 inputs to appropriately sized shortreal matrices

module mem
    #(parameter N_p=4, parameter M_p=4, parameter K_p=2
    ,parameter R_p=16, parameter C_p=16
    )

    (output shortreal input_fm_o[N_p][R_p][C_p]
    ,output shortreal weights_o[M_p][N_p][K_p][K_p]
    ,output shortreal output_fm_o[M_p][R_p][C_p]
    );
    // initialize mems to store memfiles
    logic [31:0] input_fm_mem [( N_p*R_p*C_p-1 ):0];
    logic [31:0] weights_mem [( M_p*N_p*K_p*K_p-1 ):0];
    logic [31:0] output_fm_mem [( M_p*R_p*C_p-1 ):0];

    // read inputs
    initial $readmemb("../test/input_fm.dat", input_fm_mem);
    initial $readmemb("../test/weights.dat", weights_mem);
    initial $readmemb("../test/output_fm.dat", output_fm_mem);

    // reshape input mem to fit shortreal array
    int itr0 = 0;
    initial begin
        for (int i = 0; i < N_p; i++) begin
            for (int j = 0; j < R_p; j++) begin
                for (int k = 0; k < C_p; k++) begin
                    input_fm_o[i][j][k] = $bitstoshortreal( input_fm_mem[itr0] );
                    itr0++;
                end
            end
        end
    end

    // reshape weights mem to fit shortreal array
    int itr1 = 0;
    initial begin
        for (int i = 0; i < N_p; i++) begin
            for (int j = 0; j < M_p; j++) begin
                for (int k = 0; k < K_p; k++) begin
                    for (int l = 0; l < K_p; l++) begin
                        weights_o[i][j][k][l] = $bitstoshortreal( weights_mem[itr1] );
                        itr1++;
                    end
                end
            end
        end
    end

    // reshape output mem to fit shortreal array
    int itr2 = 0;
    initial begin
        for (int i = 0; i < M_p; i++) begin
            for (int j = 0; j < R_p; j++) begin
                for (int k = 0; k < C_p; k++) begin
                    output_fm_o[i][j][k] = $bitstoshortreal( output_fm_mem[itr2] );
                    itr2++;
                end
            end
        end
    end
endmodule
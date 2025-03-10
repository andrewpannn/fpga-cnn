module mem
    #(parameter N_p=4, parameter M_p=4, parameter K_p=2
    ,parameter R_p=16, parameter C_p=16
    )

    (output shortreal input_fm_o[N_p][R_p][C_p]
    );
    // initialize mems to store memfiles
    logic [(N_p*R_p*C_p):0] input_fm_mem [31:0];

    // initialize shortreal arrays
    shortreal input_fm[N_p][R_p][C_p];
    shortreal weights[M_p][N_p][K_p][K_p];
    shortreal output_fm[M_p][R_p][C_p];

    // modify the name and potentially directory prefix of the file within to load the correct program and preprocessing
    initial $readmemb("../input_fm.dat", memory);

    // reshape mem to fit shortreal array
    int itr0 = 0;
    initial begin
        for (int i = 0; i < N_p; i++) begin
            for (int j = 0; j < R_p; j++) begin
                for (int k = 0; k < C_p; k++) begin
                    fm_i[i][j][k] = $bitstoshortreal(input_fm_mem[itr0]);
                end
            end
        end
    end
endmodule
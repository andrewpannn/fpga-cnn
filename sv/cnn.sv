// top level for cnn
// assumes on-chip storage of data

module cnn 
    #(parameter N_p=4, parameter M_p=4, parameter K_p=2
    ,parameter R_p=16, parameter C_p=16, parameter S_p=1
    ,parameter Tn_p=2, parameter Tm_p=2
    )

    (input shortreal fm_i[N_p][R_p][C_p]
    ,input shortreal weights_i[M_p][N_p][K_p][K_p]
    ,input logic clk_i
    ,input logic reset_i
    ,output shortreal fm_o[M_p][R_p][C_p]
    );

    // ******** CONTROL ********
    // instantiate iterator counters
    int row, col;
    int i, j;
    logic pulse_j, pulse_i, pulse_col, pulse_row;
    cnn_counter (.max_p( K_p ))
        j_counter
        (.reset_i(reset_i)
        ,.clk_i(clk_i)
        ,.en_i(~reset_i)
        ,.pulse_o(pulse_j)
        ,.it_o(j)
        );
    
    cnn_counter (.max_p( K_p ))
        i_counter
        (.reset_i(reset_i)
        ,.clk_i(clk_i)
        ,.en_i(pulse_j)
        ,.pulse_o(pulse_i)
        ,.it_o(i)
        );
    
    cnn_counter (.max_p( K_p ))
        col_counter
        (.reset_i(reset_i)
        ,.clk_i(clk_i)
        ,.en_i(pulse_i)
        ,.pulse_o(pulse_col)
        ,.it_o(col)
        );
    
    cnn_counter (.max_p( K_p ))
        row_counter
        (.reset_i(reset_i)
        ,.clk_i(clk_i)
        ,.en_i(pulse_col)
        ,.pulse_o(pulse_row)
        ,.it_o(row)
        );

    // ******** DATAPATH ********
    shortreal weights_lo[Tm_p][Tn_p]; // fed into outloop
    shortreal fm_lo[Tn_p]; 

    assign fm_lo[0] = {tii, tii+1, tii+2, tii+3};
    assign fm_lo[1]

    // generate vector for fm_lo
    genvar k
    generate
        for (k = 0; k < Tn_p) begin
            assign fm_lo[k] = fm_i[k][i][k];
        end
    endgenerate

    // generate vector for weights_lo

    module #(.Tm_p( Tm_p ), Tn_p( Tn_p ))
        loop 
        (.weights_i
        ,.fm_i)


endmodule
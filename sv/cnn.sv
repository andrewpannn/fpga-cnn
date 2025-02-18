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
    int to, ti;
    int i, j;
    logic pulse_j, pulse_i, pulse_ti, pulse_to, pulse_col, pulse_row;

    cnn_counter (.max_p( K_p ), .stride_p ( 1 ))
        j_counter
        (.reset_i(reset_i)
        ,.clk_i(clk_i)
        ,.en_i(~reset_i)
        ,.pulse_o(pulse_j)
        ,.it_o(j)
        );
    
    cnn_counter (.max_p( K_p ), .stride_p ( 1 ))
        i_counter
        (.reset_i(reset_i)
        ,.clk_i(clk_i)
        ,.en_i(pulse_j)
        ,.pulse_o(pulse_i)
        ,.it_o(i)
        );
    
    cnn_counter (.max_p( N_p ), .stride_p ( Tn_p ))
        ti_counter
        (.reset_i(reset_i)
        ,.clk_i(clk_i)
        ,.en_i(pulse_i)
        ,.pulse_o(pulse_ti)
        ,.it_o(i)
        )
    
    cnn_counter (.max_p( M_p ), .stride_p ( Tm_p ))
        to_counter
        (.reset_i(reset_i)
        ,.clk_i(clk_i)
        ,.en_i(pulse_ti)
        ,.pulse_o(pulse_to)
        ,.it_o(i)
        )
    
    cnn_counter (.max_p( C_p ), .stride_p ( 1 ))
        col_counter
        (.reset_i(reset_i)
        ,.clk_i(clk_i)
        ,.en_i(pulse_to)
        ,.pulse_o(pulse_col)
        ,.it_o(col)
        );
    
    cnn_counter (.max_p( R_p ), .stride_p ( 1 ))
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
    shortreal fm_reg_o[Tm_p][R_p][C_p];
    shortreal fm_reg_n[Tm_p]; // output from loop module

    // generate vector for fm_lo
    genvar k;
    generate
        for (k = 0; k < Tn_p) begin
            assign fm_lo[k] = fm_i[k][i][k];
        end
    endgenerate

    // generate vector for weights_lo
    /*
    genvar x;
    generate
        for (x = 0; x < Tm_p; x++) begin
            for (int y = 0; y < Tn_p; y++) begin
                assign weights_lo[x][y] = weights_i[x][y][i][j];
            end
        end
    endgenerate
    */

    output_loop #(.Tm_p( Tm_p ), Tn_p( Tn_p ))
        loop 
        (.weights_i( weights_lo )
        ,.fm_i( fm_lo )
        ,.fm_init_i ( '{default:0} )
        ,.fm_o ( fm_reg_n )
        );

    // store output in reg
    always_ff @( clk_i ) begin
        if (reset_i) begin
            fm_reg_o <= '{default:0};
        end
    end
    // update corresponding output fm
    genvar z;
    generate
        for (z = 0; z < Tm_p; z++) begin
            always_ff @( clk_i) begin
                fm_reg_o[z][row][col] <= fm_reg_n[z];
            end
        end
    endgenerate
    
    assign fm_o = fm_reg_o;

endmodule

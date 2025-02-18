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
    ,input logic valid_i
    ,output shortreal fm_o[M_p][R_p][C_p]
    );

    // ******** CONTROL ********
    // instantiate iterator counters
    int row, col;
    int to, ti;
    int i, j;
    logic pulse_j, pulse_i, pulse_ti, pulse_to, pulse_col, pulse_row;
    logic done;

    cnn_counter #(.max_p( K_p ), .stride_p ( 1 ))
        j_counter
        (.reset_i(reset_i)
        ,.clk_i(clk_i)
        ,.en_i(( ~reset_i ) & ( ~done ))
        ,.pulse_o(pulse_j)
        ,.it_o(j)
        );
    
    cnn_counter #(.max_p( K_p ), .stride_p ( 1 ))
        i_counter
        (.reset_i(reset_i)
        ,.clk_i(clk_i)
        ,.en_i(pulse_j)
        ,.pulse_o(pulse_i)
        ,.it_o(i)
        );
    
    cnn_counter #(.max_p( N_p ), .stride_p ( Tn_p ))
        ti_counter
        (.reset_i(reset_i)
        ,.clk_i(clk_i)
        ,.en_i(pulse_i)
        ,.pulse_o(pulse_ti)
        ,.it_o(ti)
        );
    
    cnn_counter #(.max_p( M_p ), .stride_p ( Tm_p ))
        to_counter
        (.reset_i(reset_i)
        ,.clk_i(clk_i)
        ,.en_i(pulse_ti)
        ,.pulse_o(pulse_to)
        ,.it_o(to)
        );
    
    cnn_counter #(.max_p( C_p ), .stride_p ( 1 ))
        col_counter
        (.reset_i(reset_i)
        ,.clk_i(clk_i)
        ,.en_i(pulse_to)
        ,.pulse_o(pulse_col)
        ,.it_o(col)
        );
    
    cnn_counter #(.max_p( R_p ), .stride_p ( 1 ))
        row_counter
        (.reset_i(reset_i)
        ,.clk_i(clk_i)
        ,.en_i(pulse_col)
        ,.pulse_o(pulse_row)
        ,.it_o(row)
        );

    // FSM for state control
    // TODO: change typedef
    typedef enum {eWAIT, eBUSY, eDONE} state_e;
    state_e state_p, state_n;

    // next state logic
    always_comb begin
        case(state_p)
            eWAIT: if (valid_i) state_n = eBUSY;
                else state_n = eWAIT;
            eBUSY: if (pulse_row) state_n = eDONE;
                else state_n = eBUSY;
            eDONE: state_n = eDONE;
        endcase
    end

    assign done = (state_p == eDONE);

    // store state for state machine, reset to eWAIT
    always_ff @(posedge clk_i) begin
        if (reset_i) state_p <= eWAIT;
        else state_p <= state_n;
    end

    
    // ******** DATAPATH ********
    shortreal weights_lo[Tm_p][Tn_p]; // fed into outloop
    shortreal fm_lo[Tn_p]; 
    // shortreal fm_reg_o[Tm_p][R_p][C_p];
    shortreal fm_reg_n[Tm_p]; // output from loop module

    // generate vector for fm_lo
    genvar k;
    generate
        for (k = 0; k < Tn_p; k++) begin
            assign fm_lo[k] = fm_i[k][i][k];
        end
    endgenerate

    // generate vector for weights_lo
    // hardcode for now TODO: fix
    genvar x;
    generate
        for (x = 0; x < Tn_p; x++) begin
            assign weights_lo[0][x] = weights_i[0][x][i][j];
        end
    endgenerate

    genvar y;
    generate
        for (y = 0; y < Tn_p; y++) begin
            assign weights_lo[1][y] = weights_i[1][y][i][j];
        end
    endgenerate

    shortreal init_test[2] = {0, 0};

    output_loop #(.Tm_p( Tm_p ), .Tn_p( Tn_p ))
        loop 
        (.weights_i( weights_lo )
        ,.fm_i( fm_lo )
        ,.fm_init_i ( init_test )
        ,.fm_o ( fm_reg_n )
        );

    // store output in reg
    // reset all values to 0
    always_ff @( clk_i ) begin
        if (reset_i) begin
            for (int i = 0; i < N_p; i++) begin
                for (int j = 0; j < R_p; j++) begin
                    for (int k = 0; k < C_p; k++) begin
                        fm_o[i][j][k] <= 0;
                    end
                end
            end
        end
    end
    // update corresponding output fm
    genvar z;
    generate
        for (z = 0; z < Tm_p; z++) begin
            always_ff @( clk_i) begin
                fm_o[to + z][row][col] <= fm_reg_n[z] + fm_o[to + z][row][col];
            end
        end
    endgenerate
    
endmodule

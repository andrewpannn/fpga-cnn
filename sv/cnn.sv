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
    logic [$clog2( K_p )-1 : 0] j_lo, i_lo;
    logic [$clog2( N_p )-1 : 0] ti_lo;
    logic [$clog2( M_p )-1 : 0] to_lo;
    logic [$clog2( C_p )-1 : 0] col_lo;
    logic [$clog2( K_p )-1 : 0] row_lo;

    logic counter_done_lo
    logic busy;

    iterator 
        #(.N_p(N_p), .M_p(M_p), .K_p(K_p), .R_p(R_p), .C_p(C_p))
        itr
        (.clk_i(clk_i)
        ,.reset_i(reset_i)
        ,.busy_i(busy)
        ,.j_o(j_lo)
        ,.i_o(i_lo)
        ,.ti_o(ti_lo)
        ,.to_o(to_lo)
        ,.col_o(col_lo)
        ,.row_o(row_lo)
        );
        
    // FSM for state control
    // TODO: change typedef
    typedef enum [1:0] {eWAIT, eBUSY, eDONE} state_e;
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

    assign busy = (state_p == eBUSY);

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
            assign fm_lo[k] = fm_i[k][i_lo][k];
        end
    endgenerate

    // generate vector for weights_lo
    // hardcode for now TODO: fix
    genvar x;
    generate
        for (x = 0; x < Tn_p; x++) begin
            assign weights_lo[0][x] = weights_i[0][x][i_lo][j_lo];
        end
    endgenerate

    genvar y;
    generate
        for (y = 0; y < Tn_p; y++) begin
            assign weights_lo[1][y] = weights_i[1][y][i_lo][j_lo];
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
                fm_o[to + z][row_lo][col_lo] <= fm_reg_n[z] + fm_o[to + z][row_lo][col_lo];
            end
        end
    endgenerate
    
endmodule

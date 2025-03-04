// manages iterators for cnn.sv
module iterator 
    #(parameter N_p=4, parameter M_p=4, parameter K_p=2
    ,parameter R_p=16, parameter C_p=16
    )

    (input logic clk_i
    ,input logic reset_i
    ,input logic busy_i
    ,output logic [$clog2( K_p )-1 : 0] j_o
    ,output logic [$clog2( K_p )-1 : 0] i_o
    ,output logic [$clog2( N_p )-1 : 0] ti_o
    ,output logic [$clog2( M_p )-1 : 0] to_o
    ,output logic [$clog2( C_p )-1 : 0] col_o
    ,output logic [$clog2( K_p )-1 : 0] row_o
    ,output logic done_o
    );

    // instantiate iterator counters
    logic pulse_j_lo, pulse_i_lo, pulse_ti_lo, pulse_to_lo
        ,pulse_col_lo, pulse_row_lo;

    assign done_o = pulse_row_lo;

    cnn_counter #(.max_p( K_p ), .stride_p ( 1 ))
        j_counter
        (.reset_i(reset_i)
        ,.clk_i(clk_i)
        ,.en_i(( ~reset_i ) & ( busy_i ))
        ,.pulse_o(pulse_j_lo)
        ,.it_o(j_o)
        );
    
    cnn_counter #(.max_p( K_p ), .stride_p ( 1 ))
        i_counter
        (.reset_i(reset_i)
        ,.clk_i(clk_i)
        ,.en_i(pulse_j_lo)
        ,.pulse_o(pulse_i_lo)
        ,.it_o(i_o)
        );
    
    cnn_counter #(.max_p( N_p ), .stride_p ( Tn_p ))
        ti_counter
        (.reset_i(reset_i)
        ,.clk_i(clk_i)
        ,.en_i(pulse_i_lo)
        ,.pulse_o(pulse_ti_lo)
        ,.it_o(ti_o)
        );
    
    cnn_counter #(.max_p( M_p ), .stride_p ( Tm_p ))
        to_counter
        (.reset_i(reset_i)
        ,.clk_i(clk_i)
        ,.en_i(pulse_ti_lo)
        ,.pulse_o(pulse_to_lo)
        ,.it_o(to_o)
        );
    
    cnn_counter #(.max_p( C_p ), .stride_p ( 1 ))
        col_counter
        (.reset_i(reset_i)
        ,.clk_i(clk_i)
        ,.en_i(pulse_to_lo)
        ,.pulse_o(pulse_col_lo)
        ,.it_o(col_o)
        );
    
    cnn_counter #(.max_p( R_p ), .stride_p ( 1 ))
        row_counter
        (.reset_i(reset_i)
        ,.clk_i(clk_i)
        ,.en_i(pulse_col_lo)
        ,.pulse_o(pulse_row_lo)
        ,.it_o(row_o)
        );

endmodule

// top level for cnn
// assumes on-chip storage of data

module cnn 
    #(parameter N_p=4, parameter M_p=4, parameter K_p=2
    ,parameter R_p=16, parameter C_p=16, parameter S_p=1
    ,parameter Tn_p=2, parameter Tm_p=2
    )

    (input shortreal fm_i[N_p][R_p][C_p]
    ,input shortreal weights_i[M_p][N_p][K_p][K_p]
    ,input logic clk
    ,input logic reset
    ,output shortreal fm_o[M_p][R_p][C_p]
    );

    int row, col;
    int i, j;

    shortreal weights_lo[Tm_p][Tn_p]; // fed into outloop
    shortreal fm_lo[Tn_p]; 

    assign fm_lo[0] = {tii, tii+1, tii+2, tii+3};
    assign fm_lo[1]

    module #(.Tm_p( Tm_p ), Tn_p( Tn_p ))
        loop 
        (.weights_i
        ,.fm_i)


endmodule
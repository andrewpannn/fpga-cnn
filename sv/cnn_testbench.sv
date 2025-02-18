module cnn_testbench ();
    cnn #(.N_p( 4 ), .M_p( 4 ), .K_p( 2 ), .R_p( 16 )
        ,.S_p( 1 ), .Tn_p ( 2 ), .Tm_p( 2 ) )
        dut
        ();
endmodule
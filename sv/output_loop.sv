// second loop unrolling
// for(too=to; too<min(to+Tm,M); too++)
// unrolls along output map dimension

module output_loop #(parameter Tm_p = 1, parameter Tn_p = 1)
    (input shortreal weights_i [Tm_p][Tn_p]
    ,input shortreal fm_i [Tm_p][Tn_p]
    ,input shortreal fm_init_i [Tm_p]
    ,output shortreal fm_o [Tm_p]
    );

    // create an instance of input_loop module for each output map
    genvar i;
    generate
    for (i = 0; i < Tm_p; i++) begin
        input_loop #(.Tn_p( Tn_p ))
        compute (.fm_i( fm_i[i] )
                ,.weights_i( weights_i[i] )
                ,.fm_init_i( fm_init_i[i] )
                ,.fm_o( fm_o[i] )
                );
    end
    endgenerate
endmodule

module output_loop_testbench();
    shortreal weights_i[2][3];
    shortreal fm_i[2][3];
    shortreal fm_init_i[2];
    shortreal fm_o[2];

    output_loop #(.Tm_p( 2 ), .Tn_p( 3 )) dut
        (weights_i
        ,fm_i
        ,fm_init_i
        ,fm_o
        );

    initial begin
        weights_i[0][2] = 0; weights_i[0][1] = 0; weights_i[0][0] = 1;
        fm_i[0][2] = 20; fm_i[0][1] = 5; fm_i[0][0] = 7.2;
        fm_init_i[0] = 10.5; 
        weights_i[1][2] = 0; weights_i[1][1] = 0; weights_i[1][0] = 0;
        fm_i[1][2] = 20; fm_i[1][1] = 5; fm_i[1][0] = 7.2;
        fm_init_i[1] = 0; 
        #10
        $stop;
    end
endmodule
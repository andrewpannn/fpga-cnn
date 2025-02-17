// second loop unrolling
// for(too=to; too<min(to+Tm,M); too++)
// unrolls along output map dimension

module output_loop #(parameter Tm_p = 1, parameter Tn_p = 1)
    (input shortreal weights_i [Tm_p - 1:0][Tn_p - 1:0]
    ,input shortreal fm_i [Tm_p - 1:0][Tn_p - 1:0]
    ,input shortreal fm_init_i [Tm_p]
    ,output shortreal fm_o [Tm_p - 1:0]
    );

    // create an instance of input_loop module for each output map
    genvar i;
    for (i = 0; i < Tm_p; i++) begin
        input_loop #(.Tn_p( Tn_p ))
        compute (.fm_i( fm_i[i] )
                ,.weights_i( weights_i[i] )
                ,.fm_init_i( fm_init_i[i] )
                ,.fm_o( fm_o[i] )
                );
    end
endmodule
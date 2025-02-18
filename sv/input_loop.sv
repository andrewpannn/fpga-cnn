// innermost loop unrolling
// for (tii=ti; tii<min(ti+Tn, N); tii++)
// feedforward combinational logic
// shortreal = c float

module input_loop 
    #(parameter Tn_p=1)
    (input shortreal fm_i [Tn_p]
    ,input shortreal weights_i[Tn_p] // stored in buffer
    ,input shortreal fm_init_i // initial value of fm output_fm[too][trr][tcc
    ,output shortreal fm_o
    );
    shortreal activation [Tn_p]; // input fm * weight

    // generate multiplication between input fm and weight
    genvar i;
    generate
    for (i = 0; i < Tn_p; i++) begin
        assign activation[i] = fm_i[i] * weights_i[i];
    end
    endgenerate
    
    shortreal sum;
    // sum together all activations
    always_comb begin
        sum = 0;
        for (int j = 0; j < Tn_p; j++) begin
            sum += activation[j];
        end
    end

    assign fm_o = sum + fm_init_i;
endmodule

module input_loop_testbench();
    // Tn_p = 2
    shortreal weights_i[3];
    shortreal fm_i[3];
    shortreal fm_init_i, fm_o;

    input_loop #(.Tn_p( 3 )) dut
        (.fm_i( fm_i )
        ,.weights_i( weights_i )
        ,.fm_init_i( fm_init_i )
        ,.fm_o( fm_o )
        );

    initial begin
        weights_i[2] = 10; weights_i[1] = 10; weights_i[0] = 10;
        fm_i[2] = 20; fm_i[1] = 5; fm_i[0] = 7.2;
        fm_init_i = 0; 
        #10
        weights_i[2] = 10; weights_i[1] = 10; weights_i[0] = 10;
        fm_i[2] = 20; fm_i[1] = 5; fm_i[0] = 7.2;
        fm_init_i = 1.54;
        #10
        weights_i[2] = 0; weights_i[1] = 5; weights_i[0] = 10;
        fm_i[2] = 1.72; fm_i[1] = 7.2; fm_i[0] = 7.2;
        fm_init_i = 0;
        #10
        $stop;
    end

endmodule


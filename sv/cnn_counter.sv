// counter with pulse
// TODO: add stride
// TODO: change output type from int to logic vector

module cnn_counter #(parameter max_p= 4, parameter stride_p = 1) 
    (input logic reset_i
    ,input logic clk_i
    ,input logic en_i
    ,output logic pulse_o
    ,output int it_o
    );

    int it_n;
    logic pulse_n;

    //advance if en_i is detected, reset back to zero if exceeds max

    always_comb begin
        it_n = it_o;
        pulse_n = 0;
        if (en_i) begin
            if (it_o == max_p - 1) begin
                pulse_n = 1;
                it_n = 0;
            end
            else begin
                pulse_n = 0;
                it_n = it_o + stride_p;
            end
        end
    end

    always_ff @(posedge clk_i) begin
        if (reset_i) begin
            it_o <= 0;
            pulse_o <= 0;
        end
        else begin
            it_o <= it_n;
            pulse_o <= pulse_n;
        end
    end


endmodule

module cnn_counter_testbench();
    logic reset_i, clk_i, en_i;
    logic pulse_o, pulse2;
    int it_o, it2;

    cnn_counter #(.max_p( 3 )) 
        dut (reset_i, clk_i, en_i, pulse_o, it_o);

    cnn_counter #(.max_p( 2 )) 
        dut2 
        (.reset_i(reset_i)
        ,.clk_i(clk_i)
        ,.en_i(pulse_o)
        ,.pulse_o(pulse2)
        ,.it_o(it2)
        );
    // Set up a simulated clock.
    parameter CLOCK_PERIOD=100;
    initial begin
        clk_i <= 0;
        forever #(CLOCK_PERIOD/2) clk_i <= ~clk_i;
    end

    initial begin
        @(posedge clk_i);
        reset_i <= 1; @(posedge clk_i);
        reset_i <= 0; @(posedge clk_i);
        en_i <= 1; @(posedge clk_i);
        en_i <= 1; @(posedge clk_i);
        en_i <= 0; @(posedge clk_i);
        en_i <= 1; @(posedge clk_i);
        en_i <= 1; @(posedge clk_i);
        en_i <= 1; @(posedge clk_i);
        en_i <= 1; @(posedge clk_i);
        @(posedge clk_i);
        @(posedge clk_i);
        @(posedge clk_i);
        @(posedge clk_i);
        $stop;
    end
endmodule
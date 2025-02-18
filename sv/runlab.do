vlib work

# vlog -work work ./*.sv
# ALL files relevant to the testbench should be listed here. 
#vlog -work work ./output_loop.sv
#vlog -work work ./input_loop.sv
vlog -work work ./cnn_counter.sv

# Note that the name of the testbench module is in this statement. If you're running a testbench with a different name CHANGE IT
vsim -voptargs="+acc" -t 1ps -lib work cnn_counter_testbench

# do <wave>.do
do wave.do

view signals
view wave

run -all
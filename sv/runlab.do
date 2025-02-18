vlib work

# ALL files relevant to the testbench should be listed here. 
vlog -work work ./*.sv

# Note that the name of the testbench module is in this statement. If you're running a testbench with a different name CHANGE IT
vsim -voptargs="+acc" -t 1ps -lib work output_loop_testbench

# do <wave>.do
do wave.do

view signals
view wave

run -all
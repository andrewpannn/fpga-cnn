vlib work

# ALL files relevant to the testbench should be listed here. 
vlog -work work ./*.sv

# Note that the name of the testbench module is in this statement. If you're running a testbench with a different name CHANGE IT
vsim -t 1fs -novopt input_loop_testbench -L unisim -L secureip -L unifast -L unimacro

view signals
view wave

# This is the wave file which stores all signals you're looking at along with their radix and other settings. If you use this feature make sure the name matches
# the saved file, otherwise ignore this.

run -all
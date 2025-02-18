onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cnn_counter_testbench/CLOCK_PERIOD
add wave -noupdate /cnn_counter_testbench/reset_i
add wave -noupdate /cnn_counter_testbench/clk_i
add wave -noupdate /cnn_counter_testbench/en_i
add wave -noupdate /cnn_counter_testbench/pulse_o
add wave -noupdate /cnn_counter_testbench/it_o
add wave -noupdate /cnn_counter_testbench/it2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 50
configure wave -gridperiod 100
configure wave -griddelta 2
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {400 ps} {1400 ps}

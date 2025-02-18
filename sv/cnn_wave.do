onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cnn_testbench/clk_i
add wave -noupdate /cnn_testbench/reset_i
add wave -noupdate /cnn_testbench/dut/state_p
add wave -noupdate /cnn_testbench/fm_i
add wave -noupdate /cnn_testbench/weights_i
add wave -noupdate /cnn_testbench/fm_o
add wave -noupdate /cnn_testbench/dut/row
add wave -noupdate /cnn_testbench/dut/col
add wave -noupdate /cnn_testbench/dut/to
add wave -noupdate /cnn_testbench/dut/ti
add wave -noupdate /cnn_testbench/dut/i
add wave -noupdate /cnn_testbench/dut/j
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
WaveRestoreZoom {99500 ps} {100500 ps}

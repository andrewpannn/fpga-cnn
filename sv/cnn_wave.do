onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group cnn /cnn_testbench/clk_i
add wave -noupdate -group cnn /cnn_testbench/reset_i
add wave -noupdate -group cnn /cnn_testbench/dut/state_p
add wave -noupdate -group cnn -expand /cnn_testbench/dut/fm_i_lo
add wave -noupdate -group cnn /cnn_testbench/weights_i
add wave -noupdate -group cnn /cnn_testbench/fm_o
add wave -noupdate -group cnn /cnn_testbench/dut/j_lo
add wave -noupdate -group cnn /cnn_testbench/dut/i_lo
add wave -noupdate -group mem /cnn_testbench/cnn_mem/input_fm_mem
add wave -noupdate -group mem /cnn_testbench/cnn_mem/weights_mem
add wave -noupdate -group mem /cnn_testbench/cnn_mem/output_fm_mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {199 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {29500 ps} {30500 ps}

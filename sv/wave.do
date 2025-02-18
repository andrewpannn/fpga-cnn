onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /output_loop_testbench/dut/Tm_p
add wave -noupdate /output_loop_testbench/dut/Tn_p
add wave -noupdate /output_loop_testbench/dut/weights_i
add wave -noupdate /output_loop_testbench/dut/fm_i
add wave -noupdate /output_loop_testbench/dut/fm_init_i
add wave -noupdate -expand /output_loop_testbench/dut/fm_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 198
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
WaveRestoreZoom {1 ps} {11 ps}

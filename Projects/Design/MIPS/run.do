vlog code_segment.v data_segment.v memory.v alu.v control_unit.v register_file.v mips.v system.v transaction.sv simulation.sv
vsim -voptargs=+acc work.testbench
add wave -position insertpoint sim:/testbench/dut/*
add wave -position insertpoint sim:/testbench/dut/mips_inst/RF/*
run -all
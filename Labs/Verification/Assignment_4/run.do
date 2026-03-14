vlog interface.sv uart_tx.sv A_4.sv +cover -covercells
vsim work.top -coverage
coverage save -onexit cov.ucdb
add wave -position insertpoint sim:/top/uart_bus/*
run -all
coverage report -details -output cov_report.txt 
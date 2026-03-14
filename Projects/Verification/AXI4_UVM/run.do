vlog -f files.txt +cover -covercells
vsim -assertdebug +acc -voptargs=+acc work.top -cover
coverage save -onexit cov.ucdb
add wave -radix hex /top/dut/*
run -all
coverage report -details -output cov_report.txt
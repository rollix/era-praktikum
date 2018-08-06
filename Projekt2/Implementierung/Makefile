all: ALU_gtk

ALU_tb: ALU_tb.vhdl ALU.vhdl
	ghdl -a ALU.vhdl
	ghdl -a ALU_tb.vhdl
	ghdl -e ALU_tb
    
ALU: ALU_tb
	ghdl -r ALU_tb --vcd=ALU.vcd

ALU_gtk: ALU ALU.vcd
	gtkwave ALU.vcd --save=ALU_config.gtkw


../builder/csim.exe: 

csim:
	$(MAKE) -C ../builder run
	

rtl.ok: csim 
	cd ../IP/ &&\
	/tools/Xilinx/Vivado/2019.1/bin/vivado_hls CNNAccel/default/rtl_export.tcl
	touch rtl.ok

rtl: rtl.ok

cosim: rtl
	$(MAKE) -C ../builder/ -f cosim.mk run

all: cosim
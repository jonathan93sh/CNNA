
#export $(MAIN_SRC)

SOLUTION_DIR := ../IP/CNNAccel/default

all: loadsrc
	make -f csimrtl.mk all V=1

run: all
	vivado_hls run_sim.tcl

clean: 
	#rm -f *.h
	#rm -f *.cpp
	#rm -f *.hpp
	#rm -f *.c
	#rm -fr obj
	
	
loadsrc: clean
	cp -f ../src/hwcore/dsp/imfilter.cpp imfilter.cpp
	#cp -f $(PROJECT_DIR)/* .
	cp -f $(SOLUTION_DIR)/syn/systemc/* .
	
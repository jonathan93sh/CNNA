# ==============================================================
# File generated on Wed Feb 20 00:28:21 +0100 2019
# Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
# SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
# IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
# Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
# ==============================================================
CSIM_DESIGN = 1

__SIM_FPO__ = 1

__SIM_MATHHLS__ = 1

__SIM_OPENCV__ = 1

__SIM_FFT__ = 1

__SIM_FIR__ = 1

__SIM_DDS__ = 1



ObjDir = obj
PROJECT_DIR = .
HWCORE_DIR = ../src/hwcore
#SOLUTION_DIR = ../32bit
#export PROJECT_DIR
#export SOLUTION_DIR
#LOADE_SRC = $(shell cp -f $$ENV(PROJECT_DIR)/* .)
#LOADE_SRC = $(shell cp -f $$ENV(SOLUTION_DIR)/* .)

#HLS_SOURCES = $(MAIN_SRC)
#@echo "Main file is $(HLS_SOURCES)"
#echo ${MAIN_SRC}
HLS_SOURCES = $(wildcard *.cpp)

#HLS_SOURCES = ../../../src/main.cpp ../../../src/DMA_generic_performance_tester.cpp
#HLS_SOURCES += ../../syn/systemc/DMA_performance_tester_dma_loop_back_thread.cpp
#HLS_SOURCES += ../../syn/systemc/DMA_performance_tester_measure_n_transfers_thread.cpp
#HLS_SOURCES += ../../syn/systemc/DMA_performance_tester.cpp

OBJECTS := $(HLS_SOURCES:%.cpp=$(ObjDir)/$(notdir %.o)) 
DEPS := $(HLS_SOURCES:%.cpp=$(ObjDir)/$(notdir %.d)) 
TARGET := csim.exe

AUTOPILOT_ROOT := D:/Xilinx/Vivado/2018.3
AUTOPILOT_MACH := win64
ifdef AP_GCC_M32
  AUTOPILOT_MACH := Linux_x86
  IFLAG += -m32
endif
ifndef AP_GCC_PATH
  AP_GCC_PATH := D:/Xilinx/Vivado/2018.3/msys64/mingw64/bin
endif
AUTOPILOT_TOOL := ${AUTOPILOT_ROOT}/${AUTOPILOT_MACH}/tools
AP_CLANG_PATH := ${AUTOPILOT_ROOT}/msys64/mingw64/bin
AUTOPILOT_TECH := ${AUTOPILOT_ROOT}/common/technology


IFLAG += -I "${AUTOPILOT_TOOL}/systemc/include"
IFLAG += -I "${AUTOPILOT_ROOT}/include"
IFLAG += -I "${AUTOPILOT_ROOT}/include/opencv"
IFLAG += -I "${AUTOPILOT_ROOT}/include/ap_sysc"
IFLAG += -I "${AUTOPILOT_TECH}/generic/SystemC"
IFLAG += -I "${AUTOPILOT_TECH}/generic/SystemC/AESL_FP_comp"
IFLAG += -I "${AUTOPILOT_TECH}/generic/SystemC/AESL_comp"
IFLAG += -I "${AUTOPILOT_TOOL}/auto_cc/include"
IFLAG += -I "${HWCORE_DIR}"
IFLAG += -I "${HWCORE_DIR}/.."
IFLAG += -I "$(SOLUTION_DIR)/syn/systemc"
IFLAG += -D__HLS_TRACE_LEVEL_PORT__
IFLAG += -D__SIM_FPO__
IFLAG += -DDEBUG_SYSTEMC
IFLAG += -D__SIM_OPENCV__

IFLAG += -D__SIM_FFT__

IFLAG += -D__SIM_FIR__

IFLAG += -D__SIM_DDS__

IFLAG += -D__DSP48E1__
LFLAG += -L$(AUTOPILOT_TOOL)/systemc/lib -lsystemc
IFLAG += -g
IFLAG += -DNT
LFLAG += -Wl,--enable-auto-import 
DFLAG += -D__xilinx_ip_top= -DAESL_TB
CCFLAG += 
TOOLCHAIN += 



include ./Makefile.rules

#loadsrc: 
#	cp -f $(PROJECT_DIR)/* .
#	cp -f $(SOLUTION_DIR)/syn/systemc/* .
#	HLS_SOURCES = $(wildcard *.cpp)




all: $(TARGET)



#%.o: %.c $(DEPS)
#	$(Echo) "   Compiling $< in $(BuildMode) mode" $(AVE_DIR_DLOG)
#	$(Verb)  $(CC) ${CCFLAG} -c -MMD -DHW_COSIM -Wno-unknown-pragmas  $(IFLAG) $(DFLAG) $< -o $@ ; \

#$(TARGET): $(OBJECTS)
#	$(Echo) "   Compiling target in $(BuildMode) mode" $(AVE_DIR_DLOG)
#	$(Verb)  $(CC) ${CCFLAG} -c -MMD -DHW_COSIM -Wno-unknown-pragmas  $(IFLAG) $(DFLAG) -o $@ $^ ; \
	#$(CC) -o $@ $^ $(CFLAGS)


$(ObjDir)/%.o: %.cpp $(ObjDir)/.dir
	$(Echo) "   Compiling $< in $(BuildMode) mode" $(AVE_DIR_DLOG)
	$(Verb)  $(CC) ${CCFLAG} -c -MMD -DHW_COSIM -Wno-unknown-pragmas  $(IFLAG) $(DFLAG) $< -o $@ ; \

-include $(DEPS)

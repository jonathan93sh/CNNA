#include src
PWD = $(shell pwd)
LD_LIBRARY_PATH_LOCAL=$(LD_LIBRARY_PATH)
RTL_PATH ?= ./IP/CNNAccel/default
SYSTEMC_RTL_MODELS = $(RTL_PATH)/syn/systemc
VIVADO_SYSTEMC_MODELS = /tools/Xilinx/Vivado/2019.1/common/technology/generic/SystemC
BUILD_DIR ?= ./build
override PARAM_LIST ?= 
BUILD_DIR_COSIM := $(BUILD_DIR)/COSIM
RM=rm -f
CPPFLAGS=-g -I./src/ -MMD -MP -fprofile-arcs -ftest-coverage --coverage -D__RTL_SIMULATION__ -D__HLS_TRACE_LEVEL_PORT__
LDFLAGS=-g -I./src/ -fprofile-arcs -ftest-coverage --coverage -D__RTL_SIMULATION__ -D__HLS_TRACE_LEVEL_PORT__
#-D__SYNTHESIS__
CPPFLAGS+=$(PARAM_LIST:%=-D%)
LDFLAGS+=$(PARAM_LIST:%=-D%)
LDLIBS=

SRCS=
MAIN_SRCS=
include src/hwcore/tb/include.mk
#overwrite main src to only use the top one
MAIN_SRCS=src/hwcore/tb/cnn/main_cnn.cpp
#add systemC RTL model to srcs
SYSTEMC_SRCS = $(wildcard $(SYSTEMC_RTL_MODELS)/*.cpp)
SYSTEMC_SRCS_FIX = $(SYSTEMC_SRCS:%=$(BUILD_DIR_COSIM)/systemcfix/%.fix.cpp)
SRCS+=$(SYSTEMC_SRCS_FIX)
CPPFLAGS+= -I$(RTL_PATH) -I$(VIVADO_SYSTEMC_MODELS) -I$(SYSTEMC_RTL_MODELS) -I./src/hwcore/hls_missing_sysc_modules
LDFLAGS+= -I$(RTL_PATH) -I$(VIVADO_SYSTEMC_MODELS) -I$(SYSTEMC_RTL_MODELS) -I./src/hwcore/hls_missing_sysc_modules

#SRCS += $(MAIN_SRCS)
OBJS := $(SRCS:%=$(BUILD_DIR_COSIM)/%.o)
MAIN_OBJS := $(MAIN_SRCS:%=$(BUILD_DIR_COSIM)/%.o)
DEPS := $(OBJS:.o=.d) $(MAIN_OBJS:.o=.d)
EXECS := $(MAIN_OBJS:.o=.run)
RES := $(MAIN_OBJS:.o=.ok)
MAIN_OBJS_DIRS := $(sort $(dir $(MAIN_OBJS)))
LCOV_FLAGS := $(MAIN_OBJS_DIRS:%=--directory %)
include lib_arch/systemc/cflags.mk

clean_run: clean run

all: coverage

run: test

build: $(EXECS) $(BUILD_DIR_COSIM)/.fix

test: $(BUILD_DIR_COSIM)/.test_cosim

coverage: $(BUILD_DIR_COSIM)/.coverage_cosim


$(BUILD_DIR_COSIM)/.fix: $(SYSTEMC_SRCS_FIX)
	echo "done"
	touch $(BUILD_DIR_COSIM)/.fix

$(BUILD_DIR_COSIM)/.test_cosim: $(RES)
	echo "done"
	touch $(BUILD_DIR_COSIM)/.test_cosim

$(BUILD_DIR_COSIM)/.coverage: $(BUILD_DIR_COSIM)/.test_cosim
	lcov $(LCOV_FLAGS) --capture --output-file $(BUILD_DIR_COSIM)/app.info
	genhtml -o coverage_reports_cosim/ $(BUILD_DIR_COSIM)/app.info
	touch $(BUILD_DIR_COSIM)/.coverage_cosim

%.ok: %.run
	$(MKDIR_P) $<.vcd_dump

	export LD_LIBRARY_PATH=$(LD_LIBRARY_PATH_LOCAL); cd $<.vcd_dump; $(PWD)/$< > $(PWD)/$<.log; RET=$$?;cd $(PWD);if [ $$RET -eq 0 ]; then tail -n10 $<.log; echo "[FINISH - OK] $@"; else tail -n100 $<.log; echo "[FINISH - ERROR] $@"; fi; echo "See full log at: $<.log" ;sleep 0.01;return $$RET
	touch $@

%.run: %.o $(OBJS) .lib_build
	$(CXX) $< $(OBJS) -o $@ $(LDFLAGS)

#$(EXECS): $(OBJS) .lib_build
#	$(MAKE) -C lib_arch/systemc/
#	$(CXX) $(OBJS) -o $@ $(LDFLAGS)

$(BUILD_DIR_COSIM)/systemcfix/%.cpp.fix.cpp: %.cpp
	$(MKDIR_P) $(dir $@)
	echo '#include <sstream>' | cat - $< > $@

# c++ source
$(BUILD_DIR_COSIM)/%.cpp.o: %.cpp .lib_build
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@


.lib_build: lib_arch/systemc/Makefile
	$(MAKE) -C lib_arch/systemc/
	touch .lib_build


.PHONY: clean

clean:
	$(RM) -r $(BUILD_DIR_COSIM)
	$(RM) -r coverage_reports_cosim
	$(RM) $(BUILD_DIR_COSIM)/.coverage_cosim
	$(RM) $(BUILD_DIR_COSIM)/.test_cosim


clean_all: clean_rtl
	rm -f .lib_build
	


-include $(DEPS)

MKDIR_P ?= mkdir -p


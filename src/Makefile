#include src
PWD = $(shell pwd)
GIT_BRANCH_NAME = $(shell git rev-parse --abbrev-ref HEAD)
GIT_COMMIT_HASH = $(shell git rev-parse --short HEAD)
GIT_REVISION_NAME = $(shell git rev-list --count origin/master).$(shell git rev-list --count origin/develop).$(shell git rev-parse --abbrev-ref HEAD).$(shell git rev-list --count HEAD)-$(shell git rev-parse --short HEAD)
IP_REVISION_NAME = $(shell git rev-list --count origin/master).$(shell git rev-list --count origin/develop).$(shell git rev-list --count HEAD)
PARAM_LIST ?= 
PARAM_LIST_TMP := $(strip $(PARAM_LIST))
PARAM_LIST_str := $(shell echo $(PARAM_LIST_TMP) | sed 's/ /-/g')
PARAM_LIST_str_hash := $(shell echo $(PARAM_LIST_str) | cksum | sed 's/ //g')
LD_LIBRARY_PATH_LOCAL=$(LD_LIBRARY_PATH)

BUILD_DIR_ROOT ?= ./build
IP_DIR ?= ./IP_catalog
IP_NAME ?= CNNAccel
RM=rm -f
CPPFLAGS=-g -I./src/ -MMD -MP -fprofile-arcs -ftest-coverage --coverage
LDFLAGS=-g -I./src/ -fprofile-arcs -ftest-coverage --coverage
LDLIBS=
#echo test
SRCS=
MAIN_SRCS=
include src/hwcore/tb/include.mk

TARGET_IP_NAME := $(IP_NAME)-$(GIT_REVISION_NAME)-${PARAM_LIST_str_hash}

TARGET_IP_FILE = $(IP_DIR)/$(TARGET_IP_NAME).zip
TARGET_IP_FILE_LOGDIR = $(IP_DIR)/$(TARGET_IP_NAME)
TARGET_BIT_FILES = $(TARGET_IP_FILE_LOGDIR)/bitfiles/.bit


TARGET_IP_FILE_UNSAFE = $(IP_DIR)/$(TARGET_IP_NAME)_unsafe.zip


CPPFLAGS+=$(PARAM_LIST:%=-D%)

RTL_FLAGS:=$(PARAM_LIST:%=-D%)

#SRCS += $(MAIN_SRCS)
APPEND_NAME = $(PARAM_LIST_str_hash)
#PARAMS-${PARAM_LIST_str}
BUILD_DIR:=$(BUILD_DIR_ROOT)/$(APPEND_NAME)
export BUILD_DIR
export PARAM_LIST
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
MAIN_OBJS := $(MAIN_SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d) $(MAIN_OBJS:.o=.d)
EXECS := $(MAIN_OBJS:.o=.run)
RES := $(MAIN_OBJS:.o=.ok)
MAIN_OBJS_DIRS := $(sort $(dir $(MAIN_OBJS)))
LCOV_FLAGS := $(MAIN_OBJS_DIRS:%=--directory %)

CNNA_SRC := src/hwcore/tb/cnn/main_cnn.cpp
CNNA_OBJ := $(CNNA_SRC:%=$(BUILD_DIR)/%.o)
CNNA_RES := $(CNNA_OBJ:.o=.ok)

TCL_SCRIPT := IP/CNNAccel/default/rtl_export-$(APPEND_NAME)-$(GIT_REVISION_NAME).tcl

include lib_arch/systemc/cflags.mk

debug_build: build
	$(RM) $@
	ln -s $(BUILD_DIR) $@ 

logfolder:
	@echo $(TARGET_IP_FILE_LOGDIR)

hash:
	@echo $(PARAM_LIST_str_hash)

gen_rtl_tcl: $(TCL_SCRIPT)

build_bit: $(TARGET_BIT_FILES)

build_ip: $(TARGET_IP_FILE)

build_ip_unsafe: $(TARGET_IP_FILE_UNSAFE)

clean_run: clean run

all: rtl coverage

run: test

run_cnna: $(CNNA_RES)

cosim: $(BUILD_DIR)/.cosim

build: $(EXECS)

$(TARGET_BIT_FILES) : build_ip
	$(MKDIR_P) $(dir $@)
	vivado -mode batch -nojournal -nolog -notrace -source bit_file_gen.tcl
	cp -f ../Vivado/CNNAccelTest0/CNNAccelTest0.srcs/sources_1/bd/CNNA_BD/hw_handoff/* $(dir $@)/
	cp -f ../Vivado/CNNAccelTest0/CNNAccelTest0.runs/impl_1/*.bit $(dir $@)/
	touch $@

$(BUILD_DIR)/param_list.txt: 
	$(MKDIR_P) $(dir $@)
	echo $(PARAM_LIST) > $@

test: $(BUILD_DIR)/.test

coverage: $(BUILD_DIR)/.coverage

$(TARGET_IP_FILE_LOGDIR)/.dir: $(BUILD_DIR)/.rtl $(BUILD_DIR)/.cosim $(BUILD_DIR)/.test
	$(MKDIR_P) $(dir $@)
	cp -f IP/CNNAccel/default/syn/report/* $(TARGET_IP_FILE_LOGDIR)/
	cp -f IP/CNNAccel/default/impl/report/verilog/* $(TARGET_IP_FILE_LOGDIR)/
	echo $(PARAM_LIST) > $(TARGET_IP_FILE_LOGDIR)/param_list.txt
	cp -f $(BUILD_DIR)/COSIM/src/hwcore/tb/cnn/main_cnn.cpp.run.vcd_dump/result.txt $(TARGET_IP_FILE_LOGDIR)/result.txt
	touch $@

$(BUILD_DIR)/.test: $(RES)
	echo "done"
	touch $@

$(BUILD_DIR)/.coverage: $(BUILD_DIR)/.test
	lcov $(LCOV_FLAGS) --capture --output-file $(BUILD_DIR)/app.info
	genhtml -o coverage_reports/ $(BUILD_DIR)/app.info
	touch $@

$(BUILD_DIR)/.cosim : $(BUILD_DIR)/.rtl
	$(MAKE) -f cosim.mk run
	touch $@

cosim_unsafe:
	$(MAKE) -f cosim.mk run
	touch $@

$(TARGET_IP_FILE_UNSAFE):
	$(MAKE) -f cosim.mk run
	touch $(BUILD_DIR)/.cosim
	$(MKDIR_P) $(dir $@)
	cp -f IP/CNNAccel/default/impl/ip/*.zip $@


$(TARGET_IP_FILE): $(TARGET_IP_FILE_LOGDIR)/.dir $(BUILD_DIR)/.rtl $(BUILD_DIR)/.cosim $(BUILD_DIR)/.test
	$(MKDIR_P) $(dir $@)
	cp -f IP/CNNAccel/default/impl/ip/*.zip $@

#%.o: %.c $(DEPS)
#	$(Echo) "   Compiling $< in $(BuildMode) mode" $(AVE_DIR_DLOG)
#	$(Verb)  $(CC) ${CCFLAG} -c -MMD -DHW_COSIM -Wno-unknown-pragmas  $(IFLAG) $(DFLAG) $< -o $@ ; \

#$(TARGET): $(OBJECTS)
#	$(Echo) "   Compiling target in $(BuildMode) mode" $(AVE_DIR_DLOG)
#	$(Verb)  $(CC) ${CCFLAG} -c -MMD -DHW_COSIM -Wno-unknown-pragmas  $(IFLAG) $(DFLAG) -o $@ $^ ; \
# org: /tools/Xilinx/Vivado/2019.1/bin/vivado_hls CNNAccel/default/rtl_export.tcl
# /mnt/c/Windows/System32/cmd.exe /c "/mnt/e/Vivado2019/Vivado/2019.1/bin/vivado_hls -f CNNAccel/default/rtl_export.tcl"

$(TCL_SCRIPT):
	cp -f IP/CNNAccel/default/rtl_export.tcl $@.tmp
	sed -i 's/-cflags[^>]*/-cflags "-D__SYNTHESIS__ -I.\/..\/src\/. $(RTL_FLAGS)"/g' $@.tmp
	sed -i 's/-version[^>]*/-version $(IP_REVISION_NAME)/g' $@.tmp
	mv $@.tmp $@


$(BUILD_DIR)/.rtl: $(BUILD_DIR)/.test $(TCL_SCRIPT)
	cd IP/ &&\
	/tools/Xilinx/Vivado/2019.1/bin/vivado_hls ../$(TCL_SCRIPT)
	touch $(BUILD_DIR)/.rtl

rtl: $(BUILD_DIR)/.rtl

%.ok: %.run
	export LD_LIBRARY_PATH=$(LD_LIBRARY_PATH_LOCAL);cd $(dir $@); $(PWD)/$< > $(PWD)/$<.log; RET=$$?;if [ $$RET -eq 0 ]; then tail -n10 $(PWD)/$<.log; echo "[FINISH - OK] $@"; else tail -n100 $(PWD)/$<.log; echo "[FINISH - ERROR] $@"; fi; echo "See full log at: $<.log" ;sleep 0.01;return $$RET
	touch $@

%.run: %.o $(OBJS) .lib_build
	$(CXX) $< $(OBJS) -o $@ $(LDFLAGS)

#$(EXECS): $(OBJS) .lib_build
#	$(MAKE) -C lib_arch/systemc/
#	$(CXX) $(OBJS) -o $@ $(LDFLAGS)

# c++ source
$(BUILD_DIR)/%.cpp.o: %.cpp .lib_build $(BUILD_DIR)/param_list.txt
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@


.lib_build: lib_arch/systemc/Makefile
	$(MAKE) -C lib_arch/systemc/
	touch $@


.PHONY: clean

clean:
	$(RM) -r $(BUILD_DIR)
	$(RM) -r coverage_reports
	$(RM) $(BUILD_DIR)/.coverage
	$(RM) $(BUILD_DIR)/.test

clean_rtl: clean
	rm -f $(BUILD_DIR)/.rtl


clean_all: clean_rtl
	rm -f .lib_build
	


-include $(DEPS)

MKDIR_P ?= mkdir -p


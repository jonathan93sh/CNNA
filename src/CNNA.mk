#include src

 

BUILD_DIR ?= ./build
RM=rm -f
CPPFLAGS=-g -I./src/ -MMD -MP 
LDFLAGS=-g -I./src/
LDLIBS=

CNNA_MAIN_SRC=src/hwcore/tb/cnn/main_cnn.cpp
CNNA_SRCS := $(CNNA_MAIN_SRC) src/hwcore/cnn/cnn.cpp
CNNA_OBJS := $(CNNA_SRCS:%=$(BUILD_DIR)/%.o)
CNNA_DEPS := $(CNNA_OBJS:.o=.d)
CNNA_EXEC ?=CNNA_tb


include lib_arch/systemc/cflags.mk

all:CNNA

	
CNNA_run: CNNA
	$(BUILD_DIR)/$(CNNA_EXEC)


CNNA: $(BUILD_DIR)/$(CNNA_EXEC)

#%.o: %.c $(DEPS)
#	$(Echo) "   Compiling $< in $(BuildMode) mode" $(AVE_DIR_DLOG)
#	$(Verb)  $(CC) ${CCFLAG} -c -MMD -DHW_COSIM -Wno-unknown-pragmas  $(IFLAG) $(DFLAG) $< -o $@ ; \

#$(TARGET): $(OBJECTS)
#	$(Echo) "   Compiling target in $(BuildMode) mode" $(AVE_DIR_DLOG)
#	$(Verb)  $(CC) ${CCFLAG} -c -MMD -DHW_COSIM -Wno-unknown-pragmas  $(IFLAG) $(DFLAG) -o $@ $^ ; \

$(BUILD_DIR)/$(CNNA_EXEC): $(CNNA_OBJS) .lib_build
	$(MAKE) -C lib_arch/systemc/
	$(CXX) $(CNNA_OBJS) -o $@ $(LDFLAGS)

# c++ source
$(BUILD_DIR)/%.cpp.o: %.cpp .lib_build
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@


.lib_build:
	$(MAKE) -C lib_arch/systemc/
	touch .lib_build


.PHONY: clean

clean:
	$(RM) -r $(BUILD_DIR)

-include $(CNNA_DEPS)

MKDIR_P ?= mkdir -p


CPPFLAGS += -I/usr/local/systemc-2.3.3/include
LDFLAGS += -L/usr/local/systemc-2.3.3/lib-linux64 -lsystemc

CPPFLAGS += -D__HLS_TRACE_LEVEL_PORT__
CPPFLAGS += -D__SIM_FPO__
CPPFLAGS += -DDEBUG_SYSTEMC
CPPFLAGS += -D__SIM_OPENCV__
CPPFLAGS += -D__SIM_FFT__
CPPFLAGS += -D__SIM_FIR__
CPPFLAGS += -D__SIM_DDS__
CPPFLAGS += -D__DSP48E1__

LD_LIBRARY_PATH_LOCAL:=/usr/local/systemc-2.3.3/lib-linux64/:$(LD_LIBRARY_PATH_LOCAL)



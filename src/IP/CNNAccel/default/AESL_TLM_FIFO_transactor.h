// -*-c++-*-
// __AESL_COPYRIGHT__

#ifndef _FIFO_TRANSACTOR_H_
#define _FIFO_TRANSACTOR_H_

#include "systemc.h"
#include "tlm.h"

using namespace tlm;

template <int __DW, typename __T>
void ConvertFromLV(const sc_lv<__DW>& lvv, __T &val)
{
    val = sc_bigint<__DW>(lvv);
}

template <int __DW>
void ConvertFromLV(const sc_lv<__DW>& lvv, int &val)
{
    val = sc_bigint<__DW>(lvv).to_int();
}

template <int __DW>
void ConvertFromLV(const sc_lv<__DW>& lvv, unsigned &val)
{
    val = sc_bigint<__DW>(lvv).to_uint();
}

template <int __DW, typename __T>
void ConvertToLV(const __T &val, sc_lv<__DW>& lvv)
{
    lvv = sc_lv<__DW>(val);
}


// Reset property.
struct AESL_ResetType {
    enum { active_high_sync, active_high_async, active_high_edge,
           active_low_sync, active_low_async, active_low_edge, };

    static bool isActiveHigh(unsigned __act) {
        return (__act == active_high_sync ||
                __act == active_high_async ||
                __act == active_high_edge);
    }
    static bool isActiveLow(unsigned __act) {
        return (__act == active_low_sync ||
                __act == active_low_async ||
                __act == active_low_edge);
    }
};


// Base class for get/set reset properties.
struct FIFOResetBase {
    sc_in< sc_logic > rst;
    unsigned mRstActive;

    FIFOResetBase(unsigned active) : mRstActive(active) { }
    bool isActiveLow() {
        return AESL_ResetType::isActiveLow(mRstActive);
    }
    bool resetTrigger() {
        return ((isActiveLow() && rst == SC_LOGIC_0) ||
                (!isActiveLow() && rst == SC_LOGIC_1));
    }
};


///
/// class: FIFO_in_transactor
//// Connecting to tlm_fifo_get_if
///
template <int DIN0_WIDTH, typename __T>
class FIFO_in_transactor: public sc_module, public FIFOResetBase {
public:
    // ESL interface.
    sc_port< tlm_fifo_get_if<__T> > FifoIn;

    // RTL interface.
    sc_in_clk clock;
    //sc_in< sc_logic > rst;

    sc_out< sc_logic > if_empty_n;
    sc_in< sc_logic > if_read;
    sc_out<__T> if_dout;

    ////////////////////////////////////////////////////////////////
    sc_trace_file* mTrace;

    sc_signal<bool> reg_can_get;

    typedef FIFO_in_transactor SC_CURRENT_USER_MODULE;
    FIFO_in_transactor(const sc_module_name _name, unsigned active) :
        sc_module(_name), FIFOResetBase(active) {
        std::string tracefn = "sc_trace_" + std::string(name());
        mTrace = sc_create_vcd_trace_file(tracefn.c_str());
        sc_trace(mTrace, clock, "(port)clock");
        sc_trace(mTrace, rst, "(port)rst");
        sc_trace(mTrace, if_empty_n, "(port)if_empty_n");
        sc_trace(mTrace, if_read, "(port)if_read");
        //sc_trace(mTrace, if_dout, "(port)if_dout");

        SC_METHOD( thread_empty_n );
        sensitive << clock.pos();
        if (isActiveLow()) sensitive << rst.neg();
        else sensitive << rst.pos();

        SC_METHOD( thread_dout );
        sensitive << clock.pos();
        if (isActiveLow()) sensitive << rst.neg();
        else sensitive << rst.pos();
    }

    ~FIFO_in_transactor() {
        sc_close_vcd_trace_file(mTrace);
    }

    void thread_empty_n() {
        if (resetTrigger()) {
            if_empty_n.write(SC_LOGIC_0);
        } else {
            sc_logic tmpflag = sc_logic(FifoIn->nb_can_get());
            if_empty_n.write(tmpflag);
        }
        reg_can_get.write(FifoIn->nb_can_get());
    }

    void thread_dout() {
        if (resetTrigger()) {
            __T tmp;
            if_dout.write(tmp);
        } else {
            if (if_read.read() == SC_LOGIC_1) {
                if (reg_can_get.read()) {
                    __T tmp;
                    FifoIn->nb_get(tmp);
                }
            }
            __T tmp;
            (*(sc_port< tlm_get_peek_if<__T> >*)(&FifoIn))->nb_peek(tmp);
            if_dout.write(tmp);
        }
    }
};


template <int DIN0_WIDTH, typename __T>
class FIFO_out_transactor: public sc_module, public FIFOResetBase {
public:
    // ESL interface.
    sc_port< tlm_fifo_put_if<__T> > FifoOut;

    // RTL interface.
    sc_in_clk clock;
    //sc_in< sc_logic > rst;

    sc_out< sc_logic > if_full_n;
    sc_in< sc_logic > if_write;
    sc_in<__T> if_din;

    ////////////////////////////////////////////////////////////////
    sc_trace_file* mTrace;

    sc_signal<bool> reg_can_put;

    typedef FIFO_out_transactor SC_CURRENT_USER_MODULE;
    FIFO_out_transactor(const sc_module_name _name, unsigned active) :
        sc_module(_name), FIFOResetBase(active) {
        std::string tracefn = "sc_trace_" + std::string(name());
        mTrace = sc_create_vcd_trace_file(tracefn.c_str());
        sc_trace(mTrace, clock, "(port)clock");
        sc_trace(mTrace, rst, "(port)rst");
        sc_trace(mTrace, if_full_n, "(port)if_full_n");
        sc_trace(mTrace, if_write, "(port)if_write");
        //sc_trace(mTrace, if_din, "(port)if_din");

        SC_METHOD( thread_run );
        sensitive << clock.pos();
        if (isActiveLow()) sensitive << rst.neg();
        else sensitive << rst.pos();
    }

    ~FIFO_out_transactor() {
        sc_close_vcd_trace_file(mTrace);
    }

    void thread_run() {
        reg_can_put.write(FifoOut->nb_can_put());

        if (resetTrigger()) {
            if_full_n.write(SC_LOGIC_1);
        } else {
            if (if_write.read() == SC_LOGIC_1) {
                if (reg_can_put.read()) {
                    __T tmp = if_din.read();
                    FifoOut->nb_put(tmp);
                }
            }

            if_full_n.write(sc_logic(FifoOut->nb_can_put()));
        }
    }

};



template <int DIN0_WIDTH, typename __T>
class SC_FIFO_in_transactor: public sc_module, public FIFOResetBase {
public:
    // ESL interface.
    sc_fifo_in<__T> FifoIn;

    // RTL interface.
    sc_in_clk clock;
    //sc_in< sc_logic > rst;

    sc_out< sc_logic > if_empty_n;
    sc_in< sc_logic > if_read;
    sc_out<__T> if_dout;

    ////////////////////////////////////////////////////////////////
    sc_trace_file* mTrace;

    sc_signal<bool> reg_can_get;
    sc_signal<bool> empty_delay;
    sc_signal<bool> last_flag;


    typedef SC_FIFO_in_transactor SC_CURRENT_USER_MODULE;
    SC_FIFO_in_transactor(const sc_module_name _name, unsigned active) :
        sc_module(_name), FIFOResetBase(active) {
        std::string tracefn = "sc_trace_" + std::string(name());
        mTrace = sc_create_vcd_trace_file(tracefn.c_str());
        sc_trace(mTrace, clock, "(port)clock");
        sc_trace(mTrace, rst, "(port)rst");
        sc_trace(mTrace, if_empty_n, "(port)if_empty_n");
        sc_trace(mTrace, if_read, "(port)if_read");
        //sc_trace(mTrace, empty_delay, "(io)empty_delay");
        //sc_trace(mTrace, last_flag, "(io)last_flag");
        //sc_trace(mTrace, reg_can_get, "(io)reg_can_get");

        SC_METHOD( thread_empty_n );
        sensitive << empty_delay << last_flag << this->rst;
        dont_initialize();

        SC_METHOD( thread_dout );
        sensitive << clock.pos();
        if (isActiveLow()) sensitive << rst.neg();
        else sensitive << rst.pos();
        dont_initialize();
        reseted = false;
        cycle_cnt = 0;
    }

    ~SC_FIFO_in_transactor() {
        sc_close_vcd_trace_file(mTrace);
    }

    bool reseted;
    int cycle_cnt;

    void thread_empty_n() {
        if (resetTrigger()) {
            if_empty_n.write(SC_LOGIC_0);
        } else {
            //bool tmpflag = ( FifoIn.num_available() > 0 );
            if_empty_n.write(sc_logic(empty_delay.read() || last_flag.read()));
        }
    }

    void thread_dout() {
        __T tmp;
        if (resetTrigger()) {
            if_dout.write(tmp);
            last_flag.write(0);
            empty_delay.write(0);
            reseted = true;
        } else if(reseted){
        //} else {
            empty_delay = (FifoIn.num_available() > 0);

            if ((FifoIn.num_available() <= 0) && (empty_delay.read() == 1) && (if_read.read() == SC_LOGIC_0))
            {
                last_flag = 1;
            }

            if (last_flag.read() && if_read.read().to_bool())
            {
                last_flag.write(0);
            }
            else if ((FifoIn.num_available() > 0) && (empty_delay.read() == 0) && (last_flag.read()==0)) {
                FifoIn.nb_read(tmp);
                if_dout.write(tmp);
            }
            if (if_read.read() == SC_LOGIC_1) {
                if (FifoIn.num_available() > 0) {
                    FifoIn.nb_read(tmp);
                    if_dout.write(tmp);
                }
                else
                {
                    __T tmp2;
                    if_dout.write(tmp2);
                }
            }
        } else {
            if(cycle_cnt++ > 10000) 
            {
                 cout<<"WARNING: Reset signal seems never to be triggered in test-bench (more than 10000 cycles), please check."<<endl;
                 reseted = true;
            }
        }
    }
};


template <int DIN0_WIDTH, typename __T>
class SC_FIFO_out_transactor: public sc_module, public FIFOResetBase {
public:
    // ESL interface.
    sc_fifo_out<__T> FifoOut;

    // RTL interface.
    sc_in_clk clock;
    //sc_in< sc_logic > rst;

    sc_out< sc_logic > if_full_n;
    sc_in< sc_logic > if_write;
    sc_in<__T> if_din;

    ////////////////////////////////////////////////////////////////
    sc_trace_file* mTrace;

    sc_signal<bool> reg_can_put;

    typedef SC_FIFO_out_transactor SC_CURRENT_USER_MODULE;
    SC_FIFO_out_transactor(const sc_module_name _name, unsigned active) :
        sc_module(_name), FIFOResetBase(active) {
        std::string tracefn = "sc_trace_" + std::string(name());
        mTrace = sc_create_vcd_trace_file(tracefn.c_str());
        sc_trace(mTrace, clock, "(port)clock");
        sc_trace(mTrace, rst, "(port)rst");
        sc_trace(mTrace, if_full_n, "(port)if_full_n");
        sc_trace(mTrace, if_write, "(port)if_write");
        //sc_trace(mTrace, if_din, "(port)if_din");

        SC_METHOD( thread_run );
        sensitive << clock.pos();
        if (isActiveLow()) sensitive << rst.neg();
        else sensitive << rst.pos();
    }

    ~SC_FIFO_out_transactor() {
        sc_close_vcd_trace_file(mTrace);
    }

    void thread_run() {
        reg_can_put.write(( FifoOut.num_free() > 0 ));

        if (resetTrigger()) {
            if_full_n.write(SC_LOGIC_1);
        } else {
            if (if_write.read() == SC_LOGIC_1) {
                if (reg_can_put.read()) {
                    __T tmp = if_din.read();
                    FifoOut.nb_write(tmp);
                }
            }
            if_full_n.write(sc_logic(FifoOut.num_free()>0));
        }
    }

};




#if 0
/// RTL FIFO model.
template<int DIN0_WIDTH, int DEPTH=16, int LATENCY=1>
class ACMP_FIFO: public sc_module
{
public:
    sc_in_clk clk;
    sc_in< sc_logic > reset;

    sc_out< sc_logic > if_empty_n;
    sc_in< sc_logic > if_read;
    sc_out< sc_lv<DIN0_WIDTH> > if_dout;

    sc_out< sc_logic > if_full_n;
    sc_in< sc_logic > if_write;
    sc_in< sc_lv<DIN0_WIDTH> > if_din;

    ////////////////////////////////////////////////////////////////
    // Transactors
    FIFO_in_transactor<DIN0_WIDTH, sc_lv<DIN0_WIDTH> > inFifo_tr;
    FIFO_out_transactor<DIN0_WIDTH, sc_lv<DIN0_WIDTH> >  outFifo_tr;

    sc_fifo<sc_lv<DIN0_WIDTH> > mFifo;

    sc_trace_file* mTrace;

    ACMP_FIFO(const sc_module_name _name) :
        sc_module(_name),
        inFifo_tr("in_tr"), outFifo_tr("out_tr"),
        mFifo("esl_fifo", DEPTH) {

        std::string tracefn = "sc_trace_" + std::string(name());
        mTrace = sc_create_vcd_trace_file(tracefn.c_str());
        sc_trace(mTrace, clk, "(port)clk");
        sc_trace(mTrace, reset, "(port)reset");
        sc_trace(mTrace, if_empty_n, "(port)if_empty_n");
        sc_trace(mTrace, if_read, "(port)if_read");
        sc_trace(mTrace, if_dout, "(port)if_dout");
        sc_trace(mTrace, if_full_n, "(port)if_full_n");
        sc_trace(mTrace, if_write, "(port)if_write");
        sc_trace(mTrace, if_din, "(port)if_din");

        inFifo_tr.FifoIn(mFifo);

        inFifo_tr.clock(clk);
        inFifo_tr.rst(reset);
        inFifo_tr.if_empty_n(if_empty_n);
        inFifo_tr.if_read(if_read);
        inFifo_tr.if_dout(if_dout);

        outFifo_tr.FifoOut(mFifo);

        outFifo_tr.clock(clk);
        outFifo_tr.rst(reset);
        outFifo_tr.if_full_n(if_full_n);
        outFifo_tr.if_write(if_write);
        outFifo_tr.if_din(if_din);
    }

    ~ACMP_FIFO() {
        sc_close_vcd_trace_file(mTrace);
    }
};


#endif

#endif



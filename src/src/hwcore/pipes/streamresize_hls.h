#pragma once
#define SC_INCLUDE_FX
#include <systemc.h>
#include "hwcore/hf/helperlib.h"
#include "hwcore/pipes/test.h"
#include "hwcore/pipes/pipes.h"


#define WIN_DATA 64
#define WOUT_DATA 64

SC_MODULE(stream_resize)
{
    private:
    struct linker_func
        {
            template<typename F>
            inline static void link(F & ref,unsigned i)
            {
                ref.test.dout[i](ref.dout[i]);
                
            }
        };

   public:

    hwcore::pipes::sc_stream_splitter<64,16> test;
    SC_MODULE_CLK_RESET_SIGNAL;

    sc_fifo_in<hwcore::pipes::SC_DATA_T(64) > din;
    sc_fifo_out<hwcore::pipes::SC_DATA_T(64) > dout[16];

    

    

    SC_CTOR(stream_resize)
        :SC_INST(test)
    {
        #pragma HLS ARRAY_PARTITION variable=dout complete dim=1
        
        SC_MODULE_LINK(test);
        test.din(din);
        hwcore::hf::unroll<16,linker_func>::link(*this);
    }

};


/*
SC_MODULE(stream_resize)
{
    private:
    struct linker_func
        {
            template<typename F>
            inline static void link(F & ref,unsigned i)
            {
                ref.test.dout[i](ref.dout[i]);
                
            }
        };

   public:

    hwcore::pipes::sc_stream_splitter_clone<hwcore::pipes::SC_DATA_T(64),16> test;
    SC_MODULE_CLK_RESET_SIGNAL;

    sc_fifo_in<hwcore::pipes::SC_DATA_T(64) > din;
    sc_fifo_out<hwcore::pipes::SC_DATA_T(64) > dout[16];

    

    

    SC_CTOR(stream_resize)
        :SC_INST(test)
    {
        #pragma HLS ARRAY_PARTITION variable=dout complete dim=1
        
        SC_MODULE_LINK(test);
        test.din(din);
        hwcore::hf::unroll<16,linker_func>::link(*this);
    }

};*/


/*struct wrap
{
    test<10> resize;
    wrap()
        :resize("test")
    {

    }

    inline test<10> *operator->()
    {
    	return &resize;
    }
};

template<class T>
struct sc_wrap
{
    T _module;

    inline explicit sc_wrap(const char * name)
        :_module(sc_gen_unique_name(name))
    {

    }

    inline explicit sc_wrap()
        :_module(sc_gen_unique_name("sc_wrap"))
    {
        
    }

    inline T *operator->()
    {
    	return &_module;
    }

    inline T &get()
    {
        return _module;
    }
};*/



/*
SC_MODULE(stream_resize)
{
    private:
    struct linker_func
        {
            template<typename F>
            inline static void link(F & ref,unsigned i)
            {
                ref.resize_array.get(i).clk(ref.clk);
                ref.resize_array.get(i).reset(ref.reset);
            }
        };

   public:
    //hwcore::pipes::sc_stream_resize<WIN_DATA,WOUT_DATA> resize;
	//test<10> resize;
    //wrap resize;

    //hwcore::hf::sc_wrap<test<10> > resize;
    hwcore::hf::sc_static_list<test<64>, 3> resize_array;
    SC_MODULE_CLK_RESET_SIGNAL;

    sc_fifo_in<hwcore::pipes::SC_DATA_T(64) > din;
    sc_fifo_out<hwcore::pipes::SC_DATA_T(64) > dout;

    hwcore::hf::sc_static_list<sc_fifo<hwcore::pipes::SC_DATA_T(64)>,2 > fifo_array;
    //sc_fifo<hwcore::pipes::SC_DATA_T(64)> fifo_1;
    //sc_fifo<hwcore::pipes::SC_DATA_T(64)> fifo_2;
    //sc_fifo<hwcore::pipes::SC_DATA_T(64) > u0_2_u1;
    

     

    SC_CTOR(stream_resize)
        :fifo_array(32)
        //fifo_1(32),
        //fifo_2(32)
    //:resize("test")
    {
        //SC_MODULE_LINK(resize.resize);
        //resize_array.get(0).clk(clk);

        //for(int i=0;i<1;i++)

        
        
        hwcore::hf::unroll<3,linker_func>::link(*this);

       

        resize_array.get(0).reset(reset);
           //resize_array.get(1).clk(clk);
            resize_array.get(1).reset(reset);
            //resize_array.get(2).clk(clk);
            resize_array.get(2).reset(reset);




        resize_array.get(0).din(din);
        resize_array.get(0).dout(fifo_array.get(0));

        resize_array.get(1).din(fifo_array.get(0));
        resize_array.get(1).dout(fifo_array.get(1));

        resize_array.get(1).din(fifo_array.get(1));
        resize_array.get(1).dout(dout);
        reset_signal_is(reset,true);
    }

};*/

/*template <int Win, int Wout>
SC_MODULE(sc_stream_resize_up)
{


    typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1*Win>::interface_T in_T;
    typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1*Wout>::interface_T out_T;

    enum
    {
        //raw_resize_N = (Win >= Wout ? (int)ceil((float)Win / (float)Wout) : (int)ceil((float)Wout / (float)Win))
        raw_resize_N = (Win >= Wout ? hwcore::hf::const_float<Win, Wout>::CEIL : hwcore::hf::const_float<Wout, Win>::CEIL)
    };

    SC_MODULE_CLK_RESET_SIGNAL;

    sc_fifo_in<in_T > din;
    sc_fifo_out<out_T > dout;

    inline void trace(sc_trace_file * trace)
    {
        SC_TRACE_ADD(clk);
        SC_TRACE_ADD(reset);
        //SC_TRACE_ADD(din);
        //SC_TRACE_ADD(dout);
    }

    SC_CTOR_TEMPLATE(sc_stream_resize_up)
    {
        SC_CTHREAD(thread_sc_stream_resize, clk.pos());
        reset_signal_is(reset, true);
    }

    void thread_sc_stream_resize()
    {
        HLS_DEBUG(1, 1, 0, "init thread");

        out_T tmp_out;
        tmp_out.setKeep(0);
        int idx = 0;
        while (true)
        {
            in_T tmp_in;

            IF_SC_FIFO_NB_READ_FLUSH(din, tmp_in)
            {
                if (tmp_in.EOP())
                {
                    tmp_out.setEOP();
                    dout.write(tmp_out);
                    idx = 0;
                }
                else
                {
                    tmp_out.template setData<sc_bv, Win>(tmp_in.data, idx);
                    tmp_out.tkeep((Win / 8) * (idx + 1) - 1, (Win / 8) * idx) = tmp_in.tkeep;
                    if (idx == raw_resize_N - 1 || tmp_in.tlast == 1U)
                    {
                        tmp_out.tlast = tmp_in.tlast;
                        dout.write(tmp_out);
                        tmp_out.setKeep(0);
                        idx = 0;
                    }
                    else
                    {
                        idx++;
                    }
                }
            }
        }
    }
};*/
/*
using namespace hwcore;
using namespace hwcore::pipes;

SC_MODULE(stream_resize)
{
   public:
    sc_stream_resize<32,64> resize;
	//test<10> resize;
    SC_MODULE_CLK_RESET_SIGNAL;

    sc_fifo_in<hwcore::pipes::SC_DATA_T(32) > din;
    sc_fifo_out<hwcore::pipes::SC_DATA_T(64) > dout;

    SC_CTOR(stream_resize)
        :resize("test")
    {
        SC_MODULE_LINK(resize);
        resize.din(din);
        resize.dout(dout);
        reset_signal_is(reset,true);
    }

};
*/
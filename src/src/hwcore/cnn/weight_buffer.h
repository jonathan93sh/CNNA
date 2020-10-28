/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#define SC_INCLUDE_FX
#include "hwcore/pipes/pipes.h"
#include <systemc.h>

#if 0

template<int W, int out_N, int fifo_depth>
SC_MODULE(_weight_buffer){
    public:
    typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1*W>::interface_T in_T;
    typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1*W>::interface_T out_T;

    typedef hwcore::pipes::sc_stream_buffer<W>  weight_buf_T;
    private:

    hwcore::pipes::sc_stream_realign<W> realign_u0;
    sc_fifo<in_T> u0_2_u1;
    hwcore::pipes::sc_stream_splitter<W, out_N> package_splitter_u1;
    
    hwcore::hf::sc_static_list<sc_fifo<in_T>, out_N > u1_2_u2;

    hwcore::hf::sc_static_list<weight_buf_T, out_N > weight_buf_u2;

    public:
    SC_MODULE_CLK_RESET_SIGNAL;

    sc_fifo_in<in_T > din;
    sc_fifo_in< sc_uint<16> > ctrl_row_N;

    sc_fifo_in< sc_uint<1> > ctrls_in;
    
    hwcore::pipes::sc_stream_splitter_clone< sc_uint<1>, out_N> ctrls_in_split;
    hwcore::hf::sc_static_list<sc_fifo< sc_uint<1> >, out_N> split_2_buf;

    //hwcore::hf::sc_vector<sc_fifo_out<in_T >, out_N > dout;
    
    sc_fifo_out<in_T > dout[out_N];

    inline void trace(sc_trace_file *trace)
	{
		SC_TRACE_ADD(clk);
		SC_TRACE_ADD(reset);
        //SC_TRACE_ADD(din);
        //SC_TRACE_ADD(ctrl_row_N);
        //SC_TRACE_ADD(ctrls_in);
        SC_TRACE_ADD_MODULE(ctrls_in_split);
        for(int i=0;i<out_N;i++)
        {
            SC_TRACE_ADD_MODULE(u1_2_u2.get(i));
            SC_TRACE_ADD_MODULE(weight_buf_u2.get(i));
            //SC_TRACE_ADD(dout[i]);
        }
        
        SC_TRACE_ADD_MODULE(realign_u0);
        SC_TRACE_ADD_MODULE(u0_2_u1);

	}

    struct linker_loop
    {
        template<typename T>
        static inline void link(T & ref, unsigned i)
        {
            ref.weight_buf_u2.get(i).clk(ref.clk);
            ref.weight_buf_u2.get(i).reset(ref.reset);
            ref.package_splitter_u1.dout.get(i)(ref.u1_2_u2.get(i));
            ref.weight_buf_u2.get(i).ctrls_in(ref.split_2_buf.get(i));
            ref.ctrls_in_split.dout.get(i)(ref.split_2_buf.get(i));
            ref.weight_buf_u2.get(i).din(ref.u1_2_u2.get(i));
            ref.weight_buf_u2.get(i).dout(ref.dout[i]);
        }
    };

    SC_CTOR_TEMPLATE(_weight_buffer)
        :u0_2_u1("u0_2_u1",16),
        u1_2_u2("u1_2_u2",1*fifo_depth),
        split_2_buf("split_2_buf",16),
        SC_INST(realign_u0),
        SC_INST(package_splitter_u1),
        SC_INST(weight_buf_u2),
        SC_INST(ctrls_in_split)
    {
#pragma HLS ARRAY_PARTITION variable = dout complete dim = 1
        //HLS_DEBUG(1,1,0,"init");
        SC_MODULE_LINK(realign_u0);
        SC_MODULE_LINK(package_splitter_u1);
        SC_MODULE_LINK(ctrls_in_split);
        //SC_MODULE_LINK(weight_buf_u2);

        realign_u0.din(din);
        realign_u0.dout(u0_2_u1);
        realign_u0.ctrl(ctrl_row_N);
        package_splitter_u1.din(u0_2_u1);
        ctrls_in_split.din(ctrls_in);
        hwcore::hf::unroll<1*out_N, linker_loop>::link(*this);
        //HLS_DEBUG(1,1,0,"done");
    }



};

template<int W, int out_N, int fifo_depth>
SC_MODULE(_weight_buffer2){
    public:
    typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1*W>::interface_T in_T;
    private:

    

    public:
    SC_MODULE_CLK_RESET_SIGNAL;

    sc_fifo_in<in_T > din;
    sc_fifo_in< sc_uint<16> > ctrl_row_N;

    sc_fifo_in< sc_uint<1> > ctrls_in;
    
    //hwcore::hf::sc_vector<sc_fifo_out<in_T >, out_N > dout;
    sc_fifo_out<in_T > dout[out_N];
    hwcore::pipes::sc_stream_realign<W> realign_u0;
    sc_fifo<in_T> u0_2_u1;
    hwcore::pipes::sc_stream_splitter<W, out_N> package_splitter_u1;
    
    hwcore::hf::sc_static_list<sc_fifo<in_T>, out_N > u1_2_u2;

    hwcore::hf::sc_static_list<hwcore::pipes::sc_stream_buffer<W> , out_N > weight_buf_u2;


    hwcore::hf::sc_static_list<sc_fifo< sc_uint<1> >, out_N> split_2_buf;


    inline void trace(sc_trace_file *trace)
	{
		/*SC_TRACE_ADD(clk);
		SC_TRACE_ADD(reset);
        //SC_TRACE_ADD(din);
        //SC_TRACE_ADD(ctrl_row_N);
        //SC_TRACE_ADD(ctrls_in);
        SC_TRACE_ADD_MODULE(ctrls_in_split);
        for(int i=0;i<out_N;i++)
        {
            SC_TRACE_ADD_MODULE(u1_2_u2.get(i));
            SC_TRACE_ADD_MODULE(weight_buf_u2.get(i));
            //SC_TRACE_ADD(dout[i]);
        }
        
        SC_TRACE_ADD_MODULE(realign_u0);
        SC_TRACE_ADD_MODULE(u0_2_u1);*/

	}

    struct linker_loop
    {
        
        static inline void link(_weight_buffer2 & ref, unsigned i)
        {
            ref.weight_buf_u2.get(i).clk(ref.clk);
            ref.weight_buf_u2.get(i).reset(ref.reset);
            ref.package_splitter_u1.dout.get(i)(ref.u1_2_u2.get(i));
            ref.weight_buf_u2.get(i).ctrls_in(ref.split_2_buf.get(i));
            //ref.ctrls_in_split.dout.get(i)(ref.split_2_buf.get(i));
            ref.weight_buf_u2.get(i).din(ref.u1_2_u2.get(i));
            ref.weight_buf_u2.get(i).dout(ref.dout[i]);

            //ref.package_splitter_u1.dout.get(i)(ref.dout[i]);
        }
    };

    SC_CTOR_TEMPLATE(_weight_buffer2)
        :u0_2_u1(16),//"u0_2_u1",
        u1_2_u2(16),//1*fifo_depth "u1_2_u2",
        split_2_buf(16),//"split_2_buf"
        SC_INST(realign_u0),
        SC_INST(package_splitter_u1)//,
        //SC_INST(weight_buf_u2)//,
        //SC_INST(ctrls_in_split)
    {
#pragma HLS ARRAY_PARTITION variable = dout complete dim = 1
        //HLS_DEBUG(1,1,0,"init");
        SC_MODULE_LINK(realign_u0);
        SC_MODULE_LINK(package_splitter_u1);


        realign_u0.din(din);
        realign_u0.dout(u0_2_u1);
        realign_u0.ctrl(ctrl_row_N);
        package_splitter_u1.din(u0_2_u1);
        hwcore::hf::unroll<1*out_N, linker_loop>::link(*this);
        //HLS_DEBUG(1,1,0,"done");
        SC_CTHREAD(wb_thread,clk.pos());
        reset_signal_is(reset,true);
    }

    void wb_thread()
    {
        while(true)
        {
            sc_uint<1> din_tmp = 0;//ctrls_in.read();
            for(int i = 0; i < out_N; i++)
            {
#pragma HLS UNROLL
                //split_2_buf.get(i).write(din_tmp);
            }
        }
    }

};



namespace hwcore
{
namespace cnn
{
template<int W, int out_N, int fifo_depth>
using weight_buffer = ::_weight_buffer<W,out_N,fifo_depth>;
template<int W, int out_N, int fifo_depth>
using weight_buffer2 = ::_weight_buffer2<W,out_N,fifo_depth>;
}
} // namespace hwcore

#endif
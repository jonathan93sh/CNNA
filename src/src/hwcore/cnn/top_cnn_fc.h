/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#if 0
#pragma once
#define SC_INCLUDE_FX
#include "hwcore/cnn/cnn.h"
#include "hwcore/cnn/data_buffer.h"
#include "hwcore/cnn/weight_buffer.h"
#include "hwcore/pipes/pipes.h"
#include <systemc.h>
#define __tag inst_1
#include "hwcore/pipes/streamresize.h"
#define __tag inst_2
#include "hwcore/pipes/streamresize.h"
#define __tag inst_1
#include "hwcore/pipes/streamsplit.h"
#define __tag inst_2
#include "hwcore/pipes/streamsplit.h"


template<int data_W=16, int data_P=2, int input_BW_N=32, int output_BW_N=32, int PE_N=16, int PE_bw_N=16>
SC_MODULE(_top_cnn)
{
public:
    enum {
        dma_input_width = data_W*input_BW_N,
        dma_output_width = data_W*output_BW_N,
        data_flow_width = data_W*PE_bw_N,
        data_pe_merge_width = data_W*PE_N
    };
    
    typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1*data_flow_width>::interface_T data_flow_T;
    typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1*data_W>::interface_T data_T;
    typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1*data_W*PE_N>::interface_T data_pe_merge_T;
    typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1*dma_input_width>::interface_T in_T;
    typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1*dma_output_width>::interface_T out_T;

public:
    SC_MODULE_CLK_RESET_SIGNAL;

    sc_fifo_in<in_T > data_sink;

    sc_fifo_out<out_T > data_source;

    sc_fifo_in< sc_uint<1> > weight_ctrls_in;
    sc_fifo_in< sc_uint<1> > data_ctrls_in;
    sc_fifo_in< sc_uint<1> > ctrl_channel;
    sc_fifo_in< sc_uint<16> > ctrl_row_N;


    hwcore::pipes::inst_1::sc_stream_resize<dma_input_width, data_flow_width> resize_u0;

    sc_fifo<data_flow_T > data_2_u1; 

    hwcore::pipes::sc_stream_router<data_flow_width> package_handler_u1;

    sc_fifo<data_flow_T > u1_2_wb;
    sc_fifo<data_flow_T > u1_2_u3;
    

    //weight part
    //hwcore::cnn::weight_buffer2<data_flow_width, PE_N, 1> wb_u2;
    hwcore::pipes::sc_stream_realign<data_flow_width> realign_u0;
    sc_fifo<data_flow_T> wb_u0_2_u1;
    hwcore::pipes::sc_stream_splitter<data_flow_width, PE_N> wb_package_splitter_u1;
    hwcore::hf::sc_static_list<sc_fifo<data_flow_T>, PE_N > wb_u1_2_u2;

    hwcore::pipes::inst_1::sc_stream_splitter_clone<sc_uint<1> , PE_N> wb_ctrls_splitter;
    hwcore::hf::sc_static_list<sc_fifo< sc_uint<1> >, PE_N> wb_ctrls_split_2_buf;
    
    hwcore::hf::sc_static_list<hwcore::pipes::sc_stream_buffer_not_stream_while_write<data_flow_width> , PE_N > wb_weight_buf_u2;
    hwcore::hf::sc_static_list<sc_fifo< data_flow_T >, PE_N> wb_2_pe;


    //data part
    hwcore::cnn::data_buffer_fc_only<1*data_flow_width> db_u3_1;
    sc_fifo<data_flow_T> db_u3_2_splitter; 
    hwcore::pipes::inst_2::sc_stream_splitter_clone<data_flow_T , PE_N> db_u3_stream_split;
    
    hwcore::hf::sc_static_list2<sc_fifo<data_flow_T>, PE_N > u3_2_u4_array;

    //PE array

    hwcore::hf::sc_static_list2<hwcore::cnn::PE<data_W, data_P, PE_bw_N>, PE_N> PE_array_u4;

    hwcore::hf::sc_static_list2<sc_fifo<data_T>, PE_N > u4_2_u5_array; //

    hwcore::pipes::sc_stream_merge_raw<data_W, PE_N> merge_u5;

    sc_fifo<data_pe_merge_T> u5_2_u6;

    hwcore::pipes::inst_2::sc_stream_resize<data_pe_merge_width, dma_output_width> resize_u6;

    struct wb_package_splitter_u1_link
    {
        static inline void link(_top_cnn & ref, const unsigned i)
        {

            ref.wb_package_splitter_u1.dout[i](ref.wb_u1_2_u2.get(i));

            ref.wb_ctrls_splitter.dout[i](ref.wb_ctrls_split_2_buf.get(i));

            ref.wb_weight_buf_u2.get(i).clk(ref.clk);
            ref.wb_weight_buf_u2.get(i).reset(ref.reset);
            ref.wb_weight_buf_u2.get(i).din(ref.wb_u1_2_u2.get(i));
            ref.wb_weight_buf_u2.get(i).ctrls_in(ref.wb_ctrls_split_2_buf.get(i));
            ref.wb_weight_buf_u2.get(i).dout(ref.wb_2_pe.get(i));

            ref.db_u3_stream_split.dout[i](ref.u3_2_u4_array.get(i));

            ref.PE_array_u4.get(i).clk(ref.clk);
            ref.PE_array_u4.get(i).reset(ref.reset);
            ref.PE_array_u4.get(i).Win(ref.wb_2_pe.get(i));
            ref.PE_array_u4.get(i).Xin(ref.u3_2_u4_array.get(i));
            ref.PE_array_u4.get(i).dout(ref.u4_2_u5_array.get(i));
            ref.merge_u5.din[i](ref.u4_2_u5_array.get(i));
            
        }
    };

    SC_CTOR_TEMPLATE(_top_cnn)
        :SC_INST(resize_u0),
        data_2_u1(1),
        SC_INST(package_handler_u1),
        u1_2_wb(1),
        u1_2_u3(1),
        SC_INST(realign_u0),
        wb_u0_2_u1(1),
        SC_INST(wb_package_splitter_u1),
        wb_u1_2_u2(1),
        SC_INST(wb_ctrls_splitter),
        wb_ctrls_split_2_buf(1),
        SC_INST(wb_weight_buf_u2),
        wb_2_pe(1),
        SC_INST(db_u3_1),
        db_u3_2_splitter(1),
        SC_INST(db_u3_stream_split),
        u3_2_u4_array(1),
        SC_INST(PE_array_u4),
        u4_2_u5_array(1),
        SC_INST(merge_u5),
        u5_2_u6(1),
        SC_INST(resize_u6)
    {
        //resize_u0 ---------------------
        SC_MODULE_LINK(resize_u0);
        resize_u0.din(data_sink);
        resize_u0.dout(data_2_u1);

        //package_handler_u1 ------------
        SC_MODULE_LINK(package_handler_u1);
        package_handler_u1.din(data_2_u1);
        package_handler_u1.ctrl_channel(ctrl_channel);
        package_handler_u1.dout_a(u1_2_wb);
        package_handler_u1.dout_b(u1_2_u3);

        //wb_u2 --------------------
        SC_MODULE_LINK(realign_u0);
        realign_u0.din(u1_2_wb);
        realign_u0.ctrl(ctrl_row_N);
        realign_u0.dout(wb_u0_2_u1);
        SC_MODULE_LINK(wb_package_splitter_u1);
        wb_package_splitter_u1.din(wb_u0_2_u1);
        SC_MODULE_LINK(wb_ctrls_splitter);
        wb_ctrls_splitter.din(weight_ctrls_in);



        hwcore::hf::unroll<1*PE_N, wb_package_splitter_u1_link>::link(*this);

        //db_u3_1 -----------------------
        SC_MODULE_LINK(db_u3_1);
        db_u3_1.din(u1_2_u3);
        db_u3_1.ctrls_in(data_ctrls_in);
        db_u3_1.dout(db_u3_2_splitter);
        SC_MODULE_LINK(db_u3_stream_split);
        db_u3_stream_split.din(db_u3_2_splitter);
        // PE

        // output
        SC_MODULE_LINK(merge_u5);
        merge_u5.dout(u5_2_u6);
        SC_MODULE_LINK(resize_u6);
        resize_u6.din(u5_2_u6);
        resize_u6.dout(data_source);

    }

public:


    


    inline void trace(sc_trace_file *trace)
	{
		/*SC_TRACE_ADD(clk);
		SC_TRACE_ADD(reset);
        //SC_TRACE_ADD(data_sink);
        //SC_TRACE_ADD(data_ctrls_in);
        //SC_TRACE_ADD(ctrl_channel);
        //SC_TRACE_ADD(ctrl_row_N);
        SC_TRACE_ADD_MODULE(data_2_u1);
        SC_TRACE_ADD_MODULE(package_handler_u1);
        SC_TRACE_ADD_MODULE(u1_2_u2);
        SC_TRACE_ADD_MODULE(u1_2_u3);
        SC_TRACE_ADD_MODULE(wb_u2);
        //SC_TRACE_ADD_MODULE(db_u3);
        SC_TRACE_ADD_MODULE(db_u3_2_splitter);
        for(int i=0;i<PE_N;i++)
        {
            SC_TRACE_ADD_MODULE(u2_2_u4_array.get(i));
            SC_TRACE_ADD_MODULE(u3_2_u4_array.get(i));
            SC_TRACE_ADD_MODULE(PE_array_u4.get(i));
            SC_TRACE_ADD_MODULE(u4_2_u5_array.get(i));
        }
        SC_TRACE_ADD_MODULE(merge_u5);
        SC_TRACE_ADD_MODULE(u5_2_u6);
        SC_TRACE_ADD_MODULE(resize_u6);
        
        //data_source
        //SC_TRACE_ADD(data_source);*/
	}


};

namespace hwcore
{
namespace cnn
{

template<int data_W=16, int data_P=2, int input_BW_N=32, int output_BW_N=32, int PE_N=16, int PE_bw_N=16>
using top_cnn = ::_top_cnn<data_W, data_P, input_BW_N, output_BW_N, PE_N, PE_bw_N>;


} // namespace cnn
} // namespace hwcore
#endif
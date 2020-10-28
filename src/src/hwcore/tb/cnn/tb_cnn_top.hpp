/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#define SC_INCLUDE_FX
#include <systemc.h>
#include "hwcore/cnn/cnn.h"
#include "hwcore/pipes/pipes.h"
#include "hwcore/hf/helperlib.h"

using namespace hwcore;

SC_MODULE(cpu_sim)
{
    sc_fifo_out<pipes::sc_data_stream_t<16*32> > dma_out; 
    sc_fifo_in<pipes::sc_data_stream_t<16*32> > dma_in; 
    //sc_out<uint32_t>
};

SC_MODULE(tb_cnn_top)
{
    
    hf::sc_fifo_template<pipes::sc_data_stream_t<16*32> > cpu_sim_2_u1_dma; 
    
    cnn::top_cnn<> cnn_u1;
    
    hf::sc_fifo_template<pipes::sc_data_stream_t<16*32> > u1_2_cpu_sim_dma;


};
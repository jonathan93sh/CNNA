/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#include <systemc.h>
#include "hwcore/dsp/imfilter.h"
#include "hwcore/tb/scfileio.h"

#define TB_IMFILTER_W W_WIDTH

SC_MODULE(filter_load)
{
	SC_MODULE_CLK_RESET_SIGNAL;

	sc_out<sc_fixed<W_WIDTH,P_DATA> > Wout[3*3];

    SC_CTOR_DEFAULT(filter_load)
    {
        SC_CTHREAD(thread_filter_load, clk.pos());
		reset_signal_is(reset,true);
    }

    void thread_filter_load()
    {
        sc_fixed<W_WIDTH,P_DATA> coeffs[N_ROWS * N_ROWS] = {1.0f, 0.0f, -1.0f,
													 2.0f, 0.0f, -2.0f,
													 1.0f, 0.0f, -1.0f};

        //sc_fixed<16,8> coeffs[N_ROWS * N_ROWS] = {0.1f, 0.2f, 0.3f,
		//											 0.4f, 0.5f, -0.4f,
		//											 -0.3f, -0.2f, -0.1f};
        
        for(int i=0;i<3*3;i++)
        {
            Wout[i].write(coeffs[i]);
        }
        while(1)
        {
            wait();
        }
    }
};

SC_MODULE(TB_imfilter_top)
{

    sc_clock clk;
	sc_signal<bool> reset;

    template<int W>
    using imread = hwcore::tb::imread_func_fx<W,W/2>;

    template<int W>
    using imwrite = hwcore::tb::imwrite_func_fx<W,W/2>;

    template<int W=TB_IMFILTER_W, int depth=16>
    using fifo=hwcore::hf::sc_fifo_template< hwcore::pipes::sc_data_stream_t<W>, depth >;

    hwcore::tb::sc_fileread<TB_IMFILTER_W, imread> fr_u1;
    fifo<> u1_2_u2;
    filter_load filter_loader;
	sc_signal<sc_fixed<W_WIDTH,P_DATA> > Wout[3*3];
    imfilter filter_u2;
    fifo<> u2_2_u3;
    hwcore::tb::sc_filewrite<TB_IMFILTER_W, imwrite> fw_u3;

    

    SC_CTOR_DEFAULT(TB_imfilter_top)
        :clk("clk",sc_time(10,SC_NS)),fr_u1("in_im_512_x_512.txt"), fw_u3("out_im_512_x_512.txt")
    {
        SC_MODULE_LINK(filter_u2);
        SC_MODULE_LINK(filter_loader);
        fr_u1.dout(u1_2_u2);

        for(int i = 0; i < 3*3; i++)
        {
            filter_loader.Wout[i](Wout[i]);
            filter_u2.Win[i](Wout[i]);
        }
        filter_u2.din(u1_2_u2);
        filter_u2.dout(u2_2_u3);
        fw_u3.din(u2_2_u3);
        


    }
    


};

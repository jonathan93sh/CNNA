/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#define SC_INCLUDE_FX
#include <systemc.h>
#include "hwcore/pipes/streamsplit.h"
#include "hwcore/pipes/streammerge.h"
#include "hwcore/pipes/streamresize.h"
#include "hwcore/pipes/data_types.h"

#if __RTL_SIMULATION__

//#include "DMA_performance_tester_rtl_wrapper.h"

//#else
//#include "DMA_generic_performance_tester.hpp"
#endif

#define split_N 64

const long test_size = 20*split_N;

SC_MODULE(mon_split_and_merge)
{
	sc_fifo_in<hwcore::pipes::sc_data_stream_t<16> > data_in;

	SC_CTOR(mon_split_and_merge)
	{
		SC_THREAD(mon_thread);
	}

	void mon_thread()
	{
		

		for(int a=0;a<2;a++)
		{
			uint16_t data_gen = 0;
			hwcore::pipes::sc_data_stream_t<16> tmp_in;
			do
			{
				tmp_in = data_in.read();
				std::cout << "(mon) got signal." << std::endl;
				//for(int i=0;i<split_N;i++)
				//{
					if(tmp_in.template getKeep<16>(0)==1)
					{
						int tmp = tmp_in.template getData<sc_uint, 16>(0).to_uint();
						std::cout << "(mon) got new data: " <<tmp << std::endl;
						sc_assert(tmp == data_gen);
						data_gen++;
					}
				//}
				
			}while(data_gen < test_size);
		}

		std::cout << "Test finish no errors" << std::endl;

		sc_stop();
	}
};

SC_MODULE(wave_split_and_merge)
{
	sc_fifo_out<hwcore::pipes::sc_data_stream_t<16> > data_out;

	SC_CTOR(wave_split_and_merge)
	{
		SC_THREAD(wave_thread);
	}

	void wave_thread()
	{
		hwcore::pipes::sc_data_stream_t<16> tmp;
		for (int i = 0; i < test_size; i++)
		{
			
			tmp.data = i;
			std::cout << "(wave) write new data: " << i << std::endl;
			tmp.setKeep();
			tmp.tlast = 1;
			data_out.write(tmp);
		}

		tmp.setEOP();
		data_out.write(tmp);

		for (int i = 0; i < test_size; i++)
		{
			tmp.data = i;
			std::cout << "(wave) write new data: " << i << std::endl;
			tmp.setKeep();
			tmp.tlast = 1;

			data_out.write(tmp);
		}

		tmp.setEOP();
		data_out.write(tmp);
	}
};

SC_MODULE(tb_split_and_merge)
{
#if __RTL_SIMULATION__
	//DMA_performance_tester_rtl_wrapper u1;
#else
	//DMA_performance_tester u1;
#endif

	sc_clock clk;
	sc_signal<bool> reset;

	wave_split_and_merge wave;
	
	sc_fifo<hwcore::pipes::sc_data_stream_t<16> > wave_2_u1;
	
	hwcore::pipes::sc_stream_splitter<16,split_N,false> u1_ss;
	
	hwcore::hf::sc_static_list<sc_fifo<hwcore::pipes::sc_data_stream_t<16> >, split_N> u1_2_u2;
	//sc_fifo<hwcore::pipes::DATA_STREAM_t<16> > u1_2_u2[32];
	
	hwcore::pipes::sc_stream_merge_raw<16,split_N> u2_sm;
	
	sc_fifo<hwcore::pipes::sc_data_stream_t<16*split_N> > u2_2_u3;

	hwcore::pipes::sc_stream_resize<16*split_N, 16> u3_sr;

	sc_fifo<hwcore::pipes::sc_data_stream_t<16> > u3_2_mon;

	mon_split_and_merge mon;

	SC_CTOR(tb_split_and_merge)
		: u1_ss("u1_ss"),u2_sm("u2_sm"), u3_sr("u3_sr"), wave("wave"), mon("mon"),
		  clk("clock", sc_time(10, SC_NS)),wave_2_u1(64),u2_2_u3(64), u3_2_mon(64),u1_2_u2("fifo",1)
	{
		wave.data_out(wave_2_u1);
		u1_ss.din(wave_2_u1);

		u1_ss.clk(clk);
		u1_ss.reset(reset);
		
		for(int i=0;i<split_N;i++)
		{
			u1_ss.dout[i](u1_2_u2.get(i));
			u2_sm.din[i](u1_2_u2.get(i));
		}

		u2_sm.clk(clk);
		u2_sm.reset(reset);

		u2_sm.dout(u2_2_u3);	
		u3_sr.din(u2_2_u3);

		u3_sr.clk(clk);
		u3_sr.reset(reset);

		u3_sr.dout(u3_2_mon);

		mon.data_in(u3_2_mon);
	}
};

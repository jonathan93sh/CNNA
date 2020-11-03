/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#define SC_INCLUDE_FX
#include <systemc.h>
#include "DMA_data_types.h"
#include "score_lib.h"

#include <list>
#include <algorithm>
#include <math.h>

class monitor_logger
{
	static std::vector<sc_time> &getInEList()
	{
		static std::vector<sc_time> _ingressEvent;
		return _ingressEvent;
	}
	static std::vector<sc_time> &getEgEList()
	{
		static std::vector<sc_time> _egressEvent;
		return _egressEvent;
	}
public:
	static void ingressEvent()
	{
		getInEList().push_back(sc_time_stamp());
	}

	static void egressEvent()
	{
		getEgEList().push_back(sc_time_stamp());
	}

	static void measure_log()
	{
		std::vector<sc_time> delta;
		std::vector<sc_time> delta_in;
		std::vector<sc_time> delta_eg;
		sc_time min = SC_ZERO_TIME;
		sc_time max = SC_ZERO_TIME;
		sc_time min_in = SC_ZERO_TIME;
		sc_time max_in = SC_ZERO_TIME;
		sc_time min_eg = SC_ZERO_TIME;
		sc_time max_eg = SC_ZERO_TIME;
		for(int i=0;i < getEgEList().size();i++)
		{
			sc_time tmp;
			if(i!=0)
			{
				tmp = getInEList()[i]-getInEList()[i-1];
				delta_in.push_back(tmp);
				if(min_in == SC_ZERO_TIME || tmp < min_in)
					min_in = tmp;

				if(max_in == SC_ZERO_TIME || tmp > max_in)
					max_in = tmp;

				tmp = getEgEList()[i]-getEgEList()[i-1];
				delta_eg.push_back(tmp);
				if(min_eg == SC_ZERO_TIME || tmp < min_eg)
					min_eg = tmp;

				if(max_eg == SC_ZERO_TIME || tmp > max_eg)
					max_eg = tmp;
			}

			tmp = getEgEList()[i]-getInEList()[i];
			delta.push_back(tmp);
			if(min == SC_ZERO_TIME || tmp < min)
				min = tmp;

			if(max == SC_ZERO_TIME || tmp > max)
				max = tmp;

		}

		sc_time avg = SC_ZERO_TIME;
		sc_time avg_in = SC_ZERO_TIME;
		sc_time avg_eg = SC_ZERO_TIME;

		for(int i = 0; i < delta_in.size();i++)
		{
			avg_in += delta_in[i];
			avg_eg += delta_eg[i];
		}

		avg_in = avg_in / delta_in.size();
		avg_eg = avg_eg / delta_eg.size();

		for(int i = 0; i < delta.size();i++)
		{
			avg += delta[i];
		}
		avg = avg / delta.size();

		std::cout << "measure log:" << std::endl;
		std::cout << "latency:          [min , avg , max]: [" << (min) << " , " << (avg) << " , " << (max) <<"]" << std::endl;
		std::cout << "interval ingress: [min , avg , max]: [" << (min_in) << " , " << (avg_in) << " , " << (max_in) <<"]" << std::endl;
		std::cout << "interval egress:  [min , avg , max]: [" << (min_eg) << " , " << (avg_eg) << " , " << (max_eg) <<"]" << std::endl;
	}
};

SC_MODULE(waveform)
{
	sc_in<bool> clk;
	sc_out<bool> reset;
	sc_fifo_out<DATA1024_t > source;

	SC_CTOR(waveform)
	{
		SC_CTHREAD(waveform_thread,clk.pos());
	}

	void waveform_thread()
	{
		DATA1024_t tmp;

		tmp.data = 0;
		tmp.tlast = 0;
		reset.write(true);
		float numberGen = 0;
		while(true)
		{
			wait();
			reset.write(false);

			for(int i=0;i<10;i++)
			{
				wait();
				if(i==10-1)
				{
					tmp.tlast = 1;
					cout << "sending TLAST signal" << endl;
				}
				else
				{
					tmp.tlast = 0;
				}
				if(i==0)
					monitor_logger::ingressEvent();
				source.write(tmp);

				//while(source.num_free() != 0) {wait();}
				for(int i=0;i<64;i++)
				{

					sc_fixed<16,8> fx = sin(numberGen)*120.1f;
					//sc_signed us_tmp(fx.wl());
					//us_tmp = (fx << (fx.wl()-fx.iwl()));

					//tmp.data((16-1) + (16*i),16*i) = (sc_bv<16>)us_tmp;
					tmp.data((16-1) + (16*i),16*i) = fixed2bv<16,8>(fx);
					sc_bv<16> tmpCheckRaw = (sc_bv<16>)tmp.data((16-1) + (16*i),16*i);

					sc_fixed<16,8> tmpCheck = bv2fixed<16,8>(tmpCheckRaw);


					if(fx != tmpCheck)
					{

						sc_stop();
						std::cout << "(casting error) got: " << fx << " != " << tmpCheck << std::endl ;//<< " (RAW: " << us_tmp << ")" << std::endl;
					}
					else
					{
						//std::cout << "(casting OK) got: " << fx << " != " << tmpCheck << std::endl;
					}
					numberGen += 0.1;
				}

			}
		}
	}

};

SC_MODULE(monitor)
{
	sc_in<bool> clk;
	sc_in<bool> reset;
	sc_fifo_in<DATA32_t > sink;
	std::ofstream ofs;

	SC_CTOR(monitor)
		:ofs("test.txt", std::ofstream::out)
	{
		SC_CTHREAD(monitor_thread,clk.pos());
		reset_signal_is(reset,true);
	}

	~monitor()
	{
		ofs.close();
	}


	void monitor_thread()
	{

		DATA32_t tmp;
		unsigned countdown = 30;
		while(true)
		{

			sink.read(tmp);
			monitor_logger::egressEvent();
			//std::string tmp_string = "PKGnr is: " + std::to_string((unsigned)count.read().to_uint())  + "TDATA: " + std::to_string((unsigned long)tmp.data.to_uint());// + " @ " +  sc_time_stamp();
			//ofs << "@" << sc_time_stamp() << "last: " << tmp.tlast;
			//SC_REPORT_WARNING(::SC_ID_ASSERTION_FAILED_, tmp_string.c_str());
			//sc_report(true);
			sc_signed ss_tmp(32);
			ss_tmp = tmp.data;
			sc_fixed<32,16> tmpCheck =  ((sc_fixed<32*2,16*2>)ss_tmp)>>16;
			cout << "TDATA: " << tmpCheck << " @ " <<  sc_time_stamp() << endl;
			if(tmp.tlast==1)
			{
				//clog << "test2" <<  sc_time_stamp() << endl;
				//cerr << "test" <<  sc_time_stamp() << endl;
				cout << "got TLAST signal @ " <<  sc_time_stamp() << endl;
			}
			countdown--;
			if(countdown==0)
			{
				cout << "sc_stop signal" << endl;

				sc_stop();
				monitor_logger::measure_log();
			}

		}
	}

};


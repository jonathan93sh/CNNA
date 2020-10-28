#pragma once
#include <systemc.h>

#include <AXI4_if.h>

#define MAX_TASK 120
#define BURST_SIZE 16

struct dma_desc
{
	unsigned add;
	unsigned len;
	dma_desc():add(0),len(0){}
	dma_desc(unsigned add_, unsigned len_)
		:add(add_), len(len_)
	{

	}
};

SC_MODULE(cnna_dma)
{
	enum{
		X=0,Y=1,W=2,Xbuf=3
	};

	sc_in<bool> clk, reset;

	AXI4M_bus_port<sc_uint<128> > Xmem, Ymem, Wmem, Xbufmem;

	sc_fifo_out<sc_uint<128> > Xs, Ws, Xbufs;
	sc_fifo_in<sc_uint<128> > Ys;

	sc_in<unsigned> address, length;
	sc_in<int> select;
	sc_in<bool> add;
	sc_in<bool> fire;
	sc_in<bool> clean;

	SC_CTOR(cnna_dma)
	{
		SC_CTHREAD(Xthread,clk.pos());
		reset_signal_is(reset,true);
	}

	void Xthread()
	{
		dma_desc tasks[MAX_TASK];
		sc_uint<128> raw_data[BURST_SIZE];
		int ptr=0;
		int n_task=0;
		bool pre_add = true;
		bool pre_fire = true;
		X_main_loop:while(true)
		{
			int status=0;
			X_ctrl_loop: do
			{
				status = Xmem.read(0);
				if(clean.read())
				{
					n_task = 0;
				}

				if(select.read() == X && !pre_add && add.read() && n_task < MAX_TASK)
				{
					tasks[n_task] = dma_desc(address.read(), length.read());
					n_task++;
				}
			}while(status == 0);

			X_stream_loop: for(int i=0;i<n_task;i++)
			{
				dma_desc tmp = tasks[i];
				for(int a=0;a<tmp.len/BURST_SIZE;a++)
				{
					Xmem.burst_read(tmp.add,BURST_SIZE, raw_data);
					for(int b=0;b<BURST_SIZE;b++)
					{
						Xs.write(raw_data[b]);
					}
				}
			}
		}
	}


};

/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#define SC_INCLUDE_FX
#include <systemc.h>
#include "hwcore/pipes/pipes.h"
#include "hwcore/hf/helperlib.h"
#include <fstream>
#include <iostream>
#include <string>

namespace hwcore
{
namespace tb
{

template <int W, int P = W / 2>
struct imread_func_fx
{
	bool operator()(std::string line, pipes::sc_data_stream_t<W> &data, bool eof)
	{

		double tmp = std::stod(line);

		sc_fixed<W, P> tmpfx(tmp);
		data.data = hwcore::hf::fixed2bv<W, P>(tmpfx);
		data.tlast = eof;
		HLS_DEBUG(1,200,"line: {%s}, double: {%f}, fixed: {%f}, data: {%s} ", line.c_str(), tmp, tmpfx.to_double() , data.data.to_string().c_str());
		return true;
	}
};

template <int W, int P = W / 2>
struct imwrite_func_fx
{
	bool operator()(std::string &line, pipes::sc_data_stream_t<W> data)
	{
		sc_fixed<W, P> tmpfx = data.template getDataFixed<P>();
		line = std::to_string(tmpfx.to_double());
		HLS_DEBUG(1,200,"line: {%s}, fixed: {%f}, data: {%s} ", line.c_str(), tmpfx.to_double() , data.data.to_string().c_str());
		return data.tlast==1;
	}
};

template <int W, template <int> class func>
SC_MODULE(sc_fileread)
{
  private:
	std::string mRaw_image_file;
	std::ifstream fs;
  public:
	sc_fifo_out<hwcore::pipes::sc_data_stream_t<W> > dout;

	SC_CTOR_DEFAULT_PARAM(sc_fileread, std::string raw_image_file)
		: mRaw_image_file(raw_image_file)
	{
		SC_THREAD(imread_thread);
	}

	virtual ~sc_fileread()
	{
		fs.close();
	}

	void imread_thread()
	{
		func<W> f_helper;
		fs.open(mRaw_image_file);
		bool is_open = fs.is_open();

		sc_assert(is_open);
		if (!is_open)
			sc_stop();

		std::string line;
		pipes::sc_data_stream_t<W> tmp;
		while (std::getline(fs, line))
		{

			f_helper(line, tmp, fs.eof());
			dout.write(tmp);
		}

		while (true)
		{
			wait();
		}
	}
};


template <int W, template <int> class func>
SC_MODULE(sc_filewrite)
{
  private:
	std::string mRaw_image_file;
	std::ofstream fs;
  public:
	sc_fifo_in<hwcore::pipes::sc_data_stream_t<W> > din;


	SC_CTOR_DEFAULT_PARAM(sc_filewrite, std::string raw_image_file)
		: mRaw_image_file(raw_image_file)
	{
		SC_THREAD(imwrite_thread);
	}

	virtual ~sc_filewrite()
	{
		fs.close();
	}

	void imwrite_thread()
	{
		func<W> f_helper;

		fs.open(mRaw_image_file);

		sc_assert(fs.is_open());
		if (!fs.is_open())
			sc_stop();

		std::string line;

		//fs << "test";
		while (true)
		{
			bool last = f_helper(line,din.read());
			
			
			fs << line << std::endl;

			fs.flush();
			if(last)
				break;
		}

		sc_stop();
		while (true)
		{
			wait();
		}
	}
};
} // namespace tb
} // namespace hwcore

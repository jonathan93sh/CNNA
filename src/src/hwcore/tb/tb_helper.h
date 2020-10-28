/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#define SC_INCLUDE_FX
#include <systemc.h>

#include <list>
#include <algorithm>
#include <math.h>

namespace hwcore
{
namespace tb
{

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

	static void measure_log(std::ostream &out = std::cout)
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
		for (int i = 0; i < getEgEList().size(); i++)
		{
			sc_time tmp;
			if (i != 0)
			{
				tmp = getInEList()[i] - getInEList()[i - 1];
				delta_in.push_back(tmp);
				if (min_in == SC_ZERO_TIME || tmp < min_in)
					min_in = tmp;

				if (max_in == SC_ZERO_TIME || tmp > max_in)
					max_in = tmp;

				tmp = getEgEList()[i] - getEgEList()[i - 1];
				delta_eg.push_back(tmp);
				if (min_eg == SC_ZERO_TIME || tmp < min_eg)
					min_eg = tmp;

				if (max_eg == SC_ZERO_TIME || tmp > max_eg)
					max_eg = tmp;
			}

			tmp = getEgEList()[i] - getInEList()[i];
			delta.push_back(tmp);
			if (min == SC_ZERO_TIME || tmp < min)
				min = tmp;

			if (max == SC_ZERO_TIME || tmp > max)
				max = tmp;
		}

		sc_time avg = SC_ZERO_TIME;
		sc_time avg_in = SC_ZERO_TIME;
		sc_time avg_eg = SC_ZERO_TIME;

		for (int i = 0; i < delta_in.size(); i++)
		{
			avg_in += delta_in[i];
			avg_eg += delta_eg[i];
		}

		avg_in = avg_in / delta_in.size();
		avg_eg = avg_eg / delta_eg.size();

		for (int i = 0; i < delta.size(); i++)
		{
			avg += delta[i];
		}
		avg = avg / delta.size();

		out << "measure log:" << std::endl;
		out << "latency:          [min , avg , max]: [" << (min) << " , " << (avg) << " , " << (max) << "]" << std::endl;
		out << "interval ingress: [min , avg , max]: [" << (min_in) << " , " << (avg_in) << " , " << (max_in) << "]" << std::endl;
		out << "interval egress:  [min , avg , max]: [" << (min_eg) << " , " << (avg_eg) << " , " << (max_eg) << "]" << std::endl;
	}
};
} // namespace tb
} // namespace hwcore
/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#define SC_INCLUDE_FX
#include <systemc.h>
#include "hwcore/hf/helperlib.h"

namespace hwcore
{
namespace hw
{

template <int W, int N>
class circle_buffer
{
  private:
    sc_biguint<W> ram[N];

    int widx;
    int ridx;

  public:
    circle_buffer()
        : widx(0), ridx(0)
    {
#pragma HLS array_partition variable = ram complete
    }

    void reset()
    {
        widx = 0;
        ridx = 0;
    }

    size_t count() const
    {
        return (widx >= ridx ? widx : widx + N) - ridx;
    }

    size_t free() const
    {
        return N - count();
    }


    void operator<<(const sc_uint<W> &data_in)
    {
        push(data_in);
    }

    template<int I>
    void push(const sc_fixed<W,I> &data_in)
    {
        ram[widx] = hf::fixed2bv<W,I>(data_in);
        widx = (widx == N - 1 ? 0 : widx + 1);
    }

    void push(const sc_uint<W> &data_in)
    {
        ram[widx] = data_in;
        widx = (widx == N - 1 ? 0 : widx + 1);
    }

    template<int I>
    sc_fixed<W,I> pop()
    {
        int ridx_tmp = ridx;
        ridx = (ridx == N - 1 ? 0 : ridx + 1);
        return hf::bv2fixed<W,I>(ram[ridx_tmp]);
    }

    sc_uint<W> pop()
    {
        int ridx_tmp = ridx;
        ridx = (ridx == N - 1 ? 0 : ridx + 1);
        return ram[ridx_tmp];
    }
};

} // namespace hw
} // namespace hwcore
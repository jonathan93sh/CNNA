#define SC_INCLUDE_FX
#include <systemc.h>
#include "hwcore/dsp/imfilter.h"
#include "hwcore/hf/helperlib.h"
#include "hwcore/hw/hw.h"
#include "hwcore/pipes/pipes.h"

/*namespace hwcore
{
namespace dsp
{*/
using namespace hwcore;

void imfilter::imfilter_thread()
{

	SC_STREAM_INTERFACE_CREATE_SINK(din)
	SC_STREAM_INTERFACE_CREATE_SOURCE(dout)
	SC_AXI_INTERFACE_CREATE(Win)

	hw::circular_line_buffer<N_ROWS, im_WIDTH, X_W> buffer;
	hw::shiftreg<fixed_X_t, N_ROWS> COL_buf[N_ROWS];
	fixed_W_t coeffs[N_ROWS * N_ROWS];

	sc_uint<hf::log2_ceil<im_WIDTH>::val> col_indx = 0;
	int row_N_div_2_floor = hf::const_float<N_ROWS, 2>::FLOOR;
	int row_indx_low = -row_N_div_2_floor;
	int row_indx_high = im_WIDTH - 1;
	int row_indx = row_indx_low;
	
	wait();
imfilter_thread_loop:
	while (1)
	{

		fixed_X_t window_tmp[N_ROWS];

		data_t raw_in;
		sc_fixed<W_WIDTH, P_DATA> tmp_in;

		for (int r = 0; r < im_WIDTH + (N_ROWS / 2); r++) //-(N_ROWS / 2)
		{

			for (int c = 0; c < im_WIDTH + (N_ROWS / 2); c++) //-N_ROWS / 2 // + (N_ROWS / 2)
			{
#pragma HLS pipeline II = 1
				/*for (int i = 0; i < N_ROWS * N_ROWS; i++)
					{
						HLS_DEBUG(1, 1000, "coeffs[%d]: {%f}", i, coeffs[i].to_double());
					}*/
				if (0 <= r && r < im_WIDTH && 0 <= c && c < im_WIDTH)
				{
					din.read(raw_in);
					tmp_in = raw_in.getDataFixed<P_DATA>();
				}
				else
				{
					tmp_in = 0;
				}

				if(r==0 && c == 0)
				{
									
					for (int i = 0; i < N_ROWS * N_ROWS; i++)
					{
	#pragma HLS UNROLL
						coeffs[i] = (fixed_W_t)Win[i].read();
						HLS_DEBUG(1, 1000,0, "coeffs[%d]: {%f}", i, coeffs[i].to_double());
					}
				}

				if (0 <= c && c < im_WIDTH)
				{
					buffer.template exec_fixed<X_P>((fixed_X_t)tmp_in, c, window_tmp);
					HLS_DEBUG(1, 1000,0, "fixed_in: {%f}, data: {%s}", tmp_in.to_double(), raw_in.data.to_string().c_str());
				}
				else
				{
					for (int i = 0; i < N_ROWS; i++)
					{
#pragma HLS UNROLL
						window_tmp[i] = 0;
					}
				}

				for (int i = 0; i < N_ROWS; i++)
				{
#pragma HLS UNROLL
					COL_buf[i] << window_tmp[N_ROWS - i - 1];
					HLS_DEBUG(1, 1000,0, "W[%d]: {%f}", N_ROWS - i - 1, window_tmp[N_ROWS - i - 1].to_double());
				}

				fixed_Y_t tmp_out = 0;

			window_sliding_loop:
				for (int r_i = 0; r_i < N_ROWS; r_i++)
				{
#pragma HLS UNROLL
					for (int c_i = 0; c_i < N_ROWS; c_i++)
					{
						int r_i_rev = (N_ROWS - r_i - 1);
						int c_i_rev = (N_ROWS - c_i - 1);
						int coeffs_idx = r_i + (c_i * N_ROWS);
						int r_rel = r - r_i;
						int c_rel = c - c_i;
						if (true) //(0 <= r_rel && r_rel < im_WIDTH && 0 <= c_rel && c_rel < im_WIDTH)
						{
							tmp_out += COL_buf[r_i][c_i] * coeffs[coeffs_idx];
							HLS_DEBUG(1, 1000,0, "X: {%f}, W: {%f}, P: {%f}, sum: {%f}, coeff_idx: {%d} ", COL_buf[r_i][c_i].to_double(),
									  coeffs[coeffs_idx].to_double(),
									  (COL_buf[r_i][c_i] * coeffs[coeffs_idx]).to_double(),
									  tmp_out.to_double(),
									  coeffs_idx);
						}
					}
				}

				data_t raw_out;
				raw_out.setDataFixed<P_DATA>((sc_fixed<W_WIDTH, P_DATA>)tmp_out);
				raw_out.setKeep();
				raw_out.tlast = (r == im_WIDTH + (N_ROWS / 2) - 1 && c == im_WIDTH + (N_ROWS / 2) - 1 ? 1 : 0);
				if (r >= (N_ROWS / 2) && c >= (N_ROWS / 2))
					dout.write(raw_out);
			}
			buffer.EOL_Handle();
		}
	}
}

/*} // namespace dsp
} // namespace hwcore*/

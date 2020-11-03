/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#define AP_INT_MAX_W 2048 // Size of "sc_bv<W> data" exceed limit (1024) for ALexNet layer 11x11
#define SC_INCLUDE_FX
#include "hwcore/hf/helperlib.h"
#include <iostream>
#include <string>
#include <systemc.h>

#define SC_STREAM_INTERFACE_CREATE_SOURCE(interface, param)                                                            \
	DO_PRAGMA(HLS RESOURCE variable = interface core = AXI4Stream metadata =                                           \
	              param port_map = {{interface##_0 TDATA} {interface##_1 TLAST} {interface##_2 TKEEP}})

#define SC_STREAM_INTERFACE_CREATE_SINK(interface, param)                                                              \
	DO_PRAGMA(HLS RESOURCE variable = interface core = AXI4Stream metadata =                                           \
	              param port_map = {{interface##_0 TDATA} {interface##_1 TLAST} {interface##_2 TKEEP}})

#define SC_AXI_INTERFACE_CREATE(interface)                                                                             \
	DO_PRAGMA(HLS resource core = AXI4LiteS metadata = "-bus_bundle slv0" variable = interface)

/*#ifdef __SYNTHESIS__NOT
#define SC_DECL_INTERFACE(name,W)  struct name : public hwcore::pipes::DATA_STREAM_t<W>{typedef
hwcore::pipes::DATA_STREAM_t<W> interface_T; } #else #define SC_DECL_INTERFACE(name,W)  using name =
hwcore::pipes::DATA_STREAM_t<W> hwcore::pipes::DATA_STREAM_t<W> impl
//#define SC_DECL_INTERFACE(W)  SC_DECL_INTERFACE__(W);
//#define SC_DECL_INTERFACE_NAME(name,W)
//#define SC_DECL_INTERFACE__(W)  using DATA_STREAM_ ## W = hwcore::pipes::DATA_STREAM_t<W>;
#endif*/

//#define DATA_std_t(W) DATA_STREAM_##W

#define SC_DATA_T(W) SC_DATA_T__(W)
#define SC_DATA_T__(W) SC_DATA_STREAM_T_trait<W>::interface_T

#define SC_DECL_INTERFACE_STD__(W)                                                                                     \
	SC_DECL_INTERFACE(SC_DATA_STREAM_##W, W);                                                                          \
	template <> struct SC_DATA_STREAM_T_trait<W> { typedef SC_DATA_STREAM_##W interface_T; };

#define SC_DECL_INTERFACE(name, W)                                                                                     \
	struct name : public hwcore::pipes::SC_DATA_STREAM_t<W> {                                                          \
		typedef hwcore::pipes::SC_DATA_STREAM_t<W> interface_T;                                                        \
                                                                                                                       \
		inline name() : SC_DATA_STREAM_t<W>() {}                                                                       \
                                                                                                                       \
		inline name(const name &ref) {                                                                                 \
			data = ref.data;                                                                                           \
			tlast = ref.tlast;                                                                                         \
			tkeep = ref.tkeep;                                                                                         \
		}                                                                                                              \
                                                                                                                       \
		inline name(const interface_T &ref) {                                                                          \
			data = ref.data;                                                                                           \
			tlast = ref.tlast;                                                                                         \
			tkeep = ref.tkeep;                                                                                         \
		}                                                                                                              \
                                                                                                                       \
		inline name(sc_bv<W> data_, sc_uint<1> tlast_ = 0, sc_uint<W / 8> tkeep_ = 0) {                                \
			data = data_;                                                                                              \
			tlast = tlast_;                                                                                            \
			tkeep = tkeep_;                                                                                            \
		}                                                                                                              \
	};

/*		operator interface_T()\
        {\
            interface_T tmp;\
            tmp.data = data;\
            tmp.tlast = tlast;\
            tmp.tkeep = tkeep;\
            return tmp;\
        }\*/

namespace hwcore {
namespace pipes {

template <class T> class sc_fifo_base_dummy {
  public:
	inline friend void sc_trace(sc_trace_file *tf, const T &v, const std::string &NAME) {}

	inline friend std::ostream &operator<<(ostream &os, T const &v) {
		// os << "(" << v.data << "," << v.tlast << "," << v.tkeep << ")";//std::boolalpha
		return os;
	}
};

template <int W, int keepW = 8> class SC_DATA_STREAM_t {
  public:
	sc_bv<W> data;
	sc_uint<1> tlast;
	sc_bv<W / keepW> tkeep;

	inline SC_DATA_STREAM_t() : data(), tlast(), tkeep() {}

	inline SC_DATA_STREAM_t(const SC_DATA_STREAM_t &ref) {
		data = ref.data;
		tlast = ref.tlast;
		tkeep = ref.tkeep;
	}

	inline SC_DATA_STREAM_t(sc_bv<W> data_, sc_uint<1> tlast_ = 0, sc_uint<W / keepW> tkeep_ = 0) {
		data = data_;
		tlast = tlast_;
		tkeep = tkeep_;
	}

	template <int pW, int pkeepW = 8> inline void fit(const SC_DATA_STREAM_t<pW, pkeepW> &ref) {
		data = 0;
		tkeep = 0;
		data(pW - 1, 0) = ref.data;
		tlast = ref.tlast;
		tkeep((pW / 8) - 1, 0) = ref.tkeep;
	}

	// inline void setData(sc_uint<32> data_)

	inline bool operator==(const SC_DATA_STREAM_t &rhs) const {
		return (rhs.data == data && rhs.tlast == tlast && rhs.tkeep == tkeep);
	}

	inline SC_DATA_STREAM_t &operator=(const SC_DATA_STREAM_t &rhs) {
		data = rhs.data;
		tlast = rhs.tlast;
		tkeep = rhs.tkeep;
		return *this;
	}

	inline friend void sc_trace(sc_trace_file *tf, const SC_DATA_STREAM_t &v, const std::string &NAME) {
		sc_trace(tf, v.data, NAME + ".data");
		sc_trace(tf, v.tlast, NAME + ".tlast");
		sc_trace(tf, v.tkeep, NAME + ".tkeep");
	}

	inline friend std::ostream &operator<<(ostream &os, SC_DATA_STREAM_t const &v) {
		os << "(" << v.data << "," << v.tlast << "," << v.tkeep << ")"; // std::boolalpha
		return os;
	}

	inline bool EOP() { return (tlast == 1 && tkeep.get_bit(0) == 0 && tkeep.get_bit((W / keepW) - 1) == 0); }

	inline bool EOPRev() {
		// warning remove this
		return (tlast == 1 && tkeep.get_bit((W / keepW) - 1) == 0);
	}

	inline void setEOP() {
		data = 0;
		setKeep(0);
		tlast = 1;
	}

	inline bool unValid() { return (tlast == 0 && tkeep.get_bit(0) == 0); }

	inline void setUnvalid(sc_uint<1> _tlast = 0) {
		data = 0;
		setKeep(0);
		tlast = _tlast;
	}

	inline void setKeep() { tkeep = hwcore::hf::HIGH<sc_uint, W / keepW>(); }

	inline void setKeep(int pkg_size) {
		for (int i = 0; i < W / keepW; i++) {
#pragma HLS UNROLL
			if (i < pkg_size) {
				tkeep[i] = 1;
			} else {
				tkeep[i] = 0;
			}
		}
	}

	/*template<int data_W>
	void setKeep(sc_bv<W/data_W> keepVal)
	{
	    const int N_new_keep = W/data_W;
	    const int rate = (data_W/8);
	    for(int a=0;a<N_new_keep;a++)
	    {
	        #pragma HLS UNROLL
	        for(int b=0;b<rate;b++)
	        {
	            #pragma HLS UNROLL
	            tkeep[(a*rate) + b] = keepVal[a];

	        }
	    }
	}*/

	template <int data_W> inline void setKeep(int keepVal, int index) {
		const int N_new_keep = W / data_W;
		const int rate = (data_W / keepW);

		for (int b = 0; b < rate; b++) {
#pragma HLS UNROLL
			tkeep[(index * rate) + b] = keepVal;
		}
	}

	template <int data_W> inline void setKeep(int pkg_size) {
		for (int i = 0; i < W / data_W; i++) {
#pragma HLS UNROLL
			setKeep<data_W>((i < pkg_size ? 1 : 0), i);
		}
	}

	template <int data_W> inline void setKeepRev(int pkg_size) {
		for (int i = 0; i < W / data_W; i++) {
#pragma HLS UNROLL
			setKeep<data_W>((i < pkg_size ? 1 : 0), (W / data_W) - i - 1);
		}
	}

	template <int data_W> inline int getKeep(int index) {
		const int N_new_keep = W / data_W;
		const int rate = (data_W / keepW);
		return tkeep.get_bit(index * rate);
	}

	template <template <int> class data_T, int data_W, int N> inline void getData(data_T<data_W> *out) {
	ASSIGNLOOP:
		for (int i = 0; i < N; i++) {
#pragma HLS UNROLL
			sc_bv<data_W> tmp = data(data_W - 1 + data_W * i, data_W * i);
			out[i] = tmp;
		}
	}

	template <template <int> class data_T, int data_W> inline data_T<data_W> getData(int index) {
		sc_bv<data_W> tmp = data(data_W - 1 + data_W * index, data_W * index);
		return tmp;
	}

	template <int data_W, int data_P, int N> inline void getDataFixed(sc_fixed<data_W, data_P> out[N]) {
	ASSIGNLOOP:
		for (int i = 0; i < N; i++) {
#pragma HLS UNROLL
			sc_bv<data_W> tmp = data(data_W - 1 + data_W * i, data_W * i);
			out[i] = hwcore::hf::bv2fixed<data_W, data_P>(tmp);
		}
	}

	template <int data_W, int data_P, int N> inline void getDatauFixed(sc_ufixed<data_W, data_P> out[N]) {
	ASSIGNLOOP:
		for (int i = 0; i < N; i++) {
#pragma HLS UNROLL
			sc_bv<data_W> tmp = data(data_W - 1 + data_W * i, data_W * i);
			out[i] = hwcore::hf::bv2ufixed<data_W, data_P>(tmp);
		}
	}

	template <int data_W, int data_P, int N> inline void getDataFixed(sc_fixed<data_W, data_P, SC_TRN, SC_SAT> out[N]) {
	ASSIGNLOOP:
		for (int i = 0; i < N; i++) {
#pragma HLS UNROLL
			sc_bv<data_W> tmp = data(data_W - 1 + data_W * i, data_W * i);
			out[i] = hwcore::hf::bv2fixed<data_W, data_P>(tmp);
		}
	}

	template <int data_P> inline sc_fixed<W, data_P> getDataFixed() { return hwcore::hf::bv2fixed<W, data_P>(data); }

	template <template <int> class data_T, int data_W> inline void setData(data_T<data_W> din, int index) {
		data(data_W - 1 + data_W * index, data_W * index) = din;
	}

	template <template <int> class data_T, int data_W, int N> inline void setData(data_T<data_W> din[N]) {
	ASSIGNLOOP:
		for (int i = 0; i < N; i++) {
#pragma HLS UNROLL
			data(data_W - 1 + data_W * i, data_W * i) = din[i];
		}
	}

	template <int data_W, int data_P, int N> inline void setDataFixed(sc_fixed<data_W, data_P> in[N]) {
	ASSIGNLOOP:
		for (int i = 0; i < N; i++) {
#pragma HLS UNROLL
			data(data_W - 1 + data_W * i, data_W * i) = hwcore::hf::fixed2bv<data_W, data_P>(in[i]);
		}
	}

	template <int data_W, int data_P, int N> inline void setDataUfixed(sc_ufixed<data_W, data_P> in[N]) {
	ASSIGNLOOP:
		for (int i = 0; i < N; i++) {
#pragma HLS UNROLL
			data(data_W - 1 + data_W * i, data_W * i) = hwcore::hf::ufixed2bv<data_W, data_P>(in[i]);
		}
	}

	template <int data_W, int data_P, int N> inline void setDataFixed(sc_fixed<data_W, data_P, SC_TRN, SC_SAT> in[N]) {
	ASSIGNLOOP:
		for (int i = 0; i < N; i++) {
#pragma HLS UNROLL
			data(data_W - 1 + data_W * i, data_W * i) = hwcore::hf::fixed2bv<data_W, data_P>(in[i]);
		}
	}

	template <int data_P> inline void setDataFixed(sc_fixed<W, data_P> in) {
		data = hwcore::hf::fixed2bv<W, data_P>(in);
	}
};

template <typename SC_DATA_STREAM_T1, typename SC_DATA_STREAM_T2>
void SC_DATA_STREAM_copy_info(SC_DATA_STREAM_T1 &dst, SC_DATA_STREAM_T2 &src) {
	dst.tlast = src.tlast;
	dst.tkeep = src.tkeep;
}

template <int W> struct SC_DATA_STREAM_T_trait { typedef SC_DATA_STREAM_t<W> interface_T; };

#ifdef __SYNTHESIS__

SC_DECL_INTERFACE_STD__(8);
SC_DECL_INTERFACE_STD__(16);
SC_DECL_INTERFACE_STD__(32);
SC_DECL_INTERFACE_STD__(64);
SC_DECL_INTERFACE_STD__(128);
SC_DECL_INTERFACE_STD__(256);
SC_DECL_INTERFACE_STD__(512);
SC_DECL_INTERFACE_STD__(1024);

template <int W> using sc_data_stream_t = typename SC_DATA_STREAM_T_trait<1 * W>::interface_T;

#else
// Clang has easier to understand this one instead of the one needed for synthesis.
template <int W> using sc_data_stream_t = SC_DATA_STREAM_t<W, 8>;

#endif

} // namespace pipes
} // namespace hwcore

#ifdef __RTL_SIMULATION__
template <int W> SC_MODULE(SC_FIFO_IN_TRANS) {
	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<hwcore::pipes::sc_data_stream_t<W> > data_sink;
	sc_signal<sc_logic> data_sink_empty_n;
	sc_signal<sc_logic> data_sink_read;
	sc_signal<sc_lv<W> > data_sink_0_dout;
	sc_signal<sc_lv<1> > data_sink_1_dout;
	sc_signal<sc_lv<W / 8> > data_sink_2_dout;

	sc_signal<sc_logic> data_sink_1_read, data_sink_2_read;

#define SC_FIFO_IN_TRANS_CONNECT(inst, thisinst, port)                                                                 \
	SC_MODULE_LINK(thisinst);                                                                                          \
	thisinst.data_sink(port);                                                                                          \
	inst.port##_0_dout(thisinst.data_sink_0_dout);                                                                     \
	inst.port##_0_empty_n(thisinst.data_sink_empty_n);                                                                 \
	inst.port##_0_read(thisinst.data_sink_read);                                                                       \
	inst.port##_1_dout(thisinst.data_sink_1_dout);                                                                     \
	inst.port##_1_empty_n(thisinst.data_sink_empty_n);                                                                 \
	inst.port##_2_dout(thisinst.data_sink_2_dout);                                                                     \
	inst.port##_2_empty_n(thisinst.data_sink_empty_n);                                                                 \
	inst.port##_1_read(thisinst.data_sink_1_read);                                                                     \
	inst.port##_2_read(thisinst.data_sink_2_read);

	SC_CTOR(SC_FIFO_IN_TRANS) {
		SC_CTHREAD(TRANS_thread, clk);
		reset_signal_is(reset, true);
	}

	void TRANS_thread() {
		data_sink_empty_n.write(SC_LOGIC_0);
		data_sink_0_dout.write(0);
		data_sink_1_dout.write(0);
		data_sink_2_dout.write(0);
		while (true) {
			// wait();
			data_sink_empty_n.write(SC_LOGIC_0);
			data_sink_0_dout.write(0);
			data_sink_1_dout.write(0);
			data_sink_2_dout.write(0);

			hwcore::pipes::sc_data_stream_t<W> tmp = data_sink.read();

			data_sink_0_dout.write(tmp.data);
			data_sink_1_dout.write(tmp.tlast);
			data_sink_2_dout.write(tmp.tkeep);
			data_sink_empty_n.write(SC_LOGIC_1);
			wait();

			while (data_sink_read.read() == SC_LOGIC_0) {
				wait();
			}
		}
	}
};

template <int W> SC_MODULE(SC_FIFO_OUT_TRANS) {
	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_out<hwcore::pipes::sc_data_stream_t<W> > data_source;

	sc_signal<sc_logic> data_source_full_n;
	sc_signal<sc_logic> data_source_write;
	sc_signal<sc_lv<W> > data_source_0_din;
	sc_signal<sc_lv<1> > data_source_1_din;
	sc_signal<sc_lv<W / 8> > data_source_2_din;

	sc_signal<sc_logic> data_source_1_write;
	sc_signal<sc_logic> data_source_2_write;

#define SC_FIFO_OUT_TRANS_CONNECT(inst, thisinst, port)                                                                \
	SC_MODULE_LINK(thisinst);                                                                                          \
	thisinst.data_source(port);                                                                                        \
	inst.port##_0_full_n(thisinst.data_source_full_n);                                                                 \
	inst.port##_1_full_n(thisinst.data_source_full_n);                                                                 \
	inst.port##_2_full_n(thisinst.data_source_full_n);                                                                 \
	inst.port##_0_write(thisinst.data_source_write);                                                                   \
	inst.port##_0_din(thisinst.data_source_0_din);                                                                     \
	inst.port##_1_din(thisinst.data_source_1_din);                                                                     \
	inst.port##_2_din(thisinst.data_source_2_din);                                                                     \
	inst.port##_1_write(thisinst.data_source_1_write);                                                                 \
	inst.port##_2_write(thisinst.data_source_2_write);

	SC_CTOR(SC_FIFO_OUT_TRANS) {
		SC_CTHREAD(TRANS_THREAD, clk.pos());
		reset_signal_is(reset, true);
	}

	void TRANS_THREAD() {
		data_source_full_n.write(SC_LOGIC_0);
		bool full_n = false;
		while (true) {
			wait();
			full_n = !(data_source.num_free() == 0);
			if (full_n) {
				data_source_full_n.write(SC_LOGIC_1);
				if (data_source_write.read() == SC_LOGIC_1) {
					hwcore::pipes::sc_data_stream_t<W> tmp;
					tmp.data = data_source_0_din.read();
					tmp.tlast = data_source_1_din.read();
					tmp.tkeep = data_source_2_din.read();
					if (data_source.nb_write(tmp)) {
						/*full_n = !(data_source.num_free()==0);
						data_source_full_n.write(SC_LOGIC_1);*/
					}
				}
			} else {
				data_source_full_n.write(SC_LOGIC_0);
			}
		}
	}
};
#endif

//#define SC_DECL_INTERFACE(name,W)  struct name : public hwcore::pipes::DATA_STREAM_t<W>{typedef
// hwcore::pipes::DATA_STREAM_t<W> interface_T; }

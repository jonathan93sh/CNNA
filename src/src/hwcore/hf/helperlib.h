/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#define SC_INCLUDE_FX
#include <cmath>
#include <systemc.h>

#ifndef __SYNTHESIS__
#include <algorithm>
#include <functional>
#include <memory>
#include <vector>
#endif
//#include <type_traits>

// https://gcc.gnu.org/onlinedocs/cpp/Pragmas.html
#define DO_PRAGMA(x) _Pragma(#x)

// https://stackoverflow.com/questions/19666142/why-is-a-level-of-indirection-needed-for-this-concatenation-macro
// @DaoWen
#define JOIN(symbol1, symbol2) _DO_JOIN(symbol1, symbol2)
#define _DO_JOIN(symbol1, symbol2) symbol1##symbol2

#define str(s) #s
#define xstr(s) str(s)
#define EXPAND(x) x
#define FIRST(first, ...) first
#define REMOVE_FIRST(first, ...) __VA_ARGS__

#define dummy_end()                                                                                                    \
	do {                                                                                                               \
	} while (false)

#ifdef HLS_APPROX_TIME
#define wait_approx() wait()
#define wait_approx_for(n)                                                                                             \
	for (int __wafi = 0; __wafi < n; __wafi++) {                                                                       \
		wait_approx();                                                                                                 \
	}                                                                                                                  \
	dummy_end()
#else
#define wait_approx()
#define wait_approx_for(n)
#endif

#define hls_pipeline(_II)                                                                                              \
	DO_PRAGMA(HLS pipeline II = _II);                                                                                  \
	wait_approx_for(_II)

#define hls_pipeline_raw(_II) DO_PRAGMA(HLS pipeline II = _II)

#define hls_unroll() DO_PRAGMA(HLS unroll)

#define hls_unroll_factor(_factor) DO_PRAGMA(HLS unroll factor = _factor)

// wait_approx_for(_factor / N)

#define hls_loop() wait_approx()

#define hls_array_partition(_variable, param) DO_PRAGMA(HLS array_partition variable = _variable param)

#define hls_array_partition_complete(_variable) hls_array_partition(_variable, complete)

#define SC_MODULE_CLK_RESET_SIGNAL                                                                                     \
	sc_in<bool> clk;                                                                                                   \
	sc_in<bool> reset

#define SC_MODULE_LINK(module)                                                                                         \
	module.reset(reset);                                                                                               \
	module.clk(clk)

#define SC_CTOR_DEFAULT(user_module_name)                                                                              \
	typedef user_module_name SC_CURRENT_USER_MODULE;                                                                   \
	inline explicit user_module_name(                                                                                  \
	    ::sc_core::sc_module_name) //=sc_gen_unique_name(#user_module_name "_u" xstr(__COUNTER__) ))

#define SC_CTOR_DEFAULT_PARAM(user_module_name, ...)                                                                   \
	typedef user_module_name SC_CURRENT_USER_MODULE;                                                                   \
	inline explicit user_module_name(                                                                                  \
	    __VA_ARGS__, ::sc_core::sc_module_name) //=sc_gen_unique_name(#user_module_name "_u" xstr(__COUNTER__) ) )

#define SC_CTOR_TEMPLATE(user_module_name)                                                                             \
	typedef user_module_name SC_CURRENT_USER_MODULE;                                                                   \
	inline explicit user_module_name(                                                                                  \
	    ::sc_core::sc_module_name) //=sc_gen_unique_name(#user_module_name "_u" xstr(__COUNTER__) ))

#define SC_CTOR_TEMPLATE_PARAM(user_module_name, ...)                                                                  \
	typedef user_module_name SC_CURRENT_USER_MODULE;                                                                   \
	inline explicit user_module_name(                                                                                  \
	    __VA_ARGS__, ::sc_core::sc_module_name) //=sc_gen_unique_name(#user_module_name "_u" xstr(__COUNTER__) ) )

#define IF_SC_FIFO_NB_READ_FLUSH(fifo_in_port, data)                                                                   \
	if (!fifo_in_port.nb_read(data)) {                                                                                 \
		wait();                                                                                                        \
	} else

#define IF_SC_FIFO_NB_READ_FLUSH_SKIP(fifo_in_port, data, skip_read)                                                   \
	bool blob = false;                                                                                                 \
	if (!(skip_read)) {                                                                                                \
		blob = !fifo_in_port.nb_read(data);                                                                            \
	}                                                                                                                  \
	if (blob) {                                                                                                        \
		wait();                                                                                                        \
	} else

#define SC_INST(module_name) module_name(#module_name)

#ifdef __SYNTHESIS__TEST
#define SC_TRACE_ADD(port) sc_trace(trace, port, std::string("(" #port ").") + port.name())
#define SC_TRACE_ADD_MODULE(module) module.trace(trace);
#define SC_TRACE_ADD_MODULE_FIFO(module)                                                                               \
	module.trace(trace);                                                                                               \
	sc_trace_fifo::add(trace);
#else
#define SC_TRACE_ADD(port)
#define SC_TRACE_ADD_MODULE(module)
#define SC_TRACE_ADD_MODULE_FIFO(module)
#endif

#ifndef HLS_DEBUG_LEVEL
#define HLS_DEBUG_LEVEL 999
#endif

#ifndef __SYNTHESIS__
#define HLS_DEBUG(LEVEL, interval, max_N_times, ...)                                                                   \
	if (LEVEL <= HLS_DEBUG_LEVEL) {                                                                                    \
		static int __value__HLS_DEBUG_INTERVAL__ = 0;                                                                  \
		__value__HLS_DEBUG_INTERVAL__ = 0;                                                                             \
		if (__value__HLS_DEBUG_INTERVAL__ % interval == 0 &&                                                           \
		    (max_N_times == 0 || __value__HLS_DEBUG_INTERVAL__ < max_N_times)) {                                       \
			printf("[ ");                                                                                              \
			sc_time_stamp().print();                                                                                   \
			printf(" ] - ");                                                                                           \
			printf("(func: %s) %s:%d: (%s)", __func__, __FILE__, __LINE__, this->name());                              \
			printf(__VA_ARGS__);                                                                                       \
			printf("\r\n");                                                                                            \
			fflush(stdout);                                                                                            \
		}                                                                                                              \
		__value__HLS_DEBUG_INTERVAL__++;                                                                               \
	}
#define HLS_DEBUG_EXEC(func) func
#define HLS_DEBUG_SWITCH_EXEC(func_debug, func_synth) func_debug
#else
#define HLS_DEBUG(...)
#define HLS_DEBUG_EXEC(func)
#define HLS_DEBUG_SWITCH_EXEC(func_debug, func_synth) func_synth
#endif

#define debug_cout                                                                                                     \
	std::cout << "[ " << sc_time_stamp().to_string() << " ] - (func: " << __func__ << ") " << __FILE__ << ":"          \
	          << __LINE__ << ": (" << this->name() << ")"

//#define HLS_DEBUG(...)

namespace hwcore {

namespace hf {

template <class T> void create_dummy_signal(sc_out<T> &port) {
	sc_signal<T> *ptr = new sc_signal<T>();
	port(*ptr);
}

#define sc_set_port_optional(port) HLS_DEBUG_EXEC(hwcore::hf::create_dummy_signal(port))

#ifndef __SYNTHESIS__

/*
class sc_port_optional {

    static std::vector<std::function<void()> > &getVec() {
        static std::vector<std::function<void()> > exec;
        return exec;
    }

  public:
    template <class T> void set_port(sc_out<T> &port) {

        getVec.push_back([&]() { port });
    }

    void doWork() {
        auto vec = getVec();

        for (auto itr : vec) {
            itr();
        }
    }
};*/

class sc_trace_fifo {
  public:
	class sc_fifo_wrap_base {
	  public:
		virtual ~sc_fifo_wrap_base() {}
		virtual int num_available() const = 0;
		virtual int num_free() const = 0;
		virtual void print(::std::ostream & = ::std::cout) const = 0;
		virtual void dump(::std::ostream & = ::std::cout) const = 0;
		virtual const char *name() const = 0;
		virtual sc_port_base *getReader() = 0;
		virtual sc_port_base *getWriter() = 0;
	};

	template <class fifo> class sc_fifo_wrap : public virtual sc_fifo_wrap_base {
		fifo *mRef;

	  public:
		sc_fifo_wrap(fifo &ref) : mRef(&ref) {}
		virtual ~sc_fifo_wrap() {}
		virtual int num_available() const { return mRef->num_available(); };
		virtual int num_free() const { return mRef->num_free(); };
		virtual void print(::std::ostream &os = ::std::cout) const { mRef->print(os); };
		virtual void dump(::std::ostream &os = ::std::cout) const { mRef->dump(os); };
		virtual const char *name() const { return mRef->name(); }
		virtual sc_port_base *getReader() { return mRef->getReader(); };
		virtual sc_port_base *getWriter() { return mRef->getWriter(); };
	};

	static std::vector<std::shared_ptr<sc_fifo_wrap_base> > &getList() {
		static std::vector<std::shared_ptr<sc_fifo_wrap_base> > list;
		return list;
	}

	template <class fifo> static void add(fifo &f) { getList().push_back(std::make_shared<sc_fifo_wrap<fifo> >(f)); }
};

template <class T> class sc_fifo_with_trace : public sc_fifo<T> {
  public:
	explicit sc_fifo_with_trace(int size_ = 16) : sc_fifo<T>(size_) { sc_trace_fifo::add(*this); }

	explicit sc_fifo_with_trace(const char *name_, int size_ = 16) : sc_fifo<T>(name_, size_) {
		sc_trace_fifo::add(*this);
	}

	sc_port_base *getReader() { return sc_fifo<T>::m_reader; }

	sc_port_base *getWriter() { return sc_fifo<T>::m_writer; }

	virtual ~sc_fifo_with_trace() {}
};

#endif

template <unsigned N, class Linker> //, template<unsigned,typename,typename> class helper>
struct unroll {
	template <typename F> inline static void link(F &f) {
		// helper<N-1,F,T>::link(f,t);
		Linker::link(f, N - 1);
		unroll<N - 1, Linker>::link(f);
	}
};

template <class Linker> // template<unsigned,typename,typename> class helper>
struct unroll<0, Linker> {
	template <typename F> inline static void link(F &f) {}
};

/*template <unsigned N>//, template<unsigned,typename,typename> class helper>
struct linkArray {
    template <typename T1, typename T2> inline static void link(F & f) {
        //helper<N-1,F,T>::link(f,t);
        Linker::link(f,N-1);
        unroll<N-1,Linker>::link(f);
    }
};

template <class Linker>//template<unsigned,typename,typename> class helper>
struct unroll<0,Linker> {
    template <typename F> inline static void link(F & f) {
    }
};*/

template <class T> struct sc_wrap {
	T _module;

	inline explicit sc_wrap(const char *name) : _module(sc_gen_unique_name(name)) {}

	inline explicit sc_wrap() : _module(sc_gen_unique_name("sc_wrap")) {}

	inline T *operator->() { return &_module; }

	inline T &get() { return _module; }
};

template <class T, int N, int _cur_indx = 0> class sc_static_data_list {
	T elem;
	sc_static_data_list<T, N - 1, _cur_indx + 1> next;

  public:
	inline explicit sc_static_data_list() {}

	inline T &get(int indx) {
		if (indx == _cur_indx) {
			return elem;
		} else {
			return next.get(indx);
		}
	}

	inline T *operator[](int indx) {
		if (indx == _cur_indx) {
			return &elem;
		} else {
			return next[indx];
		}
	}
};

template <class T, int _cur_indx> class sc_static_data_list<T, 1, _cur_indx> {
	T elem;

  public:
	inline explicit sc_static_data_list() {}

	inline T &get(int indx) { return elem; }

	inline T *operator[](int indx) { return &elem; }
};

struct none_param {};

template <class T, int N, int _cur_indx = 0> class sc_static_list {
	T elem;
	sc_static_list<T, N - 1, _cur_indx + 1> next;

  public:
	inline explicit sc_static_list(const char *name = "list") : elem(sc_gen_unique_name(name)), next(name) {}

	inline explicit sc_static_list(const char *name, int size)
	    : elem(sc_gen_unique_name(name), size), next(name, size) {}

	inline explicit sc_static_list(int size) : elem(size), next(size) {}

	inline explicit sc_static_list(none_param none) : next(none) {}

	inline T &get(int indx) {
		if (indx == _cur_indx) {
			return elem;
		} else {
			return next.get(indx);
		}
	}

	inline T *operator[](int indx) {
		if (indx == _cur_indx) {
			return &elem;
		} else {
			return next[indx];
		}
	}
};

template <class T, int _cur_indx> class sc_static_list<T, 1, _cur_indx> {
	T elem;

  public:
	inline explicit sc_static_list(const char *name = "list") : elem(sc_gen_unique_name(name)) {}

	inline explicit sc_static_list(const char *name, int size) : elem(sc_gen_unique_name(name), size) {}

	inline explicit sc_static_list(int size) : elem(size) {}
	inline explicit sc_static_list(none_param none) {}

	inline T &get(int indx) { return elem; }

	inline T *operator[](int indx) { return &elem; }
};

template <class T, int N, int _cur_indx = 0> class sc_static_list2 {
	T elem;
	sc_static_list2<T, N - 1, _cur_indx + 1> next;

  public:
	inline explicit sc_static_list2(const char *name = "list2") : elem(sc_gen_unique_name(name)), next(name) {}

	inline explicit sc_static_list2(const char *name, int size)
	    : elem(sc_gen_unique_name(name), size), next(name, size) {}

	inline explicit sc_static_list2(int size) : elem(size), next(size) {}

	inline T &get(int indx) {
		if (indx == _cur_indx) {
			return elem;
		} else {
			return next.get(indx);
		}
	}

	inline T *operator[](int indx) {
		if (indx == _cur_indx) {
			return &elem;
		} else {
			return next[indx];
		}
	}
};

template <class T, int _cur_indx> class sc_static_list2<T, 1, _cur_indx> {
	T elem;

  public:
	inline explicit sc_static_list2(const char *name = "list2") : elem(sc_gen_unique_name(name)) {}

	inline explicit sc_static_list2(const char *name, int size) : elem(sc_gen_unique_name(name), size) {}

	inline explicit sc_static_list2(int size) : elem(size) {}

	inline T &get(int indx) { return elem; }

	inline T *operator[](int indx) { return &elem; }
};

template <class T, int N> class sc_vector {
  private:
	const int _N;
	T mVec[N];
	// sc_core::sc_vector<T> mVec;
  public:
	inline explicit sc_vector() : _N(N) {
#pragma HLS ARRAY_PARTITION variable = mVec complete dim = 1
	}

	inline T &operator[](int idx) { return mVec[idx]; }

	inline T &get(int idx) { return mVec[idx]; }
};

/*template<int W, int I>
using sc_fixed_sat = sc_fixed<W,I,sc_dt::sc_q_mode::SC_TRN,sc_dt::sc_o_mode::SC_SAT>;*/

/*template <class T, int size = 16>
class sc_fifo_template : public sc_fifo<T>
{
public:
    explicit sc_fifo_template()
        : sc_fifo<T>(size)
    {
    }

    explicit sc_fifo_template(const char *name_)
        : sc_fifo<T>(name_, size)
    {
    }



private:
    // disabled
    sc_fifo_template(const sc_fifo_template<T> &);
    sc_fifo_template &operator=(const sc_fifo_template<T> &);
};*/

template <int W1, int W2> inline sc_bv<W1 + W2> bv_merge(sc_bv<W1> bv1, sc_bv<W2> bv2) {
#pragma HLS loop_merge

	sc_bv<W1 + W2> tmp;

	for (int i = 0; i < W2; i++) {
#pragma HLS unroll
		tmp[i] = bv2[i];
	}

	for (int i = 0; i < W1; i++) {
#pragma HLS unroll
		tmp[i + W2] = bv1[i];
	}
	return tmp;
}

template <int W, int p> inline sc_fixed<W, p> bv2fixed(const sc_bv<W> bitvec) {
	sc_fixed<W, p> tmp;
	for (int i = 0; i < W; i++) {
#pragma HLS unroll
		tmp[i] = bitvec.get_bit(i);
	}

	return tmp;
}

template <int W, int p> inline sc_ufixed<W, p> bv2ufixed(const sc_bv<W> bitvec) {
	sc_ufixed<W, p> tmp;
	for (int i = 0; i < W; i++) {
#pragma HLS unroll
		tmp[i] = bitvec.get_bit(i);
	}

	return tmp;
}

template <int W, int p> inline sc_bv<W> fixed2bv(const sc_fixed<W, p> fixval) {
	sc_bv<W> tmp;
	for (int i = 0; i < W; i++) {
#pragma HLS unroll
		tmp[i] = fixval[i];
	}

	return tmp;
}

template <int W, int p> inline sc_bv<W> ufixed2bv(const sc_ufixed<W, p> fixval) {
	sc_bv<W> tmp;
	for (int i = 0; i < W; i++) {
#pragma HLS unroll
		tmp[i] = fixval[i];
	}

	return tmp;
}

// https://stackoverflow.com/questions/2183087/why-cant-i-use-float-value-as-a-template-parameter @ Ashley Smart
template <int NUM, int DEN = 1, int FACTOR_1000 = 1000> struct const_float {
	enum {
		FLOOR = (int)(((float)NUM / (float)DEN) * ((float)FACTOR_1000 / 1000.0f)),
		CEIL = (int)FLOOR + ((float)FLOOR == (((float)NUM / (float)DEN) * ((float)FACTOR_1000 / 1000.0f)) ? 0 : 1)
	};
};

template <bool switch_P, class T1_true = void, class T2_false = void> struct switch_if_t {};

template <class T1_true, class T2_false> struct switch_if_t<true, T1_true, T2_false> { typedef T1_true type; };

template <class T1_true, class T2_false> struct switch_if_t<false, T1_true, T2_false> { typedef T2_false type; };

template <int N_VAL> struct log2_floor {
	enum { val = 1 + log2_floor<(N_VAL / 2 <= 1 ? 1 : N_VAL / 2)>::val };
};

template <> struct log2_floor<-1> {
	enum { val = 0 };
};
template <> struct log2_floor<0> {
	enum { val = 1 };
};
template <> struct log2_floor<1> {
	enum { val = 1 };
};

template <int N_VAL> struct log2_ceil {
	enum { val = log2_floor<N_VAL - 1>::val };
};

template <template <int> class data_T, int W> inline data_T<W> HIGH() {
	data_T<W> tmp;
	for (int i = 0; i < W; i++) {
		tmp[i] = 1;
	}
	return tmp;
}

template <int N> struct max_s {

	template <typename T> inline T max(T *a) {
		T m0 = max_s<N / 2>::max(*a[0]);
		T m1 = max_s<N - N / 2>::max(*a[N / 2]);
		return (m0 > m1 ? m0 : m1);
	}
};

template <> struct max_s<1> {
	template <typename T> inline T max(T *a) { return a[0]; }
};

template <int N, typename T> inline T max(T *a) { return max_s<N>::max(a); }

} // namespace hf

} // namespace hwcore

#ifndef __SYNTHESIS__
// template <class T> using sc_out_opt = sc_port<sc_signal_out_if<T>, 1, SC_ZERO_OR_MORE_BOUND>;

template <class T> struct sc_out_opt : public sc_port<sc_signal_out_if<T>, 2, SC_ONE_OR_MORE_BOUND> {

  private:
	sc_signal<T> mSignal;

  public:
	sc_out_opt() : sc_port<sc_signal_out_if<T>, 2, SC_ONE_OR_MORE_BOUND>() { (*this)(mSignal); }

	virtual ~sc_out_opt() {}

	void write(T data) { (*this)->write(data); }
};

#else
#define sc_out_opt sc_out
// template <class T> using sc_out_opt = sc_out<T>;
#endif

/*
#ifdef __SYNTHESIS__
#include <ap_fixed.h>
template <int W, int I> using sc_fixed_sat = ap_fixed<W, I, AP_RND, AP_SAT>;
#else

#endif*/
// template <int W, int I> using sc_fixed_sat = sc_fixed<W, I, SC_TRN, SC_SAT>;

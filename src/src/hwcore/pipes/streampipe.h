/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#include "hwcore/hf/helperlib.h"
#include <systemc.h>

template <int number> struct INT {
	enum { value = number };
};

template <class ThisObj, class Wanted, int ID_nr, bool match> struct get_module_helper {};

template <class ThisObj, class Wanted, int ID_nr> struct get_module_helper<ThisObj, Wanted, ID_nr, false> {
	typedef typename ThisObj::next_T next_t;

	static inline Wanted &func(ThisObj *thisPtr) {

		return get_module_helper<next_t, Wanted, ID_nr, ID_nr == next_t::ID>::func(&thisPtr->mNext);
	}
};

template <class ThisObj, class Wanted, int ID_nr> struct get_module_helper<ThisObj, Wanted, ID_nr, true> {
	static inline Wanted &func(ThisObj *thisPtr) { return thisPtr->mModule; }
};

template <class Wanted, class GOT> void get_module(GOT &ref) {
	// assert(!"streampipe error");
	// Wanted *ptr = (Wanted *)nullptr;
	// return *ptr;
}

template <class Wanted> Wanted &get_module(Wanted &ref) { return ref; }

template <class module_t, class DEPTH, class IDENT, class... argsList> struct streampipe {
	typedef streampipe<argsList...> next_T;
	enum { ID = IDENT::value, IDnext = next_T::ID };
	typedef typename module_t::din_itf_t din_t;
	typedef typename module_t::dout_itf_t dout_t;

	module_t mModule;
	sc_fifo<dout_t> mFifo;
	struct streampipe<argsList...> mNext;

	streampipe(int name_gen = 0)
	    : HLS_DEBUG_SWITCH_EXEC(mModule((std::string("module_") + std::string(typeid(module_t).name()) +
	                                     std::string("_") + std::to_string(name_gen))
	                                        .c_str()),
	                            mModule("mModule")),
	      mFifo(DEPTH::value), mNext(name_gen + 1) {
		int id = next_T::ID;
	}

	template <class sink_t, class source_t, class clk_t, class reset_t>
	inline void link(sink_t &sink, source_t &source, clk_t &clk, reset_t &reset) {
		mModule.clk(clk);
		mModule.reset(reset);
		mModule.din(sink);
		mModule.dout(mFifo);
		mNext.link(mFifo, source, clk, reset);
	}

	template <int ID_nr> struct get_type {
		typedef typename hwcore::hf::switch_if_t<
		    ID_nr == ID, module_t, typename streampipe<argsList...>::template get_type<ID_nr>::type>::type type;
	};

	template <int ID_nr>
	using get_module_t = typename hwcore::hf::switch_if_t<
	    ID_nr == ID,
	    module_t,                                                               // if ID is true
	    typename streampipe<argsList...>::template get_module_t<ID_nr> >::type; // if ID is false*/

	template <int ID_nr, class ret = typename get_type<ID_nr>::type> inline ret &getByID() {
		return get_module_helper<streampipe, ret, ID_nr, ID_nr == ID>::func(this);
	}
};

template <class module_t, class DEPTH, class IDENT> struct streampipe<module_t, DEPTH, IDENT> {
	enum { ID = IDENT::value };
	typedef typename module_t::din_itf_t din_t;
	typedef typename module_t::dout_itf_t dout_t;

	module_t mModule;

	streampipe(int name_gen = 0)
	    : HLS_DEBUG_SWITCH_EXEC(mModule((std::string("module_") + std::string(typeid(module_t).name()) +
	                                     std::string("_") + std::to_string(name_gen))
	                                        .c_str()),
	                            mModule("mModule")) {}

	template <class sink_t, class source_t, class clk_t, class reset_t>
	inline void link(sink_t &sink, source_t &source, clk_t &clk, reset_t &reset) {
		mModule.clk(clk);
		mModule.reset(reset);
		mModule.din(sink);
		mModule.dout(source);
	}

	template <int ID_nr> struct get_type { typedef module_t type; };

	template <int ID_nr> using get_module_t = module_t;

	/*template<int ID_nr>
	//using get_module_t=hwcore::hf::switch_if_t<ID_nr==ID,
	                                            module_t,//if ID is true
	                                            struct streampipe<argsList...>::get_module_t<ID_nr> >; //if ID is
	false*/

	template <int ID_nr, class ret = module_t> inline ret &getByID() { return get_module<ret, module_t>(mModule); }
};

/*
enum ID_list {
    u1=0,
    u2,
    u3,
    u4
};

void test_pipes()
{
    typedef streampipe<hwcore::pipes::sc_stream_resize<32,16>, INT<1> , INT<ID_list::u1>,
                        hwcore::pipes::sc_stream_resize<32,64>, INT<16>, INT<ID_list::u2> > pipe_type_test;

    pipe_type_test test;



                //hwcore::pipes::sc_stream_resize<16,64>, INT<16>, INT<ID_list::u2> >


                //hwcore::pipes::sc_stream_resize<64,8>, INT<16>, INT<ID_list::u3>,
                //hwcore::pipes::sc_stream_resize<8,64>, INT<ID_list::u4>> pipe_type_test;
    //pipe_type_test pipe_test;
    //pipe_type_test::get_module_t<ID_list::u1> test("");
    //pipe_test.getByID<0>().dump();


//pipe_test.getByID<ID_list::u1>()
    //pipe_type_test::get_module_t<ID_list::u1> test;

    //pipe_test.
    //auto test_obj = pipe_test.getByID<u1>();


}*/
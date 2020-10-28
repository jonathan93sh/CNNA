#pragma once
#include "hwcore/hf/helperlib.h"
#include "hwcore/pipes/data_types.h"
#include <systemc.h>

#define sc_status_add_width 8
#define sc_status_debug_level 9999999

struct sc_status_egress_t : public hwcore::pipes::sc_fifo_base_dummy<struct sc_status_egress_t> {
	sc_uint<sc_status_add_width> c_next_add;
	sc_uint<sc_status_add_width> add;
	int value;
	bool operator==(const sc_status_egress_t &ref) {
		return (c_next_add == ref.c_next_add && add == ref.add && value == ref.value);
	}
};

struct sc_status_ingress_t : public hwcore::pipes::sc_fifo_base_dummy<struct sc_status_ingress_t> {
	int value;
	bool operator==(const sc_status_ingress_t &ref) { return (value == ref.value); }
};

SC_MODULE(sc_status_module) {
	SC_MODULE_CLK_RESET_SIGNAL;
	sc_in<int> status_add;
	sc_out<int> status_val;

	sc_out<sc_status_egress_t> egress_out;
	sc_in<sc_status_ingress_t> egress_in;

	void getStatus_egress_out() {
		HLS_DEBUG(sc_status_debug_level, 1, 0, "STATUS reg update");
		sc_status_egress_t tmp_out;
		tmp_out.add = status_add.read();
		tmp_out.value = -1;
		tmp_out.c_next_add = 1;
		egress_out.write(tmp_out);
	}

	void getStatus_egress_in() {
		HLS_DEBUG(sc_status_debug_level, 1, 0, "STATUS reg update new value");
		sc_status_ingress_t tmp_in = egress_in.read();
		status_val.write(tmp_in.value);
	}

	SC_CTOR(sc_status_module) {
		SC_METHOD(getStatus_egress_out);
		sensitive << status_add << reset;
		SC_METHOD(getStatus_egress_in);
		sensitive << egress_in << reset;
		reset_signal_is(reset, true);
	}
};

SC_MODULE(sc_status_reg) {
	SC_MODULE_CLK_RESET_SIGNAL;
	sc_in<int> status;

	sc_in<sc_status_egress_t> ingress_out;
	sc_out<sc_status_ingress_t> ingress_in;

	sc_out<sc_status_egress_t> egress_out;
	sc_in<sc_status_ingress_t> egress_in;

	void met_out_handle() {
		sc_status_egress_t tmp_in = ingress_out.read();

		if (tmp_in.add == tmp_in.c_next_add) {
			tmp_in.value = status.read();
			HLS_DEBUG(sc_status_debug_level, 1, 0, "reg[%d]got new value: %d", tmp_in.c_next_add.to_int(), tmp_in.value)
		}

		tmp_in.c_next_add++;

		egress_out.write(tmp_in);
	}

	void met_in_handle() {
		sc_status_ingress_t tmp = egress_in.read();
		ingress_in.write(tmp);
	}

	SC_CTOR(sc_status_reg) {

		SC_METHOD(met_out_handle);
		sensitive << status << ingress_out << reset;
		SC_METHOD(met_in_handle);
		sensitive << egress_in << reset;
		reset_signal_is(reset, true);
	}
};

SC_MODULE(sc_status_end) {
	SC_MODULE_CLK_RESET_SIGNAL;

	sc_in<sc_status_egress_t> ingress_out;
	sc_out<sc_status_ingress_t> ingress_in;

	void met_loop_back_handle() {
		sc_status_egress_t tmp_in = ingress_out.read();
		sc_status_ingress_t tmp_out;
		if (tmp_in.add >= tmp_in.c_next_add) {
			tmp_out.value = tmp_in.c_next_add;
		} else {
			tmp_out.value = tmp_in.value;
		}

		HLS_DEBUG(sc_status_debug_level, 1, 0, "REG_status reg[%d/%d] = [%d]", tmp_in.add.to_int(),
		          tmp_in.c_next_add.to_int(), tmp_out.value);

		ingress_in.write(tmp_out);
	}

	SC_CTOR(sc_status_end) {

		SC_METHOD(met_loop_back_handle);
		sensitive << ingress_out << reset;
		reset_signal_is(reset, true);
	}
};

#define sc_status_module_create_interface_only(name)                                                                   \
	sc_in<int> status_add;                                                                                             \
	sc_out<int> status_val;

#define sc_status_module_create(name)                                                                                  \
	sc_status_module name;                                                                                             \
	sc_signal<sc_status_egress_t> name##_egress_out;                                                                   \
	sc_signal<sc_status_ingress_t> name##_egress_in;                                                                   \
	sc_signal<int> name##_status_add;                                                                                  \
	sc_signal<int> name##_status_val;                                                                                  \
	sc_in<int> status_add;                                                                                             \
	sc_out<int> status_val;                                                                                            \
	void name##_methode() {                                                                                            \
		SC_AXI_INTERFACE_CREATE(status_add);                                                                           \
		SC_AXI_INTERFACE_CREATE(status_val);                                                                           \
		name##_status_add.write(status_add.read());                                                                    \
		status_val.write(name##_status_val.read());                                                                    \
	}

#define sc_status_reg_create(name)                                                                                     \
	sc_status_reg name;                                                                                                \
	sc_signal<sc_status_egress_t> name##_egress_out;                                                                   \
	sc_signal<sc_status_ingress_t> name##_egress_in;                                                                   \
	sc_signal<int> name##_status

#define sc_status_reg_create_dummy(name)                                                                               \
	sc_signal<sc_status_egress_t> name##_egress_out;                                                                   \
	sc_signal<sc_status_ingress_t> name##_egress_in;

#define sc_status_interface_create(name)                                                                               \
	sc_out<sc_status_egress_t> name##_egress_out;                                                                      \
	sc_in<sc_status_ingress_t> name##_egress_in;                                                                       \
	sc_in<sc_status_egress_t> name##_ingress_out;                                                                      \
	sc_out<sc_status_ingress_t> name##_ingress_in;

#define sc_status_end_create(name) sc_status_end name;

#define sc_status_reg_connect(name, prev)                                                                              \
	name.ingress_out(prev##_egress_out);                                                                               \
	name.ingress_in(prev##_egress_in);                                                                                 \
	name.egress_out(name##_egress_out);                                                                                \
	name.egress_in(name##_egress_in);                                                                                  \
	name.status(name##_status);                                                                                        \
	name.clk(clk);                                                                                                     \
	name.reset(reset)

#define sc_status_reg_connect_no_egress_signal(name, prev)                                                             \
	name.ingress_out(prev##_egress_out);                                                                               \
	name.ingress_in(prev##_egress_in);                                                                                 \
	name.status(name##_status);                                                                                        \
	name.clk(clk);                                                                                                     \
	name.reset(reset)

#define sc_status_reg_connect_dummy(name, dummy, prev)                                                                 \
	name##_ingress_out(prev##_egress_out);                                                                             \
	name##_ingress_in(prev##_egress_in);                                                                               \
	name##_egress_out(dummy##_egress_out);                                                                             \
	name##_egress_in(dummy##_egress_in);

#define sc_status_reg_connect_interface(name, interface)                                                               \
	name.ingress_out(interface##_ingress_out);                                                                         \
	name.ingress_in(interface##_ingress_in);                                                                           \
	name.egress_out(name##_egress_out);                                                                                \
	name.egress_in(name##_egress_in);                                                                                  \
	name.status(name##_status);                                                                                        \
	name.clk(clk);                                                                                                     \
	name.reset(reset)

#define sc_status_reg_interface_connect_loopback(name, interface)                                                      \
	name.egress_out(interface##_egress_out);                                                                           \
	name.egress_in(interface##_egress_in);

#define sc_status_reg_interface_connect(name, dummy, prev)                                                             \
	name##_ingress_out(prev##_egress_out);                                                                             \
	name##_ingress_in(prev##_egress_in);                                                                               \
	name##_egress_out(dummy##_egress_out);                                                                             \
	name##_egress_in(dummy##_egress_in);

#define sc_status_module_connect(name)                                                                                 \
	name.egress_out(name##_egress_out);                                                                                \
	name.egress_in(name##_egress_in);                                                                                  \
	name.status_add(name##_status_add);                                                                                \
	name.status_val(name##_status_val);                                                                                \
	name.clk(clk);                                                                                                     \
	name.reset(reset);                                                                                                 \
	SC_METHOD(name##_methode);                                                                                         \
	sensitive << name##_status_val << status_add

#define _sc_status_end_connect(name, prev)                                                                             \
	name.ingress_out(prev##_egress_out);                                                                               \
	name.ingress_in(prev##_egress_in);                                                                                 \
	name.clk(clk);                                                                                                     \
	name.reset(reset)

#define sc_status_end_connect(name, prev) _sc_status_end_connect(name, prev)

template <class T> struct sc_fifo_monitor {
	sc_fifo<T> fifo_in;
	sc_fifo<T> fifo_out;
	sc_status_reg_create(fifo_reg_write_n);
	sc_status_reg_create(fifo_reg_blocked);

	sc_fifo_monitor(int n, char *name) : fifo_in(1), fifo_out(n), fifo_reg_write_n(name), fifo_reg_blocked(name) {}

	// operator sc_fifo_in_if<T>() { return fifo_in; }
};

#define sc_status_reg_fifo_mon(fifo, type)                                                                             \
	sc_fifo_monitor<type> fifo;                                                                                        \
	void fifo##_proxy() {                                                                                              \
                                                                                                                       \
		int write_n = 0;                                                                                               \
		while (true) {                                                                                                 \
			fifo.fifo_reg_write_n_status.write(write_n);                                                               \
			fifo.fifo_reg_blocked_status = 0;                                                                          \
			type tmp = fifo.fifo_in.read();                                                                            \
			fifo.fifo_reg_blocked_status = 1;                                                                          \
			fifo.fifo_out.write(tmp);                                                                                  \
			write_n++;                                                                                                 \
		}                                                                                                              \
	}
// fifo.proxy_thread_forward();
#define sc_status_reg_fifo_mon_connect(fifo, pre)                                                                      \
	sc_status_reg_connect(fifo.fifo_reg_write_n, pre);                                                                 \
	sc_status_reg_connect(fifo.fifo_reg_blocked, fifo.fifo_reg_write_n);                                               \
	SC_CTHREAD(fifo##_proxy, clk.pos())

#define sc_status_reg_fifo_mon_egress(fifo) fifo.fifo_reg_blocked

#define sc_status_reg_fifo_count(fifo)                                                                                 \
	sc_status_reg_create(fifo##_reg);                                                                                  \
	void fifo##_monitor() {                                                                                            \
		while (true) {                                                                                                 \
			wait();                                                                                                    \
			fifo##_reg_status.write(fifo.num_available());                                                             \
		}                                                                                                              \
	}

//fifo##_reg_status.write(fifo.num_available());                                                             \


// template <class T> using sc_out_opt = sc_port<sc_signal_inout_if<T>, 1, SC_ZERO_OR_MORE_BOUND>;

#define sc_status_reg_fifo_count_connect(fifo, pre)                                                                    \
	SC_CTHREAD(fifo##_monitor, clk.pos());                                                                             \
	sc_status_reg_connect(fifo##_reg, pre)

SC_MODULE(sc_status_test) {
	SC_MODULE_CLK_RESET_SIGNAL;

	// sc_signal<int> dummy_signal;

	// sc_fifo_in<int> fifo_ingress;
	// sc_status_reg_fifo_mon(test, int);
	// sc_fifo_out<int> fifo_egress;
	// sc_fifo_in<int> fifo_ingress;
	// sc_fifo_out<int> fifo_egress;
	// sc_fifo<int> fifo_s;

	// sc_status_reg_fifo_count(fifo_s);

	sc_status_module_create(sm);
	sc_status_reg_create(r1);
	sc_status_reg_create(r2);
	sc_status_reg_create(r3);
	sc_status_reg_create(r4);
	sc_status_end_create(rend);

	SC_CTOR(sc_status_test)
	    : SC_INST(sm), SC_INST(r1), SC_INST(r2), SC_INST(r3), SC_INST(r4), SC_INST(rend) { // test(16, "test") {
		// fifo_ingress(test.fifo_in);
		// fifo_egress(test.fifo_out);
		// dummy_out(dummy_signal);
		sc_status_module_connect(sm);

		sc_status_reg_connect(r1, sm);
		sc_status_reg_connect(r2, r1);
		sc_status_reg_connect(r3, r2);
		sc_status_reg_connect(r4, r3);
		// sc_status_reg_fifo_mon_connect(test, r5);
		sc_status_end_connect(rend, r4);
		SC_CTHREAD(test_thread, clk.pos());
		reset_signal_is(reset, true);
	}
	// sc_status_reg_fifo_count_connect(fifo, r5);

	void test_thread() {
		r1_status.write(0xBEEF);
		r2_status.write(0xFEEB);
		r3_status.write(3);
		int counter = 0;
		r4_status.write(0);
		while (true) {
			wait();

			counter++;
			r4_status.write(counter);
		}
	}
};

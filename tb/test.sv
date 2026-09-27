`ifndef TEST_SV
`define TEST_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "env.sv"
`include "rst_dut.sv"
`include "valid_wrrd_fixed.sv"
`include "valid_wrrd_incr.sv"
`include "valid_wrrd_wrap.sv"
`include "err_wrrd_fix.sv"

////////////////////////////////////////////////////////////////////////////////
// TEST
////////////////////////////////////////////////////////////////////////////////
class test extends uvm_test;
  `uvm_component_utils(test)

  env e;
  rst_dut          rst_seq;
  valid_wrrd_fixed fixed_seq;
  valid_wrrd_incr  incr_seq;
  valid_wrrd_wrap  wrap_seq;
  err_wrrd_fix     err_seq;

  function new(string inst = "test", uvm_component c);
    super.new(inst, c);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("env", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    rst_seq   = rst_dut::type_id::create("rst_seq");
    fixed_seq = valid_wrrd_fixed::type_id::create("fixed_seq");
    incr_seq  = valid_wrrd_incr::type_id::create("incr_seq");
    wrap_seq  = valid_wrrd_wrap::type_id::create("wrap_seq");
    err_seq   = err_wrrd_fix::type_id::create("err_seq");

   rst_seq.start(e.a.seqr);
    fixed_seq.start(e.a.seqr);
    rst_seq.start(e.a.seqr);
    incr_seq.start(e.a.seqr);
    rst_seq.start(e.a.seqr);
    wrap_seq.start(e.a.seqr);
    rst_seq.start(e.a.seqr);
    err_seq.start(e.a.seqr);

    #20;
    phase.drop_objection(this);
  endtask
endclass

`endif // TEST_SV
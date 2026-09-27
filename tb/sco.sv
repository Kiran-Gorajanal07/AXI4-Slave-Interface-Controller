`ifndef SCO_SV
`define SCO_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "transaction.sv"

////////////////////////////////////////////////////////////////////////////////
// SCOREBOARD
////////////////////////////////////////////////////////////////////////////////
class sco extends uvm_scoreboard;
  `uvm_component_utils(sco)

  uvm_tlm_analysis_fifo#(transaction) sco_data;
  uvm_tlm_analysis_fifo#(transaction) sco_data_ref;

  transaction tr, trref;

  function new(string inst = "sco", uvm_component parent = null);
    super.new(inst, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sco_data     = new("sco_data", this);
    sco_data_ref = new("sco_data_ref", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      sco_data.get(tr);
      sco_data_ref.get(trref);

      if(tr.op == rstdut)
        `uvm_info("SCO", "System Reset", UVM_NONE)
      else if(tr.compare(trref))
        `uvm_info("SCO", $sformatf("Test PASSED  op:%s addr:%0d len:%0d bresp:%0d/%0d rresp:%0d/%0d",
          tr.op.name(), tr.awaddr, tr.awlen, tr.bresp, trref.bresp, tr.rresp, trref.rresp), UVM_NONE)
      else
        `uvm_info("SCO", $sformatf("Test FAILED  op:%s addr:%0d len:%0d bresp:%0d/%0d rresp:%0d/%0d",
          tr.op.name(), tr.awaddr, tr.awlen, tr.bresp, trref.bresp, tr.rresp, trref.rresp), UVM_NONE)
      $display("----------------------------------------------------------------");
    end
  endtask
endclass

`endif // SCO_SV
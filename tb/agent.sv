`ifndef AGENT_SV
`define AGENT_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "driver.sv"
`include "mon.sv"
`include "ref_model.sv"
`include "axi_coverage.sv"

////////////////////////////////////////////////////////////////////////////////
// AGENT
////////////////////////////////////////////////////////////////////////////////
class agent extends uvm_agent;
  `uvm_component_utils(agent)

  driver        d;
  uvm_sequencer#(transaction) seqr;
  mon           m;
  ref_model     ref_m;
  axi_coverage  cov;

  function new(string inst = "agent", uvm_component parent = null);
    super.new(inst, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m     = mon::type_id::create("m", this);
    ref_m = ref_model::type_id::create("ref_m", this);
    d     = driver::type_id::create("d", this);
    seqr  = uvm_sequencer#(transaction)::type_id::create("seqr", this);
    cov   = axi_coverage::type_id::create("cov", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    d.seq_item_port.connect(seqr.seq_item_export);
    m.send.connect(cov.analysis_export);
  endfunction
endclass

`endif // AGENT_SV
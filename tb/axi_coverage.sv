`ifndef AXI_COVERAGE_SV
`define AXI_COVERAGE_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "transaction.sv"

////////////////////////////////////////////////////////////////////////////////
// FUNCTIONAL COVERAGE
////////////////////////////////////////////////////////////////////////////////
class axi_coverage extends uvm_subscriber #(transaction);
  `uvm_component_utils(axi_coverage)

  transaction tr;

  covergroup axi_cg;
    option.per_instance = 1;
    option.name         = "axi_cov";

    op_cp: coverpoint tr.op {
      bins fixed    = {wrrdfixed};
      bins incr     = {wrrdincr};
      bins wrap     = {wrrdwrap};
      bins err_fix  = {wrrderrfix};
      ignore_bins ignore_rst = {rstdut};
    }

    burst_cp: coverpoint tr.awburst {
      bins fixed_b = {2'b00};
      bins incr_b  = {2'b01};
      bins wrap_b  = {2'b10};
      illegal_bins reserved = {2'b11};
    }

    addr_cp: coverpoint tr.awaddr {
      bins valid_zone = {[0:127]};
      bins error_zone = {[128:$]};
    }

    bresp_cp: coverpoint tr.bresp {
      bins okay   = {2'b00};
      bins decerr = {2'b11};
      ignore_bins unused = {2'b01, 2'b10};
    }

    rresp_cp: coverpoint tr.rresp {
      bins okay   = {2'b00};
      bins decerr = {2'b11};
      ignore_bins unused = {2'b01, 2'b10};
    }

    id_cp: coverpoint tr.id {
      bins low_id  = {[0:7]};
      bins high_id = {[8:15]};
    }

    op_x_bresp: cross op_cp, bresp_cp {
      ignore_bins ig1 = binsof(op_cp.fixed)   && binsof(bresp_cp.decerr);
      ignore_bins ig2 = binsof(op_cp.incr)    && binsof(bresp_cp.decerr);
      ignore_bins ig3 = binsof(op_cp.wrap)    && binsof(bresp_cp.decerr);
      ignore_bins ig4 = binsof(op_cp.err_fix) && binsof(bresp_cp.okay);
    }

    op_x_rresp: cross op_cp, rresp_cp {
      ignore_bins ig1 = binsof(op_cp.fixed)   && binsof(rresp_cp.decerr);
      ignore_bins ig2 = binsof(op_cp.incr)    && binsof(rresp_cp.decerr);
      ignore_bins ig3 = binsof(op_cp.wrap)    && binsof(rresp_cp.decerr);
      ignore_bins ig4 = binsof(op_cp.err_fix) && binsof(rresp_cp.okay);
    }

    addr_x_bresp: cross addr_cp, bresp_cp {
      ignore_bins ig1 = binsof(addr_cp.valid_zone) && binsof(bresp_cp.decerr);
      ignore_bins ig2 = binsof(addr_cp.error_zone) && binsof(bresp_cp.okay);
    }

  endgroup

  function new(string name, uvm_component parent);
    super.new(name, parent);
    axi_cg = new();
  endfunction

  function void write(transaction t);
    if (t.op == rstdut) return;
    tr = t;
    axi_cg.sample();
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info("COV", $sformatf("AXI Functional Coverage = %0.2f%%",
      axi_cg.get_inst_coverage()), UVM_LOW)
  endfunction
endclass

`endif // AXI_COVERAGE_SV
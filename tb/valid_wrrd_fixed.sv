`ifndef VALID_WRRD_FIXED_SV
`define VALID_WRRD_FIXED_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "transaction.sv"

////////////////////////////////////////////////////////////////////////////////
// SEQUENCE: VALID FIXED BURST WRITE->READ
////////////////////////////////////////////////////////////////////////////////
class valid_wrrd_fixed extends uvm_sequence#(transaction);
  `uvm_object_utils(valid_wrrd_fixed)
  transaction tr;
  function new(string name = "valid_wrrd_fixed"); super.new(name); endfunction

  virtual task body();
    tr = transaction::type_id::create("tr");
    $display("------------------------------");
    `uvm_info("SEQ", "Sending Fixed mode Transaction to DRV", UVM_NONE);
    start_item(tr);
    if(!tr.randomize()) `uvm_error("SEQ", "randomize failed")
    tr.op      = wrrdfixed;
    tr.awlen   = 7;
    tr.awburst = 0;
    tr.awsize  = 2;
    finish_item(tr);
  endtask
endclass

`endif // VALID_WRRD_FIXED_SV
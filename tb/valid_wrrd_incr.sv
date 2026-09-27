`ifndef VALID_WRRD_INCR_SV
`define VALID_WRRD_INCR_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "transaction.sv"

////////////////////////////////////////////////////////////////////////////////
// SEQUENCE: VALID INCR BURST WRITE->READ
////////////////////////////////////////////////////////////////////////////////
class valid_wrrd_incr extends uvm_sequence#(transaction);
  `uvm_object_utils(valid_wrrd_incr)
  transaction tr;
  function new(string name = "valid_wrrd_incr"); super.new(name); endfunction

  virtual task body();
    tr = transaction::type_id::create("tr");
    $display("------------------------------");
    `uvm_info("SEQ", "Sending INCR mode Transaction to DRV", UVM_NONE);
    start_item(tr);
    if(!tr.randomize()) `uvm_error("SEQ", "randomize failed")
    tr.op      = wrrdincr;
    tr.awlen   = 7;
    tr.awburst = 1;
    tr.awsize  = 2;
    finish_item(tr);
  endtask
endclass

`endif // VALID_WRRD_INCR_SV
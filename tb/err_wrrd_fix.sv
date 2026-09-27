`ifndef ERR_WRRD_FIX_SV
`define ERR_WRRD_FIX_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "transaction.sv"

////////////////////////////////////////////////////////////////////////////////
// SEQUENCE: ERROR (ADDRESS-DECODE) TRANSACTION
////////////////////////////////////////////////////////////////////////////////
class err_wrrd_fix extends uvm_sequence#(transaction);
  `uvm_object_utils(err_wrrd_fix)
  transaction tr;
  function new(string name = "err_wrrd_fix"); super.new(name); endfunction

  virtual task body();
    tr = transaction::type_id::create("tr");
    $display("------------------------------");
    `uvm_info("SEQ", "Sending Error Transaction to DRV", UVM_NONE);
    start_item(tr);
    if(!tr.randomize()) `uvm_error("SEQ", "randomize failed")
    tr.op      = wrrderrfix;
    tr.awlen   = 7;
    tr.awburst = 0;
    tr.awsize  = 2;
    finish_item(tr);
  endtask
endclass

`endif // ERR_WRRD_FIX_SV
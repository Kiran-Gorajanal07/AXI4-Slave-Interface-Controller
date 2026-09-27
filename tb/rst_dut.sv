`ifndef RST_DUT_SV
`define RST_DUT_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "transaction.sv"

////////////////////////////////////////////////////////////////////////////////
// SEQUENCE: RESET
////////////////////////////////////////////////////////////////////////////////
class rst_dut extends uvm_sequence#(transaction);
  `uvm_object_utils(rst_dut)
  transaction tr;
  function new(string name = "rst_dut"); super.new(name); endfunction

  virtual task body();
    repeat(5) begin
      tr = transaction::type_id::create("tr");
      $display("------------------------------");
      `uvm_info("SEQ", "Sending RST Transaction to DRV", UVM_NONE);
      start_item(tr);
      if(!tr.randomize()) `uvm_error("SEQ", "randomize failed")
      tr.op = rstdut;
      finish_item(tr);
    end
  endtask
endclass

`endif // RST_DUT_SV
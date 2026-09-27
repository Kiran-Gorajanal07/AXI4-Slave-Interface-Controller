`ifndef MON_SV
`define MON_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "transaction.sv"

////////////////////////////////////////////////////////////////////////////////
// MONITOR
////////////////////////////////////////////////////////////////////////////////
class mon extends uvm_monitor;
  `uvm_component_utils(mon)

  uvm_analysis_port#(transaction) send;
  transaction tr;
  virtual axi_if vif;

  function new(string inst = "mon", uvm_component parent = null);
    super.new(inst, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr   = transaction::type_id::create("tr");
    send = new("send", this);
    if(!uvm_config_db#(virtual axi_if)::get(this,"","vif",vif))
      `uvm_error("MON","Unable to access Interface");
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.clk);

      if(!vif.resetn) begin
        tr.op          = rstdut;
        tr.awaddr      = 32'h0;
        tr.awlen       = 4'h0;
        tr.awburst     = 2'h0;
        tr.rdata_beats = new[0];
        tr.bresp       = 2'b00;
        tr.rresp       = 2'b00;
        `uvm_info("MON", "System Reset Detected", UVM_MEDIUM);
        send.write(tr);
      end
      else begin
        wait(vif.awvalid == 1'b1);
        tr.awaddr  = vif.awaddr;
        tr.awlen   = vif.awlen;
        tr.awburst = vif.awburst;

        if(vif.awaddr < 128) begin
          case(vif.awburst)
            2'b00:   tr.op = wrrdfixed;
            2'b01:   tr.op = wrrdincr;
            2'b10:   tr.op = wrrdwrap;
            default: tr.op = wrrdfixed;
          endcase

          for(int i = 0; i < (vif.awlen + 1); i++) begin
            @(posedge vif.wready);
          end

          @(posedge vif.bvalid);
          tr.bresp = vif.bresp;

          wait(vif.arvalid == 1'b1);

          tr.rdata_beats = new[vif.arlen + 1];
          for(int i = 0; i < (vif.arlen + 1); i++) begin
            @(posedge vif.rvalid);
            tr.rdata_beats[i] = vif.rdata;
          end

          @(posedge vif.rlast);
          tr.rresp = vif.rresp;

          `uvm_info("MON", $sformatf("BURST op:%s addr:%0d len:%0d bresp:%0d rresp:%0d",
            tr.op.name(), tr.awaddr, tr.awlen, tr.bresp, tr.rresp), UVM_NONE);
          send.write(tr);
          $display("------------------------------");
        end
        else begin
          tr.op = wrrderrfix;

          for(int i = 0; i < (vif.awlen + 1); i++) begin
            @(negedge vif.wready);
          end

          @(posedge vif.bvalid);
          tr.bresp = vif.bresp;

          wait(vif.arvalid == 1'b1);

          tr.rdata_beats = new[vif.arlen + 1];
          for(int i = 0; i < (vif.arlen + 1); i++) begin
            @(posedge vif.arready);
            tr.rdata_beats[i] = 32'h0;
          end

          @(posedge vif.rlast);
          tr.rresp = vif.rresp;

          `uvm_info("MON", $sformatf("ERROR BURST addr:%0d bresp:%0d rresp:%0d",
            tr.awaddr, tr.bresp, tr.rresp), UVM_NONE);
          send.write(tr);
          $display("------------------------------");
        end
      end
    end
  endtask
endclass

`endif // MON_SV
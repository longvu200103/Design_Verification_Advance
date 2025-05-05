//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************

//`include "spi_tlm_pkg.svh"
//`include "spi_cfg_pkg.svh"

//import spi_tlm_pkg::*;
//import spi_cfg_pkg::*;

//============================================================================================================================
// Scoreboard responsible for data checking
//============================================================================================================================
class sb extends uvm_scoreboard;

  `uvm_component_utils(sb)

  // Outbound: use spi_tlm transaction
  uvm_tlm_analysis_fifo#(spi_tlm) ref_ap_fifo;
  uvm_tlm_analysis_fifo#(spi_tlm) act_ap_fifo;

  // Inbound: use spi_tlm transaction
  uvm_tlm_analysis_fifo#(spi_tlm) ref_inb_ap_fifo;
  uvm_tlm_analysis_fifo#(spi_tlm) act_inb_ap_fifo;

  string    my_name;
  spi_cfg   spi_cfg_h;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    my_name = name;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ref_ap_fifo     = new("ref_ap_fifo", this);
    act_ap_fifo     = new("act_ap_fifo", this);
    ref_inb_ap_fifo = new("ref_inb_ap_fifo", this);
    act_inb_ap_fifo = new("act_inb_ap_fifo", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(spi_cfg)::get(this, "", "SPI_CFG", spi_cfg_h)) begin
      `uvm_error(my_name, "Could not retrieve virtual spi_cfg_h")
    end
  endfunction

  // Task to verify outbound data
  task monitor_outbound;
    spi_tlm ref_pkt;
    spi_tlm act_pkt;
    reg [31:0] ref_mosi;
    reg [31:0] act_mosi;
    begin
      forever begin
        act_ap_fifo.get(act_pkt);
        `uvm_info(my_name, $psprintf("Received act_pkt mosi = 0x%0h", act_pkt.mosi), UVM_NONE)
        if (ref_ap_fifo.is_empty()) begin
          `uvm_fatal(my_name, "ref_ap_fifo is empty");
        end else begin
          ref_ap_fifo.get(ref_pkt);
          ref_mosi = ref_pkt.mosi[31:0] & spi_cfg_h.mask[31:0];
          act_mosi = act_pkt.mosi[31:0] & spi_cfg_h.mask[31:0];
          if (ref_mosi == act_mosi) begin
            `uvm_info(my_name, $psprintf("Matched mosi = 0x%0h", ref_mosi), UVM_NONE)
          end else begin
            `uvm_error(my_name, $psprintf("Mismatched ref mosi = 0x%0h, act mosi = 0x%0h", ref_mosi, act_mosi));
          end
        end
      end
    end
  endtask

  // Task to verify inbound data
  task monitor_inbound;
    spi_tlm ref_pkt;
    spi_tlm act_pkt;
    reg [31:0] ref_miso;
    reg [31:0] act_miso;
    begin
      forever begin
        act_inb_ap_fifo.get(act_pkt);
        `uvm_info(my_name, $psprintf("Received act_pkt miso = 0x%0h", act_pkt.miso), UVM_NONE)
        if (ref_inb_ap_fifo.is_empty()) begin
          `uvm_fatal(my_name, "ref_inb_ap_fifo is empty");
        end else begin
          ref_inb_ap_fifo.get(ref_pkt);
          ref_miso = ref_pkt.miso[31:0] & spi_cfg_h.mask[31:0];
          act_miso = act_pkt.miso[31:0] & spi_cfg_h.mask[31:0];
          if (ref_miso == act_miso) begin
            `uvm_info(my_name, $psprintf("Matched miso = 0x%0h", ref_miso), UVM_NONE)
          end else begin
            `uvm_error(my_name, $psprintf("Mismatched ref miso = 0x%0h, act miso = 0x%0h", ref_miso, act_miso));
          end
        end
      end
    end
  endtask

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork
      monitor_outbound;
      monitor_inbound;
    join
  endtask

endclass

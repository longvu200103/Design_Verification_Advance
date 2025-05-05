//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class spi_driver #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends spi_driver_base #(REQ,RSP);

  `uvm_component_param_utils(spi_driver #(REQ,RSP))

  string   my_name;
  
  virtual interface spi_if vif;
  virtual interface clk_rst_if clk_rst_vif;
 
  function new(string name, uvm_component parent);
     super.new(name,parent);
     my_name = name;
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //
    // Getting the interface handle via get_config_object call
    //
    if( !uvm_config_db #(virtual spi_if)::get(this,"","SPI_VIF",vif) ) begin
       `uvm_error(my_name, "Could not retrieve virtual spi_if");
    end
  endfunction
 
  virtual task run_phase(uvm_phase phase);
    uvm_report_info(my_name,"Running ...",UVM_MEDIUM);
    if( !uvm_config_db #(virtual clk_rst_if)::get(this,"","CLK_RST_VIF",clk_rst_vif) ) begin
      `uvm_error(my_name, "Could not retrieve virtual clk_rst_if");
    end     
    if( !uvm_config_db #(spi_cfg)::get(this,"","SPI_CFG",spi_cfg_h) ) begin
      `uvm_error(my_name, "Could not retrieve virtual spi_cfg_h");
    end     
    get_and_drive();
  endtask

	// Transmit SPI data to the DUT miso line
  task get_and_drive;
    REQ req_pkt;
    // todo:
    // change transaction type to sb_tlm
    REQ ref_pkt;
    RSP rsp_pkt;
		integer ref_pkt_cnt;
    
		ref_pkt_cnt = 0;
    //forever @(posedge vif.clk) begin
    forever begin
      //
      // seq_item_port object is part of the uvm_driver class
      // get_next_item method is part of the interface api between uvm_driver and uvm_sequencer
      //
      seq_item_port.get_next_item(req_pkt); // blocking call
			for (int ii=0; ii<spi_cfg_h.num_chars; ii++) begin
				if (spi_cfg_h.bit_rxneg == 1) begin
					@(posedge vif.sclk_pad_o);
					if (spi_cfg_h.bit_lsb == 1) begin
						vif.miso_bit = req_pkt.miso[ii];
					end else begin
						vif.miso_bit = req_pkt.miso[spi_cfg_h.num_chars-1-ii];
					end
				end else begin
					if (spi_cfg_h.bit_lsb == 1) begin
						vif.miso_bit = req_pkt.miso[ii];
					end else begin
						vif.miso_bit = req_pkt.miso[spi_cfg_h.num_chars-1-ii];
					end
					@(negedge vif.sclk_pad_o);
				end
				//vif.miso_bit = req_pkt.miso[ii];
			end
      
      // todo:
      // Make sure you mask out the unused upper bits
      // Inbound: insert a for loop to send num_dwords out to SB
      ref_pkt = REQ::type_id::create($psprintf("ref_pkt_id_%d",ref_pkt_cnt));
			ref_pkt.miso = req_pkt.miso;
      ref_spi_ap.write(ref_pkt); // Send the reference inbound packet to SB
			ref_pkt_cnt++;
      //
      //
      rsp_pkt_cnt++;
      rsp_pkt = RSP::type_id::create($psprintf("rsp_pkt_id_%d",rsp_pkt_cnt));
      rsp_pkt.set_id_info(req_pkt);
      rsp_pkt.copy(req_pkt);
      seq_item_port.item_done(rsp_pkt);
    end
  endtask

endclass
  


//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
// Predictor responsible for generating a reference packet
//============================================================================================================================
`uvm_analysis_imp_decl(_apb_ap_imp)
`uvm_analysis_imp_decl(_spi_ap_imp)

class predictor extends uvm_component;
	`uvm_component_utils(predictor)

	typedef spi_tlm REQ;
  string  my_name;
	uvm_analysis_imp_apb_ap_imp #(REQ,predictor) apb_ap_imp; // APB writes to Tx regs
  // todo:
  // Outbound: update the packet type to sb_tlm
	uvm_analysis_port #(REQ) ref_apb_ap;
	uvm_analysis_imp_spi_ap_imp #(REQ,predictor) spi_ap_imp; // APB reads of Rx regs
  // todo:
  // Inbound: update the packet type to sb_tlm
	uvm_analysis_port #(REQ) act_spi_ap;
	integer ref_pkt_cnt;
	integer act_pkt_cnt;
	spi_cfg spi_cfg_h;
	bit [127:0] mosi;
	bit [127:0] miso;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
    my_name = name;
		ref_apb_ap = new("ref_apb_ap",this);
		act_spi_ap = new("act_spi_ap",this);
		reset();
  endfunction

	function void reset;
		`uvm_info(my_name,"Predictor resetting",UVM_NONE)
		ref_pkt_cnt = 0;
		act_pkt_cnt = 0;
		miso = 0;
	endfunction

	function void build_phase(uvm_phase phase);
		apb_ap_imp = new("apb_ap_imp",this);
		spi_ap_imp = new("spi_ap_imp",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		if( !uvm_config_db #(spi_cfg)::get(this,"","SPI_CFG",spi_cfg_h) ) begin
			`uvm_error(my_name, "Could not retrieve virtual spi_cfg_h")
		end
	endfunction

	// ==================================================================================================
	// After performing an APB write to a Tx register, the driver sends the packet here
	// The assumption is the sequence must perform writes to all four Tx registers before starting a
	// new transmission.
	// ==================================================================================================
	function void write_apb_ap_imp(REQ req_pkt);
  // todo:
  // Outbound: update the packet type to sb_tlm
		REQ ref_pkt;

		`uvm_info(my_name,$psprintf("Write to address %0d wdata=%0x",req_pkt.addr,req_pkt.wdata),UVM_NONE)
		case (req_pkt.addr)
			00: mosi[31:0]   = req_pkt.wdata;
			04: mosi[63:32]  = req_pkt.wdata;
			08: mosi[95:64]  = req_pkt.wdata;
		  12: mosi[127:96] = req_pkt.wdata;
		endcase
		ref_pkt_cnt++;
		if (ref_pkt_cnt == 4) begin
			ref_pkt = REQ::type_id::create($psprintf("ref_pkt_%0d",ref_pkt_cnt));
			`uvm_info(my_name,$psprintf("Assigning mosi = %0x",mosi),UVM_NONE)
			ref_pkt.mosi = mosi;
      // todo:
      // Make sure you mask the data before the for loop
      // Outbound: insert a for loop to write spi_cfg_h.num_dwords out
			ref_apb_ap.write(ref_pkt); // Send the outbound reference packet to the SB
			ref_pkt_cnt = 0;
		end
	endfunction

	// ==================================================================================================
	// Read num_dwords of Rx regs to generate an actual packet to send to the SB
	// ==================================================================================================
	function void write_spi_ap_imp(REQ req_pkt);
    // todo:
    // Inbound: change transaction type to sb_tlm
		REQ act_pkt;

		`uvm_info(my_name,$psprintf("Read at address %0d rdata=%0x",req_pkt.addr,req_pkt.rdata),UVM_NONE)
		case (req_pkt.addr)
			00: miso[31:0]   = req_pkt.rdata;
			04: miso[63:32]  = req_pkt.rdata;
			08: miso[95:64]  = req_pkt.rdata;
		  12: miso[127:96] = req_pkt.rdata;
		endcase
		act_pkt_cnt++;
		if (act_pkt_cnt == spi_cfg_h.num_dwords) begin
      // todo:
      // Make sure you mask the data before the for loop
      // Inbound: insert a for loop to send inbound actual data of type sb_tlm 
			act_pkt = REQ::type_id::create($psprintf("act_pkt_%0d",act_pkt_cnt));
			`uvm_info(my_name,$psprintf("Assigning miso = %0x",miso),UVM_NONE)
			act_pkt.miso = miso;
			act_spi_ap.write(act_pkt); // Send the inbound actual packet to the SB
			act_pkt_cnt = 0;
		end
	endfunction

	virtual task run_phase(uvm_phase phase);
	endtask

endclass


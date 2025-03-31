//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class apb_demo_seq #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_sequence #(REQ,RSP);

  `uvm_object_param_utils(apb_demo_seq #(REQ,RSP))
  
  string my_name;
   
	spi_cfg spi_cfg_h;
  integer drain_time = 10;
  
  function new(string name="");
    super.new(name);
		my_name = name;
  endfunction

	// Write to all four Tx regs
	task write_tx_regs;
    REQ req_pkt;
    RSP rsp_pkt; 
	endtask

	// Write to control reg to start transmission
	task write_ctl_reg;
    REQ req_pkt;
    RSP rsp_pkt; 
	endtask

	// Read the Rx regs
	task read_rx_regs;
    REQ req_pkt;
    RSP rsp_pkt; 
	endtask

	task reset;
    REQ   rst_pkt;
    RSP   rsp_pkt; 
	endtask
   
	// Start the transmission max_loop times. Each time num_chars of bits are transmitted
  task body;

		assert(uvm_resource_db #(spi_cfg)::read_by_name(get_full_name(),"SPI_CFG",spi_cfg_h));
		reset();
		write_tx_regs();
		write_ctl_reg();

  endtask
   
endclass

//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class apb_driver #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends apb_driver_base #(REQ,RSP);

  `uvm_component_param_utils(apb_driver #(REQ,RSP))

  string   my_name;
  
  virtual interface apb_if vif;
  virtual interface clk_rst_if clk_rst_vif;
 
  function new(string name, uvm_component parent);
     super.new(name,parent);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    uvm_object           tmp_obj_hdl;
 
    super.connect_phase(phase);
    my_name = get_name();
    //
    // Getting the interface handle via get_config_object call
    //
    if( !uvm_config_db #(virtual apb_if)::get(this,"","apb_vif",vif) ) begin
       `uvm_error(my_name, "Could not retrieve virtual apb_if");
    end
  endfunction
 
  virtual task run_phase(uvm_phase phase);
    uvm_report_info(my_name,"Running ...",UVM_MEDIUM);
    if( !uvm_config_db #(virtual clk_rst_if)::get(this,"","CLK_RST_VIF",clk_rst_vif) ) begin
      `uvm_error(my_name, "Could not retrieve virtual clk_rst_if");
    end     
    get_and_drive();
  endtask
  
  task get_and_drive;
    string   msg;
    REQ req_pkt;
    RSP rsp_pkt;
    
    uvm_report_info(my_name,"Starting get_and_drive");
    forever @(posedge vif.clk) begin
      //
      // seq_item_port object is part of the uvm_driver class
      // get_next_item method is part of the interface api between uvm_driver and uvm_sequencer
      //
      seq_item_port.get_next_item(req_pkt); // blocking call
      if (req_pkt == null) begin
        uvm_report_info(my_name,"No packet available");
        continue;
      end
      uvm_report_info(my_name,"Packet available");
      if (req_pkt.to_reset == 1)
      	clk_rst_vif.do_reset(5);
      else
	      send_data(req_pkt);
      
      //
      // Send coverage data
      //
      if (req_pkt.to_reset != 1) begin
      	cov_port.write(req_pkt);
			end
      //
      //
      rsp_pkt_cnt++;
      rsp_pkt = RSP::type_id::create($psprintf("rsp_pkt_id_%d",rsp_pkt_cnt));
      rsp_pkt.set_id_info(req_pkt);
      rsp_pkt.copy(req_pkt);
      seq_item_port.item_done(rsp_pkt);
    end
  endtask
  
  virtual task apb_write(input REQ pkt);
      @(posedge vif.PCLK) begin
          apb_vif.PADDR <= pkt.PADDR;
          apb_vif.PSEL <= pkt.PADDR;
          apb_vif.PWDATA <= pkt.PWDATA;
          apb_vif.PENABLE <= pkt.PENABLE;
      end
  endtask
  
  virtual task apb_read(input REQ pkt);
      @(posedge vif.PCLK) begin
          apb_vif.PADDR <= pkt.PADDR;
          apb_vif.PSEL <= pkt.PADDR;
          apb_vif.PENABLE <= pkt.PENABLE;
          pkt.PRDATA <= apb_vif.PRDATA;
      end
  endtask

  virtual task apb_drive(input REQ req_pkt, output RSP rsp_pkt);
    @(posedge vif.PCLK);
    vif.PSEL    <= 1;                    
    vif.PADDR   <= req_pkt.PADDR;         
    vif.PWRITE  <= req_pkt.PWRITE;        
    vif.PWDATA  <= req_pkt.PWDATA;       
    @(posedge vif.PCLK);
    vif.PENABLE <= 1;
    wait(vif.PREADY == 1);
    if (req_pkt.PWRITE == 0) begin
        rsp_pkt.PRDATA = vif.PRDATA;      
    end
  endtask

  
  // This task performs a single write
  virtual task send_data(input REQ w_obj);
  	@(posedge vif.clk) begin
  		if (vif.rst == 0 && vif.q_full == 0) begin   	
  			vif.req <= 1;
     		vif.in_data <= w_obj.data;
     		vif.chan <= w_obj.chan;
   		end
   	end
  	@(posedge vif.clk) begin
  		vif.req <= 0;
  	end
  endtask
  
endclass
  

//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//
//***************************************************************************************************************
class apb_master_agent #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_agent;
   `uvm_component_param_utils(apb_master_agent #(REQ,RSP))
   typedef apb_driver #(REQ,RSP) apb_driver_t;
   typedef apb_monitor #(REQ) apb_monitor_t;
   typedef uvm_sequencer #(REQ,RSP) apb_sequencer_t;
   
   string   my_name;
   
   apb_sequencer_t  sequencer;
   apb_driver_t      driver ;
   apb_monitor_t    monitor;
  
   uvm_analysis_port #(REQ) ref_port;  // This port is used to send reference data to the scoreboard
   uvm_analysis_port #(REQ) act_port;  // This port is used to send actual data to the scoreboard
  
   uvm_analysis_port #(REQ) cov_port;  // This port is used to send coverage data
  
   function new(string name, uvm_component parent);
      super.new(name,parent);
      my_name = get_name();
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      sequencer = apb_sequencer_t::type_id::create("apb_sequencer",this);
      driver = apb_driver_t::type_id::create("apb_driver",this);
      monitor = apb_monitor_t::type_id::create("apb_monitor",this);
      ref_port = new($psprintf("%s_ref_port",my_name),this);
      act_port = new($psprintf("%s_act_port",my_name),this);
      cov_port = new($psprintf("%s_cov_port",my_name),this);
   endfunction
   
   function void connect;
      monitor.ref_port.connect(ref_port);
      driver.cov_port.connect(cov_port);
      //
      // Connect the sequencer to the driver
      //
      driver.seq_item_port.connect(sequencer.seq_item_export);
   endfunction
   
   task run;
    
   endtask
   
endclass


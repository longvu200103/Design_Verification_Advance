//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// A demo test case.
//***************************************************************************************************************
class spi_demo_test extends uvm_test;

	`uvm_component_utils(spi_demo_test)
	
	string	my_name;
	
	typedef spi_env #(spi_tlm,spi_tlm) env_t;
	env_t   env_h;
  typedef apb_demo_seq #(spi_tlm,spi_tlm) apb_demo_seq_t;
  apb_demo_seq_t apb_demo_seq;
  spi_cfg spi_cfg_h;

	function new(string name, uvm_component parent);
		super.new(name,parent);
		my_name = name;
	endfunction
	
	function void build_phase(uvm_phase phase);
    integer	cmd_num_write;
      
		super.build_phase(phase);
		env_h = env_t::type_id::create("spi_env",this);
		spi_cfg_h = spi_cfg::type_id::create("spi_cfg");
		uvm_config_db#(spi_cfg)::set(null,"*","SPI_CFG",spi_cfg_h);
		
	endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction
  
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
  endfunction
	
	task run_phase(uvm_phase phase);
		apb_demo_seq = apb_demo_seq_t::type_id::create("apb_demo_seq_name");
    phase.raise_objection(this,"Objection raised by spi_demo_test");
    
		assert(spi_cfg_h.randomize());
   	apb_demo_seq.start(env_h.apb_agent_0.sequencer,null);

    phase.drop_objection(this,"Objection dropped by spi_demo_test");
	endtask
	
endclass

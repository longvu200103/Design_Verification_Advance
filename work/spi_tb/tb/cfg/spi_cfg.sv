//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class spi_cfg extends uvm_object;

  `uvm_object_utils(spi_cfg)
  
  string  my_name;
	rand bit bit_ass; // control reg bits
	rand bit bit_ie; // control reg bits
	rand bit bit_lsb; // control reg bits
	rand bit bit_txneg; // control reg bits
	rand bit bit_rxneg; // control reg bits
	rand bit bit_gobsy; // control reg bits
	rand bit [6:0] num_char;
    
  function new(string name = "");
    super.new(name);
    my_name = name;
  endfunction

  constraint default_config_c {
				bit_ass   == 1;
				bit_ie    == 1;
				bit_lsb   == 1;
				bit_txneg == 0;
				bit_rxneg == 1;
				bit_gobsy == 1;
				num_char == 0;
  }
  
endclass

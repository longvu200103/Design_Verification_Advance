//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class spi_tlm extends uvm_sequence_item;
   `uvm_object_utils(spi_tlm);
    
    string   my_name;
   
    bit [31:0] PADDR;
    bit PWRITE;
    bit [31:0] PWDATA;
    bit [31:0] PRDATA;
    bit [127:0] mosi_pad_o;
    bit [127:0] miso_pad_o;
    bit to_reset;

    function new(string name = "spi_tlm");
      super.new(name);
      my_name = name;
    endfunction

endclass

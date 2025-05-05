`ifndef SPI_CFG_SVH
`define SPI_CFG_SVH

import uvm_pkg::*;
`include "uvm_macros.svh"

class spi_cfg;
  // … (các khai báo khác, ví dụ mask)
  bit [127:0] mask = '1;

  // semaphore để đồng bộ giữa outbound và inbound
  semaphore sem;

  function new(string name = "spi_cfg");
    // khởi tạo bộ đếm = 0
    sem = new(0);
  endfunction

  // helper (tuỳ chọn)
  function void put_sem(int count = 1);
    sem.put(count);
  endfunction

  function void get_sem(int count = 1);
    sem.get(count);
  endfunction

endclass

`endif // SPI_CFG_SVH

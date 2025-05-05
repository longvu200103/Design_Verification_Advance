//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class spi_demo_seq #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends base_seq #(REQ,RSP);

  `uvm_object_param_utils(spi_demo_seq #(REQ,RSP))
  
  string my_name;
   
  function new(string name="");
    super.new(name);
		my_name = name;
  endfunction

task body;
  REQ req_pkt;
  RSP rsp_pkt;

  super.body();

  for (int ii = 0; ii < spi_cfg_h.max_loop; ii++) begin
    // todo:
    // perform semaphore get of 1 here
    spi_cfg_h.sem.get(1); // BLOCK until semaphore is available

    req_pkt = REQ::type_id::create($psprintf("req_pkt_id_%0d", ii));
    req_pkt.miso = 128'haaaaaaaa_bbbbbbbb_cccccccc_dddddddd;
    wait_for_grant();
    send_request(req_pkt);
    uvm_report_info(my_name, $psprintf("Sending packet"));

    get_response(rsp_pkt);
    uvm_report_info(my_name, $psprintf("Received response packet %x", rsp_pkt.addr));
  end
endtask

   
endclass

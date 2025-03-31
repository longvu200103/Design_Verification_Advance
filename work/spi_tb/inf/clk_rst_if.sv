//***************************************************************************************************************
//***************************************************************************************************************
`timescale 1ns/1ps

interface clk_rst_if (output logic clk, output logic rst);
// pragma attribute clk_rst_if partition_interface_xif

	task do_reset (integer reset_length); // pragma tbx xtf
		rst = 0;
		repeat (reset_length) @(posedge clk);
		rst = 1;
	endtask
	
	initial begin
		#1;
		clk = 1;
		rst = 0;
		forever begin
			#20ns clk = ~clk;
		end
	end

endinterface

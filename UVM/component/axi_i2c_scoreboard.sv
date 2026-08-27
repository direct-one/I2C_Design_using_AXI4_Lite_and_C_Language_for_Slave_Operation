`ifndef AXI_I2C_SCOREBOARD_SV
`define AXI_I2C_SCOREBOARD_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class axi_i2c_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(axi_i2c_scoreboard)
    
    uvm_analysis_imp #(axi_i2c_seq_item, axi_i2c_scoreboard) item_collected_export;

    function new(string name = "axi_i2c_scoreboard", uvm_component parent = null);
        super.new(name, parent);
        item_collected_export = new("item_collected_export", this);
    endfunction

    virtual function void write(axi_i2c_seq_item item);
        `uvm_info("SCB", $sformatf("Received item: ADDR=%0h, DATA=%0h, WRITE=%0b", item.addr, item.data, item.is_write), UVM_LOW)
        // Check standard AXI transactions here
        // (Detailed I2C checking would go here, evaluating if AXI writes led to correct I2C states)
    endfunction
endclass

`endif

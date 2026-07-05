`ifndef AXI_I2C_AGENT_SV
`define AXI_I2C_AGENT_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class axi_i2c_agent extends uvm_agent;
    `uvm_component_utils(axi_i2c_agent)
    
    axi_i2c_sequencer sqr;
    axi_i2c_driver    drv;
    axi_i2c_monitor   mon;

    function new(string name = "axi_i2c_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sqr = axi_i2c_sequencer::type_id::create("sqr", this);
        drv = axi_i2c_driver::type_id::create("drv", this);
        mon = axi_i2c_monitor::type_id::create("mon", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
endclass

`endif

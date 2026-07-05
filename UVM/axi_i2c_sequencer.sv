`ifndef AXI_I2C_SEQUENCER_SV
`define AXI_I2C_SEQUENCER_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class axi_i2c_sequencer extends uvm_sequencer #(axi_i2c_seq_item);
    
    `uvm_component_utils(axi_i2c_sequencer)

    function new(string name = "axi_i2c_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

endclass

`endif

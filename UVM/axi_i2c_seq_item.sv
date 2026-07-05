`ifndef AXI_I2C_SEQ_ITEM_SV
`define AXI_I2C_SEQ_ITEM_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class axi_i2c_seq_item extends uvm_sequence_item;
    
    rand logic [3:0]  addr;
    rand logic [31:0] data;
    rand logic        is_write;
    
    // Response
    logic [1:0]       resp;
    logic [31:0]      read_data;

    `uvm_object_utils_begin(axi_i2c_seq_item)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(is_write, UVM_ALL_ON)
        `uvm_field_int(resp, UVM_ALL_ON)
        `uvm_field_int(read_data, UVM_ALL_ON)
    `uvm_object_utils_end

    // Constraints for 4-byte aligned AXI-Lite addresses
    constraint valid_addr {
        addr inside {4'h0, 4'h4, 4'h8, 4'hC};
    }

    function new(string name = "axi_i2c_seq_item");
        super.new(name);
    endfunction

endclass

`endif

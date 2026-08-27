`ifndef AXI_I2C_SEQ_SV
`define AXI_I2C_SEQ_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class axi_i2c_base_seq extends uvm_sequence #(axi_i2c_seq_item);
    `uvm_object_utils(axi_i2c_base_seq)

    function new(string name = "axi_i2c_base_seq");
        super.new(name);
    endfunction
    
    virtual task write_reg(logic [3:0] addr, logic [31:0] data);
        req = axi_i2c_seq_item::type_id::create("req");
        start_item(req);
        req.addr = addr;
        req.data = data;
        req.is_write = 1;
        finish_item(req);
    endtask

    virtual task read_reg(logic [3:0] addr, output logic [31:0] data);
        req = axi_i2c_seq_item::type_id::create("req");
        start_item(req);
        req.addr = addr;
        req.is_write = 0;
        finish_item(req);
        data = req.read_data;
    endtask
endclass

class axi_i2c_random_test_seq extends axi_i2c_base_seq;
    `uvm_object_utils(axi_i2c_random_test_seq)

    function new(string name = "axi_i2c_random_test_seq");
        super.new(name);
    endfunction

    task body();
        logic [31:0] rdata;
        
        repeat (10) begin
            // Generate random writes and reads
            req = axi_i2c_seq_item::type_id::create("req");
            start_item(req);
            assert(req.randomize());
            finish_item(req);
        end
    endtask
endclass

`endif

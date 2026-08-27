`ifndef AXI_I2C_SEQ_SV
`define AXI_I2C_SEQ_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class axi_i2c_base_seq extends uvm_sequence #(axi_i2c_seq_item);
    `uvm_object_utils(axi_i2c_base_seq)
    function new(string name = "axi_i2c_base_seq"); super.new(name); endfunction

    virtual task write_reg(logic [3:0] addr, logic [31:0] data);
        req = axi_i2c_seq_item::type_id::create("write_req");
        start_item(req);
        req.addr = addr; req.data = data; req.is_write = 1;
        finish_item(req);
    endtask

    virtual task read_reg(logic [3:0] addr, output logic [31:0] data);
        req = axi_i2c_seq_item::type_id::create("read_req");
        start_item(req);
        req.addr = addr; req.data = '0; req.is_write = 0;
        finish_item(req);
        data = req.read_data;
    endtask
endclass

class axi_i2c_random_test_seq extends axi_i2c_base_seq;
    `uvm_object_utils(axi_i2c_random_test_seq)
    function new(string name = "axi_i2c_random_test_seq"); super.new(name); endfunction

    task body();
        logic [31:0] rdata;
        // Deterministic read-after-write checks guarantee meaningful comparisons.
        write_reg(4'h0, 32'h0000_0000);
        read_reg (4'h0, rdata);
        write_reg(4'h4, 32'h0000_00A5);
        read_reg (4'h4, rdata);

        repeat (50) begin
            req = axi_i2c_seq_item::type_id::create("random_req");
            start_item(req);
            if (!req.randomize()) `uvm_fatal("SEQ", "Transaction randomization failed")
            finish_item(req);
        end
    endtask
endclass

`endif

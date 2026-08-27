`ifndef AXI_I2C_COVERAGE_SV
`define AXI_I2C_COVERAGE_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class axi_i2c_coverage extends uvm_subscriber #(axi_i2c_seq_item);
    `uvm_component_utils(axi_i2c_coverage)

    axi_i2c_seq_item item;

    covergroup axi_cg;
        option.per_instance = 1;
        
        cp_addr: coverpoint item.addr {
            bins start_reg = {4'h0};
            bins write_reg = {4'h4};
            bins read_reg  = {4'h8};
            bins stop_reg  = {4'hC};
        }
        
        cp_write: coverpoint item.is_write {
            bins read  = {0};
            bins write = {1};
        }

        cross cp_addr, cp_write;
    endgroup

    function new(string name = "axi_i2c_coverage", uvm_component parent = null);
        super.new(name, parent);
        axi_cg = new();
    endfunction

    virtual function void write(axi_i2c_seq_item t);
        item = t;
        axi_cg.sample();
    endfunction
endclass

`endif

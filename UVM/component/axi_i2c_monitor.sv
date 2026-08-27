`ifndef AXI_I2C_MONITOR_SV
`define AXI_I2C_MONITOR_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class axi_i2c_monitor extends uvm_monitor;
    `uvm_component_utils(axi_i2c_monitor)
    
    virtual i2c_axi_if vif;
    uvm_analysis_port #(axi_i2c_seq_item) ap;

    function new(string name = "axi_i2c_monitor", uvm_component parent = null);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual i2c_axi_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("MON", "Could not get vif")
        end
    endfunction

    task run_phase(uvm_phase phase);
        axi_i2c_seq_item item;
        
        forever begin
            @(vif.mon_cb);
            
            // Basic monitoring of AXI Write
            if (vif.mon_cb.awvalid && vif.mon_cb.awready && vif.mon_cb.wvalid && vif.mon_cb.wready) begin
                item = axi_i2c_seq_item::type_id::create("item");
                item.is_write = 1;
                item.addr = vif.mon_cb.awaddr;
                item.data = vif.mon_cb.wdata;
                ap.write(item);
            end
            
            // Basic monitoring of AXI Read
            if (vif.mon_cb.rvalid && vif.mon_cb.rready) begin
                item = axi_i2c_seq_item::type_id::create("item");
                item.is_write = 0;
                item.addr = vif.mon_cb.araddr;
                item.read_data = vif.mon_cb.rdata;
                ap.write(item);
            end
        end
    endtask
endclass

`endif

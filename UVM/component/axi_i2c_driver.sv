`ifndef AXI_I2C_DRIVER_SV
`define AXI_I2C_DRIVER_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class axi_i2c_driver extends uvm_driver #(axi_i2c_seq_item);
    `uvm_component_utils(axi_i2c_driver)
    
    virtual i2c_axi_if vif;

    function new(string name = "axi_i2c_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual i2c_axi_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("DRV", "Could not get vif")
        end
    endfunction

    task run_phase(uvm_phase phase);
        // Reset initialization
        vif.cb.awvalid <= 0;
        vif.cb.wvalid  <= 0;
        vif.cb.bready  <= 0;
        vif.cb.arvalid <= 0;
        vif.cb.rready  <= 0;
        
        forever begin
            seq_item_port.get_next_item(req);
            
            if (req.is_write) begin
                // AXI Write Transaction
                vif.cb.awaddr  <= req.addr;
                vif.cb.awvalid <= 1;
                vif.cb.wdata   <= req.data;
                vif.cb.wstrb   <= 4'hF;
                vif.cb.wvalid  <= 1;
                vif.cb.bready  <= 1;
                
                @(vif.cb);
                wait(vif.cb.awready && vif.cb.wready);
                
                vif.cb.awvalid <= 0;
                vif.cb.wvalid  <= 0;
                
                wait(vif.cb.bvalid);
                req.resp = vif.cb.bresp;
                vif.cb.bready <= 0;
            end else begin
                // AXI Read Transaction
                vif.cb.araddr  <= req.addr;
                vif.cb.arvalid <= 1;
                vif.cb.rready  <= 1;
                
                @(vif.cb);
                wait(vif.cb.arready);
                vif.cb.arvalid <= 0;
                
                wait(vif.cb.rvalid);
                req.read_data = vif.cb.rdata;
                req.resp = vif.cb.rresp;
                vif.cb.rready <= 0;
            end
            
            @(vif.cb);
            seq_item_port.item_done();
        end
    endtask
endclass

`endif

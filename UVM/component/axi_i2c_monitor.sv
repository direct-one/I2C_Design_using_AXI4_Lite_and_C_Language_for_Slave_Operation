`ifndef AXI_I2C_MONITOR_SV
`define AXI_I2C_MONITOR_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class axi_i2c_monitor extends uvm_monitor;
    `uvm_component_utils(axi_i2c_monitor)

    virtual i2c_axi_if vif;
    uvm_analysis_port #(axi_i2c_seq_item) ap;

    logic [3:0]  pending_awaddr;
    logic [31:0] pending_wdata;
    logic [3:0]  pending_wstrb;
    logic [3:0]  pending_araddr;
    bit have_aw, have_w, write_waiting_for_b, read_waiting_for_r;

    function new(string name = "axi_i2c_monitor", uvm_component parent = null);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual i2c_axi_if)::get(this, "", "vif", vif))
            `uvm_fatal("MON", "Could not get vif")
    endfunction

    task run_phase(uvm_phase phase);
        axi_i2c_seq_item item;
        have_aw = 0;
        have_w = 0;
        write_waiting_for_b = 0;
        read_waiting_for_r = 0;

        forever begin
            @(vif.mon_cb);
            if (!vif.resetn) begin
                have_aw = 0;
                have_w = 0;
                write_waiting_for_b = 0;
                read_waiting_for_r = 0;
                continue;
            end

            if (vif.mon_cb.awvalid && vif.mon_cb.awready) begin
                pending_awaddr = vif.mon_cb.awaddr;
                have_aw = 1;
            end
            if (vif.mon_cb.wvalid && vif.mon_cb.wready) begin
                pending_wdata = vif.mon_cb.wdata;
                pending_wstrb = vif.mon_cb.wstrb;
                have_w = 1;
            end
            if (have_aw && have_w) begin
                write_waiting_for_b = 1;
                have_aw = 0;
                have_w = 0;
            end
            if (write_waiting_for_b && vif.mon_cb.bvalid && vif.mon_cb.bready) begin
                item = axi_i2c_seq_item::type_id::create("write_item");
                item.is_write = 1;
                item.addr = pending_awaddr;
                item.data = pending_wdata;
                item.strb = pending_wstrb;
                item.resp = vif.mon_cb.bresp;
                ap.write(item);
                write_waiting_for_b = 0;
            end

            if (vif.mon_cb.arvalid && vif.mon_cb.arready) begin
                pending_araddr = vif.mon_cb.araddr;
                read_waiting_for_r = 1;
            end
            if (read_waiting_for_r && vif.mon_cb.rvalid && vif.mon_cb.rready) begin
                item = axi_i2c_seq_item::type_id::create("read_item");
                item.is_write = 0;
                item.addr = pending_araddr;
                item.read_data = vif.mon_cb.rdata;
                item.resp = vif.mon_cb.rresp;
                ap.write(item);
                read_waiting_for_r = 0;
            end
        end
    endtask
endclass

`endif

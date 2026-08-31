`ifndef AXI_I2C_COVERAGE_SV
`define AXI_I2C_COVERAGE_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class axi_i2c_coverage extends uvm_subscriber #(axi_i2c_seq_item);
    `uvm_component_utils(axi_i2c_coverage)

    axi_i2c_seq_item item;
    int unsigned sample_count;
    int unsigned read_count;
    int unsigned write_count;
    int unsigned addr_count [0:3];

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

        addr_x_access: cross cp_addr, cp_write {
            // The sequence constrains 0x8 and 0xC to reads, so their write
            // combinations are excluded from the coverage goal.
            ignore_bins dynamic_register_writes =
                binsof(cp_addr.read_reg)  && binsof(cp_write.write) ||
                binsof(cp_addr.stop_reg)  && binsof(cp_write.write);
        }
    endgroup

    function new(string name = "axi_i2c_coverage", uvm_component parent = null);
        super.new(name, parent);
        axi_cg = new();
    endfunction

    virtual function void write(axi_i2c_seq_item t);
        item = t;
        sample_count++;

        if (t.is_write)
            write_count++;
        else
            read_count++;

        case (t.addr)
            4'h0: addr_count[0]++;
            4'h4: addr_count[1]++;
            4'h8: addr_count[2]++;
            4'hC: addr_count[3]++;
            default: ;
        endcase

        axi_cg.sample();
    endfunction

    function void report_phase(uvm_phase phase);
        real total_cov;
        real addr_cov;
        real access_cov;
        real cross_cov;

        super.report_phase(phase);
        total_cov  = axi_cg.get_inst_coverage();
        addr_cov   = axi_cg.cp_addr.get_coverage();
        access_cov = axi_cg.cp_write.get_coverage();
        cross_cov  = axi_cg.addr_x_access.get_coverage();

        `uvm_info("COV_SUMMARY", "", UVM_NONE)
        `uvm_info("COV_SUMMARY", "============================================================", UVM_NONE)
        `uvm_info("COV_SUMMARY", "                  AXI-I2C COVERAGE SUMMARY", UVM_NONE)
        `uvm_info("COV_SUMMARY", "============================================================", UVM_NONE)
        `uvm_info("COV_SUMMARY", $sformatf("  Total samples      : %0d", sample_count), UVM_NONE)
        `uvm_info("COV_SUMMARY", $sformatf("  Write samples      : %0d", write_count), UVM_NONE)
        `uvm_info("COV_SUMMARY", $sformatf("  Read samples       : %0d", read_count), UVM_NONE)
        `uvm_info("COV_SUMMARY", "------------------------------------------------------------", UVM_NONE)
        `uvm_info("COV_SUMMARY", $sformatf("  Address 0x0 hits   : %0d", addr_count[0]), UVM_NONE)
        `uvm_info("COV_SUMMARY", $sformatf("  Address 0x4 hits   : %0d", addr_count[1]), UVM_NONE)
        `uvm_info("COV_SUMMARY", $sformatf("  Address 0x8 hits   : %0d", addr_count[2]), UVM_NONE)
        `uvm_info("COV_SUMMARY", $sformatf("  Address 0xC hits   : %0d", addr_count[3]), UVM_NONE)
        `uvm_info("COV_SUMMARY", "------------------------------------------------------------", UVM_NONE)
        `uvm_info("COV_SUMMARY", $sformatf("  Address coverage   : %0.2f%%", addr_cov), UVM_NONE)
        `uvm_info("COV_SUMMARY", $sformatf("  Access coverage    : %0.2f%%", access_cov), UVM_NONE)
        `uvm_info("COV_SUMMARY", $sformatf("  Cross coverage     : %0.2f%%", cross_cov), UVM_NONE)
        `uvm_info("COV_SUMMARY", $sformatf("  Overall coverage   : %0.2f%%", total_cov), UVM_NONE)
        `uvm_info("COV_SUMMARY", "============================================================", UVM_NONE)

        if (sample_count == 0)
            `uvm_error("COV_EMPTY", "No transactions were sampled by the coverage collector")
    endfunction
endclass

`endif

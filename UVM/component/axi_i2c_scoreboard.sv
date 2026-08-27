`ifndef AXI_I2C_SCOREBOARD_SV
`define AXI_I2C_SCOREBOARD_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class axi_i2c_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(axi_i2c_scoreboard)

    localparam logic [1:0] AXI_OKAY = 2'b00;
    uvm_analysis_imp #(axi_i2c_seq_item, axi_i2c_scoreboard) item_collected_export;
    logic [31:0] reg_model [0:1];
    int unsigned total_count, pass_count, fail_count, response_error_count;

    function new(string name = "axi_i2c_scoreboard", uvm_component parent = null);
        super.new(name, parent);
        item_collected_export = new("item_collected_export", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        reg_model[0] = '0;
        reg_model[1] = '0;
    endfunction

    function void record_pass(string message);
        pass_count++;
        `uvm_info("SCB_PASS", message, UVM_LOW)
    endfunction

    function void record_fail(string message);
        fail_count++;
        `uvm_error("SCB_FAIL", message)
    endfunction

    function void write(axi_i2c_seq_item item);
        logic [31:0] expected;
        int index;
        total_count++;

        if (item.resp !== AXI_OKAY) begin
            response_error_count++;
            record_fail($sformatf("AXI %s response error: addr=0x%0h resp=%0b",
                                  item.is_write ? "WRITE" : "READ", item.addr, item.resp));
            return;
        end

        if (item.is_write) begin
            if (!(item.addr inside {4'h0, 4'h4})) begin
                record_fail($sformatf("Write to read-only/dynamic register: addr=0x%0h", item.addr));
                return;
            end
            index = item.addr[2];
            expected = reg_model[index];
            for (int byte_index = 0; byte_index < 4; byte_index++)
                if (item.strb[byte_index])
                    expected[byte_index*8 +: 8] = item.data[byte_index*8 +: 8];
            reg_model[index] = expected;
            record_pass($sformatf("WRITE OK: addr=0x%0h model=0x%08h strb=0x%0h",
                                  item.addr, expected, item.strb));
        end else if (item.addr inside {4'h0, 4'h4}) begin
            index = item.addr[2];
            expected = reg_model[index];
            if (item.read_data === expected)
                record_pass($sformatf("READ MATCH: addr=0x%0h expected=0x%08h actual=0x%08h",
                                      item.addr, expected, item.read_data));
            else
                record_fail($sformatf("READ MISMATCH: addr=0x%0h expected=0x%08h actual=0x%08h",
                                      item.addr, expected, item.read_data));
        end else begin
            // 0x8(status) and 0xC(rx_data) are DUT-state dependent. Without an
            // independent I2C slave/reference model, only AXI response is checked.
            record_pass($sformatf("DYNAMIC READ response OK: addr=0x%0h data=0x%08h",
                                  item.addr, item.read_data));
        end
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SCB_SUMMARY",
                  $sformatf("total=%0d pass=%0d fail=%0d response_errors=%0d",
                            total_count, pass_count, fail_count, response_error_count), UVM_NONE)
        if (total_count == 0)
            `uvm_error("SCB_EMPTY", "No completed AXI transactions were observed")
        if (fail_count != 0)
            `uvm_error("SCB_RESULT", $sformatf("Scoreboard failed with %0d mismatch(es)", fail_count))
    endfunction
endclass

`endif

`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

// Include all UVM files
`include "i2c_axi_if.sv"
`include "axi_i2c_seq_item.sv"
`include "axi_i2c_sequencer.sv"
`include "axi_i2c_seq.sv"
`include "axi_i2c_driver.sv"
`include "axi_i2c_monitor.sv"
`include "axi_i2c_agent.sv"
`include "axi_i2c_scoreboard.sv"
`include "axi_i2c_coverage.sv"
`include "axi_i2c_env.sv"
`include "axi_i2c_test.sv"

module tb_top;

    logic clk;
    logic resetn;

    // Instantiate interface
    i2c_axi_if vif(clk, resetn);
    
    // Pull-up resistor for I2C
    pullup(vif.sda);

    // Instantiate DUT (AXI_I2C_P_v1_0)
    // Note: Assuming standard mapping. If parameter definitions vary, update them.
    AXI_I2C_P_v1_0 #(
        .C_S00_AXI_DATA_WIDTH(32),
        .C_S00_AXI_ADDR_WIDTH(4)
    ) dut (
        .s00_axi_aclk(clk),
        .s00_axi_aresetn(resetn),
        .s00_axi_awaddr(vif.awaddr),
        .s00_axi_awprot(vif.awprot),
        .s00_axi_awvalid(vif.awvalid),
        .s00_axi_awready(vif.awready),
        .s00_axi_wdata(vif.wdata),
        .s00_axi_wstrb(vif.wstrb),
        .s00_axi_wvalid(vif.wvalid),
        .s00_axi_wready(vif.wready),
        .s00_axi_bresp(vif.bresp),
        .s00_axi_bvalid(vif.bvalid),
        .s00_axi_bready(vif.bready),
        .s00_axi_araddr(vif.araddr),
        .s00_axi_arprot(vif.arprot),
        .s00_axi_arvalid(vif.arvalid),
        .s00_axi_arready(vif.arready),
        .s00_axi_rdata(vif.rdata),
        .s00_axi_rresp(vif.rresp),
        .s00_axi_rvalid(vif.rvalid),
        .s00_axi_rready(vif.rready),
        .sda(vif.sda),
        .scl(vif.scl)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Reset and UVM start
    initial begin
        resetn = 0;
        #50 resetn = 1;
        
        // Pass interface to UVM config DB
        uvm_config_db#(virtual i2c_axi_if)::set(null, "*", "vif", vif);
        
        // Run test
        run_test("axi_i2c_test");
    end

endmodule

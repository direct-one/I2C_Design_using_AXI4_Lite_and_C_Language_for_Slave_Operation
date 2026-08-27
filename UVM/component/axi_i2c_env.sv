`ifndef AXI_I2C_ENV_SV
`define AXI_I2C_ENV_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class axi_i2c_env extends uvm_env;
    `uvm_component_utils(axi_i2c_env)
    
    axi_i2c_agent      agt;
    axi_i2c_scoreboard scb;
    axi_i2c_coverage   cov;

    function new(string name = "axi_i2c_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = axi_i2c_agent::type_id::create("agt", this);
        scb = axi_i2c_scoreboard::type_id::create("scb", this);
        cov = axi_i2c_coverage::type_id::create("cov", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agt.mon.ap.connect(scb.item_collected_export);
        agt.mon.ap.connect(cov.analysis_export);
    endfunction
endclass

`endif

`ifndef AXI_I2C_TEST_SV
`define AXI_I2C_TEST_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class axi_i2c_test extends uvm_test;
    `uvm_component_utils(axi_i2c_test)
    
    axi_i2c_env env;

    function new(string name = "axi_i2c_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = axi_i2c_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        axi_i2c_random_test_seq seq;
        seq = axi_i2c_random_test_seq::type_id::create("seq");
        
        phase.raise_objection(this);
        seq.start(env.agt.sqr);
        #1000ns;
        phase.drop_objection(this);
    endtask
endclass

`endif

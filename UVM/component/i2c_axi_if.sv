`ifndef I2C_AXI_IF_SV
`define I2C_AXI_IF_SV

interface i2c_axi_if(input logic clk, input logic resetn);
    
    // AXI-Lite Signals
    logic [3:0]  awaddr;
    logic [2:0]  awprot;
    logic        awvalid;
    logic        awready;
    
    logic [31:0] wdata;
    logic [3:0]  wstrb;
    logic        wvalid;
    logic        wready;
    
    logic [1:0]  bresp;
    logic        bvalid;
    logic        bready;
    
    logic [3:0]  araddr;
    logic [2:0]  arprot;
    logic        arvalid;
    logic        arready;
    
    logic [31:0] rdata;
    logic [1:0]  rresp;
    logic        rvalid;
    logic        rready;

    // I2C Signals
    wire         sda;
    logic        scl;
    
    // Clocking block for driver
    clocking cb @(posedge clk);
        default input #1step output #1;
        output awaddr, awprot, awvalid;
        input  awready;
        output wdata, wstrb, wvalid;
        input  wready;
        input  bresp, bvalid;
        output bready;
        output araddr, arprot, arvalid;
        input  arready;
        input  rdata, rresp, rvalid;
        output rready;
    endclocking
    
    // Clocking block for monitor
    clocking mon_cb @(posedge clk);
        default input #1step output #1;
        input awaddr, awprot, awvalid, awready;
        input wdata, wstrb, wvalid, wready;
        input bresp, bvalid, bready;
        input araddr, arprot, arvalid, arready;
        input rdata, rresp, rvalid, rready;
        input sda, scl;
    endclocking

endinterface

`endif

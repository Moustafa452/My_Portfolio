interface axi_if #(
    parameter int DATA_WIDTH  = 32,
    parameter int ADDR_WIDTH  = 16
    ) (input bit clk);

    logic ACLK = clk;
    logic ARESETn;

    logic [ADDR_WIDTH-1:0] AWADDR;
    logic [7:0]  AWLEN;
    logic [2:0]  AWSIZE;
    logic       AWVALID;
    logic       AWREADY;

    logic [DATA_WIDTH-1:0] WDATA;
    logic       WLAST;
    logic       WVALID;
    logic       WREADY;

    logic [1:0]  BRESP;
    logic       BVALID;
    logic       BREADY;

    logic [ADDR_WIDTH-1:0] ARADDR;
    logic [7:0]  ARLEN;
    logic [2:0]  ARSIZE;
    logic       ARVALID;
    logic       ARREADY;

    logic [DATA_WIDTH-1:0] RDATA;
    logic [1:0]  RRESP;
    logic       RLAST;
    logic       RVALID;
    logic       RREADY;

    modport DUT (
        input  ACLK, ARESETn, AWADDR, AWLEN, AWSIZE, AWVALID, WDATA, WLAST, WVALID, BREADY,
               ARADDR, ARLEN, ARSIZE, ARVALID, RREADY,
        output AWREADY, WREADY, BRESP, BVALID, ARREADY, RDATA, RRESP, RLAST, RVALID
    );

    modport TB (
        input   ACLK, AWREADY, WREADY, BRESP, BVALID, ARREADY, RDATA, RRESP, RLAST, RVALID,
        output ARESETn, AWADDR, AWLEN, AWSIZE, AWVALID, WDATA, WLAST, WVALID, BREADY,
               ARADDR, ARLEN, ARSIZE, ARVALID, RREADY
    ); 
endinterface
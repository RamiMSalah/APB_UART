module UART_APB_tb();
parameter WIDTH = 32            ;     
    reg  PCLK                   ;
    reg  PRESETn                ;
    reg  PSEL                   ;
    reg  PENABLE                ;
    reg  [WIDTH-1:0] PADDR      ;
    reg  PWRITE                 ;
    reg  [WIDTH-1:0] PWDATA     ;
    wire [WIDTH-1:0] PRDATA     ;
    wire PREADY                 ;
UART_APB_TOP #(
) DUT(
.PCLK(PCLK)       ,
.PRESETn(PRESETn) ,
.PSEL(PSEL)       ,
.PENABLE(PENABLE) ,
.PADDR(PADDR)     ,
.PWRITE(PWRITE)   ,
.PWDATA(PWDATA)   ,
.PRDATA(PRDATA)   ,
.PREADY(PREADY)
);


initial begin
    PCLK = 0;
    forever begin
        PCLK = ~PCLK;
        #1;
    end
end
parameter baudrate = 10417;

//CHOOSE NUMBER FROM after ->


// ===========================================
// Baud Rate Divider Table (Fclk = 100 MHz)
// Divider = Fclk / Baud
// ===========================================
// 300       -> 333333
// 600       -> 166667
// 1200      -> 83333
// 2400      -> 41667
// 4800      -> 20833
// 9600      -> 10417
// 14400     -> 6944
// 19200     -> 5208
// 28800     -> 3472
// 38400     -> 2604
// 57600     -> 1736
// 115200    -> 868
// 230400    -> 434
// 460800    -> 217
// 921600    -> 109
// 1000000   -> 100
// 2000000   -> 50
// 5000000   -> 20
// 10000000  -> 10
// ===========================================


initial begin
/*=================================================================================*/
// RESETING ALL PROJECT & SENDING THE BAUD_RATE
/*=================================================================================*/
    PRESETn = 0;
    PSEL    = 0;
    PWRITE  = 0;
    PENABLE = 0;
    PADDR   = 0;
    PWDATA  = 0;
    @(negedge PCLK);
    PRESETn = 1;
    @(negedge PCLK);
    PSEL    = 0;
    @(negedge PCLK);
    PSEL = 1;
    PWRITE   =1;
    PADDR = 32'h00000004;
    PWDATA = baudrate;  
    @(negedge PCLK);
    PENABLE  = 1;
    @(negedge PCLK);
    PENABLE = 0;
    @(negedge PCLK);
    PSEL = 0;
    @(negedge PCLK);
    @(negedge PCLK);

    $display("BAUDRATE:: %d",DUT.baud_gen.baud_div);
    /////////////////////
    PSEL = 1;
    PWRITE   =1;
    PADDR = 32'h00000000;
    PWDATA = 32'h00000006;
    @(negedge PCLK);
    PENABLE  = 1;
    @(negedge PCLK);
    PENABLE = 0;
    repeat (baudrate) @(negedge PCLK);
    @(negedge PCLK);
    PSEL = 0;
    $display("RX_RESET: %b",DUT.uart_rx.rst);
/*=================================================================================*/
// Enabling the Project
/*=================================================================================*/
    PSEL    = 0;
    @(negedge PCLK);
    PSEL = 1;
    PWRITE   =1;
    PADDR = 32'h00000000;
    PWDATA = 32'h00000009;
    @(negedge PCLK);
    PENABLE  = 1;
    @(negedge PCLK);
    PENABLE = 0;
    repeat (baudrate) @(negedge PCLK);
    @(negedge PCLK);
    PSEL = 0;
    $display("RX_Enable: %b",DUT.uart_rx.rx_en);
/*=================================================================================*/
// Sending the data by transmitter
/*=================================================================================*/
    @(negedge PCLK);
    PSEL = 1;
    PWRITE   =1;
    PADDR = 32'h00000002;
    PWDATA = 32'h000000A1;
    @(negedge PCLK);
    PENABLE  = 1;
    @(negedge PCLK);
    PENABLE = 0;
    repeat (15*baudrate) @(negedge PCLK);
    @(negedge PCLK);
    PSEL = 0;
    $display("TX_DATA: %h",DUT.uart_tx.data);
    $display("RX_DATA: %h",DUT.uart_rx.out);
    @(negedge PCLK);

/*=================================================================================*/
// RECIVING THE DATA BY THE APB_MASTER
/*=================================================================================*/
    PSEL    = 0;
    @(negedge PCLK);
    PSEL = 1;
    PWRITE   =0;
    PADDR = 32'h00000003;
    @(negedge PCLK);
    PENABLE  = 1;
    @(negedge PCLK);
    PENABLE = 0;
    @(negedge PCLK);
    repeat (baudrate) @(negedge PCLK);

        $display("PRDATA: %h",PRDATA);
    PSEL = 0;
    $stop;
end
endmodule
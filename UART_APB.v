module UART_APB_TOP #(
    parameter WIDTH32 = 32       ,
    parameter WIDTH8  = 8        ,
    parameter WIDTH18 = 18     
)(
    input  PSEL                  ,
    input  PENABLE               ,
    input  PWRITE                ,
    input  PCLK                  ,
    input  PRESETn               ,
    input  BAUD                  ,
    input  [WIDTH32-1:0] PADDR   ,
    input  [WIDTH32-1:0] PWDATA  , 
    output [WIDTH32-1:0] PRDATA  ,
    output PREADY
);

/*=================================================================================*/
// WIRING
/*=================================================================================*/
    wire        tx_busy, tx_done                    ;
    wire        rx_busy, rx_done                    ;
    wire        tx_en, tx_rst                       ;
    wire        rx_en, rx_rst                       ;
    wire        uart_line                           ;   
    wire        BCLK                                ;       
    wire [WIDTH18:0] baud_div                     ;
    wire [WIDTH8-1:0]  tx_data                      ;
    wire [WIDTH8-1:0]  rx_data                      ;
/*=================================================================================*/
// BAUD_RATE
/*=================================================================================*/
    baudrate
     baud_gen (
        .baud_div(baud_div),
        .clk(PCLK),
        .arst_n(PRESETn),
        .BCLK(BCLK)
    );

/*=================================================================================*/
// APB_SLAVE
/*=================================================================================*/
    APB_SLAVE apb (
        .baud_div(baud_div),
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PRDATA(PRDATA),
        .PREADY(PREADY),

        // Connections to UART
        .tx_busy(tx_busy),
        .tx_done(tx_done),
        .rx_busy(rx_busy),
        .rx_done(rx_done),
        .rx_data(rx_data),
        .tx_data(tx_data),
        .tx_en(tx_en),
        .tx_rst(tx_rst),
        .rx_en(rx_en),
        .rx_rst(rx_rst)
    );

/*=================================================================================*/
// TRANSMITTER
/*=================================================================================*/
    UART_TRANSMITTER uart_tx (
        .clk(PCLK),
        .arst_n(PRESETn),
        .rst(tx_rst),
        .BCLK(BCLK),
        .tx_en(tx_en),
        .data(tx_data),
        .busy(tx_busy),
        .done(tx_done),
        .tx_data(uart_line)   
    );

/*=================================================================================*/
// RECIVER
/*=================================================================================*/
    UART_RECIVER uart_rx (
        .clk(PCLK),
        .arst_n(PRESETn),
        .rst(rx_rst),
        .BCLK(BCLK),
        .rx_en(rx_en),
        .rx_data(uart_line),   
        .busy(rx_busy),
        .done(rx_done),
        .out(rx_data)
    );
endmodule

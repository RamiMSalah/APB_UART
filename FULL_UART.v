
/*=================================================================================*/
// ONLY UART (RX-TX) WITHOUT APB
/*=================================================================================*/ 
module FULL_UART #(
parameter WIDTH8 = 8             ,
parameter WIDTH18 = 18     

)(
    input        PCLK            ,
    input        PRESETn         ,
    input        tx_en           ,
    input        tx_rst          ,
    input        rx_rst          ,
    input     [18:0] baud_div    ,
    input        rx_en           , 
    input  [WIDTH8-1:0] tx_data  ,
    output [WIDTH8-1:0] rx_data  ,
    output       tx_busy         , 
    output       tx_done         ,
    output       rx_busy         ,
    output       rx_done         
);
    wire uart_line               ;   
    wire BCLK                    ;       
    baudrate
     baud_gen (
        .baud_div(baud_div),
        .clk(PCLK),
        .arst_n(PRESETn),
        .BCLK(BCLK)
    );
    UART_TRANSMITTER uart_tx (
        .clk(PCLK)               ,
        .arst_n(PRESETn)         ,
        .rst(tx_rst)             ,
        .BCLK(BCLK)              ,
        .tx_en(tx_en)            ,
        .data(tx_data)           ,
        .busy(tx_busy)           ,
        .done(tx_done)           ,
        .tx_data(uart_line)   
    );

    UART_RECIVER uart_rx (
        .clk(PCLK)               ,
        .arst_n(PRESETn)         ,
        .rst(rx_rst)             ,
        .BCLK(BCLK)              ,
        .rx_en(rx_en)            ,
        .rx_data(uart_line)      ,   
        .busy(rx_busy)           ,
        .done(rx_done)           ,
        .out(rx_data)
    );
endmodule

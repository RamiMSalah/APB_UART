module FULL_UART(
    //input        PCLK,
    //input        PRESETn,

    //input        tx_en,
    //input  [7:0] tx_data,
    //input        tx_rst,
    //input        rx_rst,
    //input        rx_en,
    //output       tx_busy, 
    //output       tx_done,
    //output       rx_busy,
    //output       rx_done,
    //output [7:0] rx_data
);

    //wire uart_line;   // الخط اللي هيوصل TX → RX
    //wire BCLK;        // Baud Clock

    baudrate #(
        .BAUD(9600),
        .FREQUENCY(100_000_000)
    ) baud_gen (
        .clk(PCLK),
        .arst_n(PRESETn),
        .BCLK(BCLK)
    );

    UART_TRANSMITTER uart_tx (
        .clk(PCLK),
        .arst_n(PRESETn),
        .rst(tx_rst),
        .BCLK(BCLK),
        .tx_en(tx_en),
        .data(tx_data),
        .busy(tx_busy),
        .done(tx_done),
        .tx_data(uart_line)   // يخرج على خط UART
    );

    UART_RECIVER uart_rx (
        .clk(PCLK),
        .arst_n(PRESETn),
        .rst(rx_rst),
        .BCLK(BCLK),
        .rx_en(rx_en),
        .rx_data(uart_line),   // يدخل نفس الخط
        .busy(rx_busy),
        .done(rx_done),
        .out(rx_data)
    );

endmodule

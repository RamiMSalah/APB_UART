module UART_APB_TOP #(
    parameter WIDTH = 32
)(
    input  PSEL,
    input  PENABLE,
    input  [WIDTH-1:0] PADDR,
    input  PWRITE,
    input  [WIDTH-1:0] PWDATA,
    input  PCLK,
    input  PRESETn,
    output [WIDTH-1:0] PRDATA,
    output PREADY
);

    //=============================
    // Wires
    //=============================
    wire        tx_busy, tx_done;
    wire        rx_busy, rx_done;
    wire [7:0]  tx_data;
    wire [7:0]  rx_data;
    wire        tx_en, tx_rst;
    wire        rx_en, rx_rst;

    wire        uart_line;   // الخط اللي هيوصل TX → RX
    wire        BCLK;        // Baud Clock

    //=============================
    // BAUD GENERATOR
    //=============================
    baudrate #(
        .BAUD(9600),
        .FREQUENCY(100_000_000)
    ) baud_gen (
        .clk(PCLK),
        .arst_n(PRESETn),
        .BCLK(BCLK)
    );

    //=============================
    // APB SLAVE
    //=============================
    APB_SLAVE apb (
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

    //=============================
    // UART TRANSMITTER
    //=============================
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

    //=============================
    // UART RECEIVER
    //=============================
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

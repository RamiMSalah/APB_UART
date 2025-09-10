module UART_tb();
parameter WIDTH = 32;

parameter baudrate = 868;

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

    reg  PCLK;
    reg  PRESETn;
    reg tx_en;
    reg [7:0] tx_data;
    reg tx_rst;
    reg rx_rst;
    reg rx_en;
    wire        tx_busy; 
    wire bit_sent;
    wire tx_done;
    wire        rx_busy;
    wire  rx_done;
    wire [7:0]  rx_data;
FULL_UART #(
) DUT(
.baudrate(baudrate)
.PCLK(PCLK),
.PRESETn(PRESETn),
.tx_en(tx_en),
.tx_data(tx_data),
.tx_rst(tx_rst),
.rx_rst(rx_rst),
.rx_en(rx_en),
.tx_busy(tx_busy),
.tx_done(tx_done),
.rx_busy(rx_busy),
.rx_done(rx_done),
.rx_data(rx_data)
);


initial begin
    PCLK = 0;
    forever begin
        PCLK = ~PCLK;
        #1;
    end
end

initial begin
    PRESETn = 0;
    tx_rst  = 1;
    rx_rst  = 1;
    tx_data = 0;
    @(negedge PCLK);
    @(negedge PCLK);
    PRESETn = 1;
    tx_rst  = 0;
    rx_rst  = 0;
    rx_en  = 1;
    tx_data = 8'b10110011;
    tx_en = 1;
    @(negedge PCLK);

    repeat (baudrate * 15) @(negedge PCLK);
$display("++++++++++++++++++");
    tx_en  = 0;
    rx_en  = 0;
    $display("YOUR DATA SENT IS %b",DUT.uart_tx.data);
    $display("YOUR DATA REGISTERED IS %b",DUT.uart_rx.rx_register);
    $display("YOUR DATA RECIVED IS %b",DUT.uart_rx.out);
    $stop;
end

initial begin
    forever begin
        @(posedge DUT.BCLK);
         
$display("|TX_Enable: %b |,|TX_Data: %b |,|TX_RST: %b|,|TX_Busy: %b|,|TX_Done: %b|,|Current State of TRA: %b|, |Counter: %d|, |BIT SENT: %b| ",
DUT.uart_tx.tx_en,DUT.uart_tx.data,DUT.uart_tx.rst,DUT.uart_tx.busy,DUT.uart_tx.done,DUT.uart_tx.cs,DUT.uart_tx.counter,DUT.uart_tx.tx_data);


/*
            $display("|RX_Enable: %b |,|RX_Data: %b |,|RX_RST: %b|,|RX_Busy: %b|,|RX_Done: %b|, |Counter: %d|, |BIT RECIVED: %b| ",
DUT.uart_rx.rx_en,DUT.uart_rx.out,DUT.uart_rx.rst,DUT.uart_rx.busy,DUT.uart_rx.done,DUT.uart_rx.counter,DUT.uart_rx.rx_data);

*/
end
end
 
endmodule
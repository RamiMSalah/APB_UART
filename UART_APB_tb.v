`timescale 1ns/1ps

module UART_APB_tb;

    parameter WIDTH = 32;
    parameter BAUD_DELAY = 1_100_000; // ≈ 1.1 ms @ 1ns timescale (10 bits @ 9600 baud)

    // APB signals
    reg  PSEL;
    reg  PENABLE;
    reg  [WIDTH-1:0] PADDR;
    reg  PWRITE;
    reg  [WIDTH-1:0] PWDATA;
    reg  PCLK;
    reg  PRESETn;
    wire [WIDTH-1:0] PRDATA;
    wire PREADY;

    // DUT instance
    UART_APB_TOP dut (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PRDATA(PRDATA),
        .PREADY(PREADY)
    );

    // Clock generation (100 MHz)
    initial begin
        PCLK = 0;
        forever #5 PCLK = ~PCLK;
    end

    // FSM monitoring
    // FSM monitoring with baud pulses
    initial begin
        $display("time\tAPB_CS\tTX_CS\tRX_CS\ttx_busy\trx_busy\ttx_data\trx_out");
        forever begin
            @(posedge dut.BCLK);   // اتأكد إن اسم الإشارة هو نفسه اللي عندك في التوب
            $display("%0t\t%b\t%b\t%b\t%b\t%b\t%b\t%h",
                $time,
                dut.apb.cs,
                dut.uart_tx.cs,
                dut.uart_rx.cs,
                dut.uart_tx.busy,
                dut.uart_rx.busy,
                dut.uart_tx.tx_data,
                dut.uart_rx.out
            );
        end
    end

    // Stimulus
    initial begin
        PRESETn = 0;
        PSEL    = 0;
        PENABLE = 0;
        PWRITE  = 0;
        PADDR   = 0;
        PWDATA  = 0;

        // Apply reset
        #200 PRESETn = 1;

        // =====================================================
        // Step 1: Write CTRL_REG (0x0000) to enable TX & RX
        // =====================================================
        @(posedge PCLK);
        PSEL   <= 1;
        PWRITE <= 1;
        PADDR  <= 32'h0000;
        PWDATA <= 32'h00000009;   // tx_en=1, rx_en=1

        @(posedge PCLK);
        PENABLE <= 1;

        @(posedge PCLK);
        PSEL    <= 0;
        PENABLE <= 0;

        // انتظر وقت كافي لبداية الـ FSM
        #(BAUD_DELAY);

        // =====================================================
        // Step 2: Write TX_DATA (0x0002) to send data
        // =====================================================
        @(posedge PCLK);
        PSEL   <= 1;
        PWRITE <= 1;
        PADDR  <= 32'h0002;
        PWDATA <= 32'h000000A0;

        @(posedge PCLK);
        PENABLE <= 1;

        @(posedge PCLK);
        PSEL    <= 0;
        PENABLE <= 0;

        // انتظر وقت كافي لإرسال باكيت كامل
        #(BAUD_DELAY);

        // =====================================================
        // Step 3: Read RX_DATA (0x0003)
        // =====================================================
        @(posedge PCLK);
        PSEL   <= 1;
        PWRITE <= 0;
        PADDR  <= 32'h0003;

        @(posedge PCLK);

        PENABLE <= 1;
        @(posedge PCLK);
        @(posedge PCLK);
        #(BAUD_DELAY);
        $display("Current State:",dut.apb.cs);
        $display("RX_DATA = %h", PRDATA);


        $finish;
    end

endmodule

module UART_TRANSMITTER 
#(
    parameter width  = 8,               
    parameter width2 = 3,               
    parameter IDLE   = 3'b000,          
    parameter START  = 3'b001,          
    parameter DATA   = 3'b010,          
    parameter STOP   = 3'b011,          
    parameter DONE   = 3'b100           
)
(
    input  tx_en,        
    input  BCLK,         
    input  rst,          
    input  arst_n,       
    input  clk,          
    input  [7:0] data,   
    output reg done,     
    output reg busy,     
    output reg tx_data   
);

    reg [width2-1:0] cs, ns; 
    reg [9:0] tx_register;    // {stop, data[7:0], start}
    reg [3:0] counter;        
    reg countdone;            

/*=================================================================================*/
// FSM STATE RESET BLOCK
/*=================================================================================*/
always @(posedge clk or negedge arst_n) begin
    if(~arst_n)
        cs <= IDLE;
    else if(rst)
        cs <= IDLE;
    else if(BCLK)
        cs <= ns;
end

/*=================================================================================*/
// FSM Current State Function BLOCK
/*=================================================================================*/
always @(posedge clk or negedge arst_n) begin
    if(~arst_n) begin
        countdone   <= 0;
        counter     <= 0;
        tx_register <= 0;
        done        <= 0;
        busy        <= 0;
        tx_data     <= 1'b1; // idle line = 1
    end 
    else if(rst) begin
        countdone   <= 0;
        counter     <= 0;
        tx_register <= 0;
        done        <= 0;
        busy        <= 0;
        tx_data     <= 1'b1;
    end 
    else begin
        case (cs)
            IDLE: begin
                done    <= 0;
                busy    <= 0;
                tx_data <= 1'b1; // idle line
                counter <= 0;
            end

            START: begin
                if(BCLK) begin
                    tx_register <= {1'b1, data, 1'b0}; // stop + data + start
                    tx_data     <= 1'b0;               // start bit
                    busy        <= 1;
                end
            end

            DATA: begin
                if(BCLK) begin
                    tx_data <= tx_register[counter];   // send current bit
                    if(counter == 8) begin
                        countdone <= 1'b1;
                    end else begin
                        counter   <= counter + 1;
                        countdone <= 0;
                    end
                end
            end

            STOP: begin
                if(BCLK) begin
                    tx_data   <= tx_register[9]; // stop bit = 1
                    countdone <= 0;
                end
            end

            DONE: begin
                if(BCLK) begin
                    busy    <= 0;
                    done    <= 1;
                    tx_data <= 1'b1;  // back to idle
                end
            end

            default: begin
                tx_data <= 1'b1;
                busy    <= 0;
                done    <= 0;
            end
        endcase
    end
end

/*=================================================================================*/
// FSM TRANSITIONS BLOCK
/*=================================================================================*/
always @(*) begin
    ns = cs;
    case (cs)
        IDLE:  if(tx_en) ns = START;
        START: ns = DATA;
        DATA:  if(countdone) ns = STOP;
        STOP:  ns = DONE;
        DONE:  ns = IDLE;
        default: ns = IDLE;
    endcase
end

endmodule

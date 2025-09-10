module UART_RECIVER 
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
    input  rx_en,        
    input  BCLK,         
    input  rst,          
    input  arst_n,       
    input  clk,          
    input  rx_data,      
    output reg done,     
    output reg busy,     
    output reg rx_error, 
    output reg [7:0] out 
);

    reg [width2-1:0] cs, ns; 
    reg [9:0] rx_register;   
    reg [3:0] counter;       
    reg countdone;           
    reg r_Rx_Data_R, r_Rx_Data; // double-register for metastability

/*=================================================================================*/
// Double-register input (metastability protection)
/*=================================================================================*/
always @(posedge clk) begin
    r_Rx_Data_R <= rx_data;
    r_Rx_Data   <= r_Rx_Data_R;
end

/*=================================================================================*/
// FSM STATE RESET BLOCK
/*=================================================================================*/
always @(posedge clk or negedge arst_n) begin
    if(~arst_n) begin
        cs <= IDLE;
    end else if(rst) begin
        cs <= IDLE;
    end else if(BCLK) begin
        cs <= ns;
    end
end

/*=================================================================================*/
// FSM Current State Function BLOCK
/*=================================================================================*/
always @(posedge clk or negedge arst_n) begin
    if(~arst_n) begin
        busy        <= 0;
        out         <= 0;
        rx_register <= 0;
        done        <= 0;
        counter     <= 0;
        countdone   <= 0;
    end 
    else if(rst) begin
        busy        <= 0;
        out         <= 0;
        rx_register <= 0;
        done        <= 0;
        counter     <= 0;
        countdone   <= 0;
    end 
    else begin
        case (cs)
            IDLE: begin
                busy      <= 0;
                done      <= 0;
                counter   <= 0;
                countdone <= 0;
            end

            START: begin
                if(BCLK) begin
                    busy <= 1;

                    rx_register[0] <= r_Rx_Data;
                end
            end 

            DATA: begin
                if(BCLK) begin
                    rx_register[counter+1] <= r_Rx_Data;
                    if(counter == 7) begin
                        countdone <= 1'b1;
                    end else begin
                        counter   <= counter+1;
                        countdone <= 1'b0;
                    end
                end
            end 

            STOP: begin
                if(BCLK) begin
                    rx_register[9] <= r_Rx_Data; 
                end
            end

            DONE: begin
                if(BCLK) begin
                    busy  <= 0;
                    done  <= 1;
                    out   <= rx_register[8:1]; 
                end
            end

            default: begin
                busy <= 0;
                done <= 0;
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
        IDLE:  if(rx_en && ~r_Rx_Data) ns = START; // detect start bit
        START: ns = DATA;
        DATA:  if(countdone) ns = STOP;
        STOP:  ns = DONE;
        DONE:  ns = IDLE;
        default: ns = IDLE;
    endcase
end

/*=================================================================================*/
// Error check: start must be 0, stop must be 1
/*=================================================================================*/
always @(posedge clk or negedge arst_n) begin
    if (~arst_n)
        rx_error <= 0;
    else if (done) begin
        if (rx_register[0] != 1'b0 || rx_register[9] != 1'b1)
            rx_error <= 1;
        else
            rx_error <= 0;
    end
end

endmodule

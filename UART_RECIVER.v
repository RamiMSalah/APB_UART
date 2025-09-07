    module UART_RECIVER 
    #(
    parameter width  = 8                ,
    parameter width2 = 3                ,
    parameter IDLE   =  3'b000          ,
    parameter START  =  3'b001          ,
    parameter DATA   =  3'b010          ,
    parameter DONE   =  3'b011          
    )
    (
        input rx_en                     ,
        input BCLK                      ,
        input rst                       ,
        input arst_n                    , 
        input clk                       ,  
        input  rx_data                  ,
        output reg done                 ,
        output reg busy                 ,
        output  reg [7:0] out        
    );

    reg [width2-1:0] cs                 ;
    reg [width2-1:0] ns                 ;
    reg [9:0] rx_register         ;
    reg [3:0] counter                   ;
    reg countdone                       ;

/*=================================================================================*/
// FSM STATE RESETING BLOCK
/*=================================================================================*/

    always @(posedge clk or negedge arst_n) begin
        if(~arst_n) begin
        cs <= IDLE;
        end else begin
            if(rst) begin
            cs <= IDLE;
            end else begin
                if(BCLK) begin
                cs <= ns;
                end
            end
        end
    end


/*=================================================================================*/
// FSM Current State Function BLOCK
/*=================================================================================*/
always @(posedge clk or negedge arst_n) begin
    if(~arst_n) begin
        busy <= 0;
        out  <= 0;
        rx_register <=0;
        done        <=0;
        counter <=9;
        countdone <=0;
    end else begin
        if(rst) begin
        busy <= 0;
        out  <= 0;
        rx_register <=0;
        done        <=0;
        counter <=9;
        countdone <=0;
        end else begin
            case (cs)
            IDLE: begin
            end
            START: begin
                if(BCLK) begin
                  busy <= 1; 
                end
            end
            DATA: begin
              if(counter == 0 & BCLK) begin
                countdone <=1;
              end else begin
                if(BCLK) begin
                    rx_register[counter] <= rx_data;
                  counter <= counter -1;
                end
              end
            end
            DONE: begin
                counter   <=9;
              out <= rx_register[8:1];  
              busy <= 0;
              done <= 1;
            end
                default: begin
  busy      <= 1'b0;
  done      <= 1'b0;
  countdone <= 1'b0;

                end
            endcase
        end
    end
end
/*=================================================================================*/
// FSM TRANSITONS BLOCK
/*=================================================================================*/
    always @(*) begin
        ns = cs;
        case (cs)
        IDLE: begin
        if(rx_en &&rx_data) begin
            ns = START;
        end
        end
        START: begin
            if(busy) begin
              ns = DATA;
            end
        end
        DATA: begin
            if(countdone) begin
              ns = DONE;
            end
        end

        DONE: begin
            if(done) begin
              ns = IDLE;
            end
        end
            default: begin
                ns = IDLE;
            end
        endcase
    end
    endmodule
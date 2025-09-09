    module UART_RECIVERt
    #(
    parameter width  = 8                ,
    parameter width2 = 3                ,
    parameter IDLE   =  3'b000          ,
    parameter START  =  3'b001          ,
    parameter DATA   =  3'b010          ,
    parameter ERR    =  3'b011          ,
    parameter DONE   =  3'b100          
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
        output reg rx_error             ,
        output  reg [7:0] out        
    );

    reg [width2-1:0] cs                 ;
    reg [width2-1:0] ns                 ;
    reg [8:0] rx_register               ;
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
        counter <=0;
        countdone <=0;
    end else begin
        if(rst) begin
        busy <= 0;
        out  <= 0;
        rx_register <=0;
        done        <=0;
        counter <=0;
        countdone <=0;
        end else begin
            case (cs)
            START: begin
                if(BCLK) begin
              busy <= 1;
                end
            end 
            DATA: begin
                if(counter == 7 && BCLK) begin
                  countdone <= 1'b1;
                end else begin
                    if(BCLK) begin
                        rx_register[counter] <= rx_data;
                        counter <= counter+1;
                        countdone <= 1'b0;
                    end
                end
            end 
            DONE:
            if(BCLK) begin
                    counter   <=0;
                    busy    <= 1'b0;
                    done    <= 1'b1;
                    out     <= {rx_register[8:1]};
            end
                            default: begin
                   busy    <= 1'b0;
                   done    <= 1'b0;
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
        if(rx_en) begin
            ns = START;
        end
        end
        START: begin
            if(busy && ~rx_data) begin
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

always @(posedge clk or negedge arst_n) begin
    if (~arst_n)
        rx_error <= 0 ;
    else if (done && (rx_register[0] != 1'b0 || rx_register[9] != 1'b1))
        rx_error <= 1 ;
    else
        rx_error <= 0 ;
end


    endmodule
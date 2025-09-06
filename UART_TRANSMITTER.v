    module UART_TRANSMITTER 
    #(
    parameter width  = 8                ,
    parameter width2 = 3                ,
    parameter IDLE   =  3'b000          ,
    parameter START  =  3'b001          ,
    parameter DATA   =  3'b010          ,
    parameter DONE   =  3'b011          
    )
    (
        input tx_en                     ,
        input BCLK                      ,
        input rst                       ,
        input arst_n                    , 
        input clk                       ,  
        input [7:0] data                ,
        output reg done                 ,
        output reg busy                 ,
        output reg tx_data
    );

    reg [width2-1:0] cs                 ;
    reg [width2-1:0] ns                 ;
    reg [width-1:0] tx_register         ;
    reg [3:0] counter                   ;
    reg countdone                       ;
    reg load                            ;


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
            countdone   <=0;
            counter     <=0;
            tx_register <=0;
            load        <=0;
        end 
        else begin
            if(rst) begin
            countdone   <=0;
            counter     <=0;
            tx_register <=0; 
            load        <=0;
            end 
            else begin
                case (cs)
                //IDLE STATE
                IDLE: begin
                  done <= 1'b0;
                end
                //START STATE
                START: begin
                    if(BCLK) begin
                    tx_register <= data;
                    tx_data     <= 1'b0;
                    load        <= 1'b1;
                    busy        <= 1'b1;      
                    end
                end
                //DATA STATE
                DATA: begin
             if(counter == width-1 && BCLK) begin
                    countdone <=1'b1;
                end 
                else begin
                    if(BCLK) begin
                tx_data   <= tx_register[counter];
                counter   <= counter + 1 ;
                countdone <=1'b0;            
                    end
                end
                end
                //DONE STATE
                DONE: begin
                    counter   <=0;
                    busy    <= 1'b0;
                    tx_data <= 1'b1;
                    done    <= 1'b1;
                    load    <= 1'b0;
                end
                    default: begin
                   tx_data <= 1'b1;
                   busy    <= 1'b0;
                   done    <= 1'b0;
                   load    <= 1'b0;
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
        if(tx_en) begin
            ns = START;
        end
        end
        START: begin
            if(load) begin
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
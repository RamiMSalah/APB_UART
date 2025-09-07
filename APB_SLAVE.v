module APB_SLAVE #(
parameter  Width = 32                         ,    
parameter  Width2 = 2                         ,    

parameter IDLE      = 2'b00                   ,
parameter SETUP     = 2'b01                   ,
parameter ACCESS    = 2'b10                   
)(
input  [Width-1:0] PADDR                      ,
input  [Width-1:0] PWDATA                     ,
input tx_busy                                 ,
input tx_done                                 ,
input rx_busy                                 ,
input rx_done                                 ,
input [7:0] rx_data                           ,

//APB SLAVE -----> UART


input PCLK                                    ,
input PRESETn                                 ,
input PSEL                                    ,
input PENABLE                                 ,
input PWRITE                                  ,
output  reg [Width-1:0]   PRDATA              ,
output reg   PREADY                           ,
output rx_en                                  ,
output rx_rst                                 ,
output tx_en                                  ,
output tx_rst                                 ,
output [7:0] tx_data                           
);

reg [Width2-1:0] cs                           ;
reg [Width2-1:0] ns                           ;
reg [Width-1:0] CTRL_REG                      ;
reg [Width-1:0] STATS_REG                     ;
reg [Width-1:0] TX_DATA                       ;
reg [Width-1:0] RX_DATA                       ;
reg [Width-1:0] BAUDIV                        ;


always @(posedge PCLK or negedge PRESETn) begin
    if(~PRESETn) begin
        cs <= IDLE;
    end else begin
        cs <= ns;
    end
end

always @(posedge PCLK or negedge PRESETn) begin
    if(~PRESETn) begin
      CTRL_REG  <= 32'b0;
      STATS_REG <= 32'b0;
      TX_DATA   <= 32'b0;
      RX_DATA   <= 32'b0;
      BAUDIV    <= 32'b0;
    end else begin
        if(cs == ACCESS &&PWRITE) begin
          if(PADDR==32'h0000) begin
            CTRL_REG <= {28'b0, PWDATA[3:0]};
          end 
          else if(PADDR==32'h0002) begin
                TX_DATA <= {24'b0,PWDATA[7:0]};
          end 
          else if(PADDR==32'h0004) begin
                BAUDIV <= {16'b0,PWDATA[15:0]};
          end
        end 
        else begin
          if(cs==ACCESS && ~PWRITE) begin
            if(PADDR==32'h0000) begin
                PRDATA <= {28'b0, CTRL_REG[3:0]};
            end
            else if(PADDR==32'h0001) begin
                PRDATA <= {27'b0, STATS_REG[4:0]};
            end 
            else if (PADDR==32'h0002) begin
                PRDATA <= {24'b0, TX_DATA[7:0]};
            end
            else if (PADDR==32'h0003) begin
                PRDATA <= {24'b0,RX_DATA[7:0]};
            end 
            else begin
                PRDATA <= {16'b0,BAUDIV[15:0]};
            end
          end
        end
        end
    
end

always @(*) begin
ns = cs;
case (cs)
IDLE: begin
  if(PSEL) begin
    ns = SETUP; 
  end 
end
SETUP: begin
  if(PENABLE) begin
    ns = ACCESS;
  end 
end
ACCESS: begin
    if(PREADY && PSEL && ~PENABLE) begin
        ns = SETUP;
    end else if(PREADY && ~PSEL) begin
      ns = IDLE;
    end
end
    default: begin
        ns = IDLE;
    end
endcase
end

always @(*) begin
  case (cs)
    IDLE:   PREADY = 1'b0;
    SETUP:  PREADY = 1'b0;
    ACCESS: PREADY = 1'b1;  
    default:PREADY = 1'b0;
  endcase
end
    assign rx_en = CTRL_REG[0] ;
    assign rx_rst = CTRL_REG[1] ;
    assign tx_rst = CTRL_REG[2] ;
    assign tx_en = CTRL_REG[3] ;

//TX_REG SIGNALS
    assign tx_data = TX_DATA ;

//STATS_REG SIGNALS
always @(posedge PCLK or negedge PRESETn) begin
    if (~PRESETn)
        STATS_REG <= 0 ;
    else begin
        STATS_REG[0] <= tx_busy ;
        STATS_REG[1] <= tx_done ;
        STATS_REG[2] <= rx_busy ;
        STATS_REG[3] <= rx_done ;
        STATS_REG[31:4] <= 0 ;
    end
end

//RX_REG SIGNALS
always @(posedge PCLK or negedge PRESETn) begin
    if(~PRESETn)
        RX_DATA <= 0 ;
    else if(rx_done) begin
        RX_DATA[7:0] <= rx_data ;
    end
end

endmodule 
module APB_SLAVE #(
parameter  Width = 32                         ,    
parameter  Width2 = 2                         ,    

parameter IDLE      = 2'b00                   ,
parameter SETUP     = 2'b01                   ,
parameter ACCESS    = 2'b10                   
)(
input  [Width-1:0] PADDR                      ,
input  [Width-1:0] PWDATA                     ,
input PCLK                                    ,
input PRESETn                                 ,
input PSEL                                    ,
input PENABLE                                 ,
input PWRITE                                  ,
output  reg [Width-1:0]   PRDATA              ,
output reg   PREADY
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


endmodule 
module baudrate (
input  [18:0] baud_div, 
input clk        ,
input arst_n     ,
output reg  BCLK  
);

reg [19:0] counter;
always @(posedge clk or negedge arst_n) begin
    if(~arst_n) begin
      counter <= 0;
      BCLK    <= 0;
    end else begin
        if(counter == baud_div-1) begin
          BCLK <= 1;
          counter <=0;
        end else begin
            counter <= counter +1;
            BCLK <=0;
        end
    end
end



endmodule
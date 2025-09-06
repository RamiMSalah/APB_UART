module baudrate #(
parameter BAUD = 9600 ,
parameter FREQUENCY = 100000000 ,

localparam FINAL = (FREQUENCY / (BAUD)) 
)(
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
        if(counter == FINAL -1) begin
          BCLK <= 1;
          counter <=0;
        end else begin
            counter <= counter +1;
            BCLK <=0;
        end
    end
end



endmodule
module UART_RECIVER #(
parameter width = 8                ,
parameter IDLE  =  3'b000          ,
parameter START =  3'b001          ,
parameter DATA  =  3'b010          ,
parameter ERR   =  3'b011          ,
parameter DONE  =  3'b100 
)
(
    input clk,
    input rx_en,
    input rst,
    input arst_n,
    input rx_in,
    output reg done,
    output reg err,
    output reg busy,
    output reg [width-1:0] data
);

reg [2:0] cs;
reg [2:0] ns;

always @(posedge clk or negedge arst_n) begin
    if(~arst_n) begin
        cs <=IDLE;
    end else begin
        if(rst) begin
            cs <=IDLE;
        end else begin
            cs <= ns;
        end
    end 
end

always @(*) begin
    ns = cs;
    case (cs)
    IDLE: begin

    end
        default: begin
            default_case
        end
    endcase
end


endmodule
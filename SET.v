module SET ( clk , rst, en, central, radius, mode, busy, valid, candidate );

input clk, rst;
input en;
input [23:0] central;
input [11:0] radius;
input [1:0] mode;
output reg busy;
output reg valid;
output reg [7:0] candidate;

reg [3:0]x1,y1,x2,y2,r1,r2;
reg[5:0]r1_sqr,r2_sqr; 
reg [3:0]x_test,y_test;
wire  [10:0]x1_real,y1_real,test,x2_real,y2_real,test2;
reg [1:0] m;
always@(posedge clk or posedge rst) begin
  if(rst) begin
    busy <= 1'd0;
    valid <= 1'd0;
    candidate <= 8'd0;
    x_test <= 4'd1;
    y_test <= 4'd1;
  end
  else if(en)begin
    x1 <= central[23:20];
    y1 <= central[19:16];
    x2 <= central[15:12];
    y2 <= central[11:8];
    r1 <= radius[11:8];
    r2 <= radius[7:4];
    m <= mode;
    candidate <= 8'd0;
    valid <= 1'd0;
    x_test <= 4'd1;
    y_test <= 4'd1;
    busy <= 1'd1;
  end
  else if(busy ==1'd1)begin
    if(x_test == 4'd8 &&y_test == 4'd9)begin
      valid <= 1'd1;
      busy <= 1'd0;
    end
    else begin
      if(x_test != 4'd8 &&y_test == 4'd8)begin
        x_test <= x_test + 4'b1;
        y_test <= 4'b1;
      end
      else begin
        y_test <= y_test + 4'b1;
      end
      case(m)
        2'b00:begin
        if(test <= r1_sqr)begin
          candidate <= candidate + 8'd1;
        end
      end
      2'b01:begin
        if(test <= r1_sqr && test2 <= r2_sqr)begin
          candidate <= candidate + 8'd1;
        end
      end
      default:begin
        if(( test  <=  (r1_sqr)  &&  test2  >  (r2_sqr) )||
          (test > r1_sqr && test2 <= r2_sqr))begin
          candidate <= candidate + 8'd1;
        end
      end
      endcase
    end
end
end

always @(*) begin
  r1_sqr = r1*r1;
  r2_sqr = r2*r2;
  
end

assign x1_real = (x_test > x1) ? x_test - x1 : x1 - x_test;
assign y1_real = (y_test > y1) ? y_test - y1 : y1 - y_test;
assign test = (x1_real * x1_real + y1_real * y1_real);
assign x2_real = (x_test > x2) ? x_test - x2 : x2 - x_test;
assign y2_real = (y_test > y2) ? y_test - y2 : y2 - y_test;
assign test2 = (x2_real * x2_real + y2_real * y2_real);


endmodule
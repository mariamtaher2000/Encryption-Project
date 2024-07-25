module STATE_SHIFT_REGISTER_V3 
	#(parameter [1:0] width = 2'd1)
	(	input clk,rst,
		input [0:4] enable,
		input [0:4] [width-1:0] data, // 5 bit i/p
		output logic [0:4] out_data // 5 bit o/p
		);

SHIFT_REGISTER_V3 #(width) x0 (.clk(clk), .rst(rst), .enable(enable[0]), .data(data[0]), .out(out_data[0]));
SHIFT_REGISTER_V3 #(width) x1 (.clk(clk), .rst(rst), .enable(enable[1]), .data(data[1]), .out(out_data[1]));
SHIFT_REGISTER_V3 #(width) x2 (.clk(clk), .rst(rst), .enable(enable[2]), .data(data[2]), .out(out_data[2]));
SHIFT_REGISTER_V3 #(width) x3 (.clk(clk), .rst(rst), .enable(enable[3]), .data(data[3]), .out(out_data[3]));
SHIFT_REGISTER_V3 #(width) x4 (.clk(clk), .rst(rst), .enable(enable[4]), .data(data[4]), .out(out_data[4]));

endmodule
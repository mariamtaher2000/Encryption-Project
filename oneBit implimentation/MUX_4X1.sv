module MUX_4X1 #(parameter width = 320)
	(
        input [width - 1:0] x_0,
	 	input [width - 1:0] x_1,
	 	input [width - 1:0] x_2,
	 	input [width - 1:0] x_3,
		input [1:0] sel,
		output logic [width - 1:0] x
	 );
	
logic [width - 1:0] x_a,x_b;

MUX_2X1 #(width) u1 (.x_0(x_0), .x_1(x_1), .sel(sel[0]), .x(x_a));
MUX_2X1 #(width) u2 (.x_0(x_2), .x_1(x_3), .sel(sel[0]), .x(x_b));
MUX_2X1 #(width) u3 (.x_0(x_a), .x_1(x_b), .sel(sel[1]), .x(x));

endmodule






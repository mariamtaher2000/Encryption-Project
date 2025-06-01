module MUX_2X1 #(parameter width = 320)
	(
        input [width - 1:0] x_0,
	 	input [width - 1:0] x_1,
		input sel,
		output logic [width - 1:0] x
	 );
	assign x = (~sel)? x_0 :x_1;


endmodule
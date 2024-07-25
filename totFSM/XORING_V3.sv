module XORING_V3
	(
	  input [0:4] [63:0] x,
	  output logic [0:4] out
	 );
	
assign out[0] = x[0][63] ^ x[0][18] ^ x[0][27];
assign out[1] = x[1][63] ^ x[1][60] ^ x[1][38];
assign out[2] = x[2][63] ^ x[2][0] ^ x[2][5];
assign out[3] = x[3][63] ^ x[3][9] ^ x[3][16];
assign out[4] = x[4][63] ^ x[4][6] ^ x[4][40];	 
	 
endmodule






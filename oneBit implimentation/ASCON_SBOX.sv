module ASCON_SBOX
	#(parameter [1:0] width = 2'd1 )
	(
        input [width - 1:0] x0_i,
	 	input [width - 1:0] x1_i,
	 	input [width - 1:0] x2_i,
		input [width - 1:0] x3_i,
		input [width - 1:0] x4_i,
		output logic [width - 1:0] x0_o,
		output logic [width - 1:0] x1_o,
		output logic [width - 1:0] x2_o,
		output logic [width - 1:0] x3_o,
		output logic [width - 1:0] x4_o
	 );

logic [width - 1:0] x0_a,x0_b;
logic [width - 1:0] x1_a;
logic [width - 1:0] x2_a,x2_b;
logic [width - 1:0] x3_a;
logic [width - 1:0] x4_a;
logic [width - 1:0] temp0,temp0_4,temp1,temp1_0,temp2,temp2_1,temp3,temp3_2,temp4,temp4_3;


assign x0_a = x0_i ^ x4_i; 
assign temp0 = ~x0_a;
assign temp0_4 = temp0 & x1_i;
assign x0_b = temp1_0 ^ x0_a;
assign x0_o = x0_b ^ x4_o;

assign temp1 = ~x1_i; 
assign temp1_0 = temp1 & x2_a;
assign x1_a = temp2_1 ^ x1_i;
assign x1_o = x1_a ^ x0_b;

assign x2_a = x1_i ^ x2_i;
assign temp2 = ~x2_a; 
assign temp2_1 = temp2 & x3_i;
assign x2_b = temp3_2 ^ x2_a;
assign x2_o = ~x2_b;  

assign temp3 = ~x3_i;  
assign temp3_2 = temp3 & x4_a;
assign x3_a = temp4_3 ^ x3_i;
assign x3_o = x3_a ^ x2_b;

assign x4_a = x3_i ^ x4_i;
assign temp4 = ~x4_a;  
assign temp4_3 = temp4 & x0_a;
assign x4_o = x4_a ^ temp0_4;

endmodule






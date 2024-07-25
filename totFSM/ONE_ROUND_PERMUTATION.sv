module ONE_ROUND_PERMUTATION
	#(parameter [1:0] width = 2'd1)
	(
	input rst,clk,
	input [0:4] input_data,
	input constant,
	input start_permutation,
	input [3:0] iteration,
	output logic [0:4] output_data
	);


logic [0:4] data,Xs,Ss,out,enable; 
STATE_SHIFT_REGISTER_V3 #(width) u1 (.clk(clk), .rst(rst), .enable(enable), .data(data), .out_data(Xs));
ASCON_SBOX #(width) u2 (.x0_i(Xs[0]), .x1_i(Xs[1]), .x2_i(Xs[2]), .x3_i(Xs[3]), .x4_i(Xs[4]), 
						.x0_o(Ss[0]), .x1_o(Ss[1]), .x2_o(Ss[2]), .x3_o(Ss[3]), .x4_o(Ss[4]));



//In case of enable part-------------------------------------------------------------
//logic enable_sbox;
//logic [4:0] input_to_sbox;
//AND_ENABLE u8 (.Xs(Xs), .enable_sbox(enable_sbox), .input_to_sbox(input_to_sbox));
//ASCON_SBOX #(width) u2 (.x0_i(input_to_sbox[0]), .x1_i(input_to_sbox[1]), .x2_i(input_to_sbox[2]), 
//						  .x3_i(input_to_sbox[3]), .x4_i(input_to_sbox[4]), 
// 						  .x0_o(Ss[0]), .x1_o(Ss[1]), .x2_o(Ss[2]), .x3_o(Ss[3]), .x4_o(Ss[4]));



XORING_V3 u3 (.x({u1.x0.out_data,u1.x1.out_data,u1.x2.out_data,u1.x3.out_data,u1.x4.out_data}), .out(out));

//temp mux
logic [2:0] temp_sel;
logic temp_data,temp,temp_enable;
//temp mux
always @(*) begin
	case(temp_sel)
		3'b000:  temp_data = out[0]; 
		3'b001:	 temp_data = out[1];
		3'b011:  temp_data = out[2];
		3'b010:  temp_data = out[3];
		3'b110:  temp_data = out[3];
		3'b111:  temp_data = out[4];
		default: temp_data = 0;	
	endcase	
end

//temp register
SHIFT_REGISTER_V3 #(width) u4 (.clk(clk), .rst(rst), .enable(temp_enable),.data(temp_data), .out(temp));

logic start_count,count_done;
logic [5:0] value;
logic [1:0] state_sel;
logic start_iteration,iteration_done;
//counter
COUNTER #(6) u5 (.clk(clk), .rst(rst), .start_count(start_count), .value(value), .count_done(count_done));
//fsm
ONE_BIT_FSM  u6 (.clk(clk), .rst(rst), .count_done(count_done), .start_permutation(start_permutation), .iteration(iteration), 
				.enable(enable), .start_count(start_count) , .temp_sel(temp_sel), .iteration_done(iteration_done), .start_iteration (start_iteration),
				.temp_enable(temp_enable), .value(value), .state_sel(state_sel));

D_COUNTER  u8 (.clk(clk), .rst(rst), .start_iteration(start_iteration), .iteration_value(iteration), .iteration_done(iteration_done));


//In case of enable part-------------------------------------------------------------
//ONE_BIT_FSM u6 (.clk(clk), .rst(rst), .count_done(count_done), .start_permutation(start_permutation), 
//	   			  .enable(enable), .start_count(start_count) , .temp_sel(temp_sel), 
//				  .temp_enable(temp_enable), .value(value), .state_sel(state_sel), .enable_sbox(enable_sbox));



//fadl only mux
logic [0:4] input_from_temp;
always @(*) begin
	case(temp_sel)
		3'b000:  input_from_temp = {Xs[0],4'b0};
		3'b001:	 input_from_temp = {temp,Xs[1],3'b0};
		3'b011:  input_from_temp = {1'b0,temp,Xs[2],2'b0};
		3'b010:  input_from_temp = {2'b0,temp,Xs[3],1'b0};
		3'b110:  input_from_temp = {2'b0,(temp ^ constant),Xs[3],1'b0};
		3'b111:  input_from_temp = {3'b0,temp,Xs[4]};
		default: input_from_temp = {4'b0,temp};	
	endcase	
end

MUX_4X1 #(.width(5)) u7 (.x_0(input_data), .x_1({input_data[0:1],(input_data[2] ^ constant),input_data[3:4]}), 
						 .x_2(input_from_temp), .x_3(Ss), .sel(state_sel), .x(data));



assign output_data = Xs;

endmodule
module ONE_ROUND_PERMUTATION
	#(parameter [1:0] width = 2'd1)
	(
	input rst,clk,
	input [0:4] input_data,
	input input_AD_PT,
	input constant,
	input start_encryption,
	input padd_with_one,
	//input [3:0] iteration,
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
logic temp,temp1,temp_enable;
tri logic temp_data,temp2;

logic [7:0] output_data1;
//awl 7aga 3di el temp sel 3la decoder
Decoder_3x8 u77 (.inp_data(temp_sel), .output_data(output_data1));
/*
//temp mux
always @(temp_sel,out) begin
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
*/
Tri_State_Buffer #(.size(1)) u78 (.in_data(out[0]), .in_data_enable(output_data1[0]), .out_data(temp_data));
Tri_State_Buffer #(.size(1)) u79 (.in_data(out[1]), .in_data_enable(output_data1[1]), .out_data(temp_data));
Tri_State_Buffer #(.size(1)) u80 (.in_data(out[2]), .in_data_enable(output_data1[3]), .out_data(temp_data));
Tri_State_Buffer #(.size(1)) u81 (.in_data(out[3]), .in_data_enable(output_data1[2]), .out_data(temp_data));
Tri_State_Buffer #(.size(1)) u82 (.in_data(out[3]), .in_data_enable(output_data1[6]), .out_data(temp_data));
Tri_State_Buffer #(.size(1)) u83 (.in_data(out[4]), .in_data_enable(output_data1[7]), .out_data(temp_data));
Tri_State_Buffer #(.size(1)) u66 (.in_data(1'b0),   .in_data_enable(output_data1[5]), .out_data(temp_data));
Tri_State_Buffer #(.size(1)) u67 (.in_data(1'b0),   .in_data_enable(output_data1[4]), .out_data(temp_data));


//temp register
SHIFT_REGISTER_V3 #(width) u4 (.clk(clk), .rst(rst), .enable(temp_enable),.data(temp_data), .out(temp1));

logic start_count,count_done;
logic [5:0] value;
logic [1:0] state_sel;
logic start_iteration,iteration_done,start_permutation,rst_d_counter;
logic [3:0] iteration;
logic [2:0] state_sel_padding;

//my counter
COUNTER #(6) u5 (.clk(clk), .rst(rst), .start_count(start_count), .value(value), .count_done(count_done));
D_COUNTER  u8 (.clk(clk), .rst(rst_d_counter), .start_iteration(start_iteration), .iteration_value(iteration), .iteration_done(iteration_done));

//external fsm
ONE_BIT_FSM_ALL u9 (.clk(clk), .rst(rst), .start_encryption(start_encryption), .iteration_done(iteration_done), 
					.iteration(iteration), .state_sel_padding(state_sel_padding),.count_done(count_done) ,.start_permutation(start_permutation),.rst_d_counter(rst_d_counter),
					.encryption_done(encryption_done));
//internal fsm
ONE_BIT_FSM  u6 (.clk(clk), .rst(rst), .count_done(count_done), .start_permutation(start_permutation), 
				.enable(enable), .start_count(start_count) , .temp_sel(temp_sel), .iteration_done(iteration_done), 
				.start_iteration (start_iteration), .temp_enable(temp_enable), .value(value), .state_sel(state_sel));



//In case of enable part-------------------------------------------------------------
//ONE_BIT_FSM u6 (.clk(clk), .rst(rst), .count_done(count_done), .start_permutation(start_permutation), 
//	   			  .enable(enable), .start_count(start_count) , .temp_sel(temp_sel), 
//				  .temp_enable(temp_enable), .value(value), .state_sel(state_sel), .enable_sbox(enable_sbox));

//mux for temp mn temp1
//7an7ot hna brdooo
/*
always @(*) begin
	case(temp_sel)
		3'b000:  temp2 = 1'b0; 
		3'b001:	 temp2 = ( (state_sel_padding == 3'b01) || (state_sel_padding == 3'b11) )? input_AD_PT : 1'b0; 	//x0
		3'b011:  temp2 = (state_sel_padding == 3'b10)? input_data[1] : 1'b0;	//x1
		3'b010:  temp2 = (state_sel_padding == 3'b10)? input_data[2] : 1'b0;	//x2
		3'b110:  temp2 = (state_sel_padding == 3'b10)? input_data[2] : 1'b0;	//x2
		3'b111:  temp2 = (state_sel_padding == 3'b01)? input_data[1] : (state_sel_padding == 3'b111)? input_data[1]: 1'b0;	//x3
		3'b101:  temp2 = (state_sel_padding == 3'b01)? input_data[2] : (state_sel_padding == 3'b011)? padd_with_one : (state_sel_padding == 3'b111)? input_data[2] : 1'b0;  	//x4	
		default: temp2 = 1'b0;	
	endcase	
end*/

logic t2,t3,t4,t5,t6,t7;
assign t2 = ( (state_sel_padding == 3'b01) || (state_sel_padding == 3'b11) )? input_AD_PT : 1'b0; 	//x0
assign t3 = (state_sel_padding == 3'b10)? input_data[1] : 1'b0;	//x1
assign t4 = (state_sel_padding == 3'b10)? input_data[2] : 1'b0;	//x2
assign t5 = (state_sel_padding == 3'b10)? input_data[2] : 1'b0;	//x2
assign t6 = (state_sel_padding == 3'b01)? input_data[1] : (state_sel_padding == 3'b111)? input_data[1]: 1'b0;	//x3
assign t7 = (state_sel_padding == 3'b01)? input_data[2] : (state_sel_padding == 3'b011)? padd_with_one : (state_sel_padding == 3'b111)? input_data[2] : 1'b0;  	//x4 



Tri_State_Buffer #(.size(1)) u84 (.in_data(1'b0), .in_data_enable(output_data1[0]), .out_data(temp2));
Tri_State_Buffer #(.size(1)) u85 (.in_data(t2),   .in_data_enable(output_data1[1]), .out_data(temp2));
Tri_State_Buffer #(.size(1)) u86 (.in_data(t3),   .in_data_enable(output_data1[3]), .out_data(temp2));
Tri_State_Buffer #(.size(1)) u87 (.in_data(t4),   .in_data_enable(output_data1[2]), .out_data(temp2));
Tri_State_Buffer #(.size(1)) u88 (.in_data(t5),   .in_data_enable(output_data1[6]), .out_data(temp2));
Tri_State_Buffer #(.size(1)) u89 (.in_data(t6),   .in_data_enable(output_data1[7]), .out_data(temp2));
Tri_State_Buffer #(.size(1)) u90 (.in_data(t7),   .in_data_enable(output_data1[5]), .out_data(temp2));
Tri_State_Buffer #(.size(1)) u68 (.in_data(1'b0), .in_data_enable(output_data1[4]), .out_data(temp2));

assign temp  = temp1 ^ temp2;

//fadl only mux
tri logic [0:4] input_from_temp;
///start
//logic h;
//assign h = temp ^ constant;
///end
//7n3'yr deeh kman
/*
always @(temp_sel,Xs,temp,constant) begin
	case(temp_sel)
		3'b000:  input_from_temp = {Xs[0],4'b0};
		3'b001:	 input_from_temp = {temp,Xs[1],3'b0};
		3'b011:  input_from_temp = {1'b0,temp,Xs[2],2'b0};
		3'b010:  input_from_temp = {2'b0,temp,Xs[3],1'b0};
		3'b110:  input_from_temp = {2'b0,(temp^constant) ,Xs[3],1'b0};
		//3'b110:  input_from_temp = {2'b0,h,Xs[3],1'b0};
		3'b111:  input_from_temp = {3'b0,temp,Xs[4]};
		default: input_from_temp = {4'b0,temp};	
	endcase	
end
*/
logic [0:4] t8,t9,t10,t11,t12,t13;
assign t8 = {Xs[0],4'b0};
assign t9 = {temp,Xs[1],3'b0};
assign t10 = {1'b0,temp,Xs[2],2'b0};
assign t11 = {2'b0,temp,Xs[3],1'b0};
assign t12 = {2'b0,(temp^constant) ,Xs[3],1'b0};
assign t13 = {3'b0,temp,Xs[4]};
assign t14 = {4'b0,temp};

Tri_State_Buffer #(.size(5)) u91 (.in_data(t8),    .in_data_enable(output_data1[0]), .out_data(input_from_temp));
Tri_State_Buffer #(.size(5)) u92 (.in_data(t9),    .in_data_enable(output_data1[1]), .out_data(input_from_temp));
Tri_State_Buffer #(.size(5)) u93 (.in_data(t10),   .in_data_enable(output_data1[3]), .out_data(input_from_temp));
Tri_State_Buffer #(.size(5)) u94 (.in_data(t11),   .in_data_enable(output_data1[2]), .out_data(input_from_temp));
Tri_State_Buffer #(.size(5)) u95 (.in_data(t12),   .in_data_enable(output_data1[6]), .out_data(input_from_temp));
Tri_State_Buffer #(.size(5)) u96 (.in_data(t13),   .in_data_enable(output_data1[7]), .out_data(input_from_temp));
Tri_State_Buffer #(.size(5)) u69 (.in_data(t14),   .in_data_enable(output_data1[5]), .out_data(input_from_temp));
Tri_State_Buffer #(.size(5)) u70 (.in_data(t14),   .in_data_enable(output_data1[4]), .out_data(input_from_temp));


MUX_4X1 #(.width(5)) u7 (.x_0(input_data), .x_1({input_data[0:1],(input_data[2] ^ constant),input_data[3:4]}), 
						 .x_2(input_from_temp), .x_3(Ss), .sel(state_sel), .x(data));



assign output_data = Xs;

endmodule
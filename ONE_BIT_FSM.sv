module ONE_BIT_FSM (
	input rst,
	input clk,
	input count_done,iteration_done,
	input start_permutation,
	//input start_sbox,
	output logic [1:0] state_sel,
	output logic [4:0] enable,
	output logic start_count,temp_enable,start_iteration,
	//output logic enable_sbox,
	output logic [5:0] value,
	output logic [2:0] temp_sel
);

enum logic [3:0] { start = 4'b0000, load = 4'b0001, sbox = 4'b0010, addconst = 4'b0011, state_x3_p1 = 4'b0100,  
				   state_x2 = 4'b0101, state_x0 = 4'b0110, state_x1 = 4'b0111, state_x3_p2 = 4'b1100, 
				   state_x4 = 4'b1101, final_state = 4'b1111  } cs,ns;
// since I have 11 states therefore I need 4 bits for current state and next state using gray code

////////////////////////////////////////////////////////// State memory
always @(posedge clk or negedge rst) begin
	if (~rst) begin
		cs <= start;
	end
	else begin
		cs <= ns;		
	end
end
////////////////////////////////////////////////////////// Next State logic and output logic
always @(*) begin
	state_sel = 2'b0;
	start_count = 1'b0;
	value = 6'd63;
	temp_enable = 1'b0;
	temp_sel = 3'b0;
	enable = 5'b0;
	start_iteration = 1'b0;
	//enable_sbox = 1'b0;

	unique case (cs)	
	
	start: begin
		if (start_permutation) begin
			ns = load;
			enable = 5'b11111;////////////////////////////////////////////new
			//state_sel by default l2no 2'b00
		end
		else begin
			ns = start;
		end
	end
	load: begin
		state_sel = 2'b00;
		start_count = 1'b1;
		value = 6'd55;
		enable = 5'b11111;
		if (count_done) begin
			ns = addconst;
			enable = 5'b11111;////////////////////////////////////////////new
			state_sel = 2'b01;//state_sel
		end
		else begin
			ns = load;
		end	
	end
	addconst: begin
		state_sel = 2'b01;
		start_count = 1'b1;
		value = 6'd7;
		enable = 5'b11111;
		if (count_done) begin
			ns = sbox;
			enable = 5'b11111;////////////////////////////////////////////new
			state_sel = 2'b11;//state_sel
		end
		else begin
			ns = addconst;
		end	
	end	
	sbox: begin
		state_sel = 2'b11;
		start_count = 1'b1;
		//start_iteration = 1'b1;
		//value 6'd64;
		enable = 5'b11111;
		//enable_sbox = 1'b1;
		/*if (iteration_done) begin
			if (start_permutation) begin
				ns = start;
				enable = 5'b00000;////////////////////////////////////////////new
			end
			else begin
				ns = sbox;
			end
		end
		else */
		if (count_done) begin
			ns = state_x0;
			enable = 5'b10000;////////////////////////////////////////////new
			state_sel = 2'b10;
		    //temp_sel = 3'b000;
		    temp_enable = 1'b1;
		end
		else begin
			ns = sbox;
		//	start_iteration = 1'b0;
		end	
	end
	state_x0: begin
		state_sel = 2'b10;
		temp_sel = 3'b000;
		start_count = 1'b1;
		temp_enable = 1'b1;
		//value 6'd8;
		enable = 5'b10000;
		if (count_done) begin
			ns = state_x1;
			enable = 5'b11000;////////////////////////////////////////////new
			//state_sel = 2'b10;
		    temp_sel = 3'b001;
		    //temp_enable = 1'b1;
		end
		else begin
			ns = state_x0;
		end	
	end
	state_x1: begin
		state_sel = 2'b10;
		temp_sel = 3'b001;
		start_count = 1'b1;
		temp_enable = 1'b1;
		//value 6'd64;
		enable = 5'b11000;
		if (count_done) begin
			ns = state_x2;
			enable = 5'b01100;////////////////////////////////////////////new
			//state_sel = 2'b10;
		    temp_sel = 3'b011;
		    //temp_enable = 1'b1;
		end
		else begin
			ns = state_x1;
		end	
	end
	state_x2: begin
		state_sel = 2'b10;
		temp_sel = 3'b011;
		start_count = 1'b1;
		temp_enable = 1'b1;
		//value 6'd64;
		enable = 5'b01100;
		if (count_done) begin
			ns = state_x3_p1;
			enable = 5'b00110;////////////////////////////////////////////new
			//state_sel = 2'b10;
		    temp_sel = 3'b010;
		    //temp_enable = 1'b1;
		end
		else begin
			ns = state_x2;
		end	
	end
	state_x3_p1: begin
		value = 6'd55;
		state_sel = 2'b10;
		temp_sel = 3'b010;
		start_count = 1'b1;
		temp_enable = 1'b1;
		//value 6'd64;
		enable = 5'b00110;
		if (count_done) begin
			ns = state_x3_p2;
			enable = 5'b00110;////////////////////////////////////////////new
			//state_sel = 2'b10;
		    temp_sel = 3'b110;
		    //temp_enable = 1'b1;		
		end
		else begin
			ns = state_x3_p1;
		end	
	end	
	state_x3_p2: begin
		value = 6'd7;
		state_sel = 2'b10;
		temp_sel = 3'b110;
		start_count = 1'b1;
		temp_enable = 1'b1;
		//value 6'd64;
		enable = 5'b00110;
		if (count_done) begin
			ns = state_x4;
			enable = 5'b00011;////////////////////////////////////////////new
			//state_sel = 2'b10;
		    temp_sel = 3'b111;
		    //temp_enable = 1'b1;		
		end
		else begin
			ns = state_x3_p2;
		end	
	end		
	state_x4: begin
		state_sel = 2'b10;
		temp_sel = 3'b111;
		start_count = 1'b1;
		temp_enable = 1'b1;
		//value 6'd64;
		enable = 5'b00011;
		if (count_done) begin
			ns = final_state;
			enable = 5'b00001;////////////////////////////////////////////new
			//state_sel = 2'b10;
		    temp_sel = 3'b101;
		    //temp_enable = 1'b1;	
		    start_iteration = 1'b1;	
		end
		else begin
			ns = state_x4;
		end	
	end
	final_state: begin
		state_sel = 2'b10;
		temp_sel = 3'b101;
		start_count = 1'b1;
		temp_enable = 1'b1;
		//value 6'd64;
		enable = 5'b00001;
		start_iteration = 1'b0;
		if (count_done && ~iteration_done) begin
			ns = sbox;
			enable = 5'b11111;////////////////////////////////////////////new
			state_sel = 2'b11;
		end
		else if (count_done && iteration_done) begin
			if (start_permutation) begin
				ns = start;
				enable = 5'b00000;////////////////////////////////////////////new
			end
			else begin //NOTE: in this case start_sbox mlha4 lzmaaa
				ns = sbox;
				enable = 5'b11111;////////////////////////////////////////////new
				state_sel = 2'b11;//state_sel
			end
		end
		else begin
			start_iteration = 1'b0;
			ns = final_state;
		end	
	end			
	endcase

end

endmodule

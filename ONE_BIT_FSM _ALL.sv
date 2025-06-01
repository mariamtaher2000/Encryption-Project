module ONE_BIT_FSM_ALL(
	input rst,
	input clk,
	input iteration_done, count_done,
	input start_encryption,
	output logic [2:0] state_sel_padding,
	output logic start_permutation,rst_d_counter,
	output logic [3:0] iteration,   //the value of iteration
	//output logic start_sbox,
	output logic encryption_done
);

  enum logic [3:0] { reset = 4'b0000, S_I = 4'b0001, F_I = 4'b0011, S_A = 4'b0010, F_A = 4'b0110,  
				   						 S_P = 4'b0111, F_P = 4'b0101, final_state = 4'b0100, F_F = 4'b1100} cs,ns;
// since I have 8 states therefore I need 3 bits for current state and next state

////////////////////////////////////////////////////////// State memory
always @(posedge clk or negedge rst) begin
	if (~rst) begin
		cs <= reset;
	end
	else begin
		cs <= ns;		
	end
end
////////////////////////////////////////////////////////// Next State logic and output logic
always @(*) begin

	state_sel_padding = 3'b00;
	start_permutation = 1'b0;
	iteration = 4'd11;
	//start_sbox = 1'b0;
	encryption_done = 1'b0;
	rst_d_counter = 1'b1;

	unique case (cs)	
	
	reset: begin
		if(start_encryption) begin
			ns = S_I;
			rst_d_counter = 1'b0;
			start_permutation=1'b1;
	    iteration=4'd11;			
		end
		else
			ns = reset;
	end

	S_I: begin
		//rst_d_counter = 1'b1;
		start_permutation=1'b1;
	  iteration=4'd11;
		
		if (count_done && iteration_done ) begin
			ns = F_I;
			rst_d_counter = 1'b0;
			iteration = 4'd1;
			state_sel_padding = 3'b01;   //padding k & AD
			start_permutation = 1'b0;
			//start_sbox = 1'b1;
		end
		else begin
			ns = S_I;
			start_permutation = 1'b0;
		end

	end

	F_I: begin
	  iteration = 4'd1;
		state_sel_padding = 3'b01;   //padding k & AD
		//start_sbox = 1'b1;
		
		if (count_done && iteration_done ) begin
			ns = S_A;
			rst_d_counter = 1'b0;
			iteration = 4'd5;
			state_sel_padding = 3'b00;   
			//start_permutation = 1'b0 l2n el default 0 
			//start_sbox = 1'b1;
		end
		else begin
			ns = F_I;
		end	
	end

	S_A: begin
	   iteration = 4'd5;
	   state_sel_padding = 3'b00;   
	   //start_sbox = 1'b1;
        
		if (count_done && iteration_done) begin
			rst_d_counter = 1'b0;
			ns = F_A;
			iteration = 4'd1;
			state_sel_padding = 3'b11;   
			//start_permutation = 1'b0
			//start_sbox = 1'b1;
		end
		else begin
			ns = S_A;
		end	
	end	

	F_A: begin
	  iteration = 4'd1;
		//start_sbox = 1'b1;
		state_sel_padding = 3'b11;   //input p  and padding

		if (count_done && iteration_done) begin
			rst_d_counter = 1'b0;
			ns = S_P;
			iteration = 4'd5;
			state_sel_padding = 3'b00;   
			//start_permutation = 1'b0
			//start_sbox = 1'b1;			
		end
		else begin
			ns = F_A;
		end	
	end

	S_P: begin
	  iteration = 4'd5;
		//start_sbox = 1'b1;
		state_sel_padding = 3'b00;  
        
		if (count_done && iteration_done) begin
			rst_d_counter = 1'b0;
			ns = F_P;
			iteration = 4'd1;
			state_sel_padding = 3'b10;   
			//start_permutation = 1'b0
			//start_sbox = 1'b1;			
		end
		else begin
			ns = S_P;
		end	
	end

	F_P: begin
	  iteration = 4'd1;
		state_sel_padding = 3'b10;
		//start_sbox = 1'b1;
		
		if (count_done && iteration_done) begin
			rst_d_counter = 1'b0;
			ns =final_state;
			iteration = 4'd11;
			state_sel_padding = 3'b00;   
			//start_permutation = 1'b0
			//start_sbox = 1'b1;				
		end
		else begin
			ns = F_P;
		end	
	end

	final_state: begin
		iteration=4'd11;
		//start_sbox = 1'b1;
		//start_permutation = 1'b1;
		state_sel_padding = 3'b00;
		if (count_done && iteration_done) begin
			rst_d_counter = 1'b0;
			ns = F_F;
			iteration = 4'd1;
			state_sel_padding = 3'b111;
			//encryption_done = 1'b1;	
		end
		else begin
			ns = final_state;
		end
	end

	F_F: begin
		iteration=4'd1;
		//start_sbox = 1'b1;
		start_permutation = 1'b1;
		state_sel_padding = 3'b111;
		if (count_done && iteration_done) begin
			rst_d_counter = 1'b0;
			ns = reset;
			encryption_done = 1'b1;	
		end
		else begin
			ns = F_F;
		end
	end
	endcase

end

endmodule





	
	
	
	
	
	
	
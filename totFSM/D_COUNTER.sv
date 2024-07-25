module D_COUNTER
	(
		input clk,rst,start_iteration,
	 	input [3:0] iteration_value,
		output logic iteration_done
	 );

	logic [3:0] op;

	always @(posedge clk or negedge rst) begin
		if(~rst) begin
			op <= iteration_value;
		end 
		else begin
			if(start_iteration) begin
				if (op  > 0) begin
					op <= op - 1;
				end
				else begin
					op <= 0 ;
				end	
			end
		end
	end
	assign iteration_done = (op == 0)? 1'b1 : 1'b0;

endmodule






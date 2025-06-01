module COUNTER
	#(parameter N = 6 )
	(
		input clk,rst,start_count,
	 	input [N-1:0] value,
		output logic count_done
	 );

	logic [N-1:0] op;

	always @(posedge clk or negedge rst) begin
		if(~rst) begin
			op <= 0;
		end 
		else begin
			if(start_count) begin
				if (op  < value) begin
					op <= op + 1;
				end
				else begin
					op <=0;
				end	
			end
		end
	end
	assign count_done = (op == value)? 1'b1 : 1'b0;

endmodule






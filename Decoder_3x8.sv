module Decoder_3x8 (
	input [2:0] inp_data,    
	output logic [7:0] output_data 
);

always_comb begin
	case (inp_data)
		3'd0: output_data = 8'b0000_0001;
		3'd1: output_data = 8'b0000_0010;
		3'd2: output_data = 8'b0000_0100;
		3'd3: output_data = 8'b0000_1000;

		3'd4: output_data = 8'b0001_0000;
		3'd5: output_data = 8'b0010_0000;
		3'd6: output_data = 8'b0100_0000;
		3'd7: output_data = 8'b1000_0000;
	
		default : output_data = 8'b0000_0000;
	endcase
	
end

endmodule
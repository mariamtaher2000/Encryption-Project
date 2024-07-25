module SHIFT_REGISTER_V3 
	#(parameter [1:0] width = 2'd1)
	(	input clk,rst,enable,
		input [width-1:0] data,
		output logic out
		);

logic [63:0] out_data;
always @(posedge clk or negedge rst) begin
	if (~rst) begin
		out_data <= 0;
	end
	else begin
		if (enable) 
			out_data <= {out_data[63-width:0],data};
	end
end

assign out = out_data[63];

endmodule
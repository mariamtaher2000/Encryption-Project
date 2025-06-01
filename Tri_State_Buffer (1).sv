module Tri_State_Buffer  #(parameter size = 5) (
	input [0: size-1] in_data,
	input in_data_enable,
	output logic [0: size-1] out_data
);

assign out_data = (in_data_enable === 1'b1)? in_data: 'bz;

endmodule
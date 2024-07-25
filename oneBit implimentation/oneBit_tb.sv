// Code your testbench here
// or browse Examples
module oneBit_tb();

	bit rst,clk;
	bit [4:0] input_data;
	bit constant;
	bit start_permutation;
	bit [4:0] output_data;

	// inputs
	bit [63:0] IV = 64'h8040_0c06_0000_0000;
	bit [127:0] key = 128'h0000_0000_0000_0000_0000_0000_1215_3524;
	bit [127:0] nonce=128'hffff_ffff_ffff_ffff_ffff_ffff_c089_5e81;
	bit [7:0] cnst = 8'h4b;

	// constant = {8'hf0,8'he1,8'hd2,8'hc3,8'hb4,8'ha5,8'h96,8'h87,8'h78,8'h69,8'h5a,8'h4b};
	// IV = 64'h8040_0c06_0000_0000;

	always #5 clk =! clk;

  	ONE_ROUND_PERMUTATION #(1) dut (.rst(rst),.clk(clk),.input_data(input_data),.constant(constant),
  									.start_permutation(start_permutation),.output_data(output_data));

  
  	int  num1 = 63;
	int  num2 = 127;
	int  num3 = 7;
  
	initial begin
		clk = 1;
		rst = 0;

		repeat(10) @(posedge clk);
		
		rst = 1;
		@(negedge clk);
		//assert(ONE_ROUND_PERMUTATION.ONE_BIT_FSM.cs==start);

		start_permutation = 1;
			input_data = { IV[num1], key[num2], key[num1], nonce[num2] , nonce[num1]};


      	for (int i = 0; i < 55 ; i++) begin
			@(negedge clk);
			//input_data = { nonce[num2] , nonce[num1] , key[num2] , key[num1] , IV[num1] };
			num1 = num1 - 1;
			num2 = num2 - 1;
			input_data = { IV[num1], key[num2], key[num1], nonce[num2] , nonce[num1]};
			//num1 = num1 - 1;
			//num2 = num2 - 1;
			//@(posedge clk);

		end
		$display("current stateeeeeeeeeeeeeeeeeeeeeeeeeeeeee = %b,%t",dut.u6.cs,$time);
		
			//constant = cnst[num3];

      	for (int j = 0; j < 8 ; j++) begin
			@(negedge clk);
			//input_data = { IV[num1], key[num2], key[num1], nonce[num2] , nonce[num1]};
			//input_data = { nonce[num2] , nonce[num1] , key[num2] , key[num1] , IV[num1]};
			//constant = cnst[num3]; 
			//@(posedge clk);
			num1 = num1 - 1;
			num2 = num2 - 1;	
			//num3 = num3 - 1;
			input_data = { IV[num1], key[num2], key[num1], nonce[num2] , nonce[num1]};
			//input_data = { nonce[num2] , nonce[num1] , key[num2] , key[num1] , IV[num1]};
			constant = cnst[num3];
			num3 = num3 - 1;		
		end


		//repeat(448) @(posedge clk);
			

	end
  
  	initial begin
	    $dumpfile("test.vcd");
	    $dumpvars;
	    repeat(525) @(negedge clk);
	    //start_permutation = 0;
	    $display("key = %h, nonce = %h", key, nonce);
		$display("Output = %h",output_data);
		$display("x0 = %h",dut.u1.x0.out_data);
		$display("x1 = %h",dut.u1.x1.out_data);
		$display("x2 = %h",dut.u1.x2.out_data);
		$display("x3 = %h",dut.u1.x3.out_data);
		$display("x3 = %h",dut.u1.x4.out_data);

		$display("current state = %b",dut.u6.cs);
		//$display("x3 = %h",u1.x4.out_data);

		$stop;	
  	end

  	initial begin
  		$monitor("Output = %h",output_data);
  		$monitor("x0 = %h,%t",dut.u1.x0.out_data,$time);
		$monitor("x1 = %h,%t",dut.u1.x1.out_data,$time);
		$monitor("x2 = %h,%t",dut.u1.x2.out_data,$time);
		$monitor("x3 = %h,%t",dut.u1.x3.out_data,$time);
		$monitor("x3 = %h,%t",dut.u1.x4.out_data,$time);
  	end


endmodule 

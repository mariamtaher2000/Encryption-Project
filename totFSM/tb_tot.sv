module tb_tot();

	bit rst,clk;
	bit [4:0] input_data;
	bit constant;
	bit start_permutation;
	bit [4:0] output_data;
	bit [3:0] iteration;
	// inputs
	bit [63:0] IV = 64'h8040_0c06_0000_0000;
	bit [127:0] key = 128'h0000_0000_0000_0000_0000_0000_1215_3524;
	bit [127:0] nonce=128'hffff_ffff_ffff_ffff_ffff_ffff_c089_5e81;
	
	// Constant cr
	/*bit [7:0] cnst0 = 8'h96;
	bit [7:0] cnst1 = 8'h87;
	bit [7:0] cnst2 = 8'h78;
	bit [7:0] cnst3 = 8'h69;
	bit [7:0] cnst4 = 8'h5a;
	bit [7:0] cnst5 = 8'h4b;*/
	//bit [7:0] cnst [6] = { 8'h4b, 8'h87, 8'h78, 8'h69, 8'h5a, 8'h4b };	

	bit [7:0] cnst [6] = { 8'h96, 8'h87, 8'h78, 8'h69, 8'h5a, 8'h4b };	
	//bit [7:0] cnst12 [12] = { 8'hf0, 8'he1, 8'hd2, 8'hc3, 8'hb4, 8'ha5, 8'h96, 8'h87, 8'h78, 8'h69, 8'h5a, 8'h4b };

	//assign cnst = () ? cnst6 : cnst12;

	always #5 clk =! clk;

  	ONE_ROUND_PERMUTATION #(1) dut (.rst(rst),.clk(clk),.input_data(input_data),.constant(constant),
  									.start_permutation(start_permutation),.iteration(iteration),.output_data(output_data));

  
  	int  num1 = 63;
	int  num2 = 127;
	int  num3 = 7;
  
	initial begin
		clk = 1;
		rst = 0;
		iteration = 6;

		repeat(10) @(posedge clk);

		rst = 1;

		// --------------First round with IV, Key, nonce and constant-------------
		@(negedge clk);
		start_permutation = 1;


      	for (int i = 0; i < 55 ; i++) begin		
      		input_data = { IV[num1], key[num2], key[num1], nonce[num2] , nonce[num1]};

			@(negedge clk);
			num1 = num1 - 1;
			num2 = num2 - 1;
			input_data = { IV[num1], key[num2], key[num1], nonce[num2] , nonce[num1]};
		end
		$display("current stateeeeeeeeeeeeeeeeeeeeeeeeeeeeee = %b,%t",dut.u6.cs,$time);
		

      	for (int j = 0; j < 8 ; j++) begin
			@(negedge clk);
			num1 = num1 - 1;
			num2 = num2 - 1;	
			input_data = { IV[num1], key[num2], key[num1], nonce[num2] , nonce[num1]};
			constant = cnst[0][num3];
			num3 = num3 - 1;		
		end

		constant = 0;
		repeat(313) @(negedge clk);
		for (int j = 7 ; j >= 0 ; j--) begin
				//@(negedge clk);	
				constant = cnst[1][j];	
				@(negedge clk);	
		end	
		constant = 0;

		repeat(127) @(negedge clk);
		
		///////////////////////////

		/*repeat(312) @(negedge clk);
		for (int j = 7 ; j >= 0 ; j--) begin
				//@(negedge clk);	
				constant = cnst[2][j];	
				@(negedge clk);	
		end	
		constant = 0;

		repeat(127) @(negedge clk);*/


		// --------------Other rounds with only constant---------------------
		//for (int i = 2; i < (iteration+1) ; i++) begin

			repeat(312) @(negedge clk);

			for (int j = 7 ; j > 0 ; j--) begin
				@(negedge clk);	
				constant = cnst[2][j];	
			end	

			constant = 0;
			repeat(127) @(negedge clk);
		//end

		// -----------------------------------------------------------------
	
	end
  
  	initial begin
	    $dumpfile("test.vcd");
	    $dumpvars;
	    repeat(530 + ((iteration-1) * 448)) @(negedge clk);
	    $display("key = %h, nonce = %h", key, nonce);
		$display("Output = %h",output_data);
		$display("x0 = %h",dut.u1.x0.out_data);
		$display("x1 = %h",dut.u1.x1.out_data);
		$display("x2 = %h",dut.u1.x2.out_data);
		$display("x3 = %h",dut.u1.x3.out_data);
		$display("x4 = %h",dut.u1.x4.out_data);
		$display("current state = %b",dut.u6.cs);
		$display("next state = %b",dut.u6.ns);
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

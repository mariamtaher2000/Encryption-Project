module tb_tot();

	bit rst,clk;
	bit [4:0] input_data;
	bit input_AD_PT;
	bit constant;
	bit start_encryption;
	bit [4:0] output_data;
	bit padd_with_one;

	// inputs
	bit [63:0] IV = 64'h8040_0c06_0000_0000;
	bit [127:0] key = 128'h0000_0000_0000_0000_0000_0000_1215_3524;
	bit [127:0] nonce=128'hffff_ffff_ffff_ffff_ffff_ffff_c089_5e81;
	bit [63:0] A_data = 64'h0100_0010_0001_0000;
	bit [63:0] Plaintext = 64'h1492_2000_2562_100b;
	bit [63:0] padding = 64'h0000_0000_0000_0001;

	// Constant cr	
	bit [7:0] cnst6 [6] = { 8'h96, 8'h87, 8'h78, 8'h69, 8'h5a, 8'h4b };	
	bit [7:0] cnst12 [12] = { 8'hf0, 8'he1, 8'hd2, 8'hc3, 8'hb4, 8'ha5, 8'h96, 8'h87, 8'h78, 8'h69, 8'h5a, 8'h4b };
	int mem_file;
	
	// Clock generation
	always #5 clk =! clk;

  	// Instantiation 
  	ONE_ROUND_PERMUTATION #(1) dut (.rst(rst),.clk(clk),.input_data(input_data),.input_AD_PT(input_AD_PT),.constant(constant),
  									.start_encryption(start_encryption),.padd_with_one(padd_with_one),.output_data(output_data));

  
  	int  num1 = 63;
	int  num2 = 127;
	int  num3 = 7;
  

	initial begin

		mem_file = $fopen("indata_file.txt", "w"); 
		if (mem_file == 0) begin
            $fatal("Error opening file for writing");
        end
        
		rst = 0;
		repeat(3)@(negedge clk);
		rst = 1;
		// --------------Start initialization-------------
		@(negedge clk);
		start_encryption = 1;
		
		//@(posedge clk);
		//assert (dut.u9.iteration == 10);

      	for (int i = 0; i < 55 ; i++) begin		
      		input_data = { IV[num1], key[num2], key[num1], nonce[num2] , nonce[num1]};
      		$fwrite(mem_file, "%0b\n",input_data );
			@(negedge clk);
			num1 = num1 - 1;
			num2 = num2 - 1;
			input_data = { IV[num1], key[num2], key[num1], nonce[num2] , nonce[num1]};
			$fwrite(mem_file, "%0b\n",input_data );
		end
		//$display("current stateeeeeeeeeeeeeeeeeeeeeeeeeeeeee = %b,%t",dut.u6.cs,$time);
		

      	for (int j = 0; j < 8 ; j++) begin
			@(negedge clk);
			num1 = num1 - 1;
			num2 = num2 - 1;	
			input_data = { IV[num1], key[num2], key[num1], nonce[num2] , nonce[num1]};
			constant = cnst12[0][num3];
			num3 = num3 - 1;		
		end

		
		repeat(313) @(negedge clk);
		for (int j = 7 ; j >= 0 ; j--) begin
			//@(negedge clk);	
			constant = cnst12[1][j];	
			@(negedge clk);	
		end	
		constant = 0;

		repeat(127) @(negedge clk);
		
		///////////////////////////


		// --------------Other rounds with only constant---------------------
		for (int i = 2; i < (dut.u9.iteration +1) ; i++) begin

			repeat(312) @(negedge clk);

				for (int j = 7 ; j >= 0 ; j--) begin
					@(negedge clk);	
					constant = cnst12[i][j];	
				end	

			@(negedge clk)	constant = 0;
			repeat(127) @(negedge clk);
		end
		$display("sbox done %t",$time);
		// -----------------------------------------------------------------
		// --------------Final initialization-------------
		repeat(129) @(negedge clk);
		num1 = 63;
		for (int i = 0; i < 63 ; i++) begin		
      		input_AD_PT = A_data [num1];

			@(negedge clk);
			num1 = num1 - 1;
			input_AD_PT = A_data [num1];
		end

		repeat(120) @(negedge clk);
		
		for (int i = 7 ; i >= 0 ; i--) begin
			@(negedge clk);	
			constant = cnst6[0][i];	
		end


		$display("sbox done %t",$time);

		num2 = 127;
		@(negedge clk);
		for (int i = 0; i < 63 ; i++) begin		
      		input_data = { 1'b0, key[num2], 1'b0, 1'b0 , 1'b0};

			@(negedge clk);
			num2 = num2 - 1;
			input_data = { 1'b0, key[num2], 1'b0, 1'b0 , 1'b0};
		end

		$display("sbox done %t",$time);

		num1 = 63;
		@(negedge clk);
		for (int i = 0; i < 63 ; i++) begin		
      		input_data = { 1'b0, 1'b0, key[num1], 1'b0 , 1'b0};

			@(negedge clk);
			num1 = num1 - 1;
			input_data = { 1'b0, 1'b0, key[num1], 1'b0 , 1'b0};
		end


		//----------------------Start A_data --------------------------

		for (int i = 1; i < (dut.u9.iteration +1) ; i++) begin

			repeat(312) @(negedge clk);

				for (int j = 7 ; j >= 0 ; j--) begin
					@(negedge clk);	
					constant = cnst6[i][j];	
				end	

			@(negedge clk)	constant = 0;
			repeat(127) @(negedge clk);
		end



		//----------------------Final A_data----------------------------
		repeat(129) @(negedge clk);
		num1 = 63;
		for (int i = 0; i < 63 ; i++) begin		
      		input_AD_PT = Plaintext [num1];

			@(negedge clk);
			num1 = num1 - 1;
			input_AD_PT = Plaintext [num1];
		end

		repeat(120) @(negedge clk);
		
		for (int i = 7 ; i >= 0 ; i--) begin
			@(negedge clk);	
			constant = cnst6[0][i];	
		end


		repeat(65) @(negedge clk);

		num1 = 63;
		for (int i = 0; i < 63 ; i++) begin		
      		padd_with_one = padding [num1];

			@(negedge clk);
			num1 = num1 - 1;
			padd_with_one = padding [num1];
		end



		//----------------------Start plaintext ---------------------------
		for (int i = 1; i < (dut.u9.iteration +1) ; i++) begin

			repeat(312) @(negedge clk);

				for (int j = 7 ; j >= 0 ; j--) begin
					@(negedge clk);	
					constant = cnst6[i][j];	
				end	

			@(negedge clk)	constant = 0;
			repeat(127) @(negedge clk);
		end

		//----------------------Final plaintext----------------------------
		
		repeat(192) @(negedge clk);

		num2 = 127;
		@(negedge clk);
		for (int i = 0; i < 63 ; i++) begin		
      		input_data = { 1'b0, key[num2], 1'b0, 1'b0 , 1'b0};

			@(negedge clk);
			num2 = num2 - 1;
			input_data = { 1'b0, key[num2], 1'b0, 1'b0 , 1'b0};
		end


		num1 = 63;
		@(negedge clk);
		for (int i = 0; i < 55 ; i++) begin		
      		input_data = { 1'b0, 1'b0, key[num1], 1'b0 , 1'b0};

			@(negedge clk);
			num1 = num1 - 1;
			input_data = { 1'b0, 1'b0, key[num1], 1'b0 , 1'b0};
		end

		//@(negedge clk);
		
		for (int i = 7; i >= 0 ; i--) begin		
      		input_data = { 1'b0, 1'b0, key[num1], 1'b0 , 1'b0};
      		@(negedge clk) constant = cnst12[0][i];
		
			num1 = num1 - 1;
			input_data = { 1'b0, 1'b0, key[num1], 1'b0 , 1'b0};
			//constant = cnst12[0][i];
		end
		@(negedge clk) constant = 0;
		repeat(127) @(negedge clk);



		//----------------------Finalization----- ---------------------------
		
		start_encryption = 1'b0;

		for (int i = 1; i < (dut.u9.iteration +1) ; i++) begin

			repeat(312) @(negedge clk);

				for (int j = 7 ; j >= 0 ; j--) begin
					@(negedge clk);	
					constant = cnst12[i][j];	
				end	

			@(negedge clk)	constant = 0;
			repeat(127) @(negedge clk);
		end
		//----------------------Final Finalization----- ---------------------------

		
		repeat(320) @(negedge clk);
		
		/*for (int j = 7 ; j >= 0 ; j--) begin
			@(negedge clk);	
			constant = cnst12[i][j];	
		end*/

		num2 = 127;
		@(negedge clk);
		for (int i = 0; i < 63 ; i++) begin		
      		input_data = { 1'b0, key[num2], 1'b0, 1'b0 , 1'b0};

			@(negedge clk);
			num2 = num2 - 1;
			input_data = { 1'b0, key[num2], 1'b0, 1'b0 , 1'b0};
		end


		num1 = 63;
		@(negedge clk);
		for (int i = 0; i < 63 ; i++) begin		
      		input_data = { 1'b0, 1'b0, key[num1], 1'b0 , 1'b0};

			@(negedge clk);
			num1 = num1 - 1;
			input_data = { 1'b0, 1'b0, key[num1], 1'b0 , 1'b0};
		end
		




		


	end
  
  	initial begin
	    $dumpfile("test.vcd");
	    $dumpvars;
	    repeat(20000) @(negedge clk);
	    $fclose(mem_file);
		$stop;	
  	end

  	/*initial begin
  		$monitor("Output = %h",output_data);
  		$monitor("x0 = %h,%t",dut.u1.x0.out_data,$time);
		$monitor("x1 = %h,%t",dut.u1.x1.out_data,$time);
		$monitor("x2 = %h,%t",dut.u1.x2.out_data,$time);
		$monitor("x3 = %h,%t",dut.u1.x3.out_data,$time);
		$monitor("x3 = %h,%t",dut.u1.x4.out_data,$time);
  	end*/

endmodule 

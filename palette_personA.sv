module palette_personA(input [7:0] index, output logic [23:0] RGB);	

always_comb
	begin  
		unique case (index)
			8'b00000000 		: RGB = 24'h800080;
			8'b00000001 		: RGB = 24'h000101;
			8'b00000010 		: RGB = 24'h010300;
			8'b00000011 		: RGB = 24'h3d4137;
			8'b00000100 		: RGB = 24'h5c1b13;
			8'b00000101 		: RGB = 24'h332820;
			8'b00000110 		: RGB = 24'hcb896f;
			8'b00000111     : RGB = 24'ha54a06;
			8'b00001000     : RGB = 24'he7a688;
			8'b00001001     : RGB = 24'h6a6255;
			8'b00001010     : RGB = 24'h1a2224;
			8'b00001011     : RGB = 24'h1c2226;
			default  : RGB = 24'h000000;
			
		endcase
	end
endmodule	
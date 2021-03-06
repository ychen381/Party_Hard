module palette_background(input [7:0] index, output logic [23:0] RGB);	

always_comb
	begin  
		unique case (index)
			8'b00000000 		: RGB = 24'h800080;
			8'b00000001 		: RGB = 24'h000000;
			8'b00000010 		: RGB = 24'hebeee3;
			8'b00000011 		: RGB = 24'hffffff;
			8'b00000100 		: RGB = 24'h6d6d6d;
			8'b00000101 		: RGB = 24'h323232;
			8'b00000110 		: RGB = 24'h58646b;
			8'b00000111     : RGB = 24'h593c3c;
			8'b00001000     : RGB = 24'h886c47;
			8'b00001001     : RGB = 24'hac997f;
			8'b00001010     : RGB = 24'hc4ba90;
			8'b00001011     : RGB = 24'hbf9e4c;
			8'b00001100     : RGB = 24'hbc9027;
			8'b00001101     : RGB = 24'h595a3c;
			8'b00001110     : RGB = 24'heed111;
			8'b00001111     : RGB = 24'h708938;
			8'b00010000    : RGB = 24'h91ae51;
			8'b00010001    : RGB = 24'hc7d6cf;
			8'b00010010    : RGB = 24'h55656f;
			8'b00010011    : RGB = 24'hc1e1f2;
			default  : RGB = 24'h000000;
			
		endcase
	end
endmodule	
module palette_police(input [7:0] index, output logic [23:0] RGB);	

always_comb
	begin  
		unique case (index)
			8'b00000000 		: RGB = 24'h800080;
			8'b00000001 		: RGB = 24'h000000;
			8'b00000010 		: RGB = 24'he6e6e6;
			8'b00000011 		: RGB = 24'h505050;
			8'b00000100 		: RGB = 24'hd8d8d8;
			8'b00000101 		: RGB = 24'h6f6d82;
			8'b00000110 		: RGB = 24'h44484e;
			8'b00000111       : RGB = 24'hbf9783;
			8'b00001000     	: RGB = 24'hdca388;
			8'b00001001     	: RGB = 24'he5b5a1;
			8'b00001010     	: RGB = 24'h6b6657;
			8'b00001011     	: RGB = 24'haea990;
			8'b00001100     	: RGB = 24'hcdc29b;
			8'b00001101     	: RGB = 24'h63758b;
			8'b00001110     	: RGB = 24'h17314b;
			8'b00001111     	: RGB = 24'h26537b;
			8'b00010000    	: RGB = 24'h7a859b;
			8'b00010001    	: RGB = 24'h2a2f51;
			8'b00010010    	: RGB = 24'h1f1948;
			8'b00010011    	: RGB = 24'h7b6d87;
			8'b00010100    	: RGB = 24'h260939;
			default  			: RGB = 24'h000000;
			
		endcase
	end
endmodule	
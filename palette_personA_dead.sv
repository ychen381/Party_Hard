module palette_personA_dead(input [7:0] index, output logic [23:0] RGB);	

always_comb
	begin  
		unique case (index)
			8'b00000000 		: RGB = 24'h800080;
			8'b00000001 		: RGB = 24'h000000;
			8'b00000010 		: RGB = 24'h120000;
			8'b00000011 		: RGB = 24'h020903;
			8'b00000100 		: RGB = 24'h625952;
			8'b00000101 		: RGB = 24'h3f3c35;
			8'b00000110 		: RGB = 24'h5d5b4d;
			8'b00000111     : RGB = 24'h525a4c;
			8'b00001000     : RGB = 24'h333c34;
			8'b00001001     : RGB = 24'h421414;
			8'b00001010     : RGB = 24'h64534a;
			8'b00001011     : RGB = 24'h996452;
			8'b00001100		 : RGB = 24'he69e8b;
			8'b00001101     : RGB = 24'h88420c;
			8'b00001110     : RGB = 24'h3f1418;
			8'b00001111     : RGB = 24'ha83f00;
			8'b00010000     : RGB = 24'h201f2b;
			8'b00010001     : RGB = 24'hff0000;
			default  : RGB = 24'h000000;
			
		endcase
	end
endmodule	
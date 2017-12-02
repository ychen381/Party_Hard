module palette_yiquan(input [4:0] index, output logic [23:0] RGB);	

always_comb
	begin  
		unique case (index)
			5'b00000 		: RGB = 24'h800080;
			5'b00001 		: RGB = 24'hfccfcc;
			5'b00010 		: RGB = 24'hcfebfe;
			5'b00011 		: RGB = 24'hd7ecfe;
			5'b00100 		: RGB = 24'he0f1ff;
			5'b00101 		: RGB = 24'hfff3ec;
			5'b00110 		: RGB = 24'hfdfdfd;
			5'b00111     : RGB = 24'h1b1b1b;
			5'b01000     : RGB = 24'hf81d12;
			5'b01001     : RGB = 24'hebd1c4;
			5'b01010     : RGB = 24'heed4c7;
			5'b01011     : RGB = 24'h2b1b09;
			5'b01100     : RGB = 24'hffbf80;
			5'b01101     : RGB = 24'hffe78d;
			5'b01110     : RGB = 24'hfafecb;
			5'b01111     : RGB = 24'hc0e1fc;
			5'b10000    : RGB = 24'h996633;
			5'b10001    : RGB = 24'hffcc66;
			default  : RGB = 24'h000000;
			
		endcase
	end
endmodule	
module SRAM(input [9:0] DrawX, DrawY, output logic [19:0] ADDR);
		
		
		always_comb
				begin 						
					ADDR = DrawY * 10'd640 + DrawX;
				end
endmodule

/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  policeRAM
(
		input [18:0] read_address,
		input Clk,

		output logic [4:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [4:0] mem [0:1399];

initial
begin
	 $readmemh("C:/Users/Jackliu016/Documents/GitHub/Party_Hard/police.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule

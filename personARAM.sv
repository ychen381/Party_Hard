/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  personARAM
(
		input [18:0] read_address,
		input Clk,

		output logic [4:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [3:0] mem [0:1919];

initial
begin
	 $readmemh("C:/Users/Jackliu016/Desktop/lab8/personA.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule

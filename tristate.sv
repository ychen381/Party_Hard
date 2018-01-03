module tristate #(N = 16) (
	input logic Clk, 
	output logic [N-1:0] Data_read, // Data to Mem2IO
	inout wire [N-1:0] Data // inout bus to SRAM
);

// Registers are needed between synchronized circuit and asynchronized SRAM 
logic [N-1:0] Data_read_buffer;

always_ff @(posedge Clk)
begin

	Data_read_buffer <= Data;
	
end

// Assign Data_read_buffer to output Data_read
assign Data_read = Data_read_buffer;

endmodule
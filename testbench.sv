module testbench();

timeunit 10ns;
timeprecision 1ns;

logic [18:0] read_address;
logic Clk;
logic [23:0] data_Out;

police_car_RAM ram0(.*);

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin : CLOCK_INITILIAZATION
	Clk = 0;
end

initial begin : TEST_VECTORS
	read_address = 19'b0;
	
	#10 read_address = 10'd140;
end

endmodule

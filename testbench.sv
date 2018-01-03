module testbench();

timeunit 10ns;
timeprecision 1ns;

logic Clk, Reset, on_call, frame_clk, police_back;
logic [9:0] police_car_X, police_car_Y;
logic police_out, complete, reset_corpse;

police_car police_car0(.*);

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin : CLOCK_INITILIAZATION
	Clk = 0;
end

initial begin : TEST_VECTORS
	Reset = 0;
	on_call = 0;
	police_back = 0;
	
	#3 Reset = 0;
	#3 Reset = 0;
	#10 on_call = 1;
	#100 police_back = 1;
	#100 on_call = 0;
end

endmodule

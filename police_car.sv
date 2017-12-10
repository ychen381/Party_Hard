module  police_car ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
									  on_call,
                             frame_clk,          // The clock indicating a new frame (~60Hz)
									  police_back,
					output[9:0]  police_car_X, police_car_Y,
					output logic police_out, complete, reset_corpse
              );

    parameter [9:0] police_car_X_Step=1;      // Step size on the X axis
    parameter [9:0] police_car_Y_Step=1;      // Step size on the Y axis

    logic [9:0] police_car_X_Pos, police_car_X_Motion, police_car_Y_Pos, police_car_Y_Motion;
    logic [9:0] police_car_X_Pos_in, police_car_X_Motion_in;
	 logic [9:0] police_car_Y_Pos_in, police_car_Y_Motion_in;
	 
	 assign police_car_X = police_car_X_Pos;
	 assign police_car_Y = police_car_Y_Pos;

	 //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed;
    logic frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
    end
    assign frame_clk_rising_edge = (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    // Update ball position and motion
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            police_car_X_Pos <= 10'd640;
            police_car_Y_Pos <= 10'd450;
            police_car_X_Motion <= 10'd0;
            police_car_Y_Motion <= 10'd0;
        end
        else if (frame_clk_rising_edge)        // Update only at rising edge of frame clock
        begin
            police_car_X_Pos <= police_car_X_Pos_in;
            police_car_Y_Pos <= police_car_Y_Pos_in;
            police_car_X_Motion <= police_car_X_Motion_in;
            police_car_Y_Motion <= police_car_Y_Motion_in;
        end
        // By defualt, keep the register values.
    end

    //Start of the police_car FSM

	 enum logic [2:0] {Wait, start, arrive, Continue} State, Next_state;

	 always_ff @ (posedge Clk)
	 begin: Assign_Next_State
			if(Reset)
				State <= Wait;
			else
				State <= Next_state;
	 end

	 always_comb
	 begin
			Next_state = State;

			unique case(State)
			Wait:
				if(on_call)
					Next_state = start;
				else
					Next_state = Wait;
			start:
				if(police_car_X_Pos == 10'd320)
					Next_state = arrive;
				else
					Next_state = start;
			arrive:
				if(police_back == 1)
					Next_state = Continue;
				else
					Next_state = arrive;
			Continue:
				if(police_car_X_Pos == 10'd0)
					Next_state = Wait;
				else
					Next_state = Continue;
			default:;
			endcase
	 end

	 always_comb
	 begin
			complete = 1'b0;
			police_out = 1'b0;
			police_car_X_Motion_in = police_car_X_Motion;
			police_car_Y_Motion_in = police_car_Y_Motion;
			police_car_X_Pos_in = police_car_X_Pos + police_car_X_Motion;
			police_car_Y_Pos_in = police_car_Y_Pos + police_car_Y_Motion;
			reset_corpse = 1'b0;
			case(State)
				Wait:
				begin
					complete = 1'b1;
					police_car_X_Motion_in = 1'b0;
					police_car_Y_Motion_in = 1'b0;
					police_car_X_Pos_in = 12'd640;
					police_car_Y_Pos_in = 10'd450;
				end
				start:
				begin
					complete = 1'b0;
					police_car_X_Motion_in = (~(police_car_X_Step) + 1'b1);
				end
				arrive:
				begin
					complete = 1'b0;
					police_car_X_Motion_in = 0;
					police_out = 1'b1;
				end
				Continue:
				begin
					complete = 1'b1;
					reset_corpse = 1'b1;
					police_car_X_Motion_in = (~(police_car_X_Step) + 1'b1);
				end
			endcase
		end



endmodule

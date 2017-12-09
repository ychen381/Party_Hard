//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  personA ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
									  killed,
                             frame_clk,          // The clock indicating a new frame (~60Hz)
									  left,
									  corpse_discovered,
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
            // Whether current pixel belongs to ball or backgroun
					output[9:0]  ballX, ballY,
					output police_needed
					
              );
    
    parameter [9:0] Ball_X_Center=400;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=250;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=100;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=400;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=200;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=250;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
    parameter [9:0] Ball_Size=4;        // Ball size
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
    
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size;
    assign DistX = DrawX - Ball_X_Pos;
    assign DistY = DrawY - Ball_Y_Pos;
    assign Size = Ball_Size;
	 assign ballX = Ball_X_Pos;
	 assign ballY = Ball_Y_Pos;
	 logic wander_logic, not_moving_logic;
	 
	 enum logic [4:0] {wander, not_moving, discover_corpse, call_police, dead} State, Next_state;
	 
	 always_ff @ (posedge Clk)
	 begin: Assign_Next_State
			if(Reset)
				State <= not_moving;
			else
				State <= Next_state;
	 end
	 
	 always_comb
	 begin
			Next_state = State;
			
			unique case(State)
			not_moving: 
				Next_state = wander;
			wander:
				if(killed)
					Next_state = dead;
				else if(corpse_discovered)
					Next_state = discover_corpse;
				else
					Next_state = wander;
			dead:
				Next_state = dead;
			discover_corpse:
				if(killed)
					Next_state = dead;
				else
					Next_state = call_police;
			call_police:
				if(left)
					Next_state = wander;
				else
					Next_state = call_police;
			default:;
			endcase
	 end
	 
	 always_comb
	 begin
			not_moving_logic = 0;
			wander_logic = 0;
			police_needed = 0;
			
			case(State)
				not_moving:
					begin
						not_moving_logic = 1;
					end
				wander:
					begin
						wander_logic = 1;
					end
				discover_corpse:
					begin
						not_moving_logic = 1;
					end
				dead:
					begin
						not_moving_logic = 1;
					end
				call_police:
					begin
						not_moving_logic = 1;
						police_needed = 1;
					end
			endcase
		end
			
    
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
            Ball_X_Pos <= Ball_X_Center;
            Ball_Y_Pos <= Ball_Y_Center;
            Ball_X_Motion <= 10'd0;
            Ball_Y_Motion <= Ball_Y_Step;
        end
		  /*else if (killed)
		  begin
				Ball_X_Motion <= 10'd0;
				Ball_Y_Motion <= 10'd0;
		  end*/
        else if (frame_clk_rising_edge)        // Update only at rising edge of frame clock
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
            Ball_X_Motion <= Ball_X_Motion_in;
            Ball_Y_Motion <= Ball_Y_Motion_in;
        end
        // By defualt, keep the register values.
    end
    
    // You need to modify always_comb block.
    always_comb
    begin
        // Update the ball's position with its motion
        Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
        Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
    
        // By default, keep motion unchanged
		  Ball_X_Motion_in = Ball_X_Motion;
		  Ball_Y_Motion_in = Ball_Y_Motion;
		  
		  if(not_moving_logic)
		  begin
				Ball_X_Motion_in = 0;
				Ball_Y_Motion_in = 0;
		  end
		  
		  if(wander_logic)
		  begin
				if(Ball_X_Pos == Ball_X_Max && Ball_Y_Pos < Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
				begin
					Ball_Y_Motion_in = 1;
					Ball_X_Motion_in = 0;
				end
				else if(Ball_X_Pos > Ball_X_Min && Ball_Y_Pos == Ball_Y_Max)
				begin
					Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);  // 2's complement. 
					Ball_Y_Motion_in = 0;
				end
				else if(Ball_X_Pos == Ball_X_Min && Ball_Y_Pos > Ball_Y_Min)
				begin
					Ball_X_Motion_in = 0;
					Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);
				end
				else if(Ball_Y_Pos == Ball_Y_Min && Ball_X_Pos < Ball_X_Max)
				begin
					Ball_X_Motion_in = 1;
					Ball_Y_Motion_in = 0;
				end
				
				
		  end
        
    end
    
endmodule

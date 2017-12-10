// Code your design here
module gamestate(input Reset, frame_clk,gameover_caught,gameover_score,scoring,
						input [7:0] key,
					  output ready,
					  output lost,
					  output [10:0] totalscore,
					  output [3:0] hextotal,hextotal2);
					  
enum logic [3:0] {Start, Playing,Game_Over}   State, Next_state;   // Internal state logic
logic ready,lost_game;
logic [10:0] score_total;
logic [3:0] hex_score, hex_score2;


  always_ff @ (posedge Reset or posedge frame_clk  )
    begin : Assign_Next_State
        if (Reset) 
            State <= Start;
        else 
  
				
            State <= Next_state;
    end	


//NEXT STAte
	always_comb
    begin 
	    Next_state  = State;

	 
        unique case (State)
            Start : 
              if (key == 8'h28)//press enter to play
						Next_state <= Playing;					  
            Playing : 
              if(gameover_score || gameover_caught)
						Next_state <= Game_Over;
						
				Game_Over: 
                  if(key==8'h28)//press enter to restart
                    	Next_state<=Start;
          			else
                      	Next_state<=Game_Over;
     
            
			default : ;

	     endcase
    end	
	

	always_ff @ (posedge Reset or posedge frame_clk  )
    begin 

		rdy = 0;
		hex_score = hex_score;
		score_total = 0;
		lost_game=0;
		 
	    case (State)
			Start : 
				begin 

					score_total = 0;
					hex_score = 0;
					hex_score2 = 0;
					ready = 0;
					
					lost_game=0;
				end
			Playing : 
				begin
				
				if(scoring)
				begin
					score_total++;
					hex_score= hex_score + 1;
					hex_score2= hex_score2;
				end
				
				
				if(hex_score >= 'd10)
					begin
						hex_score = 0;
						hex_score2 = hex_score2 + 1;
					
					end
				
				
				ready = 1;
				lost_game=0;
				end
			Game_Over : 
				begin 
	
					ready = 0;
					hex_score = hex_score;
					score_total = score_total;
					hex_score2= hex_score2;
					lost_game=1;
         end
        
          default : ;
           
			  
		endcase
		
	
       
	end 	

		assign rdy = ready;
		assign totalscore = score_total;
		assign hextotal = hex_score;
		assign hextotal2 = hex_score2;
		assign lost= lost_game;
	
endmodule

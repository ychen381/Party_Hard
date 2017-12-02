// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input Clk,          // Whether current pixel belongs to ball 
                                                              //   or background (computed in ball.sv)
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
							  input        [9:0] ballX, ballY, personA_X, personA_Y, police_car_X, police_car_Y,
							  input        left_out, attack_out,
							  input        Reset,
                       output logic [7:0] VGA_R, VGA_G, VGA_B, // VGA RGB output
							  output logic personA_killed
                     );
    
    logic [7:0] Red, Green, Blue;
	 logic is_ball, is_ball_left, is_ball_attack, is_personA, is_police_car;
	 //yiquan rgb
	 logic [23:0] yiRGB;
	 //background rgb
	 logic [23:0] backgroundRGB, yileftRGB, yiattackRGB, yiattackleftRGB, personARGB;
	 logic [23:0] personA_dead_RGB;
	 //ram_out
	 logic [4:0] yiRam, yileftRam, yiattackRam, yiattackleftRam, personARam;
	 logic [4:0] personA_dead_Ram;
	 logic [7:0] backgroundRam;
	 //yiquan int
	 int yiMemX, yiMemY, yiX, yiY, draw_x, draw_y;
	 assign draw_x = DrawX;
	 assign draw_y = DrawY;
	 assign yiX = ballX;
	 assign yiY = ballY;
	 parameter [9:0] yiWidth = 10'd40;
	 parameter [9:0] yiHeight = 10'd60;
	 assign yiMemX = DrawX-(yiX-yiWidth/2);
	 assign yiMemY = DrawY-(yiY-yiHeight/2);
	 
	 //background int
	 parameter [9:0] backgroundWidth = 10'd640;
	 
	 //personA int
	 int personAMemX, personAMemY, personAX, personAY;
	 assign personAX = personA_X;
	 assign personAY = personA_Y;
	 parameter [9:0] personAWidth = 10'd30;
	 parameter [9:0] personAHeight = 10'd64;
	 assign personAMemX = DrawX-(personA_X-personAWidth/2);
	 assign personAMemY = DrawY-(personA_Y-personAHeight/2);
	 
	 //personA_dead int
	 int personA_dead_MemX, personA_dead_MemY;
	 parameter [9:0] personA_dead_Width = 10'd60;
	 parameter [9:0] personA_dead_Height = 10'd10;
	 assign personA_dead_MemX = DrawX-(personA_X-personA_dead_Width/2);
	 assign personA_dead_MemY = DrawY-(personA_Y-personA_dead_Height/2);
	 
	 //police_car_int
	 int police_car_MemX, police_car_MemY;
	 logic [23:0] police_car_RGB;
	 parameter [9:0] police_car_Width = 10'd70;
	 parameter [9:0] police_car_Height = 10'd28;
	 assign police_car_MemX = DrawX-(police_car_X-police_car_Width/2);
	 assign police_car_MemY = DrawY-(police_car_Y-police_car_Height/2);
	 
	 
	 //Read from on-chip memory
	 frameRAM yiquan0(.read_address(yiMemY*yiWidth+yiMemX), .Clk(Clk), .data_Out(yiRam));
	 //backgroundRAM background0(.read_address(draw_y*backgroundWidth+draw_x), .Clk(Clk), .data_Out(backgroundRam));
	 yiquanleftRAM yiquanleft0(.read_address(yiMemY*yiWidth+yiMemX), .Clk(Clk), .data_Out(yileftRam));
	 yiquanattackRAM yiquanattack0(.read_address(yiMemY*yiWidth+yiMemX), .Clk(Clk), .data_Out(yiattackRam));
	 yiquanattackleftRAM yiquanattackleft0(.read_address(yiMemY*yiWidth+yiMemX), .Clk(Clk), .data_Out(yiattackleftRam));
	 personARAM personA0(.read_address(personAMemY*personAWidth+personAMemX), .Clk(Clk), .data_Out(personARam));
	 personA_dead_RAM personA_dead0(.read_address(personA_dead_MemY*personA_dead_Width+personA_dead_MemX), 
	 .Clk(Clk), .data_Out(personA_dead_Ram));
	 police_car_RAM police_car0(.read_address(police_car_MemY*police_car_Width+police_car_MemX), 
	 .Clk(Clk), .data_Out(police_car_RGB));
	 
	 //palette
	 palette_yiquan yiquan1(.index(yiRam), .RGB(yiRGB));
	 palette_yiquan yiquanleft1(.index(yileftRam), .RGB(yileftRGB));
	 //palette_background background1(.index(backgroundRam), .RGB(backgroundRGB));
	 palette_yiquan yiquanattack1(.index(yiattackRam), .RGB(yiattackRGB));
	 palette_yiquan yiquanattackleft1(.index(yiattackleftRam), .RGB(yiattackleftRGB));
	 palette_personA personA1(.index(personARam), .RGB(personARGB));
	 palette_personA_dead personA_dead1(.index(personA_dead_Ram), .RGB(personA_dead_RGB));
	 
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
	 
	 logic personA_killed_in, is_personA_killed;
	 assign personA_killed_in = personA_killed;
	 
	 always_ff @ (posedge Clk)
	 begin
			personA_killed <= personA_killed_in;
			if(Reset)
			begin
				personA_killed <= 1'b0;
			end
			if(((ballX + 10'd20 >= personA_X - 10'd12 && ballX + 10'd20 <= personA_X + 10'd12 
			&& ballY >= personA_Y - 10'd28 && ballY<=personA_Y+10'd28 && left_out == 1'b0) || 
			(ballX - 10'd20 >= personA_X - 10'd12 && ballX - 10'd20 <= personA_X + 10'd12 
			&& ballY >= personA_Y - 10'd28 && ballY<=personA_Y+10'd28 && left_out == 1'b1)) && attack_out == 1'b1)
			begin
				personA_killed <= 1'b1;
			end
	 end
	 
	 always_comb
	 begin
			is_ball = 1'b0;
			is_ball_left = 1'b0;
			is_ball_attack = 1'b0;
			is_personA = 1'b0;
			is_personA_killed = 1'b0;
			is_police_car = 1'b0;
			if(DrawX >= ballX - 10'd20 && DrawX <= ballX + 10'd20 && DrawY >= ballY - 10'd30 && DrawY<=ballY+10'd30
			&& yiRGB != 24'h800080 && left_out == 1'b0 && attack_out == 1'b0)
			begin
				is_ball = 1'b1;
				is_ball_left = 1'b0;
				is_ball_attack = 1'b0;
			end
			if(DrawX >= ballX - 10'd20 && DrawX <= ballX + 10'd20 && DrawY >= ballY - 10'd30 && DrawY<=ballY+10'd30
			&& yileftRGB != 24'h800080 && left_out == 1'b1 && attack_out == 1'b0)
			begin
				is_ball_left = 1'b1;
				is_ball = 1'b0;
				is_ball_attack = 1'b0;
			end
			if(DrawX >= ballX - 10'd20 && DrawX <= ballX + 10'd20 && DrawY >= ballY - 10'd30 && DrawY<=ballY+10'd30
			&& yiattackRGB != 24'h800080 && left_out == 1'b0 && attack_out == 1'b1)
			begin
				is_ball = 1'b1;
				is_ball_left = 1'b0;
				is_ball_attack = 1'b1;
			end
			if(DrawX >= ballX - 10'd20 && DrawX <= ballX + 10'd20 && DrawY >= ballY - 10'd30 && DrawY<=ballY+10'd30
			&& yiattackleftRGB != 24'h800080 && left_out == 1'b1 && attack_out == 1'b1)
			begin
				is_ball_left = 1'b1;
				is_ball = 1'b0;
				is_ball_attack = 1'b1;
			end
			if(DrawX >= personA_X - 10'd15 && DrawX <= personA_X + 10'd15 && DrawY >= personA_Y - 10'd32 && DrawY<=personA_Y+10'd32
			&& personARGB != 24'h800080 && personA_killed == 1'b0)
			begin
				is_personA = 1'b1;
				//is_personA_killed = 1'b0;
			end
			if(DrawX >= personA_X - 10'd30 && DrawX <= personA_X + 10'd30 && DrawY >= personA_Y - 10'd5 && DrawY<=personA_Y+10'd5
			&& personA_dead_RGB != 24'h800080 && personA_killed == 1'b1)
			begin
				is_personA_killed = 1'b1;
			end
			if(DrawX >= police_car_X - 10'd35 && DrawX <= police_car_X + 10'd35 && 
			DrawY >= police_car_Y - 10'd14 && DrawY<=police_car_Y+10'd14 && police_car_RGB != 24'h000000)
			begin
				is_police_car = 1'b1;
			end
			
	 end
    
    // Assign color based on is_ball signal
    always_comb
    begin
        if (is_ball_left == 1'b0 && is_ball == 1'b1 && is_ball_attack == 1'b0) 
        begin
            // White ball
            Red = yiRGB[23:16];
            Green = yiRGB[15:8];
            Blue = yiRGB[7:0];
        end
		  else if(is_ball == 1'b0 && is_ball_left == 1'b1 && is_ball_attack == 1'b0)
		  begin
				Red = yileftRGB[23:16];
            Green = yileftRGB[15:8];
            Blue = yileftRGB[7:0];
		  end
		  else if(is_ball == 1'b1 && is_ball_left == 1'b0 && is_ball_attack == 1'b1)
		  begin
				Red = yiattackRGB[23:16];
            Green = yiattackRGB[15:8];
            Blue = yiattackRGB[7:0];
		  end
		  else if(is_ball == 1'b0 && is_ball_left == 1'b1 && is_ball_attack == 1'b1)
		  begin
				Red = yiattackleftRGB[23:16];
            Green = yiattackleftRGB[15:8];
            Blue = yiattackleftRGB[7:0];
		  end
        else 
        begin
            // Background with nice color gradient
				if(is_personA == 1'b1)
				begin
					Red = personARGB[23:16];
					Green = personARGB[15:8];
					Blue = personARGB[7:0];
				end
				else if(is_personA_killed == 1'b1)
				begin
					Red = personA_dead_RGB[23:16];
					Green = personA_dead_RGB[15:8];
					Blue = personA_dead_RGB[7:0];
				end
				else if(is_police_car == 1'b1)
				begin
					Red = police_car_RGB[23:16];
					Green = police_car_RGB[15:8];
					Blue = police_car_RGB[7:0];
				end
				else
				begin
					Red = 8'h3f; 
					Green = 8'h00;
					Blue = 8'h7f - {1'b0, DrawX[9:3]};
					/*Red = backgroundRGB[23:16]; 
					Green = backgroundRGB[15:8];
					Blue = backgroundRGB[7:0];*/
				end
        end
    end 
    
endmodule

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input Clk,          // Whether current pixel belongs to ball 
                                                              //   or background (computed in ball.sv)
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
							  input        [9:0] ballX, ballY, personA_X, personA_Y, police_car_X, police_car_Y,
							  input        [9:0] police_X, police_Y, personB_X, personB_Y,
							  input			[9:0] personC_X, personC_Y,
							  input        left_out, attack_out,
							  input        Reset, police_out,
							  input        collected,reached,
							  input        game_start, lost, police_needed_A, police_needed_B,
							  input			personA_thought1, personA_thought2, personA_thought3,
							  input			[10:0]totalscore,
							  input        [23:0]RGB_Background,
							  input			corpse_removed_A, corpse_removed_B, corpse_removed_C, 
							  input			[9:0] personD_X, personD_Y, personE_X, personE_Y, personF_X, personF_Y, personG_X, personG_Y,
							  input			police_needed_D, police_needed_E, police_needed_F, police_needed_G, 
							  input			corpse_removed_D, corpse_removed_E, corpse_removed_F, corpse_removed_G,
                       output logic [7:0] VGA_R, VGA_G, VGA_B, // VGA RGB output							 
							  output logic [9:0] death_X, death_Y,
							  output logic personA_killed, personB_killed, personC_killed,
							  output logic personD_killed, personE_killed, personF_killed, personG_killed
                     );
    
    logic [7:0] Red, Green, Blue;
	 logic is_ball, is_ball_left, is_ball_attack, is_personA, is_police_car, is_personB,is_personA_afraid;
	 logic is_personC, is_personD, is_personE, is_personF, is_personG;
	 //yiquan rgb
	 logic [23:0] yiRGB;
	 //background rgb
	 logic [23:0] backgroundRGB, yileftRGB, yiattackRGB, yiattackleftRGB, personARGB;
	 logic [23:0] personA_dead_RGB, startRGB;
	 //ram_out
	 logic [4:0] yiRam, yileftRam, yiattackRam, yiattackleftRam, personARam, backgroundRam;
	 logic [4:0] personA_dead_Ram, startRam;
	 //yiquan int
	 int yiMemX, yiMemY, yiX, yiY, draw_x, draw_y;
	 assign draw_x = DrawX;
	 assign draw_y = DrawY;
	 assign yiX = ballX;
	 assign yiY = ballY;
	 parameter [9:0] yiWidth = 10'd28;
	 parameter [9:0] yiHeight = 10'd42;
	 assign yiMemX = DrawX-(yiX-yiWidth/2);
	 assign yiMemY = DrawY-(yiY-yiHeight/2);
	 
	 //background int
	 parameter [9:0] backgroundWidth = 10'd640;
	 
	 //personA int
	 int personAMemX, personAMemY, personAX, personAY;
	 assign personAX = personA_X;
	 assign personAY = personA_Y;
	 parameter [9:0] personAWidth = 10'd20;
	 parameter [9:0] personAHeight = 10'd44;
	 assign personAMemX = DrawX-(personA_X-personAWidth/2);
	 assign personAMemY = DrawY-(personA_Y-personAHeight/2);
	
	 
	 //personA_dead int
	 int personA_dead_MemX, personA_dead_MemY;
	 parameter [9:0] personA_dead_Width = 10'd60;
	 parameter [9:0] personA_dead_Height = 10'd10;
	 assign personA_dead_MemX = DrawX-(personA_X-personA_dead_Width/2);
	 assign personA_dead_MemY = DrawY-(personA_Y-personA_dead_Height/2);
	 
	 //personA_discover int
	 int personA_discover_MemX, personA_discover_MemY;
	 logic [23:0]personA_discover_RGB;
	 logic is_personA_discover;
	 parameter [9:0] personA_discover_Width = 10'd20;
	 parameter [9:0] personA_discover_Height = 10'd60;
	 assign personA_discover_MemX = DrawX-(personA_X-personA_discover_Width/2);
	 assign personA_discover_MemY = DrawY-(personA_Y-personA_discover_Height/2);
	 
	 //personA_discover int
	 int personA_thought_MemX, personA_thought_MemY;
	 logic [23:0]personA_thought1_RGB, personA_thought2_RGB, personA_thought3_RGB;
	 logic is_personA_thought1, is_personA_thought2, is_personA_thought3;
	 parameter [9:0] personA_thought_Width = 10'd20;
	 parameter [9:0] personA_thought_Height = 10'd60;
	 assign personA_thought_MemX = DrawX-(personA_X-personA_thought_Width/2);
	 assign personA_thought_MemY = DrawY-(personA_Y-personA_thought_Height/2);
	 
	 //police_car_int
	 int police_car_MemX, police_car_MemY;
	 logic [23:0] police_car_RGB;
	 parameter [9:0] police_car_Width = 10'd70;
	 parameter [9:0] police_car_Height = 10'd28;
	 assign police_car_MemX = DrawX-(police_car_X-police_car_Width/2);
	 assign police_car_MemY = DrawY-(police_car_Y-police_car_Height/2);
	 
	 //police_int
	 int police_MemX, police_MemY;
	 logic is_police;
	 logic[7:0] police_Ram;
	 logic[23:0] police_RGB;
	 parameter [9:0] police_Width = 10'd12;
	 parameter [9:0] police_Height = 10'd42;
	 assign police_MemX = DrawX-(police_X-police_Width/2);
	 assign police_MemY = DrawY-(police_Y-police_Height/2);
	 
	 //personB int
	 int personB_MemX, personB_MemY;
	 logic[7:0] personB_Ram;
	 logic[23:0] personB_RGB;
	 parameter [9:0] personB_Width = 10'd16;
	 parameter [9:0] personB_Height = 10'd44;
	 assign personB_MemX = DrawX-(personB_X-personB_Width/2);
	 assign personB_MemY = DrawY-(personB_Y-personB_Height/2);
	 
	 //personB_dead int
	 int personB_dead_MemX, personB_dead_MemY;
	 logic[7:0] personB_dead_Ram;
	 logic[23:0] personB_dead_RGB;
	 parameter [9:0] personB_dead_Width = 10'd74;
	 parameter [9:0] personB_dead_Height = 10'd18;
	 assign personB_dead_MemX = DrawX-(personB_X-personB_dead_Width/2);
	 assign personB_dead_MemY = DrawY-(personB_Y-personB_dead_Height/2);
	 
	 //personB_discover int
	 int personB_discover_MemX, personB_discover_MemY;
	 logic [23:0]personB_discover_RGB;
	 logic is_personB_discover;
	 parameter [9:0] personB_discover_Width = 10'd16;
	 parameter [9:0] personB_discover_Height = 10'd60;
	 assign personB_discover_MemX = DrawX-(personB_X-personB_discover_Width/2);
	 assign personB_discover_MemY = DrawY-(personB_Y-personB_discover_Height/2);
	 
	 //personC int
	 int personC_MemX, personC_MemY;
	 logic[23:0] personC_RGB;
	 parameter [9:0] personC_Width = 10'd22;
	 parameter [9:0] personC_Height = 10'd46;
	 assign personC_MemX = DrawX-(personC_X-personC_Width/2);
	 assign personC_MemY = DrawY-(personC_Y-personC_Height/2);
	 
	 //personC_dead int
	 int personC_dead_MemX, personC_dead_MemY;
	 logic[23:0] personC_dead_RGB;
	 parameter [9:0] personC_dead_Width = 10'd44;
	 parameter [9:0] personC_dead_Height = 10'd10;
	 assign personC_dead_MemX = DrawX-(personC_X-personC_dead_Width/2);
	 assign personC_dead_MemY = DrawY-(personC_Y-personC_dead_Height/2);
	 
	 //personD int
	 int personD_MemX, personD_MemY;
	 logic[23:0] personD_RGB;
	 parameter [9:0] personD_Width = 10'd12;
	 parameter [9:0] personD_Height = 10'd32;
	 assign personD_MemX = DrawX-(personD_X-personD_Width/2);
	 assign personD_MemY = DrawY-(personD_Y-personD_Height/2);
	 
	 //personD_dead int
	 int personD_dead_MemX, personD_dead_MemY;
	 logic[23:0] personD_dead_RGB;
	 parameter [9:0] personD_dead_Width = 10'd42;
	 parameter [9:0] personD_dead_Height = 10'd12;
	 assign personD_dead_MemX = DrawX-(personD_X-personD_dead_Width/2);
	 assign personD_dead_MemY = DrawY-(personD_Y-personD_dead_Height/2);
	 
	 //personE int
	 int personE_MemX, personE_MemY;
	 logic[23:0] personE_RGB;
	 parameter [9:0] personE_Width = 10'd40;
	 parameter [9:0] personE_Height = 10'd48;
	 assign personE_MemX = DrawX-(personE_X-personE_Width/2);
	 assign personE_MemY = DrawY-(personE_Y-personE_Height/2);
	 
	 //personE_dead int
	 int personE_dead_MemX, personE_dead_MemY;
	 logic[23:0] personE_dead_RGB;
	 parameter [9:0] personE_dead_Width = 10'd40;
	 parameter [9:0] personE_dead_Height = 10'd41;
	 assign personE_dead_MemX = DrawX-(personE_X-personE_dead_Width/2);
	 assign personE_dead_MemY = DrawY-(personE_Y-personE_dead_Height/2);
	 
	 //personF int
	 int personF_MemX, personF_MemY;
	 logic[23:0] personF_RGB;
	 parameter [9:0] personF_Width = 10'd26;
	 parameter [9:0] personF_Height = 10'd48;
	 assign personF_MemX = DrawX-(personF_X-personF_Width/2);
	 assign personF_MemY = DrawY-(personF_Y-personF_Height/2);
	 
	 //personG_dead int
	 int personF_dead_MemX, personF_dead_MemY;
	 logic[23:0] personF_dead_RGB;
	 parameter [9:0] personF_dead_Width = 10'd58;
	 parameter [9:0] personF_dead_Height = 10'd10;
	 assign personF_dead_MemX = DrawX-(personF_X-personF_dead_Width/2);
	 assign personF_dead_MemY = DrawY-(personF_Y-personF_dead_Height/2);
	 
	 //personG int
	 int personG_MemX, personG_MemY;
	 logic[23:0] personG_RGB;
	 parameter [9:0] personG_Width = 10'd26;
	 parameter [9:0] personG_Height = 10'd34;
	 assign personG_MemX = DrawX-(personG_X-personG_Width/2);
	 assign personG_MemY = DrawY-(personG_Y-personG_Height/2);
	 
	 //personG_dead int
	 int personG_dead_MemX, personG_dead_MemY;
	 logic[23:0] personG_dead_RGB;
	 parameter [9:0] personG_dead_Width = 10'd26;
	 parameter [9:0] personG_dead_Height = 10'd34;
	 assign personG_dead_MemX = DrawX-(personG_X-personG_dead_Width/2);
	 assign personG_dead_MemY = DrawY-(personG_Y-personG_dead_Height/2);
	 
	 //font int
	 logic shape_on;
	 logic[10:0] shape_x = 10;
	 logic[10:0] shape_y = 10;
	 logic[10:0] shape_size_x = 8;
	 logic[10:0] shape_size_y = 16;
	 logic[10:0] sprite_addr;
	 logic[10:0] sprite_data;
	 
	 font_rom(.addr(sprite_addr), .data(sprite_data));
	 
	 //font2 int
	 logic shape_on2;
	 logic[10:0] shape_x2 = 20;
	 logic[10:0] shape_y2 = 10;
	 logic[10:0] shape_size_x2 = 8;
	 logic[10:0] shape_size_y2 = 16;
	 logic[10:0] sprite_addr2;
	 logic[10:0] sprite_data2;
	 
	 font_rom(.addr(sprite_addr2), .data(sprite_data2));
	 
	 //font3 int
	 logic shape_on3;
	 logic[10:0] shape_x3 = 30;
	 logic[10:0] shape_y3 = 10;
	 logic[10:0] shape_size_x3 = 8;
	 logic[10:0] shape_size_y3 = 16;
	 logic[10:0] sprite_addr3;
	 logic[10:0] sprite_data3;
	 
	 font_rom(.addr(sprite_addr3), .data(sprite_data3));
	 
	 //font4 int
	 logic shape_on4;
	 logic[10:0] shape_x4 = 40;
	 logic[10:0] shape_y4 = 10;
	 logic[10:0] shape_size_x4 = 8;
	 logic[10:0] shape_size_y4 = 16;
	 logic[10:0] sprite_addr4;
	 logic[10:0] sprite_data4;
	 
	 font_rom(.addr(sprite_addr4), .data(sprite_data4));
	 
	 //font5 int
	 logic shape_on5;
	 logic[10:0] shape_x5 = 50;
	 logic[10:0] shape_y5 = 10;
	 logic[10:0] shape_size_x5 = 8;
	 logic[10:0] shape_size_y5 = 16;
	 logic[10:0] sprite_addr5;
	 logic[10:0] sprite_data5;
	 
	 font_rom(.addr(sprite_addr5), .data(sprite_data5));
	 
	 
	 
	 //Read from on-chip memory
	 frameRAM yiquan0(.read_address(yiMemY*yiWidth+yiMemX), .Clk(Clk), .data_Out(yiRam));
	 backgroundRAM background0(.read_address(draw_y*backgroundWidth+draw_x), .Clk(Clk), .data_Out(backgroundRam));
	 startRAM start0(.read_address(draw_y*backgroundWidth+draw_x), .Clk(Clk), .data_Out(startRam));
	 yiquanleftRAM yiquanleft0(.read_address(yiMemY*yiWidth+yiMemX), .Clk(Clk), .data_Out(yileftRam));
	 yiquanattackRAM yiquanattack0(.read_address(yiMemY*yiWidth+yiMemX), .Clk(Clk), .data_Out(yiattackRam));
	 yiquanattackleftRAM yiquanattackleft0(.read_address(yiMemY*yiWidth+yiMemX), .Clk(Clk), .data_Out(yiattackleftRam));
	 personARAM personA0(.read_address(personAMemY*personAWidth+personAMemX), .Clk(Clk), .data_Out(personARam));
	 personA_dead_RAM personA_dead0(.read_address(personA_dead_MemY*personA_dead_Width+personA_dead_MemX), 
	 .Clk(Clk), .data_Out(personA_dead_Ram));
	 personA_discover_RAM personA_discover0(.read_address(personA_discover_MemY*personA_discover_Width+personA_discover_MemX), 
	 .Clk(Clk), .data_Out(personA_discover_RGB));
	 personA_thought1_RAM personA_thought1_Ram(.read_address(personA_thought_MemY*personA_thought_Width+personA_thought_MemX), 
	 .Clk(Clk), .data_Out(personA_thought1_RGB));
	 personA_thought2_RAM personA_thought2_Ram(.read_address(personA_thought_MemY*personA_thought_Width+personA_thought_MemX), 
	 .Clk(Clk), .data_Out(personA_thought2_RGB));
	 personA_thought3_RAM personA_thought3_Ram(.read_address(personA_thought_MemY*personA_thought_Width+personA_thought_MemX), 
	 .Clk(Clk), .data_Out(personA_thought3_RGB));
	 
	 police_car_RAM police_car0(.read_address(police_car_MemY*police_car_Width+police_car_MemX), 
	 .Clk(Clk), .data_Out(police_car_RGB));
	 policeRAM police0(.read_address(police_MemY*police_Width+police_MemX), 
	 .Clk(Clk), .data_Out(police_Ram));
	 personBRAM personB0(.read_address(personB_MemY*personB_Width+personB_MemX), 
	 .Clk(Clk), .data_Out(personB_Ram));
	 personB_dead_RAM personB_dead0(.read_address(personB_dead_MemY*personB_dead_Width+personB_dead_MemX), 
	 .Clk(Clk), .data_Out(personB_dead_Ram));
	 personB_discover_RAM personB_discover0(.read_address(personB_discover_MemY*personB_discover_Width+
	 personB_discover_MemX), .Clk(Clk), .data_Out(personB_discover_RGB));
	 personCRAM personC0(.read_address(personC_MemY*personC_Width+personC_MemX), 
	 .Clk(Clk), .data_Out(personC_RGB));
	 personC_dead_RAM personC_dead0(.read_address(personC_dead_MemY*personC_dead_Width+personC_dead_MemX), 
	 .Clk(Clk), .data_Out(personC_dead_RGB));
	 personD_RAM personD0(.read_address(personD_MemY*personD_Width+personD_MemX), 
	 .Clk(Clk), .data_Out(personD_RGB));
	 personD_dead_RAM personD_dead0(.read_address(personD_dead_MemY*personD_dead_Width+personD_dead_MemX), 
	 .Clk(Clk), .data_Out(personD_dead_RGB));
	 personE_RAM personE0(.read_address(personE_MemY*personE_Width+personE_MemX), 
	 .Clk(Clk), .data_Out(personE_RGB));
	 personE_dead_RAM personE_dead0(.read_address(personE_dead_MemY*personE_dead_Width+personE_dead_MemX), 
	 .Clk(Clk), .data_Out(personE_dead_RGB));
	 personF_RAM personF0(.read_address(personF_MemY*personF_Width+personF_MemX), 
	 .Clk(Clk), .data_Out(personF_RGB));
	 personF_dead_RAM personF_dead0(.read_address(personF_dead_MemY*personF_dead_Width+personF_dead_MemX), 
	 .Clk(Clk), .data_Out(personF_dead_RGB));
	 personG_RAM personG0(.read_address(personG_MemY*personG_Width+personG_MemX), 
	 .Clk(Clk), .data_Out(personG_RGB));
	 personG_dead_RAM personG_dead0(.read_address(personG_dead_MemY*personG_dead_Width+personG_dead_MemX), 
	 .Clk(Clk), .data_Out(personG_dead_RGB));
	 
	 
	 //palette
	 palette_yiquan yiquan1(.index(yiRam), .RGB(yiRGB));
	 palette_yiquan yiquanleft1(.index(yileftRam), .RGB(yileftRGB));
	 palette_yiquan yiquanattack1(.index(yiattackRam), .RGB(yiattackRGB));
	 palette_yiquan yiquanattackleft1(.index(yiattackleftRam), .RGB(yiattackleftRGB));
	 palette_personA personA1(.index(personARam), .RGB(personARGB));
	 palette_personA_dead personA_dead1(.index(personA_dead_Ram), .RGB(personA_dead_RGB));
	 palette_police police1(.index(police_Ram), .RGB(police_RGB));
	 palette_personB personB1(.index(personB_Ram), .RGB(personB_RGB));
	 palette_personB_dead personB_dead1(.index(personB_dead_Ram), .RGB(personB_dead_RGB));
	 palette_background background1(.index(backgroundRam), .RGB(backgroundRGB));
	 palette_start start1(.index(startRam), .RGB(startRGB));
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
	 
	 logic personA_killed_in, is_personA_killed;
	 assign personA_killed_in = personA_killed;
	 logic personB_killed_in, is_personB_killed;
	 assign personB_killed_in = personB_killed;
	 logic personC_killed_in, is_personC_killed;
	 assign personC_killed_in = personC_killed;
	 logic personD_killed_in, is_personD_killed;
	 assign personD_killed_in = personD_killed;
	 logic personE_killed_in, is_personE_killed;
	 assign personE_killed_in = personE_killed;
	 logic personF_killed_in, is_personF_killed;
	 assign personF_killed_in = personF_killed;
	 logic personG_killed_in, is_personG_killed;
	 assign personG_killed_in = personG_killed;
	 
	 always_ff @ (posedge Clk)
	 begin
			personA_killed <= personA_killed_in;
			personB_killed <= personB_killed_in;
			personC_killed <= personC_killed_in;
			personD_killed <= personD_killed_in;
			personE_killed <= personE_killed_in;
			personF_killed <= personF_killed_in;
			personG_killed <= personG_killed_in;
			if(Reset)
			begin
				personA_killed <= 1'b0;
				personB_killed <= 1'b0;
				personC_killed <= 1'b0;
				personD_killed <= 1'b0;
				personE_killed <= 1'b0;
				personF_killed <= 1'b0;
				personG_killed <= 1'b0;
			end
			if(((ballX + 10'd14 >= personA_X - 10'd12 && ballX + 10'd14 <= personA_X + 10'd12 
			&& ballY >= personA_Y - 10'd28 && ballY<=personA_Y+10'd28 && left_out == 1'b0) || 
			(ballX - 10'd14 >= personA_X - 10'd12 && ballX - 10'd14 <= personA_X + 10'd12 
			&& ballY >= personA_Y - 10'd28 && ballY<=personA_Y+10'd28 && left_out == 1'b1)) && 
			attack_out == 1'b1)
			begin
				personA_killed <= 1'b1;
			end
			if(((ballX + 10'd14 >= personB_X - 10'd12 && ballX + 10'd14 <= personB_X + 10'd12 
			&& ballY >= personB_Y - 10'd28 && ballY<=personB_Y+10'd28 && left_out == 1'b0) || 
			(ballX - 10'd14 >= personB_X- 10'd12 && ballX - 10'd14 <= personB_X + 10'd12 
			&& ballY >= personB_Y - 10'd28 && ballY<=personB_Y+10'd28 && left_out == 1'b1)) && 
			attack_out == 1'b1)
			begin
				personB_killed <= 1'b1;
			end
			if(((ballX + 10'd14 >= personC_X - 10'd11 && ballX + 10'd14 <= personC_X + 10'd11 
			&& ballY >= personC_Y - 10'd23 && ballY<=personC_Y+10'd23 && left_out == 1'b0) || 
			(ballX - 10'd14 >= personC_X- 10'd11 && ballX - 10'd14 <= personC_X + 10'd11 
			&& ballY >= personC_Y - 10'd23 && ballY<=personC_Y+10'd23 && left_out == 1'b1)) && 
			attack_out == 1'b1)
			begin
				personC_killed <= 1'b1;
			end
			if(((ballX + 10'd14 >= personD_X - 10'd6 && ballX + 10'd14 <= personD_X + 10'd6 
			&& ballY >= personD_Y - 10'd16 && ballY<=personD_Y+10'd16 && left_out == 1'b0) || 
			(ballX - 10'd14 >= personD_X- 10'd6 && ballX - 10'd14 <= personD_X + 10'd6 
			&& ballY >= personD_Y - 10'd16 && ballY<=personD_Y+10'd16 && left_out == 1'b1)) && 
			attack_out == 1'b1)
			begin
				personD_killed <= 1'b1;
			end
			if(((ballX + 10'd14 >= personE_X - 10'd20 && ballX + 10'd14 <= personE_X + 10'd20 
			&& ballY >= personE_Y - 10'd24 && ballY<=personE_Y+10'd24 && left_out == 1'b0) || 
			(ballX - 10'd14 >= personE_X- 10'd20 && ballX - 10'd14 <= personE_X + 10'd20 
			&& ballY >= personE_Y - 10'd24 && ballY<=personE_Y+10'd24 && left_out == 1'b1)) && 
			attack_out == 1'b1)
			begin
				personE_killed <= 1'b1;
			end
			if(((ballX + 10'd14 >= personF_X - 10'd13 && ballX + 10'd14 <= personF_X + 10'd13 
			&& ballY >= personF_Y - 10'd24 && ballY<=personF_Y+10'd24 && left_out == 1'b0) || 
			(ballX - 10'd14 >= personF_X- 10'd13 && ballX - 10'd14 <= personF_X + 10'd13 
			&& ballY >= personF_Y - 10'd24 && ballY<=personF_Y+10'd24 && left_out == 1'b1)) && 
			attack_out == 1'b1)
			begin
				personF_killed <= 1'b1;
			end
			if(((ballX + 10'd14 >= personG_X - 10'd13 && ballX + 10'd14 <= personG_X + 10'd13 
			&& ballY >= personG_Y - 10'd17 && ballY<=personG_Y+10'd17 && left_out == 1'b0) || 
			(ballX - 10'd14 >= personG_X- 10'd13 && ballX - 10'd14 <= personG_X + 10'd13 
			&& ballY >= personG_Y - 10'd17 && ballY<=personG_Y+10'd17 && left_out == 1'b1)) && 
			attack_out == 1'b1)
			begin
				personG_killed <= 1'b1;
			end
	 end
	 
	 always_comb
	 begin
			death_X = 10'd0;
			death_Y = 10'd0;
			if(personA_killed == 1'b1 && corpse_removed_A == 1'b0)
			begin
				death_X = personA_X;
				death_Y = personA_Y;
			end
			else if(personB_killed == 1'b1 && corpse_removed_B == 1'b0)
			begin
				death_X = personB_X;
				death_Y = personB_Y;
			end
			else if(personC_killed == 1'b1 && corpse_removed_C == 1'b0)
			begin
				death_X = personC_X;
				death_Y = personC_Y;
			end
			else if(personD_killed == 1'b1 && corpse_removed_D == 1'b0)
			begin
				death_X = personD_X;
				death_Y = personD_Y;
			end
			else if(personE_killed == 1'b1 && corpse_removed_E == 1'b0)
			begin
				death_X = personE_X;
				death_Y = personE_Y;
			end
			else if(personF_killed == 1'b1 && corpse_removed_F == 1'b0)
			begin
				death_X = personF_X;
				death_Y = personF_Y;
			end
			else if(personG_killed == 1'b1 && corpse_removed_G == 1'b0)
			begin
				death_X = personG_X;
				death_Y = personG_Y;
			end
	 end
	 
	 always_comb
	 begin
			is_ball = 1'b0;
			is_ball_left = 1'b0;
			is_ball_attack = 1'b0;
			is_personA = 1'b0;
			is_personA_killed = 1'b0;
			is_personA_discover = 1'b0;
			is_personA_thought1 = 1'b0;
			is_personA_thought2 = 1'b0;
			is_personA_thought3 = 1'b0;
			is_police_car = 1'b0;
			is_police = 1'b0;
			is_personB = 1'b0;
			is_personB_killed = 1'b0;
			is_personB_discover = 1'b0;
			is_personC = 1'b0;
			is_personC_killed = 1'b0;
			is_personD = 1'b0;
			is_personD_killed = 1'b0;
			is_personE = 1'b0;
			is_personE_killed = 1'b0;
			is_personF = 1'b0;
			is_personF_killed = 1'b0;
			is_personG = 1'b0;
			is_personG_killed = 1'b0;
			shape_on = 1'b0;
			sprite_addr = 10'b0;
			shape_on2 = 1'b0;
			sprite_addr2 = 10'b0;
			shape_on3 = 1'b0;
			sprite_addr3 = 10'b0;
			shape_on4 = 1'b0;
			sprite_addr4 = 10'b0;
			shape_on5 = 1'b0;
			sprite_addr5 = 10'b0;
			if(DrawX >= shape_x && DrawX < shape_x + shape_size_x &&
		   	DrawY >= shape_y && DrawY < shape_y + shape_size_y)
			begin
				shape_on = 1'b1;
				sprite_addr = (DrawY - shape_y + 16*'h30);
			end
			else if(DrawX >= shape_x2 && DrawX < shape_x2 + shape_size_x2 &&
			DrawY >= shape_y2 && DrawY < shape_y2 + shape_size_y2)
			begin
				shape_on2 = 1'b1;
				if(totalscore == 11'd0)
					sprite_addr2 = (DrawY - shape_y2 + 16*'h30);
				if(totalscore == 11'd1)
					sprite_addr2 = (DrawY - shape_y2 + 16*'h31);
				if(totalscore == 11'd2)
					sprite_addr2 = (DrawY - shape_y2 + 16*'h32);
				if(totalscore == 11'd3)
					sprite_addr2 = (DrawY - shape_y2 + 16*'h33);
				if(totalscore == 11'd4)
					sprite_addr2 = (DrawY - shape_y2 + 16*'h34);
				if(totalscore == 11'd5)
					sprite_addr2 = (DrawY - shape_y2 + 16*'h35);
				if(totalscore == 11'd6)
					sprite_addr2 = (DrawY - shape_y2 + 16*'h36);
				if(totalscore == 11'd7)
					sprite_addr2 = (DrawY - shape_y2 + 16*'h37);
				if(totalscore == 11'd8)
					sprite_addr2 = (DrawY - shape_y2 + 16*'h38);
			end
			else if(DrawX >= shape_x3 && DrawX < shape_x3 + shape_size_x3 &&
		   DrawY >= shape_y3 && DrawY < shape_y3 + shape_size_y3)
			begin
				shape_on3 = 1'b1;
				sprite_addr3 = (DrawY - shape_y3 + 16*'h2f);
			end
			else if(DrawX >= shape_x4 && DrawX < shape_x4 + shape_size_x4 &&
		   DrawY >= shape_y4 && DrawY < shape_y4 + shape_size_y4)
			begin
				shape_on4 = 1'b1;
				sprite_addr4 = (DrawY - shape_y4 + 16*'h30);
			end
			else if(DrawX >= shape_x5 && DrawX < shape_x5 + shape_size_x5 &&
		   DrawY >= shape_y5 && DrawY < shape_y5 + shape_size_y5)
			begin
				shape_on5 = 1'b1;
				sprite_addr5 = (DrawY - shape_y5 + 16*'h38);
			end
			if(DrawX >= ballX - 10'd14 && DrawX <= ballX + 10'd14 && DrawY >= ballY - 10'd21 && DrawY<=ballY+10'd21
			&& yiRGB != 24'h800080 && left_out == 1'b0 && attack_out == 1'b0 && game_start == 0
			&& lost == 0)
			begin
				is_ball = 1'b1;
				is_ball_left = 1'b0;
				is_ball_attack = 1'b0;
			end
			if(DrawX >= ballX - 10'd14 && DrawX <= ballX + 10'd14 && DrawY >= ballY - 10'd21 && DrawY<=ballY+10'd21
			&& yileftRGB != 24'h800080 && left_out == 1'b1 && attack_out == 1'b0 && game_start == 0
			&& lost == 0)
			begin
				is_ball_left = 1'b1;
				is_ball = 1'b0;
				is_ball_attack = 1'b0;
			end
			if(DrawX >= ballX - 10'd14 && DrawX <= ballX + 10'd14 && DrawY >= ballY - 10'd21 && DrawY<=ballY+10'd21
			&& yiattackRGB != 24'h800080 && left_out == 1'b0 && attack_out == 1'b1 && game_start == 0
			&& lost == 0)
			begin
				is_ball = 1'b1;
				is_ball_left = 1'b0;
				is_ball_attack = 1'b1;
			end
			if(DrawX >= ballX - 10'd14 && DrawX <= ballX + 10'd14 && DrawY >= ballY - 10'd21 && DrawY<=ballY+10'd21
			&& yiattackleftRGB != 24'h800080 && left_out == 1'b1 && attack_out == 1'b1 && game_start == 0
			&& lost == 0)
			begin
				is_ball_left = 1'b1;
				is_ball = 1'b0;
				is_ball_attack = 1'b1;
			end
			if(DrawX >= personA_X - 10'd10 && DrawX <= personA_X + 10'd10 && DrawY >= personA_Y - 10'd22 && DrawY<=personA_Y+10'd22
			&& personARGB != 24'h800080 && personA_killed == 1'b0 && game_start == 0 && lost == 0 && police_needed_A == 1'b0 && 
			personA_thought1 == 1'b0 && personA_thought2 == 1'b0 && personA_thought3 == 1'b0)
			begin
				is_personA = 1'b1;
			end
			if(DrawX >= personA_X - 10'd30 && DrawX <= personA_X + 10'd30 && DrawY >= personA_Y - 10'd5 && DrawY<=personA_Y+10'd5
			&& personA_dead_RGB != 24'h800080 && personA_killed == 1'b1 && collected == 0 
			&& game_start == 0 && lost == 0 && police_needed_A == 1'b0 && personA_thought1 == 1'b0 && personA_thought2 == 1'b0
			&& personA_thought3 == 1'b0)
			begin
				is_personA_killed = 1'b1;
			end
			if(DrawX >= personA_X - 10'd10 && DrawX <= personA_X + 10'd10 && DrawY >= personA_Y - 10'd30 && DrawY<=personA_Y+10'd30
			&& personA_discover_RGB != 24'h000000 && personA_killed == 1'b0 && collected == 0 
			&& game_start == 0 && lost == 0 && police_needed_A == 1'b1 && personA_thought1 == 1'b0 && personA_thought2 == 1'b0
			&& personA_thought3 == 1'b0)
			begin
				is_personA_discover = 1'b1;
			end
			if(DrawX >= personA_X - 10'd10 && DrawX <= personA_X + 10'd10 && DrawY >= personA_Y - 10'd30 && DrawY<=personA_Y+10'd30
			&& personA_thought1_RGB != 24'h000000 && personA_killed == 1'b0 && collected == 0 
			&& game_start == 0 && lost == 0 && police_needed_A == 1'b0 && personA_thought1 == 1'b1 && personA_thought2 == 1'b0
			&& personA_thought3 == 1'b0)
			begin
				is_personA_thought1 = 1'b1;
			end
			if(DrawX >= personA_X - 10'd10 && DrawX <= personA_X + 10'd10 && DrawY >= personA_Y - 10'd30 && DrawY<=personA_Y+10'd30
			&& personA_thought2_RGB != 24'h000000 && personA_killed == 1'b0 && collected == 0 
			&& game_start == 0 && lost == 0 && police_needed_A == 1'b0 && personA_thought1 == 1'b0 && personA_thought2 == 1'b1
			&& personA_thought3 == 1'b0)
			begin
				is_personA_thought2 = 1'b1;
			end
			if(DrawX >= personA_X - 10'd10 && DrawX <= personA_X + 10'd10 && DrawY >= personA_Y - 10'd30 && DrawY<=personA_Y+10'd30
			&& personA_thought3_RGB != 24'h000000 && personA_killed == 1'b0 && collected == 0 
			&& game_start == 0 && lost == 0 && police_needed_A == 1'b0 && personA_thought1 == 1'b0 && personA_thought2 == 1'b0
			&& personA_thought3 == 1'b1)
			begin
				is_personA_thought3 = 1'b1;
			end
			if(DrawX >= police_car_X - 10'd35 && DrawX <= police_car_X + 10'd35 && 
			DrawY >= police_car_Y - 10'd14 && DrawY<=police_car_Y+10'd14 && police_car_RGB != 24'h000000
			&& game_start == 0 && lost == 0)
			begin
				is_police_car = 1'b1;
			end
			if(DrawX >= police_X - 10'd6 && DrawX <= police_X + 10'd6 && 
			DrawY >= police_Y - 10'd21 && DrawY<=police_Y+10'd21 && police_RGB != 24'h800080 && 
			police_out == 1'b1 && reached==0 && game_start == 0 && lost == 0)
			begin
				is_police = 1'b1;
			end
			if(DrawX >= personB_X - 10'd8 && DrawX <= personB_X + 10'd8 && DrawY >= personB_Y - 10'd22 && DrawY<=personB_Y+10'd22
			&& personB_RGB != 24'h800080 && personB_killed == 0 && game_start == 0 && lost == 0)
			begin
				is_personB = 1'b1;
			end
			if(DrawX >= personB_X - 10'd37 && DrawX <= personB_X + 10'd37 && DrawY >= personB_Y - 10'd9 && DrawY<=personB_Y+10'd9
			&& personB_dead_RGB!=24'h800080 && personB_killed == 1'b1 && game_start == 0 && lost == 0)
			begin
				is_personB_killed = 1'b1;
			end
			if(DrawX >= personB_X - 10'd8 && DrawX <= personB_X + 10'd8 && DrawY >= personB_Y - 10'd30 
			&& DrawY<=personB_Y+10'd30 && personB_discover_RGB != 24'h000000 && personB_killed == 1'b0 
			&& collected == 0 && game_start == 0 && lost == 0 && police_needed_B == 1'b1)
			begin
				is_personB_discover = 1'b1;
			end
			if(DrawX >= personC_X - 10'd11 && DrawX <= personC_X + 10'd11 && DrawY >= personC_Y - 10'd23 && DrawY<=personC_Y+10'd23
			&& personC_RGB != 24'h000000 && personC_killed == 0 && game_start == 0 && lost == 0)
			begin
				is_personC = 1'b1;
			end
			if(DrawX >= personC_X - 10'd22 && DrawX <= personC_X + 10'd22 && DrawY >= personC_Y - 10'd5 && DrawY<=personC_Y+10'd5
			&& personC_dead_RGB!=24'h000000 && personC_killed == 1'b1 && game_start == 0 && lost == 0)
			begin
				is_personC_killed = 1'b1;
			end
			if(DrawX >= personD_X - 10'd6 && DrawX <= personD_X + 10'd6 && DrawY >= personD_Y - 10'd16 && DrawY<=personD_Y+10'd16
			&& personD_RGB != 24'h000000 && personD_killed == 0 && game_start == 0 && lost == 0)
			begin
				is_personD = 1'b1;
			end
			if(DrawX >= personD_X - 10'd21 && DrawX <= personD_X + 10'd21 && DrawY >= personD_Y - 10'd6 && DrawY<=personD_Y+10'd6
			&& personD_dead_RGB!=24'h000000 && personD_killed == 1'b1 && game_start == 0 && lost == 0)
			begin
				is_personD_killed = 1'b1;
			end
			if(DrawX >= personE_X - 10'd20 && DrawX <= personE_X + 10'd20 && DrawY >= personE_Y - 10'd24 && DrawY<=personE_Y+10'd24
			&& personE_RGB != 24'h000000 && personE_killed == 0 && game_start == 0 && lost == 0)
			begin
				is_personE = 1'b1;
			end
			if(DrawX >= personE_X - 10'd20 && DrawX <= personE_X + 10'd20 && DrawY >= personE_Y - 10'd21 && DrawY<=personE_Y+10'd20
			&& personE_dead_RGB!=24'h000000 && personE_killed == 1'b1 && game_start == 0 && lost == 0)
			begin
				is_personE_killed = 1'b1;
			end
			if(DrawX >= personF_X - 10'd13 && DrawX <= personF_X + 10'd13 && DrawY >= personF_Y - 10'd24 && DrawY<=personF_Y+10'd24
			&& personF_RGB != 24'h000000 && personF_killed == 0 && game_start == 0 && lost == 0)
			begin
				is_personF = 1'b1;
			end
			if(DrawX >= personF_X - 10'd29 && DrawX <= personF_X + 10'd29 && DrawY >= personF_Y - 10'd5 && DrawY<=personF_Y+10'd5
			&& personF_dead_RGB!=24'h000000 && personF_killed == 1'b1 && game_start == 0 && lost == 0)
			begin
				is_personF_killed = 1'b1;
			end
			if(DrawX >= personG_X - 10'd13 && DrawX <= personG_X + 10'd13 && DrawY >= personG_Y - 10'd17 && DrawY<=personG_Y+10'd17
			&& personG_RGB != 24'h000000 && personG_killed == 0 && game_start == 0 && lost == 0)
			begin
				is_personG = 1'b1;
			end
			if(DrawX >= personG_X - 10'd13 && DrawX <= personG_X + 10'd13 && DrawY >= personG_Y - 10'd17 && DrawY<=personG_Y+10'd17
			&& personG_dead_RGB!=24'h000000 && personG_killed == 1'b1 && game_start == 0 && lost == 0)
			begin
				is_personG_killed = 1'b1;
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
				if(shape_on == 1'b1 && sprite_data[(shape_size_x-1) - (DrawX - shape_x)] == 1'b1)
				begin
					Red = 8'h00;
					Green = 8'h0;
					Blue = 8'h00;
				end
				else if(shape_on2 == 1'b1 && sprite_data2[(shape_size_x2-1) - (DrawX - shape_x2)] == 1'b1)
				begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00;
				end
				else if(shape_on3 == 1'b1 && sprite_data3[(shape_size_x3-1) - (DrawX - shape_x3)] == 1'b1)
				begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00;
				end
				else if(shape_on4 == 1'b1 && sprite_data4[(shape_size_x4-1) - (DrawX - shape_x4)] == 1'b1)
				begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00;
				end
				else if(shape_on5 == 1'b1 && sprite_data5[(shape_size_x5-1) - (DrawX - shape_x5)] == 1'b1)
				begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00;
				end
				else if(is_personA == 1'b1)
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
				else if(is_personA_discover == 1'b1)
				begin
					Red = personA_discover_RGB[23:16];
					Green = personA_discover_RGB[15:8];
					Blue = personA_discover_RGB[7:0];
				end
				else if(is_personA_thought1 == 1'b1)
				begin
					Red = personA_thought1_RGB[23:16];
					Green = personA_thought1_RGB[15:8];
					Blue = personA_thought1_RGB[7:0];
				end
				else if(is_personA_thought2 == 1'b1)
				begin
					Red = personA_thought2_RGB[23:16];
					Green = personA_thought2_RGB[15:8];
					Blue = personA_thought2_RGB[7:0];
				end
				else if(is_personA_thought3 == 1'b1)
				begin
					Red = personA_thought3_RGB[23:16];
					Green = personA_thought3_RGB[15:8];
					Blue = personA_thought3_RGB[7:0];
				end
				else if(is_police_car == 1'b1)
				begin
					Red = police_car_RGB[23:16];
					Green = police_car_RGB[15:8];
					Blue = police_car_RGB[7:0];
				end
				else if(is_police == 1'b1)
				begin
					Red = police_RGB[23:16];
					Green = police_RGB[15:8];
					Blue = police_RGB[7:0];
				end
				else if(is_personB == 1'b1)
				begin
					Red = personB_RGB[23:16];
					Green = personB_RGB[15:8];
					Blue = personB_RGB[7:0];
				end
				else if(is_personB_killed == 1'b1)
				begin
					Red = personB_dead_RGB[23:16];
					Green = personB_dead_RGB[15:8];
					Blue = personB_dead_RGB[7:0];
				end
				else if(is_personB_discover == 1'b1)
				begin
					Red = personB_discover_RGB[23:16];
					Green = personB_discover_RGB[15:8];
					Blue = personB_discover_RGB[7:0];
				end
				else if(is_personC == 1'b1)
				begin
					Red = personC_RGB[23:16];
					Green = personC_RGB[15:8];
					Blue = personC_RGB[7:0];
				end
				else if(is_personC_killed == 1'b1)
				begin
					Red = personC_dead_RGB[23:16];
					Green = personC_dead_RGB[15:8];
					Blue = personC_dead_RGB[7:0];
				end
				else if(is_personD == 1'b1)
				begin
					Red = personD_RGB[23:16];
					Green = personD_RGB[15:8];
					Blue = personD_RGB[7:0];
				end
				else if(is_personD_killed == 1'b1)
				begin
					Red = personD_dead_RGB[23:16];
					Green = personD_dead_RGB[15:8];
					Blue = personD_dead_RGB[7:0];
				end
				else if(is_personE == 1'b1)
				begin
					Red = personE_RGB[23:16];
					Green = personE_RGB[15:8];
					Blue = personE_RGB[7:0];
				end
				else if(is_personE_killed == 1'b1)
				begin
					Red = personE_dead_RGB[23:16];
					Green = personE_dead_RGB[15:8];
					Blue = personE_dead_RGB[7:0];
				end
				else if(is_personF == 1'b1)
				begin
					Red = personF_RGB[23:16];
					Green = personF_RGB[15:8];
					Blue = personF_RGB[7:0];
				end
				else if(is_personF_killed == 1'b1)
				begin
					Red = personF_dead_RGB[23:16];
					Green = personF_dead_RGB[15:8];
					Blue = personF_dead_RGB[7:0];
				end
				else if(is_personG == 1'b1)
				begin
					Red = personG_RGB[23:16];
					Green = personG_RGB[15:8];
					Blue = personG_RGB[7:0];
				end
				else if(is_personG_killed == 1'b1)
				begin
					Red = personG_dead_RGB[23:16];
					Green = personG_dead_RGB[15:8];
					Blue = personG_dead_RGB[7:0];
				end
				else
				begin
					if(game_start == 1 && lost == 0)
					begin
						Red = startRGB[23:16];
						Green = startRGB[15:8];
						Blue = startRGB[7:0];
					end
					else if(game_start == 0 && lost == 1)
					begin
						Red = 8'h66;
						Green = 8'h66;
						Blue = 8'h66;
					end
					else
					begin
						/*Red = 8'h3f; 
						Green = 8'h00;
						Blue = 8'h7f - {1'b0, DrawX[9:3]};*/
						Red = backgroundRGB[23:16]; 
						Green = backgroundRGB[15:8];
						Blue = backgroundRGB[7:0];
					end
				end
        end
    end 
    
endmodule

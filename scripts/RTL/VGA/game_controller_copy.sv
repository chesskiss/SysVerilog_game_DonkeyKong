// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2021 
//updated --Eyal Lev 2021


module	game_controller_copy	(	
			input	logic	clk,
			input	logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input	logic	monkeyDR,
			input	logic	ropeDR,
			input	logic	fruitsDR,
			input	logic	ropesDR,
			input	logic	floorsDR,
			input	logic	targetDR,
			input	logic	enemyDR,
			input logic starDR,
			input logic next_level,
			input	logic	[2:0]score,
			input logic one_sec,
			//Timer values
			input logic tc,
			
			output	logic win,
			output	logic lvl_indx,
			output	logic start_timer,
			output	logic failed,
				
			output logic collision_f_floor,
			output logic collision_f_ropes,// active in case of collision between two objects
			output logic collision_f_fruits,
			output logic collision_f_target,
			output logic collision_f_enemy,
			output logic collision_f_rope,
			output logic collision_f_star,
			output logic SingleHit_floor,
			output logic SingleHit_ropes,
			output logic SingleHit_fruits,
			output logic SingleHit_target,
			output logic SingleHit_star,
			output logic SingleHit_enemy// critical code, generating A single pulse in a frame 
);

//==----------------------------------------------------------------------------------------------------------------=
//levels controller!!! state machine decleration:
enum logic [2:0] {Slevel1, Slevel2, Swin, Slose} pres_st, next_st;
assign lvl_indx = pres_lvl;
int all_fruits_eaten;
int time_over_flag=1'b0;
int pres_lvl = 1'b0;
logic target_reached_d;

logic collision_floor;
logic collision_ropes;
logic collision_fruits;
logic collision_target;		
logic collision_enemy;
logic collision_rope;
logic collision_star;
logic star_lvl_flag;

assign collision_floor = monkeyDR && floorsDR; // 
assign collision_ropes = monkeyDR && ropesDR;
assign collision_fruits = monkeyDR && fruitsDR;
assign collision_target = monkeyDR && targetDR;
assign collision_enemy = monkeyDR && enemyDR;
assign collision_rope = monkeyDR && ropeDR;
assign collision_star = monkeyDR && starDR;
  

//logic [4:0] flag ; // a semaphore to set the output only once per frame / regardless of the number of collisions 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		collision_f_floor	<= 1'b0;
		collision_f_ropes	<= 1'b0;
		collision_f_fruits <= 1'b0;
		collision_f_target <= 1'b0;
		collision_f_enemy	<= 1'b0;
		collision_f_rope	<= 1'b0;
		collision_f_star	<= 1'b0;
		SingleHit_floor<= 1'b0 ;
		SingleHit_ropes<= 1'b0 ; 
		SingleHit_fruits<= 1'b0 ; 
		SingleHit_target<= 1'b0 ; 
		SingleHit_enemy<= 1'b0 ;
		SingleHit_star<= 1'b0 ;	
	end 
	else begin 

			SingleHit_floor<= 1'b0 ;
			SingleHit_ropes<= 1'b0 ; 
			SingleHit_fruits<= 1'b0 ; 
			SingleHit_target<= 1'b0 ; 
			SingleHit_enemy<= 1'b0 ; 
			SingleHit_star<= 1'b0 ;// default 
			
			
			
			
		if(startOfFrame) begin
			collision_f_floor	<= 1'b0;
			collision_f_ropes	<= 1'b0;
			collision_f_fruits <= 1'b0;
			collision_f_target <= 1'b0;
			collision_f_enemy	<= 1'b0; // reset for next time 
			collision_f_rope	<= 1'b0;
			collision_f_star	<= 1'b0;
		end 
//		change the section below  to collision between number and smiley


		if (collision_floor && collision_f_floor == 1'b0) begin 
					collision_f_floor	<= 1'b1; // to enter only once 
					SingleHit_floor <= collision_floor ; 
				end ; 
				
		if (collision_ropes && collision_f_ropes == 1'b0) begin 
					collision_f_ropes	<= 1'b1; // to enter only once 
					SingleHit_ropes <= collision_ropes ; 
				end ; 
				
		if (collision_fruits && collision_f_fruits == 1'b0) begin 
					collision_f_fruits	<= 1'b1; // to enter only once 
					SingleHit_fruits <= collision_fruits ; 
				end ; 
					
		if (collision_target && collision_f_target == 1'b0) begin 
					collision_f_target	<= 1'b1; // to enter only once 
					SingleHit_target <= collision_target ; 
				end ; 
					
		if (collision_enemy && collision_f_enemy == 1'b0) begin 
					collision_f_enemy	<= 1'b1; // to enter only once 
					SingleHit_enemy <= collision_enemy ;
				end ; 
		if (collision_rope && collision_f_rope == 1'b0) begin 
					collision_f_rope	<= 1'b1; // to enter only once 
					//SingleHit_rope <= collision_ropes ; 
				end ; 
		
		if (collision_star && collision_f_star == 1'b0) begin 
					collision_f_star	<= 1'b1; // to enter only once 
					SingleHit_star <= collision_star ;
		end ;
	
	end //else begin
end //always ff
	
//--------------------------------------------------------------------------------------------
//  1.  syncronous code:  executed once every clock to update the current state 
always @(posedge clk or negedge resetN)
  begin
	   
   if ( !resetN ) begin // Asynchronic reset
		pres_st <= Slevel1;
		target_reached_d <= 1'b0;
		star_lvl_flag <= 1'b0;
	end
   
	else begin 		// Synchronic logic FSM
		pres_st <= next_st;
		target_reached_d <= next_level;
		if(next_st == Slevel2 && pres_st ==Slevel1)
			star_lvl_flag <= 1'b0;
		if(collision_f_star)
			star_lvl_flag <= 1'b1;
	end
end // always sync




//--------------------------------------------------------------------------------------------

//  2.  asynchornous code: logically defining what is the next state, and the ouptput 
//      							(not seperating to two different always sections)  	
always_comb // Update next state and outputs
	begin
	// set all default values 
		next_st = pres_st; 
		start_timer = 1'b1;
		failed = 1'b0;
		win = 1'b0;
		pres_lvl = 1'b0;
		
			
		case (pres_st)

			Slevel1: begin
				pres_lvl = 1'b0;
				if(tc) begin
					next_st = Slose;
				end
			
				else if(next_level && !target_reached_d) 
					if((star_lvl_flag && score >= 3'b010) || score >= 3'b100) begin
							next_st = Slevel2;
						end
				
			end // Slevel1

			Slevel2: begin
				
				win = 1'b0;
				pres_lvl = 1'b1;
				if(tc) begin
					next_st = Slose;
				end
			
				else if(next_level && !target_reached_d) 
				if((star_lvl_flag && score >= 3'b010) || score >= 3'b100) begin
					next_st = Swin;
				end
			end // Slevel2	

			Slose: begin
				
				failed = 1'b1;
				win = 1'b0;
				next_st = Slose;
				
			end
			
			Swin: begin
			
				failed = 1'b0;
				win = 1'b1;
				next_st = Swin;


			end // Swin


			
						
		endcase
		
	end // always comb

endmodule

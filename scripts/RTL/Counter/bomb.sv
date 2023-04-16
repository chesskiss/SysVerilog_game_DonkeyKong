// (c) Technion IIT, Department of Electrical Engineering 2018 
// 
// Implements the state machine of the bomb mini-project
// FSM, with present and next states

module bomb
	(
	input logic clk, 
	input logic resetN, 
	input logic startN, 
	input logic waitN, 
	input logic OneSecPulse, 
	input logic timerEnd,
	
	output logic countLoadN, 
	output logic countEnable, 
	output logic lampEnable,
	output logic allLampOn
   );

//-------------------------------------------------------------------------------------------

// state machine decleration 
	enum logic [2:0] {Sidle, Sarm, Srun, Spause, SlampOff, SlampOn, Sdelay } pres_st, next_st;
 	
//--------------------------------------------------------------------------------------------
//  1.  syncronous code:  executed once every clock to update the current state 
always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN )  // Asynchronic reset
		pres_st <= Sidle;
   
	else 		// Synchronic logic FSM
		pres_st <= next_st;
		
	end // always sync
	
//--------------------------------------------------------------------------------------------
//  2.  asynchornous code: logically defining what is the next state, and the ouptput 
//      							(not seperating to two different always sections)  	
always_comb // Update next state and outputs
	begin
	// set all default values 
		next_st = pres_st; 
		countEnable = 1'b0;
		countLoadN = 1'b1;
		lampEnable = 1'b1;
		allLampOn = 1'b0;

			
		case (pres_st)
				
			Sidle: begin
				lampEnable = 1'b0;
				if (startN == 1'b0) 
					next_st = Sarm; 
				end // idle
						
			Sarm: begin
			
				countLoadN = 1'b0;
				if(startN)
					next_st = Srun;
				
				end // arm
					
			Srun: begin
				
				countEnable = 1'b1;
				if(!waitN)
					next_st = Spause;
				if(timerEnd)
					next_st = SlampOn;
					
				
				end // run
			
		/*	
			Srun: begin
				
				countEnable = 1'b1;
				if(timerEnd || !waitN)
					next_st = SlampOn;
					
				
				end // run */

					
			/*Spause: begin
				
				next_st = waitN ? Srun : Spause;
				
				end // pause

			*/ 
			Spause: begin
				
				next_st = waitN ? Sdelay : Spause;
			
				end
				
			Sdelay : begin
			
				if(OneSecPulse)
					next_st = Srun;
				
				end

			
						
			SlampOff: begin
					
					lampEnable = 1'b0;
					if(OneSecPulse)
						next_st = SlampOn; 
					
				end // lampOff
				
			SlampOn: begin
					
					allLampOn = 1'b1;
					if(OneSecPulse)
						next_st = SlampOff; 
						
				end // lampOn
						
						
		endcase
	end // always comb
	
endmodule

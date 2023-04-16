// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2021 
//updated --Eyal Lev 2021


module	game_controller	(	
			input	logic	clk,
			input	logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input	logic	monkeyDR,
			input	logic	ropeDR,
			input	logic	fruitsDR,
			input	logic	ropesDR,
			input	logic	floorsDR,
			input	logic	goalDR,
			
			output logic [0:2]collision, // active in case of collision between two objects
			output logic [0:2]SingleHitPulse // critical code, generating A single pulse in a frame 
);

/*
Collisions types:


collision[2] = floor and monkey
collision[1] = ropes and monkey
collision[0] = fruits and monkey
collision[3] = target and monkey

*/

				
assign collision[0] = monkeyDR && floorsDR; // 
assign collision[1] = monkeyDR && ropesDR;
assign collision[2] = monkeyDR && fruitsDR;

logic [2:0] flag ; // a semaphore to set the output only once per frame / regardless of the number of collisions 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag	<= 3'b0;
		SingleHitPulse <= 3'b0 ; 
	end 
	else begin 

			SingleHitPulse <= 3'b0 ; // default 
			if(startOfFrame) 
				flag <= 1'b0 ; // reset for next time 
				
//		change the section below  to collision between number and smiley


if (collision[0] && flag[0] == 1'b0) begin 
			flag[0]	<= 1'b1; // to enter only once 
			SingleHitPulse[0] <= collision[0] ; 
		end ; 
		
if (collision[1] && flag[1] == 1'b0) begin 
			flag[1]	<= 1'b1; // to enter only once 
			SingleHitPulse[1] <= collision[1] ; 
		end ; 
		
if (collision[0] && flag[2] == 1'b0) begin 
			flag[2]	<= 1'b1; // to enter only once 
			SingleHitPulse[2] <= collision[2] ; 
		end ; 
	end 
end

endmodule

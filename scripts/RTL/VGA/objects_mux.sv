
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021

module	objects_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
		   // monkey 
					input		logic	monkeyDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] monkeyRGB, 
			
			// target
					input		logic	targetDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] targetRGB, 

			// score
					input    logic scoreDrawingRequest, // box of numbers
					input		logic	[7:0] scoreRGB, 
					
			// star
					input    logic starDrawingRequest, // box of numbers
					input		logic	[7:0] starRGB, 
					
			// enemy
					input		logic	enemyDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] enemyRGB, 
					
			 // rope 
					input		logic	ropeDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] ropeRGB, 
			
		  // fruits
					input    logic fruitsDrawingRequest, // box of numbers
					input		logic	[7:0] fruitsRGB, 
					
			// win lose
					input		logic win,
					input		logic lose,
					input		logic	winDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] winRGB, 
					input		logic	loseDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] loseRGB,
			  
		  ////////////////////////
		  // background 
		  
		  // floors
					input    logic floorDrawingRequest, // box of numbers
					input		logic	[7:0] floorRGB,   
		 // ropes
					input    logic ropesDrawingRequest, // box of numbers
					input		logic	[7:0] ropesRGB, 
					
		// numbers
					input    logic number1DrawingRequest, // box of numbers
					input		logic	[7:0] number1RGB,
					
					input    logic number2DrawingRequest, // box of numbers
					input		logic	[7:0] number2RGB,
		
					input		logic	[7:0] backGroundRGB, 
			  
				   output	logic	[7:0] RGBOut
);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBOut	<= 8'b0;
	end
	
	else begin
	
	if( win || lose) begin
		if (win && winDrawingRequest)
			RGBOut <= winRGB;
			else if (lose && loseDrawingRequest)
				RGBOut <= loseRGB;
					else
						RGBOut <= backGroundRGB ;
	end
		
	else begin
		if (monkeyDrawingRequest == 1'b1 )   
			RGBOut <= monkeyRGB;  //first priority
			
			else if (scoreDrawingRequest)
				RGBOut <= scoreRGB;
			
				else if (targetDrawingRequest == 1'b1)
					RGBOut <= targetRGB;
					
					else if (starDrawingRequest)
						RGBOut <= starRGB;
					
						else if (enemyDrawingRequest == 1'b1 )   
								RGBOut <= enemyRGB;
							
							else if (ropeDrawingRequest == 1'b1 )   
								RGBOut <= ropeRGB;  
						 
								else if(fruitsDrawingRequest == 1'b1 )   
									RGBOut <= fruitsRGB;  
									
									else if(ropesDrawingRequest == 1'b1 )   
										RGBOut <= ropesRGB; 
									
										else if(floorDrawingRequest == 1'b1 )   
											RGBOut <= floorRGB; 
								 
											else if (number1DrawingRequest == 1'b1)
													RGBOut <= number1RGB;
													
													else if (number2DrawingRequest == 1'b1)
														RGBOut <= number2RGB;
														
														else 
															RGBOut <= backGroundRGB ; // last priority 
		end // else win lose
	end ; 
end

endmodule



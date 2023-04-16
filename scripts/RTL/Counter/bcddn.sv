// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By Liat Schwartz August 2018 

// Implements a BCD down counter 99 to 0 with enable and loadN data
// having countL, countH and tc outputs
// by instantiating two one bit down-counters


module bcddn
	(
	input  logic clk, 
	input  logic resetN, 
	input  logic loadN, 
	input  logic ena, 
	input  logic ena_cnt, 
	
	output logic [3:0] countL, 
	output logic [3:0] countH,
	output logic tc
   );

// Parameters defined as external, here with a default value - to be updated 
// in the top hierarchy graphic file with the bomb down counting values
// -----------------------------------------------------------
	parameter  logic [3:0] datainL = 4'h2 ; 
	parameter  logic [3:0] datainH = 4'h1 ;
// -----------------------------------------------------------
	
	logic  tclow, tchigh;// internal variables terminal count 
	
// Low counter instantiation
	down_counter lowc(.clk(clk), 
							.resetN(resetN),
							.loadN(loadN),	
							.ena(ena), 
							.ena_cnt(ena_cnt), 
							.datain(datainL), 
							.count(countL), 
							.tc(tclow) );
	
// High counter instantiation
	down_counter highc(.clk(clk), 
	.resetN(resetN),
							.loadN(loadN),	
							.ena(ena), 
							.ena_cnt(tclow && countH), 
							.datain(datainH), 
							.count(countH), 
							.tc(tchigh)   
							  );
	
  
 
	assign tc = (countL==0 && countH==0) ? 1:0 ;  // fill your code here   

endmodule

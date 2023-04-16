// (c) Technion IIT, Department of Electrical Engineering 2018 

// Implements a 4 bits down counter 9 to 0 with enable, enable count and loadN data.
// It outputs count and asynchronous terminal count, tc, signal 

module down_counter
	(
	input logic clk, 
	input logic resetN, 
	input logic loadN, 
	input logic ena,
	input logic ena_cnt, 
	input logic [3:0] datain,
	
	output logic [3:0] count,
	output logic tc
   );

// Down counter
always_ff @(posedge clk or negedge resetN)
   begin
	      
      if ( !resetN )	begin// Asynchronic reset
			
		 count = 4'b1111;	// fill your code here
			
		end
				
      else 	begin	// Synchronic logic		
		if(!loadN)
			begin		// fill your code here
			count[3:0] <= datain[3:0];
			end
		else begin
				if(ena_cnt && ena) begin
					if(count==4'h0) begin
						count <= 4'h9;
					end 
					else begin
						count <= count-1;
					end
				end
			end
		end //Synch
	end //always

  	
	
	// Asynchronic tc
	
	assign tc = (count == 4'b0000) ? 1 : 0; // fill your code here

		
	
endmodule

module REG16B (a, clk, q);
	
	input[15:0] a;
	input clk;
	
	output[15:0] q;
	
	reg[15:0] q;
	
	always @(posedge clk) 
		q <= a ;
		
endmodule
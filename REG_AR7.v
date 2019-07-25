module REG_AR7 (data, sel, clk, q);
	
	input[15:0] data;
	input[2:0] sel;
	input clk;
	
	output[15:0] q;
	
	reg[15:0] ramdata[0:7];
	
	always @(posedge clk)
		ramdata[sel] <= data ;
	
	assign q = ramdata[sel] ;
	
endmodule
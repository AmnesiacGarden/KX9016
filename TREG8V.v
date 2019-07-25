module TREG8V (a, en, clk, rst, q);
	
	input[15:0] a;
	input rst, clk, en;
	
	output[15:0] q;
	
	reg[15:0] q, val;
	
	always @(posedge clk or posedge rst)
		if (rst==1'b1) val <= {16{1'b0}} ;
			else val <= a ;
	always @(en or val)
		if (en==1'b1) q <= val ;
			else q <= 16'bzzzzzzzzzzzzzzzz ;
			
endmodule
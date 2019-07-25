module PCnt(sload, data, clk, aclr, q);
	
	input[15:0] data;
	input sload, clk, aclr;
	
	output[15:0] q;
	
	reg[15:0] q;
	
	always @(posedge clk or posedge aclr) begin
		if (aclr==1) q <= 0 ;
			else if (sload==1) q <= data ;
						else q <= q + 1 ;
	end
	
endmodule
module REG_B (rst, clk, load, d, q);
	
	input[15:0] d;
	input rst, clk, load;
	
	output[15:0] q;
	
	reg[15:0] q;
	
	always @(posedge clk or posedge rst) begin
		if (rst==1'b1) q <= {16{1'b0}} ;
			else begin
					if (load==1'b1) q <= d;
					end
	end
	
endmodule
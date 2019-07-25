module SFT4A (a, sel, y);
	
	input[15:0] a;
	input[2:0] sel;
	
	output[15:0] y;
	
	reg[15:0] y;
	
	parameter shftpass = 0,
				 sftl     = 1,
				 sftr     = 2,
				 rotl     = 3,
				 rotr     = 4;
				
	always @(a or sel) begin
		case (sel)
			shftpass : y <= a ; //数据直通 
         sftl     : y <= {a[14:0], 1'b0} ; //左移
         sftr     : y <= {1'b0, a[15:1]} ; //右移
         rotl     : y <= {a[14:0], a[15]} ; //循环左移
         rotr     : y <= {a[0], a[15:1]} ; //循环右移
		  default : y <= 0 ;
		endcase
	end
	
endmodule
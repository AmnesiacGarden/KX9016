module CMP_V (a, b, sel, compout);
	
	input[15:0] a, b;
	input[2:0] sel;
	
	output compout;
	
	reg compout;
	
	parameter eq  = 0,
				 neq = 1,
				 gt  = 2,
				 gte = 3,
				 lt  = 4,
				 lte = 5;
	always @(a or b or sel) begin
		case (sel)
			eq  : if (a==b) compout <= 1; else compout <= 0 ; //a等于b,输出为1
			neq : if (a!=b) compout <= 1; else compout <= 0 ; //a不等于b,输出为1
			gt  : if (a>b) compout <= 1; else compout <= 0 ; //a大于b,输出为1
			gte : if (a>=b) compout <= 1; else compout <= 0 ; //a大于等于b,输出为1
			lt  : if (a<b) compout <= 1; else compout <= 0 ; //a小于b,输出为1
			lte : if (a<=b) compout <= 1; else compout <= 0 ; //a小于等于b,输出为1
		  default : compout <= 0;
		endcase 
	end

endmodule
module ALUV (a, b, sel, c);

	input[15:0] a, b;
	input[3:0] sel;
	
	output[15:0] c;
	
	reg[15:0] c;
	
	parameter alupass = 0,
				 andOp   = 1,
				 orOp    = 2,
				 notOp   = 3,
				 xorOp   = 4,
				 plus    = 5,
				 alusub  = 6,
				 inc     = 7,
				 dec     = 8,
				 zero    = 9;
				 
	always @(a or b or sel) begin
		case (sel)
			alupass : c <= a ; //总线数据直通ALU
			andOp   : c <= a & b ; //逻辑与操作	 
			orOp    : c <= a | b ; //逻辑或操作
         notOp   : c <= a ^ b ; //逻辑异或操作
         xorOp   : c <= ~a ; //取反操作
         plus    : c <= a + b ; //算数加操作
         alusub  : c <= a - b ; //算数减操作
         inc     : c <= a + 1 ; //加1操作
         dec     : c <= a - 1 ; //减1操作
         zero    : c <= 0 ; //输出清0
		 default : c <= 0;
		endcase 	
	end
	
endmodule
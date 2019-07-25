module CONTRLA(clock,reset,instrReg,compout,progCntrWr,progCntrRd,addrRegWr,addrRegRd,outRegWr,outRegRd,shiftSel,aluSel,compSel,opRegRd,opRegWr,instrWr,regSel,regRd,regWr,rw,vma);

	input clock; 
	input reset;
	input[15:0]instrReg;
	input compout;
	
	output progCntrWr;
	output progCntrRd;
	output addrRegWr;
	output addrRegRd;
	output outRegWr;
	output outRegRd;
	output [2:0]shiftSel;output [3:0]aluSel;output [2:0]compSel;
	output opRegRd;
	output opRegWr;
	output instrWr;
	output [2:0] regSel;
	output regRd;
	output regWr;
	output rw;
	output vma;
	
	reg progCntrWr,progCntrRd,addrRegWr,addrRegRd,outRegWr,outRegRd,opRegRd,opRegWr,instrWr,regRd,regWr,rw,vma;
	reg [2:0]shiftSel,regSel;
	reg[3:0]aluSel;
	reg[4:0]current_state,next_state;
	
	wire [2:0]compSel;
	
	parameter shftpass=0,alupass=0,zero=9,inc=7,plus=5;
	parameter reset1=0,reset2=1,reset3=2,execute=3,nop=4,
			    load=5,store=6,load2=7,load3=8,load4=9,
				 store2=10,store3=11,store4=12,
				 incPc=13,incPc2=14,incPc3=15,
				 loadI2=19,loadI3=20,loadI4=21,loadI5=22,loadI6=23,
				 inc2=24,inc3=25,inc4=26,
				 move1=27,move2=28,
				 add2=29,add3=30,add4=31;
	
	always@(current_state or instrReg or compout) begin
		progCntrWr <=0 ;
		progCntrRd <=0 ;
		addrRegWr  <=0 ;
		addrRegRd  <=0 ;
		outRegWr   <=0 ;
		outRegRd   <=0 ;
		opRegRd    <=0 ;
		opRegWr    <=0 ;
		instrWr    <=0 ;
		regSel     <=0 ;
		regRd      <=0 ;
		regWr      <=0 ;
		rw         <=0 ;
		vma        <=0 ;
		
		shiftSel <= shftpass ;
		aluSel   <= alupass ;
		
		case (current_state)
			reset1: begin aluSel     <= zero ;
							  shiftSel   <= shftpass ;
			              outRegWr   <= 1'b1 ;
							  next_state <= reset2 ;
			        end
			
			reset2: begin outRegRd   <= 1'b1 ;
							  progCntrWr <= 1'b1 ;
							  addrRegWr  <= 1'b1 ;
							  next_state <= reset3 ;
			        end
					  
			reset3: begin vma        <= 1'b1 ;
			              rw         <= 1'b0 ;
							  instrWr    <= 1'b1 ;
			              next_state <= execute ;
			        end
			
			execute:
				begin
					case(instrReg[15:11])
						5'b00000:next_state <= incPc ;//NOP
						5'b00001:next_state <= load2 ;//LD
						5'b00010:next_state <= store2 ;//STA
						5'b00100:begin
						progCntrRd <= 1'b1 ;
						aluSel     <= inc ;
						shiftSel   <= shftpass ;
						next_state <= loadI2 ;
				end
			5'b00111:next_state <= inc2 ;
			5'b01101:next_state <= add2 ;
			5'b00011:next_state <= move1 ;
		  default:next_state <= incPc ;
		
		endcase
	end
	
		load2:begin regSel     <= instrReg[5:3] ;
					   regRd      <= 1'b1 ;
					   addrRegWr  <= 1'b1 ;
						next_state <= load3 ;
				end
				
		load3:begin vma        <= 1'b1 ;
		            rw         <= 1'b0 ;
		            regSel     <= instrReg[2:0] ;
		            regWr      <=1'b1 ;
		            next_state <= incPc ;
		      end
		
		add2:begin regSel     <= instrReg[5:3] ;
		           regRd      <= 1'b1 ;
		           next_state <= add3 ;
		           opRegWr    <= 1'b1 ;
		     end
		
		add3:begin regSel<=instrReg[2:0];
		           regRd<=1'b1;
		           aluSel<=plus;
	              shiftSel<=shftpass;
		           opRegWr<=1'b1;
		           next_state<=add4;
		     end
		
		add4:begin regSel<=3'b011;outRegRd<=1'b1;
		regWr<=1'b1;next_state<=incPc;
		end
		
		move1:begin regSel<=instrReg[5:3];regRd<=1'b1;aluSel<=alupass;
		shiftSel<=shftpass;outRegWr<=1'b1;next_state<= move2;
		end
		
		move2:begin regSel<=instrReg[2:0];outRegRd<=1'b1;
		regWr<=1'b1;next_state<=incPc;
		end
		
		store2:begin regSel<=instrReg[2:0];regRd<=1'b1;
		addrRegWr<=1'b1;next_state<=store3;
		end
		
		store3:begin regSel<=instrReg[5:3];regRd<=1'b1;
		rw<=1'b1;next_state<=incPc;
		end
		
		loadI2:begin progCntrRd<=1'b1;aluSel<=inc;shiftSel<=shftpass;
		outRegWr<=1'b1;next_state<=loadI3;
		end
		
		loadI3:begin outRegRd<=1'b1;next_state<=loadI4;end
		
		loadI4:begin outRegRd<=1'b1;progCntrWr<=1'b1;
		addrRegWr<=1'b1;next_state<=loadI5;
		end
		
		loadI5:begin vma<=1'b1;rw<=1'b1;next_state<=loadI6;end
		
		loadI6:begin vma<=1'b1;rw<=1'b1;next_state<=incPc;end
		
		inc2:begin regSel<=instrReg[2:0];regRd<=1'b1;aluSel<=inc;
		
		shiftSel<=shftpass; outRegWr<=1'b1;next_state<=inc3;
		end
		
		inc3:begin outRegRd<=1'b1;next_state<=inc4;
		end
		
		inc4:begin outRegRd<=1'b1;regSel<=instrReg[2:0];
		regWr<=1'b1;next_state<=incPc;
		end
		
		incPc:begin progCntrRd<=1'b1;aluSel<=inc;shiftSel<=shftpass;
		outRegWr<=1'b1;next_state<=incPc2;
		end
		
		incPc2:begin outRegRd<=1'b1; progCntrWr<=1'b1;
		addrRegWr<=1'b1;next_state<=incPc3;
		end
		
		incPc3:begin outRegRd<=1'b0; vma<=1'b1;rw<=1'b0;
		instrWr<=1'b1;next_state<=execute;
		end
		default:next_state<=incPc;
		endcase 
		end
		
	always@(posedge clock or posedge reset)
		
		if (reset==1) current_state <= reset1 ;
			else current_state <= next_state ;

endmodule 
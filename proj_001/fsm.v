module fsm(Clock,Reset,A,K2,K1);
//Gray code
//one hot coding

input Clock,Reset,A;
output K2,K1;
output [1:0] state;	//[3:0]

reg K2,K1;
reg [1:0] state;	//[3:0]

parameter	Idle = 2'b00,	//4'b1000
			Start = 2'b01,	//4'b0100
			Stop = 2'b10,	//4'b0010
			Clear = 2'b11;	//4'b0001
			
always @(posedge Clock)
	if(! Reset)
		begin
			state <= Idle;
			K2<=0;
			K1<=0;
		end
	else
		case (state)
			Idle:	if(A)
						begin
							state<=Start;
							K1<=0;
						end
					else
						begin
							state<=Idle;
							K2<=0;
							K1<=1;
						end
			Start:	if(!A)
						state <=Stop;
					else
						state <=Start;
			Stop:	if(A)
						begin
							state <=Clear;
							K2<=1;
						end
					else
						begin
							state<=Stop;
							K2<=0;
							K1<=0;
						end
			Clear:	if(!A)
						begin
							state <=Idle;
							K2<=0;
							K1<=1;
						end
					else
						begin
							state<=Clear;
							K2<=0;
							K1<=1;
						end
			default:	state <=2'bxx;
		endcase
endmodule
						


//高速状态机
//状态变化直接用作输出
module fsm2(Clock,Reset,A,K2,K1);

	input Clock,Reset,A;
	output K2,K1;
	output [4:0] state;

reg [4:0] state;

	assign K2 = state[4];
	assign K1 = state[0];
	
	parameter	//K2_i_j_K1
		Idle		=	5'b0_0_0_0_0,
		Start		=	5'b0_0_0_1_0,
		Stop		=	5'b0_0_1_0_0,
		StopToClear	=	5'b1_1_0_0_0,
		Clear		=	5'b0_1_0_1_0,
		ClearToIdle	=	5'b0_0_1_1_1;
		
	always @(posedge Clock)
		if(!Reset)
			begin
				state <= Zero;
			end
		else
			case(state)
				Idle:	if(A)
							state<=Start;
						else
							state<=Idle;
				Start:	if(!A)
							state<=Stop;
						else
							state<=Start;
				Stop:	if(A)
							state<=StopToClear;
						else
							state<=Stop;	
				StopToClear:
							state<=Clear;
				Clear:	if(!A)
							state<=ClearToIdle;
						else
							state<=Clear;
				ClearToIdle:
							state<=Idle;
				default:	state<=Idle;
			endcase
endmodule


//多输出状态机
//拆分状态变化 和  输出开关控制
//便于查错 修改
//建议的风格

module fsm3(Clock,Reset,A,K2,K1);

	input Clock,Reset,A;
	output K2,K1;
	
	reg K2,K1;
	reg [1:0] state,nextstate;
	
	parameter	
		Idle	= 2'b00,
		Start	= 2'b01,
		Stop	= 2'b10,
		Clear	= 2'b11;

	always @(posedge Clock)
		if(!Reset)
			state<=Idle;
		else
			state<=nextstate;
	
	always@(state or A )
		case(state)
			Idle:	if(A)
						nextstate = Start;
					else
						nextstate = Idle;
			Start:	if(!A)
						nextstate = Stop;
					else
						nextstate = Start;
			Stop:	if(A)
						nextstate = Clear;
					else
						nextstate = Stop;
			Clear:	if(!A)
						nextstate = Idle;
					else
						nextstate = Clear;	
			default:	nextstate = 2'bxx;
		endcase
	
	always @(state or Reset or A)
		if(!Reset)
			K1=0;
		else
			if(state == Clear && !A)
				K1=1;
			else
				K1=0;

	always @(state or Reset or A)
		if(!Reset)
			K2=0;
		else
			if(state == Clear && A)
				K2=1;
			else
				K2=0;	
				
endmodule


// Test 
`timescale 1ns/1ns

module t;

	reg a;
	reg clock, rst;
	wire k2,k1;
	
	initial
		begin
			a	=	0;
			rst	=	1;
			clock	=	0;
			#22	rst	=	0;
			#133	rst	=1;
		end
		
	always	#50	clock=~clock;
	always	@	(posedge	clock)
		begin
			#30	a	=	{$random}%2;	//随机 0 1
			#(3*50+12)
		end
	
	initial
		begin	#100000	$stop;
		end
		
	fsm m(.Clock(clock),.Reset(rst),.A(a),.K2(k2),.K1(k1))

endmodule
module seqdet(x,z,clk,rst);

input x,clk,rst;
output z;

reg [2:0] state;
wire z;

parameter 
	IDLE = 3'b0,
	A = 3'b1,
	B = 3'b2,
	C = 3'b3,
	D = 3'b4,
	E = 3'b5,
	F = 3'b6,
	G = 3'b7;

assign z=(state==D && x==0) ? 1:0;

always @(posedge clk or negedge rst)
	if(!rst)
		beign
			state <= IDLE;
		end
	else
		casex(state)
			IDLE:	if (x==1)
						state<=A;
					else
						state<=IDLE;
			A:	if (x==0)
						state<=A;
					else
						state<=A;
			B:	if (x==0)
						state<=C;
					else
						state<=F;
			C:	if (x==1)
						state<=D;
					else
						state<=G;
			D:	if (x==1)
						state<=A;
					else
						state<=E;
			E:	if (x==1)
						state<=A;
					else
						state<=C;
			F:	if (x==1)
						state<=A;
					else
						state<=B;
			G:	if (x==1)
						state<=F;
					else
						state<=G;	
			default:	state<=IDLE;
		endcase
endmodule




module ptosda(sclk,d_ena,scl,sda,rst,data);

input		sclk,rst;
input[3:0]	data;
output		ack;
output		scl;
inout		sda;

reg		scl,
		link_sda,
		ack,
		sdabuf;
		
reg[3:0]	databuf;
reg[7:0]	state;

assign	sda = link_sda?sdabuf:1'bz;

parameter	ready	=	8'b0000_0000,
			start	=	8'b0000_0001,
			bit1	=	8'b0000_0010,
			bit2	=	8'b0000_0100,
			bit3	=	8'b0000_1000,
			bit4	=	8'b0001_0000,
			bit5	=	8'b0010_0000,
			stop	=	8'b0100_0000,
			IDLE	=	8'b1000_0000;
			
always	@(posedge sclk or negedge rst)
	begin
		if(!rst)
			scl<=1;
		else
			scl<=~scl;
	end
	
always @(posedge d_ena)
	databuf <= data;
	
	
always @(negedge sclk or negedge rst)
	if(!rst)
		begin
			link_sda<=0;
			state<=ready;
			sdabuf<=1;
		end
	else
		begin
			case(state)
				ready:	if(d_ena)
							begin
								link_sda <=1;
								state <= start;
							end
						else
							begin
								link_sda<=0;
								state <= ready;
								ack<=1;
							end
				start:	if(scl && d_ena)
							begin
								sdabuf <=0;
								state <= bit1;
							end
						else
							state <=start;
				bit1:	if(!scl)
							begin
								sdabuf <=databuf[3];
								state <= bit2;
								ask<=0;
							end
						else
							state <=bit1;		
				bit2:	if(!scl)
							begin
								sdabuf <=databuf[2];
								state <= bit3;
							end
						else
							state <=bit2;	
				bit3:	if(!scl)
							begin
								sdabuf <=databuf[1];
								state <= bit4;
							end
						else
							state <=bit3;	
				bit4:	if(!scl)
							begin
								sdabuf <=databuf[0];
								state <= bit5;
							end
						else
							state <=bit4;	
				bit5:	if(!scl)
							begin
								sdabuf <= 1;
								state <= stop;
							end
						else
							state <=bit5;
				stop:	if(scl)
							begin
								sdabuf <= 1;
								state <= IDLE;
							end
						else
							state <=stop;
				IDLE:
							begin
								link_sda <= 0;
								state <=ready;
							end							
				default:
							begin
								link_sda <= 0;
								sdabuf <= 1;
								state <=ready;
							end
			endcase
		end
		
										
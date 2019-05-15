//4加法器
module add_4(X,Y,sum,C);

input [3:0] X,Y;
output [3:0] sum;
output C;

assign {C,sum} = X+Y;

endmodule

//16加法器
module add_16(X,Y,sum,C);
input [15:0] X,Y；
output[15:0] sum;
output C;

assign {c,sum} = X+Y;

endmodule

//4乘法器
module mult_4(X,Y,Product);

input [3:0] X,Y;
output [7:0] Product;

assign  Product = X*Y;

endmodule

//比较器
module compare_n(X,Y,XGY,XSY,XEY);
input [width-1:0] X,Y;
output XGY,XSY,XEY;
reg XGY,XSY,XEY;

parameter width =8;

always @(X or Y)
	begin
		if(X==Y)
			XEY=1;
		else
			XEY=0;
			
		if(X > Y)
			XGY=1;
		else
			XGY=0;	
			
		if(X<Y)
			XSY=1;
		else
			XSY=0;			
	end 
	
endmodule

//多路选择 多路器



//总线
module SampleOfBus(DataBus,link_bus,write);
inout [11:0] DataBus;
input link_bus;
reg [11:0] outsigs;
reg [13:0] insigs;

assign DataBus = (link_bus) ? outsigs : 12'hzzz;
always @(posedge write)
begin 
	outsigs <= DataBus *3;
end
endmodule	
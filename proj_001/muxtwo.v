module muxtwo(out,a,b,sl);
	input a,b,sl;
	output out;
	
	reg out;
	
	always @ (sl or a or b)
		if(!sl) out = a;
		else out =b;

endmodule


module muxtow2(out,a,b,sl);

	input a,b,sl;
	output out;
	
	wire nsl,sela,selb;
		
		assign nsl = ~sl;
		assign sela = a&nsl;
		assign selb = b&sl;
		assign out = sela|selb;
		
endmodule


module adder(count ,sum, a,b,cin);

	input [2:0] a,b;
	input cin;
	output count;
	output [2:0] sum;
	
	assign {count,sum} = a+b+cin;
	
endmodule
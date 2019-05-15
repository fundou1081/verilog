module top;

function automatic integer factorial;

input [31:0] oper;
integer i;
begin
	if(operand >=2)
		factorial = factorial(operand-1)*oper;
	else
		factorial=1;
end
endfunction

integer result;
initial
begin
	result = factorial(4);
	$display ("%d",result);
end
endmodule



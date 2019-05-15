`timescale 1ns/1ns 
`include "sigdata.v"
`include "ptosda.v"
`include "out16hi.v"

module top;

wire[3:0]	data;
wire	sclk;
wire	sda;
reg		rst;
wire[15:0]	outhigh;

	sigdata m0 	(.sclk(sclk),.data(data),.d_ena(d_ena));
	ptosda	m1	(.sclk(sclk),.d_ena(d_ena),.scl(scl),.sda(sda),.rst(rst),.data(data));
	out16hi	m2	(.scl(scl),.sda(sda),.outhigh(outhigh));


endmodule
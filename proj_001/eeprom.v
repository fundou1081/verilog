`timescale 1ns/1ns 
`define timeslice 100

module EEPROM(scl,sda);

input scl;
inout sda;
reg		outFlag;

reg[7:0]	memory[2047:0];
reg[10:0]	address;
reg[7:0]	memory_buf;
reg[7:0]	sda_buf;
reg[7:0]	shift;
reg[7:0]	addr_byte;
reg[7:0]	ctrl_byte;
reg[1:0]	State;

integer	i;
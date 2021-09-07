/* uPowerISA Core Module is the centre of all operations that handles all the operations and instantiates
all the necessary modules
*/
`include "../Module 3 - Instruction Fetch/parse_instruction.v"
`include "../Module 1 - ALU/ALU64Bit.v"
`include "../Module 2 - ALU Control/uPowerALUControl.v"
`include "Instruction_read.v"
`include "Memory_read_write.v"
`include "Register_read_write.v"

module Branch(clock);

input clock; //Execution happens only at positive level-transition (edge sensitive)

//Program counter

reg [31:0] PC = 32'b0;

//Instruction
wire [31:0] instruction;

//Parse instruction
wire [5:0] po;
wire [4:0] rs,rt,rd,bo,bi;
wire [8:0] xoxo;
wire [9:0] xox;
wire rc,aa,lk,oe;
wire [13:0] bd;
wire [63:0] ds;
wire [15:0] si;
wire [23:0] li;
wire [1:0] xods;
wire [3:0] ALUInput;

//Signals

reg RegRead, RegWrite;
reg MemRead, MemWrite, MemToReg;
reg Branch, ALUSrc, PCSrc;
reg [1:0] ALUop;

//Register contents
wire [63:0] write_data, rs_content, rt_content, rd_content, memory_read_data;

		initial begin //store
		    MemRead  = 1'b0;
			MemWrite = 1'b0;
			RegWrite = 1'b0;
			RegRead  = 1'b1;
			Branch   = 1'b1;
			ALUSrc   = 1'b0;
			PCSrc    = 1'b1;
			MemToReg = 1'b0;
			ALUop	 = 2'b01;

		end


//Modules are instantiated
read_instructions p1(instruction, PC);
parse_instruction p2(po, rs, rt, rd, bo, bi, aa, lk, rc, oe, xox, xoxo, si, bd, ds, xods, li, instruction, PC);
//control_unit p3(RegRead, RegWrite, MemRead, MemWrite, Branch, MemToReg, ALUSrc, PCSrc, ALUop, po);
ALU_Control p4(ALUInput, ALUop, xox,xoxo,xods);
ALU64bit p5(write_data, flag, ALUSrc, ALUInput, rs_content, rt_content, ds);
read_write_memory p6(memory_read_data, write_data, rd_content, rd, po, MemWrite, MemRead);
read_write_registers p7(rs_content, rt_content, rd_content, memory_read_data, write_data, rs, rt, rd, bo, bi, po, RegRead, RegWrite, MemToReg, clock);

// Updating the PC value

always @(posedge clock) 
 begin
     
     if(flag == 1 & Branch == 1 & aa == 0 & po == 6'd19)           //Branch Conditional
       PC = PC + 1 + $signed(bd);

     else if(flag == 1 & Branch == 1 & aa == 1 & po == 6'd19) begin //Branch Absolute
       PC = $signed(bd);
	   end

     else if(Branch == 1 & aa == 1 & po == 6'd18)
       PC = $signed(li);

     else if(Branch == 1 & aa == 0 & po == 6'd18)
       PC = PC + 1 + $signed(li);
     else 
       PC = PC + 1;
 end


endmodule
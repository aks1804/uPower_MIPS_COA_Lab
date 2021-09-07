/* MIPS Core Module is the centre of all operations that handles all the operations and instantiates
   all the necessary modules
*/
`include "Register_read_write.v"
`include "../Module 1 - ALU/ALU32bit.v"
`include "../Module 2 - ALU Control/ALUcontrol.v"
`include "Instruction_read.v"
`include "Memory_read_write.v"
`include "../Module 3 - Instruction Fetch/parse_instruction.v"


module Load(clock);

    input clock;   // Execution happens only at positive level-transition (edge sensitive)
	
    // Program counter
    reg[31:0] PC = 32'b0; 
	
    // Instruction
    wire [31:0] instruction;
	
    // Parse instruction
    wire [5:0] funct;
    wire [4:0] rs, rt, rd, shamt;
    wire [25:0] address;
    wire [31:0] immediate;
    wire [5:0] opcode;
	wire [3:0] ALUInput;
	
    // Signals
    reg RegRead, RegWrite, RegDst;  
    reg MemRead, MemWrite, MemToReg;
    reg branch_signal;
	wire flag;
    reg PCSrc, ALUSrc;
	reg [1:0] ALUop;
	
    // Registers contents
    wire [31:0] write_data, rs_content, rt_content, memory_read_data;
	
	// Control signals for Load Instruction
	initial begin
	MemRead  		= 1'b1;
    MemWrite 		= 1'b0;
    RegWrite 		= 1'b1;
    RegRead  		= 1'b1;
    RegDst   		= 1'b0;
    branch_signal   = 1'b0;
    ALUSrc   		= 1'b1;
    PCSrc    		= 1'b0;
    MemToReg 		= 1'b1;
	ALUop	 		= 2'b00;
	end
	
    // Instantiating all necessary modules
    read_instructions p1 (instruction, PC);
    parse_instruction p2 (opcode, rs, rt, rd, shamt, funct, immediate, address, instruction, PC);
	alu_control_unit p3 (ALUInput, funct, ALUop);
    ALU32bit p4 (write_data, flag, rs, rt, rs_content, rt_content, immediate, ALUSrc, ALUInput);
    read_write_memory p5 (memory_read_data, write_data, rt_content, opcode, MemRead, MemWrite);
    read_write_registers p6 (rs_content, rt_content, memory_read_data, write_data, rs, rt, rd, opcode, RegRead, RegWrite, RegDst, MemToReg, clock);
	
    // PC operations - The next instruction is read only when the clock is at positive edge
    always @(posedge clock) begin 
        if(branch_signal == 1 & flag == 1) begin
            PC = PC + 1 + $signed(immediate); 
        end
		else
            PC = PC + 1;
    end 
endmodule
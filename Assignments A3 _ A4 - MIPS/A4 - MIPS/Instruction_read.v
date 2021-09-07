/* This module is used to read the 32 bit MIPS instructions from the instructions.mem file
*/
module read_instructions(instruction, program_counter);

    input [31:0] program_counter;
    output reg [31:0] instruction;
	
    reg [31:0] instructions[0:6];  //set to the number of instructions in the file
	
    initial begin 
        $readmemb("instructions.mem", instructions, 0,6); 
    end
	
    always @ (program_counter) begin
        instruction = instructions[program_counter];
        $display("Instruction : %32b , PC : %32b", instruction, program_counter);
    end

endmodule


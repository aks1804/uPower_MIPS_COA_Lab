/*  This module is used to read the 32 bit uPower instructions from the instructions.mem file
*/

module read_instructions(instruction, program_counter);

    input [31:0] program_counter;
    output reg [31:0] instruction;

    reg [31:0] instructions[0:3];     //set to the number of instructions in the file

    initial begin
        $readmemb("instructions.mem", instructions, 0, 3);
    end

    always @ (program_counter) begin
        instruction = instructions[program_counter];
        $display("Instruction : %32b \n PC : %32b\n", instruction, program_counter);
    end

endmodule
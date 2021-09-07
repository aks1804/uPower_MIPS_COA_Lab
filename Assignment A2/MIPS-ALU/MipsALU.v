/* 
The following code contains an ALU Module for the MIPS ISA which takes in the opcode, contents of the registers, shiftAmount, ALUResult and AluSrc signals
with the signed Immediate as arguments
*/
/*
Done by:
Name					RollNumber
Pranav V. Kumar			181CO239
Ankush Chandrashekar	181CO209
Mohammed Rushad			181CO232
Akshat Nambiar			181CO204

Date: 15-03-2020  
*/
module ALU32bit(ALU_result, sig_branch, opcode, rs_content, rt_content, shamt, funct, immediate);
	
    input [5:0] funct, opcode;
    input [4:0] shamt; // shift amount
    input [15:0] immediate;
    input [31:0] rs_content, rt_content; //inputs
    output reg sig_branch;
    output reg [31:0] ALU_result; //Output of the ALU
	
    integer i; //Loop counter
    // Temporary variable - temp for SRA - Shift Right Arithmetic
    reg signed [31:0] temp, signed_rs, signed_rt; 
    reg [31:0] signExtend, zeroExtend;

    always @ (funct, rs_content, rt_content, shamt, immediate) begin
		
		
        // Signed value assignment
        signed_rs = rs_content;
        signed_rt = rt_content;
			
			
        // R-type instruction
        if(opcode == 6'h0) begin
			
            case(funct)
			
                6'h20 : //ADD
                    ALU_result = signed_rs + signed_rt;
				
                6'h21 : //ADDU - Add unsigned
                    ALU_result = rs_content + rt_content;
					
                6'h22 : //SUB - Subtract
                    ALU_result = signed_rs - signed_rt;
					
                6'h23 : //SUBU - Subtract unsigned
                    ALU_result = rs_content - rt_content;
					
                6'h24 : //AND
                    ALU_result = rs_content & rt_content;
					
                6'h25 : //OR
                    ALU_result = rs_content | rt_content;
					
                6'h27 : //NOR
                    ALU_result = ~(rs_content | rt_content);
					
                6'h03 : //SRA (Shift Right Arithmetic - An arithmetic right shift replicates the sign bit as needed to fill bit positions)
                    begin
                        temp = rt_content;
                        for(i = 0; i < shamt; i = i + 1) begin
                            temp = {temp[31],temp[31:1]}; //add the lsb for msb
                        end
					
                    ALU_result = temp;
                    end
					
                6'h02 : //SRL - Shift Right Logical >>
                    ALU_result = (rt_content >> shamt);
			
                6'h00 : //SLL - Shift Left Logical <<
                    ALU_result = (rt_content << shamt);
				
                6'h2b : //SLTU - Set less than unsigned
                    begin
                        if(rs_content < rt_content) begin
                            ALU_result = 1;
                        end else begin
                            ALU_result = 0;
                        end
                    end
					
                6'h2a : //SLT - Set less than
                    begin
                        if(signed_rs < signed_rt) begin
                            ALU_result = 1;
                        end else begin
                            ALU_result = 0;
                        end
                    end
			
            endcase
			
        end 
		
		
		
        // I type
        else begin
			
            signExtend = {{16{immediate[15]}}, immediate};
            zeroExtend = {{16{1'b0}}, immediate};
			
            case(opcode)
		
                6'h8 : // ADDI - Add Immediate
                    ALU_result = signed_rs + signExtend;
					
                6'h9 : // ADDIU - Add Immediate unsigned
                    ALU_result = rs_content + signExtend;
					
                6'b010010 : // ANDI - And Immediate
                    ALU_result = rs_content & zeroExtend;
					
                6'h4 : // BEQ - Branch on Equal
                    begin
                        ALU_result = signed_rs - signed_rt;
                        if(ALU_result == 0) begin
                            sig_branch = 1'b1;
                        end
                        else begin
                            sig_branch = 1'b0;
                        end
                    end
				
                6'h5 : // BNE - Branch not equal
                    begin
                        ALU_result = signed_rs - signed_rt;
                        if(ALU_result != 0) begin
                            sig_branch = 1'b1;
                            ALU_result = 1'b0;
                        end
                        else begin
                            sig_branch = 1'b0;
                        end
                    end
				
                6'b010101 : // LUI - Load upper immediate
                    ALU_result = {immediate, {16{1'b0}}};
				
                6'b010011 : // ORI - Or Immediate
                    ALU_result = rs_content | zeroExtend;
				
                6'b001010 : // SLTI - Set less than immediate
                    begin
                        if(signed_rs < $signed(signExtend)) begin
                            ALU_result = 1;
                        end else begin
                            ALU_result = 0;
                        end
                    end
				
                6'b001011 : // SLTIU - Set less than immediate unsigned
                    begin
                        if(rs_content < signExtend) begin
                            ALU_result = 1;
                        end else begin
                            ALU_result = 0;
                        end
                    end
                6'h28 : // SB - Store byte
                    ALU_result = signed_rs + signExtend;
                6'h29 : // SH -Store halfword
                    ALU_result = signed_rs + signExtend;
                6'h2b : // SW - Store Word
                    ALU_result = signed_rs + signExtend;
                6'h23 : // LW - Load Word
                    ALU_result = signed_rs + signExtend;
                6'h24 : // LBU - Load 
                    ALU_result = signed_rs + signExtend;
                6'h25 : // LHU - Load halfword unsigned
                    ALU_result = signed_rs + signExtend;
                6'h30 : // LL - Load linked
                    ALU_result = signed_rs + signExtend;
				
            endcase
		
        end
		
    end
	
	
    initial 
    begin
        $monitor("Opcode : %6b, RS : %32b, RT : %32b, signExtendImm = %32b, Result : %32b\n",
        opcode, rs_content, rt_content, signExtend, ALU_result);
    end
	
endmodule

/*
TestBench module for possible inputs to ALU32bit module
*/
module alu_tb;
	reg [5:0]opcode;
	reg [31:0]rs_content;
	reg [31:0]rt_content;
	reg [4:0] shamt;
	reg [5:0] funct;
	reg [15:0]immediate;
	wire [31:0]ALU_result;
	wire sig_branch;

	initial
	begin
		$dumpfile("MipsALU.vcd");
		$dumpvars(0,alu_tb);	
		$monitor("Opcode : %6b,Funct : %6b, RS : %32b, RT : %32b, Result : %32b\n",
			opcode,funct, rs_content, rt_content, ALU_result);

		opcode = 6'b000000;
		rs_content = 8;
		rt_content = 7;
		shamt = 5'b00000;
		funct = 6'b000000;
		immediate = 16'b1;
		 
		 
		#10
		funct = 6'h20;
		#10
		funct = 6'h22;
		#10
		funct = 6'h24;
		#10
		opcode = 6'h8;
		funct = 6'h0;

		
		#10 $finish;
	end

	ALU32bit c(
		.ALU_result(ALU_result),
		.sig_branch(sig_branch),
		.opcode(opcode),
		.rs_content(rs_content),
		.rt_content(rt_content),
		.shamt(shamt),
		.funct(funct),
		.immediate(immediate)
	);

endmodule
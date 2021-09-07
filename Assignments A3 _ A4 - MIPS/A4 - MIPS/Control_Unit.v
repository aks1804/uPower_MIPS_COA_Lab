/* Module to behave like the control unit to set the necessary signals for the execution of an 
   instruction -
   1. RegDst - Which field of the instruction is the register to be written to
   2. RegWrite - Write to register file
   3. RegRead - Read from a register
   4. ALUSrc - The source for the second input to the ALU
   5. PCSrc - Source for PC (next instruction to be executed)
   6. MemRead - Read from the main memory
   7. MemWrite - Write to the main memory
   8. MemToReg - Source of write_data (data to be written to the register file)
   9. Branch -  When a branch/jump instruction is used
*/
module control_unit(
    output reg  RegRead,
                RegWrite,
                MemRead,
                MemWrite,
                RegDst, // if this is 0 select rt, otherwise select rd
                Branch,
				BranchNE,
                ALUSrc,
                PCSrc,
                MemToReg,
	output reg [1:0] ALUop,
    input [5:0] opcode, funct
);

    initial begin
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        RegWrite = 1'b0;
        RegRead  = 1'b0;
        RegDst   = 1'b0;
        Branch   = 1'b0;
        ALUSrc   = 1'b0;
        PCSrc    = 1'b0;
        MemToReg = 1'b0;
		BranchNE = 1'b0;
		ALUop	 = 2'b00;
		
    end
	
    always @(opcode, funct) 
    begin
	    // Reset the signals to 0
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        RegWrite = 1'b0;
        RegRead  = 1'b0;
        RegDst   = 1'b0;
        Branch   = 1'b0;
		BranchNE = 1'b0;
        ALUSrc   = 1'b0;
        PCSrc    = 1'b0;
        MemToReg = 1'b0;
		ALUop	 = 2'b00;
		
        // R type
        if(opcode == 6'h0) begin
			MemRead 		= 1'b0;
			MemWrite 		= 1'b0;
			RegWrite 		= 1'b1;
			RegRead  		= 1'b1;
			RegDst   		= 1'b1;
			Branch   		= 1'b0;
			ALUSrc   		= 1'b0;
			PCSrc    		= 1'b0;
			MemToReg 		= 1'b0;
			ALUop	 		= 2'b10;
            // If NOT JR  - Jump Register
            //if(funct != 6'h08) begin
              //  RegWrite = 1'b1;
            //end
        end
		else if(opcode == 6'h23) begin // lw
			MemRead  		= 1'b1;
			MemWrite 		= 1'b0;
			RegWrite 		= 1'b1;
			RegRead  		= 1'b1;
			RegDst   		= 1'b0;
			Branch		    = 1'b0;
			ALUSrc   		= 1'b1;
			PCSrc    		= 1'b0;
			MemToReg 		= 1'b1;
			ALUop	 		= 2'b00;
		end
		
		else if(opcode == 6'h2b) begin //sw
	        MemRead  = 1'b0;
			MemWrite = 1'b1;
			RegWrite = 1'b0;
			RegRead  = 1'b1;
			RegDst   = 1'b0;
			Branch   = 1'b0;
			ALUSrc   = 1'b1;
			PCSrc    = 1'b0;
			MemToReg = 1'b0;
			ALUop	 = 2'b00;
		end
		
		else if(opcode == 6'h8) begin //addi
			MemRead  		= 1'b0;
			MemWrite 		= 1'b0;
			RegWrite 		= 1'b1;
			RegRead  		= 1'b1;
			RegDst   		= 1'b0;
			Branch   		= 1'b0;
			ALUSrc   		= 1'b1;
			PCSrc    		= 1'b0;
			MemToReg 		= 1'b0;
			ALUop	 		= 2'b00;
		end
		
		else if(opcode == 6'h4) begin //beq
			MemRead  		= 1'b0;
			MemWrite 		= 1'b0;
			RegWrite 		= 1'b0;
			RegRead  		= 1'b1;
			RegDst   		= 1'b0;
			Branch	        = 1'b1;
			ALUSrc   		= 1'b0;
			PCSrc    		= 1'b1;
			MemToReg 		= 1'b1;
			ALUop	 		= 2'b01;
		end
		
		else if(opcode == 6'h5) begin //bne
			MemRead  		= 1'b0;
			MemWrite 		= 1'b0;
			RegWrite 		= 1'b0;
			RegRead  		= 1'b1;
			RegDst   		= 1'b0;
			BranchNE        = 1'b1;
			ALUSrc   		= 1'b0;
			PCSrc    		= 1'b1;
			MemToReg 		= 1'b1;
			ALUop	 		= 2'b01;
		end
	
		//lw
        // LUI(load unsigned immediate) => no need to read any register => immediate value is written to a register
       /* else if(opcode == 6'b001111) begin
            RegWrite = 1'b1;
            ALUSrc   = 1'b1;
        end
        // If r-type, don't enter this block
        // For r-type, beq, bne, sb, sh and sw there is no need to register write
        else if(opcode != 6'h0 & opcode != 6'h4 & opcode != 6'h5 & opcode != 6'h28 & opcode != 6'h29 & opcode != 6'h2b) begin
            RegWrite = 1'b1;
        end
        // For branch instructions
        else if(opcode == 6'h4 | opcode == 6'h5) begin
            Branch   = 1'b1;
			RegRead  = 1'b1;
			ALUop 	 = 2'b01;
        end
        // For memory write operation
        // sb, sh and sw use memory to write
        else if(opcode != 6'h0 & (opcode == 6'h28 | opcode == 6'h29 | opcode == 6'h2b)) begin
            MemWrite = 1'b1;
            RegRead  = 1'b1;
            ALUSrc   = 1'b1;
			//ALUop	 = 2'b00;
        end
        // For memory read operation
        // lw, 
        else if(opcode != 6'h0 & (opcode == 6'h23))begin
            MemRead = 1'b1;
            ALUSrc  = 1'b1;
            MemToReg= 1'b1;
            RegWrite= 1'b1;
            RegRead  = 1'b1;
			ALUop = 2'b00;

        end
        // J type
       /* else
        begin
            PCSrc = 1'b1;
        end*/
    end
	
	
	
endmodule
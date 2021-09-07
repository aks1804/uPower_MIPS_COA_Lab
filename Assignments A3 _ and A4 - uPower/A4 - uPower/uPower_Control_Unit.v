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
                Branch,
                MemToReg,
                ALUSrc,
                PCSrc,
	output reg [1:0] ALUop,
    input [5:0] po
);

    initial begin
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        RegWrite = 1'b0;
        RegRead  = 1'b0;
        Branch   = 1'b0;
        ALUSrc   = 1'b0;
        PCSrc    = 1'b0;
        MemToReg = 1'b0;
		ALUop	 = 2'b00;
		
    end



    always @(po)
    begin
		//initialize
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        RegWrite = 1'b0;
        RegRead  = 1'b0;
        Branch   = 1'b0;
        ALUSrc   = 1'b0;
        PCSrc    = 1'b0;
        MemToReg = 1'b0;
		ALUop	 = 2'b00;
		
		
        //X OR XO Format
        if(po == 6'd31) 
        begin
		    MemRead  = 1'b0;
			MemWrite = 1'b0;
			RegWrite = 1'b1;
			RegRead  = 1'b1;
			Branch   = 1'b0;
			ALUSrc   = 1'b0;
			PCSrc    = 1'b0;
			MemToReg = 1'b0;
			ALUop	 = 2'b10;
            // $display("HOI\n");
            //RegRead = 1'b1;
            //RegWrite = 1'b1;        
        end
		
        if(po == 6'd58 | po == 6'd32 |po == 6'd40 |po == 6'd42 |po == 6'd34) //loads
        begin
		    MemRead  = 1'b1;
			MemWrite = 1'b0;
			RegWrite = 1'b1;
			RegRead  = 1'b1;
			Branch   = 1'b0;
			ALUSrc   = 1'b1;
			PCSrc    = 1'b0;
			MemToReg = 1'b1;
			ALUop	 = 2'b00;
		end
		
		if(po == 6'd38 |po == 6'd44 |po == 6'd37 |po == 6'd36 |po == 6'd62) //stores
        begin
		    MemRead  = 1'b0;
			MemWrite = 1'b1;
			RegWrite = 1'b0;
			RegRead  = 1'b1;
			Branch   = 1'b0;
			ALUSrc   = 1'b1;
			PCSrc    = 1'b0;
			MemToReg = 1'b0;
			ALUop	 = 2'b00;
		end
	
		if(po == 6'd19) //branch conditional
        begin
		    MemRead  = 1'b0;
			MemWrite = 1'b0;
			RegWrite = 1'b0;
			RegRead  = 1'b1;
			Branch   = 1'b1;
			ALUSrc   = 1'b0;
			PCSrc    = 1'b1;
			MemToReg = 1'b0;
			ALUop	 = 2'b01 ;
		end
		if(po == 6'd18) //branch unconditional
        begin
		    MemRead  = 1'b0;
			MemWrite = 1'b0;
			RegWrite = 1'b0;
			RegRead  = 1'b0;
			Branch   = 1'b1;
			ALUSrc   = 1'b0;
			PCSrc    = 1'b1;
			MemToReg = 1'b0;
			ALUop	 = 2'b00;
		end
    end
endmodule
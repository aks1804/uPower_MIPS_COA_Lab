/* This module is used to provide the ALU with the correct signal to perform
the right operation depending on the instruction.
*/

module ALU_Control(
	
	output reg [3:0] ALUInput,
	input [1:0] ALUop, 
    input [9:0] xox,
    input [8:0] xoxo,
    input [1:0] xods
);

	initial begin
		ALUInput = 4'b0000;
	end

    always @(ALUop, xox, xoxo, xods)
    begin
        ALUInput  = 4'b0000;	
	
        if(ALUop == 2'b00) begin // store and load
			ALUInput = 4'b0010; 
        end
        else if(ALUop == 2'b01) begin // branch
            ALUInput  = 4'b0110; 
        end
        else if(ALUop == 2'b10) begin //xo-type and x-type
			if(xoxo == 9'b100001010) begin //add
				ALUInput = 4'b0010;
			end
			if(xoxo == 9'b000101000) begin //subtract
				ALUInput = 4'b0110;
			end
			if(xox == 10'b0000011100) begin //and
				ALUInput = 4'b0000;
			end
			if(xox == 10'b0110111100) begin //or
				ALUInput = 4'b0001;
			end
        end
	end
endmodule




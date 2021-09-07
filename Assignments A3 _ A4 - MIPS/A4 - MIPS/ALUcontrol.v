// Module to behave like the ALU control unit to output the ALU control signal  

module alu_control_unit(
    output reg [3:0] ALUInput,
    input [5:0] funct,
	input [1:0] ALUop
);

    initial begin
        ALUInput  = 4'b0000;	
    end
	
    always @(ALUop, funct) 
    begin
        ALUInput  = 4'b0000;	
	
        if(ALUop == 2'b00) begin
			ALUInput = 4'b0010; 
        end
        else if(ALUop == 2'b01) begin
            ALUInput  = 4'b0110; 
        end
        else if(ALUop == 2'b10) begin //rtype
			if(funct == 6'b100000) begin //add
				ALUInput = 4'b0010;
			end
			if(funct == 6'b100010) begin //subtract
				ALUInput = 4'b0110;
			end
			if(funct == 6'b100100) begin //and
				ALUInput = 4'b0000;
			end
			if(funct == 6'b100101) begin //or
				ALUInput = 4'b0001;
			end
			if(funct == 6'b101010) begin //slt
				ALUInput = 4'b0111;
			end
        end
    end	
endmodule
/* Module designed to act as the ALU 
*/

module ALU32bit(ALU_result, flag, rs, rt, rs_content, rt_content, immediate, ALUSrc, ALUInput);
	
    input [31:0] rs_content, rt_content; //inputs
    input [4:0] rs, rt;
	input [31:0] immediate;
	input [3:0] ALUInput;
	input ALUSrc;
    output reg flag;
    output reg [31:0] ALU_result; //Output of the ALU
	
    reg signed [31:0] signed_rs, signed_rt; 

    always @ (ALUInput, rs_content, rt_content) begin
		
		
        // Signed value assignment
        signed_rs = rs_content;
		
		//Assign second input of ALU as immediated value or rt from registers depending on ALUSrc
		if(ALUSrc) begin
			signed_rt = immediate;
		end
		else
			signed_rt = rt_content;
						
            case(ALUInput)
			
                4'b0010 : //ADD
                    begin
                    ALU_result = signed_rs + signed_rt;
                    end

                4'b0110 : //SUB - Subtract
					begin
                    ALU_result = signed_rs - signed_rt;
					if(ALU_result == 0) 
						flag = 1'b1;
					else
						flag = 1'b0;
					end

                4'b0000 : //AND
                    ALU_result = rs_content & rt_content;
					
                4'b0001 : //OR
                    ALU_result = rs_content | rt_content;
					
                4'b1100 : //NOR
                    ALU_result = ~(rs_content | rt_content);
					
                4'b0111 : //SLT - Set less than
                    begin
                        if(signed_rs < signed_rt) begin
                            ALU_result = 1;
                        end else begin
                            ALU_result = 0;
                        end
                    end
			
            endcase
    end

	initial begin
        $monitor("RS : %32b, RT/Immediate : %32b, Result : %32b\n", rs_content, signed_rt, ALU_result);
    end
	
endmodule
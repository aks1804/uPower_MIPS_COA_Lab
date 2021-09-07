/* Module to read the 32-bit registers and read/write according to the 
   RegWrite an RegRead signals
*/
module read_write_registers(
    output reg [31:0] read_data_1, read_data_2,   // The output are two 32-bit binary numbers that contain the data stored in RS and RT
    input [31:0] read_mem_data, write_data,   // The data to be written
    input [4:0] rs, rt, rd,    // RS and RT are the read registers and RD (Destination register) is the write register
    input [5:0] opcode,        
    input RegRead, RegWrite, RegDst, MemToReg, clk   // Signals to perform operations
);

    reg [31:0] registers [31:0];    // The set of 32 registers (32-bit)
	
    initial begin
        $readmemb("registers.mem", registers);   //Reads all the values stored in the 32 registers
    end
	
    always @(rd, read_mem_data,write_data) begin    // If a change in the data to be written is noticed
        if(RegWrite) begin
            /* RegDst = 0 => Write to RT
               RegDst = 1 => Write to RD
            */
            if(RegDst) begin
				if(MemToReg) begin //Store data read from memory in rd
					if(opcode == 6'h24)begin
						registers[rd][7:0] = read_mem_data[7:0];
					end
					if(opcode == 6'h25)begin
						registers[rd][15:0] = read_mem_data[15:0];
					end
					else begin
						registers[rd] = read_mem_data;
					end
				end
				else begin //Store data from ALU in rd
					if(opcode == 6'h24)begin
						registers[rd][7:0] = write_data[7:0];
					end
					if(opcode == 6'h25)begin
						registers[rd][15:0] = write_data[15:0];
					end
					else begin
						registers[rd] = write_data;
					end				
				end
            end
            else begin
				if(MemToReg) begin //Store data read from memory in rt
					if(opcode == 6'h24)begin        
						registers[rt][7:0] = read_mem_data[7:0];
					end
					if(opcode == 6'h25)begin       
						registers[rt][15:0] = read_mem_data[15:0];
					end
					else begin
						registers[rt] = read_mem_data;
					end				
				end
				else begin //Store data from ALU in rt
					if(opcode == 6'h24)begin        
						registers[rt][7:0] = write_data[7:0];
					end
					if(opcode == 6'h25)begin        
						registers[rt][15:0] = write_data[15:0];
					end
					else begin
						registers[rt] = write_data;
					end
				end
            end

            // Write back the updated values to the registers file
            $writememb("registers.mem",registers);
        end
    end

    always @(rs, rt) begin
        // Read from registers
        if(RegRead) begin
            read_data_1 = registers[rs];
            read_data_2 = registers[rt];
        end
    end
endmodule
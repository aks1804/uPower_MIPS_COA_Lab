/* This module is used to read and write into the 32 bit register file
*/

module read_write_registers(
    output reg [63:0] read_data_1, read_data_2, read_data_3, // The output are two 64-bit binary numbers that contain the data stored in RS and RT
    input [63:0] read_mem_data, write_data, 
    input [4:0] rs, rt, rd, bo, bi, // RS and RT are the read registers and RD (Destination register) is the write register
    input [5:0] po,  // 6 bit po
    input RegRead, RegWrite, MemToReg, clk  // RegRead and RegWrite are signals that indicate whether the instruction needs to read from registers and/or write to a register
);
	
    reg [63:0] registers [31:0];  //The set of 64 bit registers

    //always @(rs, rt, rd, bo, bi)
	always @(rs, rt, rd)
    begin
		//$display("RTRTTRT %64b\n %5b\n",read_mem_data,rd);
        //Read from registers
        if(RegRead)
        begin
            $readmemb("registers.mem", registers);  //Reads all the values stored in the 32 registers
            if(po == 6'd19) begin //branch
                read_data_1 = registers[bo];
                read_data_2 = registers[bi];
            end
            else if(po == 6'd31) begin //xo and x type
                read_data_1 = registers[rs];
                read_data_2 = registers[rt];
            end
            else begin                              //Loads and stores
                // $display("HERE\n");
                read_data_1 = registers[rs];
                read_data_3 = registers[rd];
            end
        end
    end

    always @(read_mem_data, write_data, rd) begin
        if(RegWrite == 1'b1) begin
            $readmemb("registers.mem", registers);  //Reads all the values stored in the 32 registers
            if(MemToReg == 1'b0) begin
				if(po == 6'd34) begin    //Load Byte
					registers[rd] = {{56{1'b0}}, write_data[7:0]};
				end
				else if (po == 6'd40) begin     //Load halfword and Zero
					registers[rd] = {{48{1'b0}}, write_data[15:0]};
				end
				else if (po == 6'd42) begin      //Load halfword with sign extension
					registers[rd] = {{48{write_data[15]}}, write_data[15:0]};
				end 
				else if(po == 6'd32) begin     //Load word
					registers[rd] = {{32{1'b0}}, write_data[31:0]};
				end
				else begin                           //Load doubleword
					registers[rd] = write_data;
				end
			end
			else begin
				if(po == 6'd34) begin    //Load Byte
					registers[rd] = {{56{1'b0}}, read_mem_data[7:0]};
				end
				else if (po == 6'd40) begin     //Load halfword and Zero
					registers[rd] = {{48{1'b0}}, read_mem_data[15:0]};
				end
				else if (po == 6'd42) begin      //Load halfword with sign extension
					registers[rd] = {{48{read_mem_data[15]}}, read_mem_data[15:0]};
				end 
				else if(po == 6'd32) begin     //Load word
					registers[rd] = {{32{1'b0}}, read_mem_data[31:0]};
				end
				else begin                           //Load doubleword
					registers[rd] = read_mem_data;
				end
			end
			
           // $display("Reg 0 : %64b\nReg 1 : %64b\nReg 2 : %64b\nReg 3 : %64b\n",registers[0], registers[1], registers[2], registers[3]);
            $writememb("registers.mem", registers);
        end
    end
    

endmodule
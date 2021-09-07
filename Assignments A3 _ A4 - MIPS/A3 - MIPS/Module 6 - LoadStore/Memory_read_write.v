/* Module designed to access and perform read and write on the contents of the main memory
*/

module read_write_memory(
    output reg [31:0] read_data,  //The data read from the main memory
    input  [31:0] address, write_data, //The ADDRESS and WRITE_DATA are inputs
    input [5:0] opcode,
    input MemRead,MemWrite    // Signals for Memory read and write
);
	
	// Stores the contents of the main memory
    reg [31:0] data_mem [0:31];   
	
	//Read the main memory contents
    initial    
    begin
        $readmemb("data.mem", data_mem, 0 ,31); 
    end
	
    always @(address) begin
        if(MemWrite) begin
            if(opcode == 6'h28) begin
                data_mem[address][7:0] = write_data[7:0];
            end 
            else if(opcode == 6'h29) begin
                data_mem[address][15:0] = write_data[15:0];
            end
            else begin
                data_mem[address] = write_data;
            end
            // Write the updated contents back to the memory file
            $writememb("data.mem", data_mem);
        end
    end
	
    always @(address) begin
        if(MemRead) begin
            read_data = data_mem[address];
        end
    end	

endmodule

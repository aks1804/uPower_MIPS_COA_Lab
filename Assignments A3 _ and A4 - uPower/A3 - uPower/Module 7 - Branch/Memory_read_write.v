/* This module is used to read and write the data.mem file(Main Memory)
*/
module read_write_memory (
    output reg [63:0] read_data,
    input [63:0] address, 
    input [63:0] write_data,
    input [4:0] rd, 
    input [5:0] po, 
    input MemWrite, MemRead
);

    reg [63:0] data_mem [0:31];

    always @ (address, MemWrite, write_data) 
    begin
        if(MemWrite) begin
            $readmemb("data.mem", data_mem, 0, 31);
            if(po == 6'd38) begin
                data_mem[address] = {{56{1'b0}}, write_data[7:0]};
            end
            else if(po == 6'd44) begin
                data_mem[address] = {{48{1'b0}}, write_data[15:0]};
            end
            else if(po == 6'd36) begin
                data_mem[address] = {{32{1'b0}}, write_data[31:0]};
            end
            else begin
                data_mem[address] = write_data;
				//$display("CCCCCC %64b\n",data_mem[address]);
				
            end
			//$display("DSFSDS %64b\n",data_mem[address]);
            // Write the updated contents back to the data_mem file
            $writememb("data.mem", data_mem);            
        end
    end

    always @(address)
    begin
        $readmemb("data.mem", data_mem, 0, 31);
        if(MemRead) begin
            read_data = data_mem[address];
			//$display("sdgsfg %64b \n",read_data);
        end
    end
endmodule
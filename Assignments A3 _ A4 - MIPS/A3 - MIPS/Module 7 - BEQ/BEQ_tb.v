// MIPS test bench - To drive and simulate the entire MIPS ALU 
`include "BEQ.v"
module tb_BEQ ();

    reg clk;
    wire result;

    BEQ tb(.clock(clk));

    initial 
    begin 

        clk = 1'b0;
        #490 $finish;
    end
	
	initial
	begin
		$dumpfile("beq.vcd");
		$dumpvars(0,tb_BEQ);
	end

    always begin 
        #100 clk = ~clk;
    end

endmodule
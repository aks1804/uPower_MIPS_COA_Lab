// MIPS test bench - To drive and simulate the entire MIPS ALU 
`include "Load.v"
module tb_Load ();

    reg clk;
    wire result;

    Load tb(.clock(clk));

    initial 
    begin 

        clk = 1'b0;
        #490 $finish;
    end
	
	initial
	begin
		$dumpfile("load.vcd");
		$dumpvars(0,tb_Load);
	end

    always begin 
        #100 clk = ~clk;
    end

endmodule
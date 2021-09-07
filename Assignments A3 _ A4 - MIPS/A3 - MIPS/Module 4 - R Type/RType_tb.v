// MIPS test bench - To drive and simulate the entire MIPS ALU 
`include "Rtype.v"
module tb_RType ();

    reg clk;
    wire result;

    RType tb(.clock(clk));

    initial 
    begin 

        clk = 1'b0;
        #490 $finish;
    end
	
	initial
	begin
		$dumpfile("rtype.vcd");
		$dumpvars(0,tb_RType);
	end

    always begin 
        #100 clk = ~clk;
    end

endmodule
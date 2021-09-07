// MIPS test bench - To drive and simulate the entire MIPS ALU 
`include "Itype.v"
module tb_IType ();

    reg clk;
    wire result;

    IType tb(.clock(clk));

    initial 
    begin 

        clk = 1'b0;
        #490 $finish;
    end
	
	initial
	begin
		$dumpfile("itype.vcd");
		$dumpvars(0,tb_IType);
	end

    always begin 
        #100 clk = ~clk;
    end

endmodule
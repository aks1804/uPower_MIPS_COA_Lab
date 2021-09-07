// MIPS test bench - To drive and simulate the entire MIPS ALU 
`include "Datapath.v"
module tb_Datapath ();

    reg clk;
    wire result;

    Datapath tb(.clock(clk));

    initial 
    begin 

        clk = 1'b0;
        #7990 $finish;
    end
	
	initial
	begin
		$dumpfile("datapath.vcd");
		$dumpvars(0,tb_Datapath);
	end

    always begin 
        #100 clk = ~clk;
    end

endmodule
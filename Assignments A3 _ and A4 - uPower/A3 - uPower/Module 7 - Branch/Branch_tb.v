/* Testbenchh for the X and XO type instructions */
`include "Branch.v"

module tb_Branch();

reg clk;

Branch tb(clk);

initial 
begin 
    clk = 1'b0;
    #49 $finish;
end

initial
begin
	$dumpfile("branch.vcd");
	$dumpvars(0,tb_Branch);
end

always begin 
    #10 clk = ~clk;
end

endmodule
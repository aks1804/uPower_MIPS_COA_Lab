/* Testbenchh for the X and XO type instructions */
`include "Load.v"

module tb_Load();

reg clk;

Load tb(clk);

initial 
begin 
    clk = 1'b0;
    #9 $finish;
end

initial
begin
	$dumpfile("load.vcd");
	$dumpvars(0,tb_Load);
end

always begin 
    #10 clk = ~clk;
end

endmodule
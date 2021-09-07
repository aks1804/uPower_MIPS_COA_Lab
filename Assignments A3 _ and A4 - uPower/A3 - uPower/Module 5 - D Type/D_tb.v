/* Testbenchh for the X and XO type instructions */
`include "D_type.v"

module tb_D();

reg clk;

D tb(clk);

initial 
begin 
    clk = 1'b0;
    #19 $finish;
end

initial
begin
	$dumpfile("d.vcd");
	$dumpvars(0,tb_D);
end

always begin 
    #10 clk = ~clk;
end

endmodule
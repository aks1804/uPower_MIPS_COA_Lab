/* Testbenchh for the X and XO type instructions */
`include "X_XO_type.v"

module tb_X_XO();

reg clk;

X_XO tb(clk);

initial 
begin 
    clk = 1'b0;
    #69 $finish;
end

initial
begin
	$dumpfile("x_xo.vcd");
	$dumpvars(0,tb_X_XO);
end

always begin 
    #10 clk = ~clk;
end

endmodule
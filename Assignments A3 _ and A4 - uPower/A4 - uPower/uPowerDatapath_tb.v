/* Testbenchh for the uPower Datapath */
`include "uPowerDatapath.v"

module tb_uPowerDatapath();

reg clk;

uPowerDatapath tb(clk);

initial 
begin 
    clk = 1'b0;
    #829 $finish;
end

initial
begin
	$dumpfile("upowerdatapath.vcd");
	$dumpvars(0,tb_uPowerDatapath);
end

always begin 
    #10 clk = ~clk;
end

endmodule